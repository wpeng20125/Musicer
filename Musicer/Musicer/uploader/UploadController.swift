//
//  UploadController.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/13.
//

import UIKit

class UploadController: BaseViewController {
    
    /// 当前 controller 将要 dismiss
    var willDismiss: (()->Void)?
    /// 当前 controller 已经 dismiss，并且 dismiss 动画执行完毕
    var didDismiss: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_orange_light()
        self.setupSubViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Toaster.showLoading(withBackgroundColor: R.color.mu_color_gray_dark())
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.connect()
        }
    }
    
    //MARK: -- lazy
    private(set) lazy var files: (names: [String], modified: Bool) = {
        guard let unwrappedFiles = UserDefaults.standard.array(forKey: k_list_name_toatl) as? [String] else {
            return ([String](), false)
        }
        return (unwrappedFiles, false)

    }()
    
    private lazy var addressLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14.0)
        lbl.textColor = R.color.mu_color_white()
        lbl.textAlignment = .center
        lbl.backgroundColor = R.color.mu_color_orange_dark()
        lbl.layer.cornerRadius = 5.0
        lbl.layer.masksToBounds = true
        lbl.isUserInteractionEnabled = true
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        gesture.minimumPressDuration = 1.0
        lbl.addGestureRecognizer(gesture)
        return lbl
    }()
    
    private lazy var uploader: Uploader = { Uploader() }()
}

fileprivate extension UploadController {
    
    func setupSubViews() {
        
        let titleBar = TitleBar()
        titleBar.dataSource = self
        titleBar.delegate = self
        titleBar.backgroundColor = R.color.mu_color_orange_light()
        self.view.addSubview(titleBar)
        titleBar.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(TitleBarHeight)
        }
        titleBar.configure()
        
        let header = UIView()
        header.backgroundColor = R.color.mu_color_orange_dark()
        header.layer.cornerRadius = 10.0
        header.layer.masksToBounds = true
        self.view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalTo(titleBar.snp.bottom).offset(20.0)
            make.left.equalTo(self.view).offset(10.0)
            make.right.equalTo(self.view).offset(-10.0)
            make.height.equalTo(250.0)
        }
        
        let wifiImgView = UIImageView()
        wifiImgView.image = R.image.mu_image_upload_wifi()
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
        let str = "确保你的 iPhone 和 PC 连接的是同一个网络\n在 PC 浏览器上打开下面的链接\n(长按复制)\n在传输的过程中请勿关闭此页面"
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
        self.uploader.delegate = self
        let error: MUError = self.uploader.connect()
        switch error {
        case let .none(info): self.addressLbl.text = info
        case let .some(desc): Toaster.flash(withText: desc)
        }
        Toaster.hideLoading()
    }
    
    @objc func longPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        guard let unwrappedStr = self.addressLbl.text else { return }
        let address = unwrappedStr.trimmingCharacters(in: CharacterSet.whitespaces)
        guard address.count > 0 else { return }
        UIPasteboard.general.string = address
        Toaster.flash(withText: "链接地址已复制")
    }
}

extension UploadController: TitleBarDelegate, TitleBarDataSource, UploaderProtocol {
    
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        let property = ItemProperty()
        switch p {
        case .left: return nil
        case .middle:
            property.title = "WiFi传歌"
            property.titleColor = R.color.mu_color_white()
            property.fontSize = 15.0
            return property
        case .right:
            property.image = R.image.mu_image_upload_close()
            return property
        }
    }
    
    func itemDidClick(atPosition p: ItemPosition) {
        if case ItemPosition.right = p {
            let alert = UIAlertController(title: "提示",
                                          message: "请确保所有歌曲已传输完毕，否则关闭该页面，传输会停止!",
                                          preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let confiem = UIAlertAction(title: "确定", style: .destructive) { (action) in
                self.uploader.disconnect()
                if self.files.modified {
                    UserDefaults.standard.setValue(self.files.names, forKey: k_list_name_toatl)
                }
                if let unwrappedWillDismiss = self.willDismiss { unwrappedWillDismiss() }
                self.dismiss(animated: true) {
                    if let unwrappedDidDismiss = self.didDismiss { unwrappedDidDismiss() }
                }
            }
            alert.addAction(cancel)
            alert.addAction(confiem)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func uploader(_ uploader: Uploader, didFinishedUploadingWithPath path: String) {
        
        #warning("这里的文名要改成 md5 值")
        
        let file = NSString(string: path).lastPathComponent
        self.files.names.append(file)
        if !self.files.modified { self.files.modified = true }
    }
}
