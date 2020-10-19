//
//  UploaderController.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/13.
//

import UIKit
import GCDWebServer

fileprivate var kDefaultPort: UInt = 8080

class UploaderController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_orange_one()
        self.setupSubViews()
        self.connect()
    }
    
    //MARK: -- lazy
    fileprivate lazy var addressLbl: UILabel = {
        let tipLbl = UILabel()
        tipLbl.font = UIFont.systemFont(ofSize: 14.0)
        tipLbl.textColor = R.color.mu_color_white()
        tipLbl.textAlignment = .center
        tipLbl.backgroundColor = R.color.mu_color_orange_two()
        tipLbl.layer.cornerRadius = 5.0
        tipLbl.layer.masksToBounds = true
        tipLbl.isUserInteractionEnabled = true
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        gesture.minimumPressDuration = 1.0
        tipLbl.addGestureRecognizer(gesture)
        return tipLbl
    }()
    
    fileprivate lazy var loaderServer: GCDWebUploader? = {
        let unwrappedDoc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        guard let wrappedDoc = unwrappedDoc else { return nil }
        let path = wrappedDoc + "/songs"
        let isDir = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        let exist = FileManager.default.fileExists(atPath: path, isDirectory: isDir)
        if !exist {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                Toaster().flash(withText: "文件上传目录创建失败，请退出重试")
                return nil
            }
        }
        let uploader = GCDWebUploader(uploadDirectory: path)
        uploader.delegate = self
        kDefaultPort = UInt.random(in: 8000...8999)
        return uploader
    }()
}

fileprivate extension UploaderController {
    
    func setupSubViews() {
        
        let titleBar = TitleBar()
        titleBar.dataSource = self
        titleBar.delegate = self
        titleBar.backgroundColor = R.color.mu_color_orange_one()
        self.view.addSubview(titleBar)
        titleBar.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(kTitleBarHeight)
        }
        titleBar.reload()
        
        let header = UIView()
        header.backgroundColor = R.color.mu_color_orange_two()
        header.layer.cornerRadius = 10.0
        header.layer.masksToBounds = true
        header.layer.shadowColor = R.color.mu_color_orange_two()?.cgColor
        header.layer.shadowRadius = 5.0
        header.layer.shadowOpacity = 0.6
        self.view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalTo(titleBar.snp.bottom)
            make.left.equalTo(self.view).offset(10.0)
            make.right.equalTo(self.view).offset(-10.0)
            make.height.equalTo(250.0)
        }
        
        let wifiImgView = UIImageView()
        wifiImgView.image = R.image.mu_image_wifi()
        header.addSubview(wifiImgView)
        wifiImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(header)
            make.top.equalTo(header).offset(40.0)
            make.size.equalTo(CGSize(width: 60.0, height: 52.0))
        }
        
        let tipLbl = UILabel()
        tipLbl.numberOfLines = 0
        tipLbl.font = UIFont.systemFont(ofSize: 13.0)
        tipLbl.textColor = R.color.mu_color_white()
        let str = "确保你的 iPhone 和 PC 连接的是同一个网络\n在 PC 浏览器上打开下面的链接\n在传输的过程中请勿关闭此页面"
        let attribute = NSMutableAttributedString(string: str)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5.0
        style.alignment = .center
        attribute.addAttributes([.paragraphStyle : style], range: NSRange(location: 0, length: str.count))
        tipLbl.attributedText = attribute
        header.addSubview(tipLbl)
        tipLbl.snp.makeConstraints { (make) in
            make.top.equalTo(wifiImgView.snp.bottom).offset(40.0)
            make.left.equalTo(header).offset(20.0)
            make.right.equalTo(header).offset(-20.0)
        }
        
        self.view.addSubview(self.addressLbl)
        self.addressLbl.snp.makeConstraints { (make) in
            make.top.equalTo(header.snp.bottom).offset(50.0)
            make.left.equalTo(self.view).offset(20.0)
            make.right.equalTo(self.view).offset(-20.0)
            make.height.equalTo(50.0)
        }
    }
    
    func connect() {
        guard let server = self.loaderServer else {
            Toaster().flash(withText: "服务初始化失败，请退出重试")
            return
        }
        server.start(withPort: kDefaultPort, bonjourName: "MUSICER_HELLO_WORLD")
        guard let address = server.serverURL?.absoluteString else {
            self.addressLbl.text = "服务地址获取失败喽！"
            return
        }
        self.addressLbl.text = address
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        guard let str = self.addressLbl.text else { return }
        let address = str.trimmingCharacters(in: CharacterSet.whitespaces)
        guard address.count > 0 else { return }
        UIPasteboard.general.string = address
        Toaster().flash(withText: "链接地址已复制")
    }
}

extension UploaderController: TitleBarDelegate, TitleBarDataSource {
    
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        if case .left = p { return nil }
        let property = ItemProperty()
        if case ItemPosition.middle = p {
            property.title = "WiFi传歌"
            property.titleColor = R.color.mu_color_white()
            property.fontSize = 15.0
        }
        if case ItemPosition.right = p {
            property.image = R.image.mu_image_close()
        }
        return property
    }
    
    func itemDidClick(atPosition p: ItemPosition) {
        if case ItemPosition.right = p {
            let alert = UIAlertController(title: "提示",
                                          message: "请确保所有歌曲已传输完毕，否则关闭该页面，传输会停止",
                                          preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let confiem = UIAlertAction(title: "确定", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                guard let server = self.loaderServer else { return }
                server.stop()
            }
            alert.addAction(cancel)
            alert.addAction(confiem)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UploaderController: GCDWebUploaderDelegate {
    
    func webUploader(_ uploader: GCDWebUploader, didUploadFileAtPath path: String) {
        print(path)
    }
    
    /*TODO：
     1、文件上传格式的限制
     2、文件名的获取
     3、文件的本地存储目录和app中自定义歌曲目录的映射设计
     */
}
