//
//  UploaderServer.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/13.
//

import UIKit
import GCDWebServer

class UploaderServer: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.setupSubViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.connect()
    }
    
}

//MARK: -- 设置子view
fileprivate extension UploaderServer {
    
    func setupSubViews() {
        let header = UIView()
        header.backgroundColor = R.color.uploader_header_backgroundColor()
        
    }
}

//MARK: -- 设置上传文件服务器
fileprivate extension UploaderServer {
    
    func connect() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let uploader = GCDWebUploader(uploadDirectory: path!)
        let port = UInt.random(in: 1000...9999)
        uploader.start(withPort: port, bonjourName: "Musicer File Uploader Server")
    }
    
}
