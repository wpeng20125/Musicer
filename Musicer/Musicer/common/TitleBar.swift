//
//  TitleBar.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/14.
//

import UIKit

enum ItemPosition: Int {
    case left = 1
    case middle = 2
    case right = 3
}

class ItemProperty {
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
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition)->ItemProperty?
}

protocol TitleBarDelegate: NSObjectProtocol {
    func itemDidClick(atPosition p: ItemPosition)
}

//MARK: -- Bar itself
class TitleBar: UIView {
    
    weak var dataSource: TitleBarDataSource?
    weak var delegate: TitleBarDelegate?
    
    func configure() {
        self.setupSubViews()
    }
}

fileprivate extension TitleBar {
    
    func setupSubViews() {
        
        if let item = getItem(atPosition: .left) {
            self.addSubview(item)
            item.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(20.0)
                make.centerY.equalTo(self.snp.bottom).offset(-22.0)
                make.size.equalTo(CGSize(width: 20.0, height: 20.0))
            }
        }
        
        if let item = getItem(atPosition: .middle) {
            self.addSubview(item)
            item.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self.snp.bottom).offset(-22.0)
            }
        }
        
        if let item = getItem(atPosition: .right) {
            self.addSubview(item)
            item.snp.makeConstraints { (make) in
                make.right.equalTo(self).offset(-20.0)
                make.centerY.equalTo(self.snp.bottom).offset(-22.0)
                make.size.equalTo(CGSize(width: 20.0, height: 20.0))
            }
        }
    }
    
    func getItem(atPosition p: ItemPosition)->UIView? {
        guard let item = dataSource?.property(forNavigationBar: self, atPosition: p) else { return nil }
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
        self.delegate?.itemDidClick(atPosition: p)
    }
}
