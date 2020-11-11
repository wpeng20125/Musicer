//
//  Uploader.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/20.
//

import Foundation
import GCDWebServer

class Uploader: NSObject {
    
    //MARK: -- public
    enum UploaderError {
        case none(info: String)
        case some(desc: String)
    }
    
    static let `default` = Uploader()

    private(set) var filePath: String?
    
    func connect()->UploaderError { return self._connect() }
    
    func disconnect() { self._disconnect() }
    
    //MARK: -- private
    fileprivate var server: GCDWebUploader?
    
    override init() {
        super.init()
        self.filePath = self.createPath()
    }
}

fileprivate extension Uploader {
    
    func _connect()->UploaderError {
        guard let wrappedPath = self.filePath else {
            return UploaderError.some(desc: "文件目录创建失败，请退出重试")
        }
        let unwrappedServer: GCDWebUploader? = GCDWebUploader(uploadDirectory: wrappedPath)
        guard let wrappedServer = unwrappedServer else {
            return UploaderError.some(desc: "服务器初始化失败，请退出重试")
        }
        wrappedServer.delegate = self
        let port = UInt.random(in: 8000...8999)
        if !wrappedServer.start(withPort: port, bonjourName: "HELLO_MUSICER") {
            return UploaderError.some(desc: "服务器启动失败，请退出重试")
        }
        guard let address = wrappedServer.serverURL?.absoluteString else {
            return UploaderError.some(desc: "服务器地址获取失败，请退出重试")
        }
        self.server = wrappedServer
        return UploaderError.none(info: address)
    }
    
    func _disconnect() {
        guard let wrappedServer = self.server else { return }
        wrappedServer.stop()
        self.server = nil
    }
    
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
}

extension Uploader: GCDWebUploaderDelegate {
    
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        print(path)
    }
    
    /*TODO：
     1、文件上传格式的限制
     2、文件名的获取
     3、文件的本地存储目录和app中自定义歌曲目录的映射设计
     */
}
