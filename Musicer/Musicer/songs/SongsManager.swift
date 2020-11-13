//
//  SongsManager.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/11.
//

import UIKit

class SongsManager: NSObject {
    
    /**
     返回的是一个单例，这个类进行歌曲的管理
     */
    static let `default` = SongsManager()
    
    /**
     歌曲文件的存储目录
     */
    var folder: String? { self.createPath() }
}

fileprivate extension SongsManager {
    
    func createPath()->String? {
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
        return path
    }
    
    func loadSongsFromLocal() {
        
    }
}
