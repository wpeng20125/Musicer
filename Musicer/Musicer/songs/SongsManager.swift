//
//  SongsManager.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/11.
//

import UIKit
import AVFoundation

fileprivate let k_song_list_limit_count = 8
fileprivate let k_total_song_name_array_local_storage_key = "k_total_song_name_array_local_storage_key"
fileprivate let k_song_list_name_array_local_storage_key = "k_song_list_name_array_local_storage_key"
fileprivate let k_song_list_dictionary_local_storage_key = "k_song_list_dictionary_local_storage_key"

let k_total_song_list_name = "全部歌曲"
let k_liked_song_list_name = "我喜欢的"

typealias SongName = String
typealias SongNameArray = [SongName]
typealias SongListName = String
typealias SongListNameArray = [SongListName]
typealias SongListDictionary = [SongListName : SongNameArray]

class SongsManager: NSObject {
    
    typealias ComplateHandler = (MUError)->Void
    
    /**
     是否需要将数据更新到本地，只有在数据发生改变的时候才要更新
     */
    private var shouldUpdateLocal: Bool = false
    private let cache = SimpleCache<SongName, Song>()
    
    /**
     歌曲文件的存储目录
     */
    private(set) lazy var baseFolder: String? = { self.base_folder() }()
    
    /**
     所有歌曲文件的名称列表
     */
    private(set) lazy var totalSongNames: SongNameArray? = { self.fetch_song_names() }()
    
    /**
     歌曲列表名称的列表，列表中的每一个值都对应着一个用户创建的列表实体
     */
    private(set) lazy var songListNames: SongListNameArray? = { self.fetch_song_name_list() }()
    
    /**
     歌曲列表名称与其所对应的歌曲列表组成的一个字典
     */
    private(set) lazy var listMap: SongListDictionary? = { self.fetch_song_list_map() }()
    
    //MARK: -- Method
    
    /**
     返回的是一个单例，这个类进行歌曲的管理
     */
    static let shared = SongsManager.init_self()
    
    /**
     更新本地存储，会把该单例类持有的3个表更新到本地
     */
    func updateToLocal() { self.save_to_local() }
    
    /**
     创建一个歌曲列表
     
     @param name  歌曲列表名称
     @return  布尔值代表创建列表是否成功
     */
    func creat(songList name: SongListName)->MUError { self.creat_song_list(name) }
    
    /**
     往一个歌曲列表中添加歌曲
     
     @param  songName  要添加的歌曲的名称
     @param  listName  要添加到的歌曲列表的名称
     @return  布尔值代表添加是否成功
     */
    func add(song name: SongName, toList list: SongListName)->MUError { self.add_song(name, list) }
    
    /**
     从一个歌曲列表中删除某一首歌曲
     
     @param  songName  要删除的歌曲的名称
     @param  listName  要删除的歌曲所属列表的名称
     @return  布尔值代表删除是否成功
     */
    func delete(song name: SongName, fromList list: SongListName)->MUError { self.delete_song(name, false, list) }
    
    /**
     从一个歌曲列表中删除某一首歌曲
     
     @param  songName  要删除的歌曲的名称
     @param  delFile   是否同时删除歌曲文件
     @param  listName  要删除的歌曲所属列表的名称
     @return  布尔值代表删除是否成功
     */
    func delete(song name: SongName, withFile delFile: Bool, fromList list: SongListName)->MUError {
        self.delete_song(name, delFile, list)
    }
}

