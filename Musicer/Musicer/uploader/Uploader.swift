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
    enum Error {
        case none(info: String)
        case some(desc: String)
    }
    
    func connect()->Error { return self.f_connect() }
    
    func disconnect() { self.f_disconnect() }
    
    //MARK: -- private
    fileprivate var server: GCDWebUploader?
}

fileprivate extension Uploader {
    
    func f_connect()->Error {
        guard let wrappedPath = SongsManager.shared.baseFolder else {
            return Error.some(desc: "文件目录创建失败，请退出重试")
        }
        let unwrappedServer: GCDWebUploader? = GCDWebUploader(uploadDirectory: wrappedPath)
        guard let wrappedServer = unwrappedServer else {
            return Error.some(desc: "服务器初始化失败，请退出重试")
        }
        wrappedServer.delegate = self
        let port = UInt.random(in: 8000...8999)
        if !wrappedServer.start(withPort: port, bonjourName: "HELLO_MUSICER") {
            return Error.some(desc: "服务器启动失败，请退出重试")
        }
        guard let address = wrappedServer.serverURL?.absoluteString else {
            return Error.some(desc: "服务器地址获取失败，请退出重试")
        }
        self.server = wrappedServer
        ffprint(address)
        return Error.none(info: address)
    }
    
    func f_disconnect() {
        guard let wrappedServer = self.server else { return }
        wrappedServer.stop()
        self.server = nil
    }
}

extension Uploader: GCDWebUploaderDelegate {
    
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        ffprint(path)
    }
    
    /*TODO：
     1、文件上传格式的限制
     2、文件名的获取
     3、文件的本地存储目录和app中自定义歌曲目录的映射设计
     */
}
