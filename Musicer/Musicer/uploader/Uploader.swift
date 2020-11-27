//
//  Uploader.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/20.
//

import Foundation
import GCDWebServer

class Uploader: NSObject {
    
    func connect()->MUError { return self.f_connect() }
    
    func disconnect() { self.f_disconnect() }
    
    //MARK: -- private
    fileprivate var server: Server?
}

fileprivate extension Uploader {
    
    func f_connect()->MUError {
        guard let wrappedPath = SongsManager.shared.baseFolder else {
            return MUError.some(desc: "文件目录创建失败，请退出重试")
        }
        self.server = Server.server(withPath: wrappedPath)
        guard let wrappedServer = self.server else {
            return MUError.some(desc: "服务器初始化失败，请退出重试")
        }
        wrappedServer.delegate = self
        let port = UInt.random(in: 8000...8999)
        if !wrappedServer.start(withPort: port, bonjourName: "") {
            return MUError.some(desc: "服务器启动失败，请退出重试")
        }
        guard let address = wrappedServer.serverURL?.absoluteString else {
            return MUError.some(desc: "服务器地址获取失败，请退出重试")
        }
        ffprint(address)
        return MUError.none(info: address)
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
    
    func webUploader(_ uploader: GCDWebUploader, didDeleteItemAtPath path: String) {
        
    }
    
    /*TODO：
     1、文件上传格式的限制
     2、文件名的获取
     3、文件的本地存储目录和app中自定义歌曲目录的映射设计
     */
}

fileprivate class Server: GCDWebUploader {
    
    static func server(withPath path: String)->Server? {
        let server: Server? = Server(uploadDirectory: path)
        server?.allowedFileExtensions = ["mp3"]
        server?.title = "Hello Musicer"
        server?.prologue = "<p>⚠️ 创建文件夹、移动及删除歌曲 已经被禁止使用，请知悉！<br>⚠️ 仅支持 mp3 格式的音乐文件</p>"
        server?.epilogue = "<p>Thanks for your support！</p>"
        server?.footer = "*************** 🇨🇳🌏🇨🇳 ***************"
        return server
    }
    
    override func shouldUploadFile(atPath path: String, withTemporaryFile tempPath: String) -> Bool {  false }
    override func shouldDeleteItem(atPath path: String) -> Bool { false }
    override func shouldCreateDirectory(atPath path: String) -> Bool { false }
    override func shouldMoveItem(fromPath: String, toPath: String) -> Bool { false }
}
