//
//  SongsManager.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/11.
//

import UIKit
import AVFoundation

private let k_list_limit_count = 8
private let k_total_list_local_saving_key = "k_total_list_local_saving_key"
let k_list_name_toatl = "全部歌曲"
let k_list_name_found = "我喜欢的"

class SongManager {
    
    static let `default` = INIT_SELF()
    
    private(set) var baseFolder: String?
    private var cache: SimpleCache<String, Song>?
}

extension SongManager {
    
    /// 所有的歌单名称数组，最少也会包含 "全部歌曲" 和 "我喜欢的" 两个列表
    func totalLists()->[String] { self.fetch_total_lists() }
    
    /// 该函数的作用是获取某个列表下的歌曲
    ///
    /// - Parameters:
    ///   - name: 列表名称
    ///   - comp: 回调，通过闭包返回包含 Song 实体的数组
    func songs(forList name: String, complete comp: @escaping ([Song]?)->Void) { self.fetch_songs_for_list(name, comp) }
    
    /// 创建一个歌单列表
    ///
    /// - Parameters:
    ///   - name: 要创建的列表名称
    ///   - comp: 回调，通过闭包返回包含 Song 实体的数组
    /// - Returns: 歌单创建是否成功
    func creatFolder(withName name: String)->MUError { self.create_folder(name) }
    
    /// 将歌曲添加到一个歌单
    ///
    /// - Parameters:
    ///   - aSong: 歌曲实体
    ///   - list:  歌单名称
    /// - Returns: 添加歌曲是否成功
    func addSong(song aSong: Song, toList list: String)->MUError { self.add_song(aSong, list) }
    
    /// 将歌曲从歌单中删除
    ///
    /// - Parameters:
    ///   - aSong  歌曲实体
    ///   - list  歌单名称
    ///   - flag  是否同时删除本地文件
    /// - Returns: 删除歌曲是否成功
    func delete(song aSong: Song, from list: String, withFile flag: Bool = false)->MUError { self.del(aSong, list, flag) }
    
}

fileprivate extension SongManager {
    
    static func INIT_SELF()->SongManager {
        let manager = SongManager()
        manager.baseFolder = manager.creat_base_folder()
        manager.cache = SimpleCache<String, Song>()
        return manager
    }
    
    func creat_base_folder()->String? {
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
    
    // total list
    func fetch_total_lists()->[String] {
        guard let wrappedLists = UserDefaults.standard.array(forKey: k_total_list_local_saving_key) as? [String] else {
            let list = [k_list_name_toatl, k_list_name_found]
            UserDefaults.standard.setValue(list, forKey: k_total_list_local_saving_key)
            return list
        }
        return wrappedLists
    }
    
    // songs for list
    func fetch_songs_for_list(_ name: String, _ complete: @escaping ([Song]?)->Void) {
        let files = UserDefaults.standard.array(forKey: name) as? [String]
        guard nil != files else {
            complete(nil)
            return
        }
        self.map(files!, complete)
    }
    
    // create folder
    func create_folder(_ name: String)->MUError {
        var lists = self.fetch_total_lists()
        if (lists.count - 2) >= k_list_limit_count { return MUError.some(desc: "最多创建\(k_list_limit_count)个歌单") }
        var had = false
        for list in lists {
            if list != name { continue }
            had = true
            break
        }
        if had { return MUError.some(desc: "歌单已存在") }
        lists.append(name)
        UserDefaults.standard.setValue(lists, forKey: k_total_list_local_saving_key)
        return MUError.none(info: "歌单创建成功")
    }
    
    // add
    func add_song(_ song: Song, _ list: String)->MUError {
        guard var wrappedSongs = UserDefaults.standard.array(forKey: list) as? [String] else {
            let songs = [song.fileName]
            UserDefaults.standard.setValue(songs, forKey: list)
            return MUError.none(info: "歌曲添加成功")
        }
        wrappedSongs.append(song.fileName)
        UserDefaults.standard.setValue(wrappedSongs, forKey: list)
        return MUError.none(info: "歌曲添加成功")
    }
    
    // delete
    func del(_ song: Song, _ list: String, _ with: Bool)->MUError {
        guard with else {  // only delete reference form list
            guard self.deleteReference(song, list) else { return MUError.some(desc: "歌曲移除失败") }
            return MUError.none(info: "歌曲已从列表移除")
        }
        // delete file
        guard self.deleteFile(song) else { return MUError.some(desc: "歌曲文件删除失败") }
        // delete reference all list
        let lists = self.totalLists()
        for name in lists {
            if let wrappedSongs = UserDefaults.standard.array(forKey: name) as? [String] {
                if wrappedSongs.contains(song.fileName) { self.deleteReference(song, name) }
            }
        }
        return MUError.none(info: "歌曲已从列表移除")
    }
    
    @discardableResult
    func deleteReference(_ song: Song, _ list: String)->Bool {
        guard var wrappedSongs = UserDefaults.standard.array(forKey: list) as? [String] else {
            return false
        }
        wrappedSongs = wrappedSongs.filter { $0 != song.fileName }
        UserDefaults.standard.setValue(wrappedSongs, forKey: list)
        return true
    }
    
    func deleteFile(_ song: Song)->Bool {
        guard let folder = self.baseFolder else { return false }
        let path = folder + "/" + song.fileName
        guard FileManager.default.fileExists(atPath: path) else {
            return false
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch _ {
            return false
        }
    }
    
    //MARK: -- Song 实体创建
    func map(_ files: [String], _ complete: @escaping ([Song]?)->Void) {
        guard let wrappedAssets = self.getAssetTuples(files) else { return }
        let group = DispatchGroup()
        let keys = ["duration", "commonMetadata"]
        for tuple in wrappedAssets {
            group.enter()
            tuple.asset.loadValuesAsynchronously(forKeys: keys) {
                let unwrappedSong = self.getSong(withAsset: tuple.asset, tuple.songName, tuple.file)
                if let song = unwrappedSong { self.cache![tuple.songName] = song }
                group.leave()
            }
        }
        group.notify(qos: .default, flags: [], queue: .main) {
            var songs: [Song] = [Song]()
            for songName in files {
                if let song = self.cache![songName] { songs.append(song) }
            }
            DispatchQueue.main.async {
                complete(songs)
                self.cache!.clear()
            }
        }
    }
    
    func getAssetTuples(_ files: [String])->[(songName: String, file: URL, asset: AVAsset)]? {
        guard let folder = self.baseFolder else { return nil }
        let tumples = files.map { ($0,
                                   URL(fileURLWithPath: (folder + "/" + $0)),
                                   AVAsset(url: URL(fileURLWithPath: (folder + "/" + $0)))) }
        return tumples
    }
    
    func getSong(withAsset asset: AVAsset, _ fileName: String, _ fileURL: URL)->Song? {
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
        
        var song = Song(fileName: fileName, fileURL: fileURL)
        song.duration = t
        for item in items {
            if "title" == item.commonKey?.rawValue { song.name = item.stringValue ?? fileName }
            if "artist" == item.commonKey?.rawValue { song.author = item.stringValue }
            if "albumName" == item.commonKey?.rawValue { song.album.name = item.stringValue }
            if "artwork" == item.commonKey?.rawValue {
                var img: UIImage? = nil
                if let data = item.dataValue { img = UIImage(data: data) }
                song.album.image = img
            }
        }
        return song
    }
}
