//
//  SongsListCreateView.swift
//  Musicer
//
//  Created by 王朋 on 2020/12/2.
//

import UIKit

private let limit_w = 220.0
private let limit_h = 120.0
private let limit = 5

class SongsListCreateView: UIView {

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = R.color.mu_color_orange_light()
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        self.setupSubViews()
    }
    
    //MARK: -- private
    var cancel: (()->Void)?
    var confirm: ((String)->Void)?
    
    private lazy var textField: UITextField = {
        let input = UITextField()
        input.delegate = self
        input.borderStyle = .roundedRect
        input.backgroundColor = R.color.mu_color_orange_light()
        input.font = UIFont.systemFont(ofSize: 15.0)
        input.returnKeyType = .done
        let att = NSMutableAttributedString(string: "输入名称")
        att.addAttributes([.font : UIFont.systemFont(ofSize: 12.0), .foregroundColor : UIColor(white: 0, alpha: 0.5)], range: NSRange(location: 0, length: att.length))
        input.attributedPlaceholder = att
        return input
    }()
}

extension SongsListCreateView {
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var f = newValue
            f.size = CGSize(width: limit_w, height: limit_h)
            super.frame = f
        }
    }
    
    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            var b = newValue
            b.size = CGSize(width: limit_w, height: limit_h)
            super.bounds = b
        }
    }
}

fileprivate extension SongsListCreateView {
    
    func setupSubViews() {
        
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(15.0)
            make.left.equalTo(self).offset(20.0)
            make.right.equalTo(self).offset(-20.0)
            make.height.equalTo(30.0)
        }
        
        let tipLbl = UILabel()
        tipLbl.text = "仅支持汉字、数字、英文"
        tipLbl.font = UIFont.systemFont(ofSize: 10.0)
        tipLbl.textColor = UIColor(white: 0, alpha: 0.5)
        self.addSubview(tipLbl)
        tipLbl.snp.makeConstraints { (make) in
            make.top.equalTo(self.textField.snp.bottom).offset(5.0)
            make.left.equalTo(self.textField).offset(7.0)
        }
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.adjustsImageWhenHighlighted = false
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(R.color.mu_color_black(), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cancelBtn.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.right.equalTo(self.snp.centerX).offset(-0.25)
            make.height.equalTo(40.0)
        }
        
        let confirmBtn = UIButton(type: .custom)
        confirmBtn.adjustsImageWhenHighlighted = false
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(R.color.mu_color_black(), for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        confirmBtn.addTarget(self, action: #selector(confirm(_:)), for: .touchUpInside)
        self.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.centerX).offset(0.25)
            make.bottom.right.equalTo(self)
            make.height.equalTo(40.0)
        }
        
        let hLine = UIView()
        hLine.backgroundColor = R.color.mu_color_orange_dark()
        self.addSubview(hLine)
        hLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self).offset(-40.0)
            make.height.equalTo(0.5)
        }
        
        let vLine = UIView()
        vLine.backgroundColor = R.color.mu_color_orange_dark()
        self.addSubview(vLine)
        vLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(40.0)
            make.width.equalTo(0.5)
        }
    }
    
    @objc func cancel(_ sender: UIButton) {
        guard let wrappedCancel = self.cancel else { return }
        wrappedCancel()
    }
    
    @objc func confirm(_ sender: UIButton) {
        guard let wrappedConfirm = self.confirm else { return }
        guard var text = self.textField.text else {
            Toaster.flash(withText: "尚未输入名称")
            return
        }
        text = text.replacingOccurrences(of: " ", with: "")
        guard 0 != text.count else {
            Toaster.flash(withText: "不能只输入空格")
            return
        }
        wrappedConfirm(text)
    }
}

extension SongsListCreateView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder { textField.resignFirstResponder() }
        return true
    }
}
