//
//  NavigationBar.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/14.
//

import UIKit
import SnapKit

enum ItemPosition: Int {
    case left = 1
    case middle = 2
    case right = 3
}

class TitleBarItem {
    var title: String?
    var titleColor: UIColor?
    var fontSize: Float?
    var image: UIImage?
    var backgroundImage: UIImage?
    var backgroundColor: UIColor?
    var boarderColor: UIColor?
    var boarderWidth: Float?
    var cornerRadius: Float?
}

//MARK: -- datasource / delegate
protocol TitleBarDataSource: NSObjectProtocol {
    func item(forNavigationBar nav: TitleBar, atPosition p: ItemPosition)->TitleBarItem?
}

protocol TitleBarDelegate: NSObjectProtocol {
    func itemDidClicked(atPosition p: ItemPosition)
}

//MARK: -- Bar itself
class TitleBar: UIView {
    
    weak var dataSource: TitleBarDataSource?
    weak var delegate: TitleBarDelegate?
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
    }
}

fileprivate extension TitleBar {
    
    func setupSubViews() {
        
        if let btn = button(atPosition: .left) {
            self.addSubview(btn)
            btn.snp.makeConstraints { (maker) in
                maker.left.equalTo(self).offset(10.0)
                maker.centerY.equalTo(self.snp.bottom).offset(22.0)
                maker.size.equalTo(CGSize(width: 50.0, height: 30.0))
            }
        }
        
        if let btn = button(atPosition: .middle) {
            self.addSubview(btn)
            btn.snp.makeConstraints { (maker) in
                maker.centerX.equalTo(self)
                maker.centerY.equalTo(self.snp.bottom).offset(22.0)
                maker.size.equalTo(CGSize(width: 50.0, height: 30.0))
            }
        }
        
        if let btn = button(atPosition: .right) {
            self.addSubview(btn)
            btn.snp.makeConstraints { (maker) in
                maker.right.equalTo(self).offset(-10.0)
                maker.centerY.equalTo(self.snp.bottom).offset(22.0)
                maker.size.equalTo(CGSize(width: 50.0, height: 30.0))
            }
        }
    }
    
    func button(atPosition p: ItemPosition)->UIButton? {
        guard let item = dataSource?.item(forNavigationBar: self, atPosition: p) else { return nil }
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.tag = p.rawValue
        if let title = item.title { btn.setTitle(title, for: .normal) }
        if let titleColor = item.titleColor { btn.setTitleColor(titleColor, for: .normal) }
        if let fontSize = item.fontSize { btn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontSize)) }
        if let img = item.image { btn.setImage(img, for: .normal) }
        if let backImg = item.backgroundImage { btn.setBackgroundImage(backImg, for: .normal) }
        if let backColor = item.backgroundColor { btn.backgroundColor = backColor }
        if let boarderColor = item.boarderColor { btn.layer.borderColor = boarderColor.cgColor }
        if let boarderWidth = item.boarderWidth { btn.layer.borderWidth = CGFloat(boarderWidth) }
        if let cornerRadius = item.cornerRadius {
            btn.layer.cornerRadius = CGFloat(cornerRadius)
            btn.layer.masksToBounds = true
        }
        btn.addTarget(self, action:#selector(clickItem(_:)), for: .touchUpInside)
        return btn
    }
    
    @objc func clickItem(_ item: UIButton) {
        guard let p = ItemPosition(rawValue: item.tag) else { return }
        self.delegate?.itemDidClicked(atPosition: p)
    }
}
