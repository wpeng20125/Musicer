//
//  SongsManager.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/11.
//

import UIKit

fileprivate let k_total_song_list_name = "全部歌曲"
fileprivate let k_total_song_name_array_local_storage_key = "k_total_song_name_array_local_storage_key"
fileprivate let k_song_list_name_array_local_storage_key = "k_song_list_name_array_local_storage_key"
fileprivate let k_song_list_dictionary_local_storage_key = "k_song_list_dictionary_local_storage_key"


typealias SongName = String
typealias SongNameArray = [SongName]
typealias SongListName = String
typealias SongListNameArray = [SongListName]
typealias SongListDictionary = [SongListName : SongNameArray]

class SongsManager: NSObject {
    
    /**
     是否需要将数据更新到本地，只有在数据发生改变的时候才要更新
     */
    private(set) var shouldUpdateLocal: Bool = false
    
    /**
     歌曲文件的存储目录
     */
    private(set) lazy var baseFolder: String? = { self.base_folder() }()
    
    /**
     所有歌曲文件的名称列表
     */
    private(set) lazy var songNames: SongNameArray? = { self.fetch_song_names() }()
    
    /**
     歌曲列表名称的列表，列表中的每一个值都对应着一个用户创建的列表实体
     */
    private(set) lazy var songListNames: SongListNameArray? = { self.fetch_song_name_list() }()
    
    /**
     歌曲列表名称与其所对应的歌曲列表组成的一个字典
     */
    private(set) lazy var listMap: SongListDictionary? = { self.fetch_song_list_map() }()
    
    
    /**
     返回的是一个单例，这个类进行歌曲的管理
     */
    static let shared = SongsManager.init_self()
    
    /**
     更新本地存储，会把该单例类持有的3个表更新到本地
     */
    func save() { self.save_to_local() }
    
    /**
     创建一个歌曲列表
     
     @param name  歌曲列表名称
     @return  布尔值代表创建列表是否成功
     */
    func creatList(withName name: SongListName)->Bool { self.creat_song_list(name) }
    
    /**
     上传完一首歌曲需要把歌曲名加到全部歌曲的列表
     
     @param   songName  歌曲名
     @return    布尔值代表添加是否成功
     */
    func addSong(withName songName: SongName)->Bool { self.add_song(songName, k_total_song_list_name) }
    
    /**
     往一个歌曲列表中添加歌曲
     
     @param  songName  要添加的歌曲的名称
     @param  listName  要添加到的歌曲列表的名称
     @return  布尔值代表添加是否成功
     */
    func addSong(withName songName: SongName, toList listName: SongListName)->Bool { self.add_song(songName, listName) }
    
    /**
     从一个歌曲列表中删除某一首歌曲
     
     @param  songName  要删除的歌曲的名称
     @param  listName  要删除的歌曲所属列表的名称
     @return  布尔值代表删除是否成功
     */
    func deleteSong(withName songName: SongName, fromList listName: SongListName)->Bool { false }
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
        guard let wrappedSongNames = unwrappedSongNames else { return nil }
        return wrappedSongNames as? SongNameArray
    }
    
    func fetch_song_name_list()->SongListNameArray? {
        let unwrappedListNames =  UserDefaults.standard.array(forKey: k_song_list_name_array_local_storage_key)
        guard let wrappedListNames = unwrappedListNames else {
            self.shouldUpdateLocal = true
            let def = [k_total_song_list_name]
            return def
        }
        return wrappedListNames as? SongListNameArray
    }
    
    func fetch_song_list_map()->SongListDictionary? {
        let unwrappedListMap = UserDefaults.standard.dictionary(forKey: k_song_list_dictionary_local_storage_key)
        guard let wrappedListMap = unwrappedListMap else { return nil }
        return wrappedListMap as? SongListDictionary
    }
    
    func creat_song_list(_ name: SongListName)->Bool {
        self.shouldUpdateLocal = true
        guard nil != self.songListNames else {
            self.shouldUpdateLocal = false
            return false
        }
        self.songListNames!.append(name)
        guard nil != self.listMap else {
            self.shouldUpdateLocal = false
            self.songListNames!.removeLast()
            return false
        }
        
        return true
    }
    
    func add_song(_ songName: SongName, _ listName: SongListName)->Bool {
        self.shouldUpdateLocal = true
        
        return false
    }
    
    func delete_song(_ songName:SongName, _ listName: SongListName)->Bool {
        self.shouldUpdateLocal = true
        
        return false
    }
    
    func save_to_local() {
        guard self.shouldUpdateLocal else { return }
        self.shouldUpdateLocal = false
        UserDefaults.standard.setValue(self.songNames, forKey: k_total_song_name_array_local_storage_key)
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
