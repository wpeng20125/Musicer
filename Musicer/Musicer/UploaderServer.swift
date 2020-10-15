//
//  UploaderServer.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/13.
//

import UIKit
import GCDWebServer

fileprivate var kDefaultPort: UInt = 8080

class UploaderServer: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = R.color.uploader_backgroundColor()
        self.setupSubViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loaderServer.start(withPort: kDefaultPort, bonjourName: "MUSICER_HELLO_WORLD")
        guard let address = self.loaderServer.serverURL?.absoluteString else {
            self.addressLbl.text = "服务地址获取失败喽！"
            return
        }
        self.addressLbl.text = address
    }
    
    //MARK: -- lazy
    fileprivate lazy var addressLbl: UILabel = {
        let tipLbl = UILabel()
        tipLbl.font = UIFont.systemFont(ofSize: 14.0)
        tipLbl.textColor = R.color.uploader_header_titleColor()
        tipLbl.textAlignment = .center
        tipLbl.backgroundColor = R.color.uploader_header_backgroundColor()
        tipLbl.layer.cornerRadius = 5.0
        tipLbl.layer.masksToBounds = true
        return tipLbl
    }()
    
    fileprivate lazy var loaderServer: GCDWebUploader = {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let uploader = GCDWebUploader(uploadDirectory: path!)
        kDefaultPort = UInt.random(in: 1000...9999)
        return uploader
    }()
}


fileprivate extension UploaderServer {
    
    func setupSubViews() {
        
        let titleBar = TitleBar()
        titleBar.backgroundColor = R.color.uploader_backgroundColor()
        self.view.addSubview(titleBar)
        titleBar.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(NavigationBarHeight)
        }
        
        let header = UIView()
        header.backgroundColor = R.color.uploader_header_backgroundColor()
        header.layer.cornerRadius = 10.0
        header.layer.masksToBounds = true
        header.layer.shadowColor = R.color.uploader_header_backgroundColor()?.cgColor
        header.layer.shadowRadius = 5.0
        header.layer.shadowOpacity = 0.6
        self.view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalTo(titleBar.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(ScreenWidth / 0.618)
        }
        
        let wifiImgView = UIImageView()
        wifiImgView.image = R.image.uploader_header_wifi()
        header.addSubview(wifiImgView)
        wifiImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(header)
            make.top.equalTo(header).offset(20.0)
            make.size.equalTo(CGSize(width: 80.0, height: 60.0))
        }
        
        let tipLbl = UILabel()
        tipLbl.font = UIFont.systemFont(ofSize: 14.0)
        tipLbl.textColor = R.color.uploader_header_titleColor()
        tipLbl.textAlignment = .center
        tipLbl.text = "确保你的 iPhone 和 PC 连接的是同一个网络\n**在 PC 上打开下面提示的链接**\n在传输的过程中请勿关闭此页面"
        header.addSubview(tipLbl)
        tipLbl.snp.makeConstraints { (make) in
            make.top.equalTo(wifiImgView.snp.bottom).offset(20.0)
            make.left.equalTo(header).offset(20.0)
            make.right.equalTo(header).offset(-20.0)
        }
        
        self.view.addSubview(self.addressLbl)
        self.addressLbl.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom).offset(30.0)
            make.left.equalTo(self.view).offset(20.0)
            make.right.equalTo(self.view).offset(-20.0)
            make.height.equalTo(30.0)
        }
    }
}

extension UploaderServer: TitleBarDelegate, TitleBarDataSource {
    
    func item(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> TitleBarItem? {
        if case .left = p { return nil }
        let item = TitleBarItem()
        if case ItemPosition.middle = p {
            item.title = "WiFi传歌"
            item.titleColor = R.color.uploader_header_titleColor()
            item.fontSize = 16.0
        }
        if case ItemPosition.right = p {
            item.image = R.image.uploader_header_close()
        }
        return item
    }
    
    func itemDidClicked(atPosition p: ItemPosition) {
        if case ItemPosition.right = p {
            let alert = UIAlertController(title: "提示",
                                          message: "确保传输已完成，否则关闭页面，传输会被停止",
                                          preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let confiem = UIAlertAction(title: "确定", style: .default) { (action) in
                self.loaderServer.stop()
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancel)
            alert.addAction(confiem)
        }
    }
}