fileprivate extension SongsManager {
    
    static func init_self()->SongsManager {
        let manager = SongsManager()
        manager.addNotifications()
        return manager
    }
    
    func base_folder()->String? {
        let unwrappedDoc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        guard let wrappedDoc = unwrappedDoc else { return nil }
        let path = wrappedDoc + "/songs"
        let isDir = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        let exist = FileManager.default.fileExists(atPath: path, isDirectory: isDir)
        if !exist || !isDir.pointee.boolValue {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                return path
            } catch _ {
                return nil
            }
        }
        ffprint(path)
        return path
    }
    
    func fetch_song_names()->SongNameArray? {
        let unwrappedSongNames = UserDefaults.standard.array(forKey: k_total_song_name_array_local_storage_key)
        guard let wrappedSongNames = (unwrappedSongNames as? SongNameArray) else { return nil }
        return wrappedSongNames
    }
    
    func fetch_song_name_list()->SongListNameArray? {
        let unwrappedListNames =  UserDefaults.standard.array(forKey: k_song_list_name_array_local_storage_key)
        guard let wrappedListNames = (unwrappedListNames as? SongListNameArray) else {
            self.shouldUpdateLocal = true
            return [k_total_song_list_name, k_liked_song_list_name]
        }
        return wrappedListNames
    }
    
    func fetch_song_list_map()->SongListDictionary? {
        let unwrappedListMap = UserDefaults.standard.object(forKey: k_song_list_dictionary_local_storage_key)
        guard let wrappedListMap = (unwrappedListMap as? SongListDictionary) else {
            self.shouldUpdateLocal = true
            return [k_total_song_list_name : [SongName](), k_liked_song_list_name : [SongName]()]
        }
        return wrappedListMap
    }
    
    func creat_song_list(_ name: SongListName)->MUError {
        if nil == self.songListNames {
            self.songListNames = [k_total_song_list_name, k_liked_song_list_name]
        }else {
            if self.songListNames!.count >= k_song_list_limit_count + 2 {
                return MUError.some(desc: "最多创建\(k_song_list_limit_count)个列表")
            }
        }
        var has = false
        for existName in self.songListNames! {
            if existName != name { continue }
            has = true
            break
        }
        if has { return MUError.some(desc: "列表已存在") }
        self.songListNames!.append(name)
        
        if nil == self.listMap {
            self.listMap = [k_total_song_list_name : [SongName](), k_liked_song_list_name : [SongName]()]
        }
        self.listMap![name] = [SongName]()
        
        self.shouldUpdateLocal = true
        return MUError.none(info: "歌曲列表创建成功")
    }
    
    func add_song(_ song: SongName, _ listName: SongListName)->MUError {
        if nil == self.songListNames || nil == self.listMap { return MUError.some(desc: "歌曲列表不存在") }
        var has = false
        for name in self.songListNames! {
            if name != listName { continue }
            has = true
            break
        }
        if !has { return MUError.some(desc: "歌曲列表不存在") }
        
        guard var wrappedSongNames = self.listMap![listName] else {
            self.listMap![listName] = [song]
            return MUError.none(info: "歌曲添加列表成功")
        }
        wrappedSongNames.append(song)
        self.listMap![listName] = wrappedSongNames
        
        self.shouldUpdateLocal = true
        return MUError.none(info: "歌曲添加列表成功")
    }
    
    func delete_song(_ song: SongName, _ delFile: Bool, _ listName: SongListName)->MUError {
        if delFile {
            guard let folder = self.baseFolder else { return MUError.some(desc: "文件目录损坏") }
            let path = folder + "/" + "\(song)" + "." + "mp3"
            do {
                try FileManager.default.removeItem(atPath: path)
                for name in self.songListNames! {
                    let songNames = self.listMap![name]
                    let newSongNames = songNames!.filter { $0 != song }
                    self.listMap![listName] = newSongNames
                }
            } catch _ {
                return MUError.some(desc: "歌曲文件删除失败")
            }
        }else {
            let songNames = self.listMap![listName]
            let newSongNames = songNames!.filter { $0 != song }
            self.listMap![listName] = newSongNames
        }
        self.shouldUpdateLocal = true
        return MUError.none(info: "歌曲删除成功")
    }
    
    func save_to_local() {
        guard self.shouldUpdateLocal else { return }
        self.shouldUpdateLocal = false
        UserDefaults.standard.setValue(self.totalSongNames, forKey: k_total_song_name_array_local_storage_key)
        UserDefaults.standard.setValue(self.songListNames, forKey: k_song_list_name_array_local_storage_key)
        UserDefaults.standard.setValue(self.listMap, forKey: k_song_list_dictionary_local_storage_key)
    }
}

fileprivate extension SongsManager {
    
    func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground(_:)),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
    }
    
    @objc func appDidEnterBackground(_ noti: NSNotification) {
        self.save_to_local()
    }
    
    @objc func appWillTerminate(_ noti: NSNotification) {
        self.save_to_local()
    }
}


extension SongsManager {
    
    func map(_ songNames: [SongName], _ complete: @escaping ([Song]?)->Void) {
        guard let wrappedAssets = self.getAssetTuples(songNames) else { return }
        let group = DispatchGroup()
        let keys = ["duration", "commonMetadata"]
        for tuple in wrappedAssets {
            group.enter()
            tuple.asset.loadValuesAsynchronously(forKeys: keys) {
                let unwrappedSong = self.getSong(withAsset: tuple.asset, tuple.songName)
                if let song = unwrappedSong { self.cache[tuple.songName] = song }
                group.leave()
            }
        }
        group.notify(qos: .default, flags: [], queue: .main) {
            var songs: [Song] = [Song]()
            for songName in songNames {
                if let song = self.cache[songName] { songs.append(song) }
            }
            DispatchQueue.main.async {
                complete(songs)
                self.cache.clear()
            }
        }
    }
    
    func getAssetTuples(_ songNames: [SongName])->[(songName: SongName,asset: AVAsset)]? {
        guard let wrappedBaseFolder = self.baseFolder else { return nil }
        var assets = Array<(SongName,AVAsset)>()
        for songName in songNames {
            var path = wrappedBaseFolder + "/" + songName + ".mp3"
            #if DEBUG
            path = Bundle.main.path(forResource: songName, ofType: ".mp3")!
            #endif
            let asset = AVAsset(url: URL(fileURLWithPath: path))
            assets.append((songName,asset))
        }
        return assets
    }
    
    func getSong(withAsset asset: AVAsset, _ fileName: String)->Song? {
        var error: NSError?
        var t: Float = 0
        let durationStatus = asset.statusOfValue(forKey: "duration", error: &error)
        switch durationStatus {
        case .loaded: t = Float(asset.duration.value) / Float(asset.duration.timescale)
        default: return nil
        }
        
        var items = [AVMetadataItem]()
        let metaDataStatus = asset.statusOfValue(forKey: "commonMetadata", error: &error)
        switch metaDataStatus {
        case .loaded: items = asset.commonMetadata
        default: return nil
        }
        
        var song = Song(fileName: fileName)
        song.duration = t
        for item in items {
            if item.commonKey?.rawValue == "title" { song.name = item.stringValue }
            if item.commonKey?.rawValue == "artist" { song.author = item.stringValue }
            if item.commonKey?.rawValue == "albumName" { song.album.name = item.stringValue }
            if item.commonKey?.rawValue == "artwork" {
                var img: UIImage? = nil
                if let data = item.dataValue { img = UIImage(data: data) }
                song.album.local = img
            }
        }
        return song
    }
    
}
