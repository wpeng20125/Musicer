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
class TitleBar: UIImageView {
    
    weak var dataSource: TitleBarDataSource?
    weak var delegate: TitleBarDelegate?
    
    func configure() {
        self.isUserInteractionEnabled = true
        self.setupSubViews()
    }
}

fileprivate extension TitleBar {
    
    func setupSubViews() {
        
        if let (unwrappedProrpty, wrappedSubview) = getItem(atPosition: .left) {
            self.addSubview(wrappedSubview)
            wrappedSubview.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.snp.bottom).offset(-22.0)
                if let unwrappedLeftMargin = unwrappedProrpty.itemEdgeInset {
                    make.left.equalTo(self).offset(unwrappedLeftMargin)
                }else {
                    make.left.equalTo(self).offset(20.0)
                }
                
                if let unwrappedSize = unwrappedProrpty.itemSize {
                    make.size.equalTo(unwrappedSize)
                }else {
                    make.size.equalTo(CGSize(width: 20.0, height: 20.0))
                }
            }
        }
        
        if let (unwrappedProrpty, wrappedSubview) = getItem(atPosition: .middle) {
            self.addSubview(wrappedSubview)
            wrappedSubview.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self.snp.bottom).offset(-22.0)
                if let unwrappedSize = unwrappedProrpty.itemSize {
                    make.size.equalTo(unwrappedSize)
                }
            }
        }
        
        if let (unwrappedProrpty, wrappedSubview) = getItem(atPosition: .right) {
            self.addSubview(wrappedSubview)
            wrappedSubview.snp.makeConstraints { (make) in
                make.centerY.equalTo(self.snp.bottom).offset(-22.0)
                if let unwrappedRightMargin = unwrappedProrpty.itemEdgeInset {
                    make.right.equalTo(self).offset(-unwrappedRightMargin)
                }else {
                    make.right.equalTo(self).offset(-20.0)
                }
                if let unwrappedSize = unwrappedProrpty.itemSize {
                    make.size.equalTo(unwrappedSize)
                }else {
                    make.size.equalTo(CGSize(width: 20.0, height: 20.0))
                }
            }
        }
    }
    
    func getItem(atPosition p: ItemPosition)->(pp: ItemProperty, view: UIView)? {
        guard let unwrappedProperty = dataSource?.property(forNavigationBar: self, atPosition: p) else { return nil }
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.tag = p.rawValue
        if let unwrappedTitle = unwrappedProperty.title { btn.setTitle(unwrappedTitle, for: .normal) }
        if let unwrappedTitleColor = unwrappedProperty.titleColor { btn.setTitleColor(unwrappedTitleColor, for: .normal) }
        if let unwrappedFontSize = unwrappedProperty.fontSize { btn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(unwrappedFontSize)) }
        if let unwrappedImg = unwrappedProperty.image { btn.setImage(unwrappedImg, for: .normal) }
        if let unwrappedBackImg = unwrappedProperty.backgroundImage { btn.setImage(unwrappedBackImg, for: .normal) }
        if let unwrappedBackColor = unwrappedProperty.backgroundColor { btn.backgroundColor = unwrappedBackColor }
        if let unwrappedBoarderColor = unwrappedProperty.boarderColor { btn.layer.borderColor = unwrappedBoarderColor.cgColor }
        if let unwrappedBoarderWidth = unwrappedProperty.boarderWidth { btn.layer.borderWidth = CGFloat(unwrappedBoarderWidth) }
        if let unwrappedCornerRadius = unwrappedProperty.cornerRadius {
            btn.layer.cornerRadius = CGFloat(unwrappedCornerRadius)
            btn.layer.masksToBounds = true
        }
        btn.addTarget(self, action:#selector(clickItem(_:)), for: .touchUpInside)
        btn.expand(10.0, 10.0, 10.0, 10.0)
        return (unwrappedProperty, btn)
    }
    
    @objc func clickItem(_ item: UIButton) {
        guard let unwrappedPosition = ItemPosition(rawValue: item.tag) else { return }
        self.delegate?.itemDidClick(atPosition: unwrappedPosition)
    }
}
