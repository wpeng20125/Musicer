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
    var itemSize: CGSize?
    // 只对左右两侧的 item 有用。对于左侧的 item，该值代表的是 item 距离左边缘的距离；对于右侧的 item，该值代表的是该 item 距离右边缘的距离
    var itemEdgeInset: Float?
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
        
        if let (prorpty, subview) = getItem(atPosition: .left) {
            self.addSubview(subview)
            subview.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.snp.bottom).offset(-22.0)
                if let left = prorpty.itemEdgeInset {
                    make.left.equalTo(self).offset(left)
                }else {
                    make.left.equalTo(self).offset(20.0)
                }
                
                if let size = prorpty.itemSize {
                    make.size.equalTo(size)
                }else {
                    make.size.equalTo(CGSize(width: 20.0, height: 20.0))
                }
            }
        }
        
        if let (prorpty, subview) = getItem(atPosition: .middle) {
            self.addSubview(subview)
            subview.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self.snp.bottom).offset(-22.0)
                if let size = prorpty.itemSize {
                    make.size.equalTo(size)
                }
            }
        }
        
        if let (prorpty, subview) = getItem(atPosition: .right) {
            self.addSubview(subview)
            subview.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.snp.bottom).offset(-22.0)
                if let right = prorpty.itemEdgeInset {
                    make.right.equalTo(self).offset(-right)
                }else {
                    make.right.equalTo(self).offset(-20.0)
                }
                if let size = prorpty.itemSize {
                    make.size.equalTo(size)
                }else {
                    make.size.equalTo(CGSize(width: 20.0, height: 20.0))
                }
            }
        }
    }
    
    func getItem(atPosition p: ItemPosition)->(pp: ItemProperty, view: UIView)? {
        guard let property = dataSource?.property(forNavigationBar: self, atPosition: p) else { return nil }
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.tag = p.rawValue
        if let title = property.title { btn.setTitle(title, for: .normal) }
        if let titleColor = property.titleColor { btn.setTitleColor(titleColor, for: .normal) }
        if let fontSize = property.fontSize { btn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontSize)) }
        if let img = property.image { btn.setImage(img, for: .normal) }
        if let backImg = property.backgroundImage { btn.setBackgroundImage(backImg, for: .normal) }
        if let backColor = property.backgroundColor { btn.backgroundColor = backColor }
        if let boarderColor = property.boarderColor { btn.layer.borderColor = boarderColor.cgColor }
        if let boarderWidth = property.boarderWidth { btn.layer.borderWidth = CGFloat(boarderWidth) }
        if let cornerRadius = property.cornerRadius {
            btn.layer.cornerRadius = CGFloat(cornerRadius)
            btn.layer.masksToBounds = true
        }
        btn.addTarget(self, action:#selector(clickItem(_:)), for: .touchUpInside)
        btn.expand(10.0, 10.0, 10.0, 10.0)
        return (property, btn)
    }
    
    @objc func clickItem(_ item: UIButton) {
        guard let p = ItemPosition(rawValue: item.tag) else { return }
        self.delegate?.itemDidClick(atPosition: p)
    }
}
