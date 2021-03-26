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
    /// - Returns: 歌单创建是否成功
    func creatFolder(withName name: String)->MUError { self.create_folder(name) }
    
    /// 删除一个歌单
    ///
    /// - Parameters:
    ///   - name: 要删除的歌单名称
    /// - Returns: 歌单删除是否成功
    func deleteFolder(withName name: String)->MUError { self.delete_folder(name) }
    
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
        guard let unwrappedDoc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        let path = unwrappedDoc + "/songs"
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
        guard let unwrappedLists = UserDefaults.standard.array(forKey: k_total_list_local_saving_key) as? [String] else {
            let list = [k_list_name_toatl, k_list_name_found]
            UserDefaults.standard.setValue(list, forKey: k_total_list_local_saving_key)
            return list
        }
        return unwrappedLists
    }
    
    // songs for list
    func fetch_songs_for_list(_ name: String, _ complete: @escaping ([Song]?)->Void) {
        guard let unwrappedFiles = UserDefaults.standard.array(forKey: name) as? [String] else {
            complete(nil)
            return
        }
        guard unwrappedFiles.count > 0 else {
            complete(nil)
            return
        }
        self.map(unwrappedFiles, complete)
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
    
    // delete folder
    func delete_folder(_ name: String)->MUError {
        let totalLists = self.fetch_total_lists().filter { $0 != name }
        // delete list
        UserDefaults.standard.setValue(totalLists, forKey: k_total_list_local_saving_key)
        // remove songs that contained in list
        UserDefaults.standard.setValue(nil, forKey: name)
        return MUError.none(info: "歌单已解散")
    }
    
    // add
    func add_song(_ song: Song, _ list: String)->MUError {
        guard var unwrappedSongs = UserDefaults.standard.array(forKey: list) as? [String] else {
            let songs = [song.fileName]
            UserDefaults.standard.setValue(songs, forKey: list)
            return MUError.none(info: "歌曲添加成功")
        }
        guard nil == unwrappedSongs.firstIndex(of: song.fileName) else {
            return MUError.some(desc: "歌曲已在该列表中")
        }
        unwrappedSongs.append(song.fileName)
        UserDefaults.standard.setValue(unwrappedSongs, forKey: list)
        return MUError.none(info: "歌曲添加成功")
    }
    
    // delete
    func del(_ song: Song, _ list: String, _ with: Bool)->MUError {
        guard with else {  // only delete reference form list
            guard self.deleteReference(song, list) else { return MUError.some(desc: "歌曲移除失败") }
            return MUError.none(info: "歌曲已从歌单移除")
        }
        // delete file
        guard self.deleteFile(song) else { return MUError.some(desc: "歌曲文件删除失败") }
        // delete reference all list
        let lists = self.totalLists()
        var names = [String]()
        for name in lists {
            if !self.deleteReference(song, name) {  names.append(name) }
        }
        guard names.count > 0 else { return MUError.none(info: "歌曲已从歌单移除") }
        return MUError.none(info: "歌单：\(names.joined(separator: " | ")) 中的该歌曲移除失败，您可以尝试去相应的歌单单独删除")
    }
    
    func deleteReference(_ song: Song, _ list: String)->Bool {
        guard var unwrappedSongs = UserDefaults.standard.array(forKey: list) as? [String] else {
            return false
        }
        unwrappedSongs = unwrappedSongs.filter { $0 != song.fileName }
        UserDefaults.standard.setValue(unwrappedSongs, forKey: list)
        return true
    }
    
    func deleteFile(_ song: Song)->Bool {
        guard let unwrappedFolder = self.baseFolder else { return false }
        let path = unwrappedFolder + "/" + song.fileName
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
        guard let unwrappedAssets = self.getAssetTuples(files) else { return }
        let group = DispatchGroup()
        let keys = ["duration", "commonMetadata"]
        for tuple in unwrappedAssets {
            group.enter()
            tuple.asset.loadValuesAsynchronously(forKeys: keys) {
                let wrappedSong = self.getSong(withAsset: tuple.asset, tuple.songName, tuple.file)
                if let unwrappedSong = wrappedSong { self.cache![tuple.songName] = unwrappedSong }
                group.leave()
            }
        }
        group.notify(qos: .default, flags: [], queue: .main) {
            var songs: [Song] = [Song]()
            for songName in files {
                if let unwrappedSong = self.cache![songName] { songs.append(unwrappedSong) }
            }
            DispatchQueue.main.async {
                complete(songs)
                self.cache!.clear()
            }
        }
    }
    
    func getAssetTuples(_ files: [String])->[(songName: String, file: URL, asset: AVAsset)]? {
        guard let unwrappedFolder = self.baseFolder else { return nil }
        let tumples = files.map { ($0,
                                   URL(fileURLWithPath: (unwrappedFolder + "/" + $0)),
                                   AVAsset(url: URL(fileURLWithPath: (unwrappedFolder + "/" + $0)))) }
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
                if let unwrappedData = item.dataValue { img = UIImage(data: unwrappedData) }
                song.album.image = img
            }
        }
        return song
    }
}
