//
//  NavigationBar.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/14.
//

import UIKit
import SnapKit

enum ItemPosition {
    case left
    case middle
    case right
}

class NavigationBarItem {
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
protocol NavigationBarDataSource: NSObjectProtocol {
    func item(forNavigationBar nav: NavigationBar, atPosition p: ItemPosition)->NavigationBarItem?
}

protocol NavigationBarDelegate: NSObjectProtocol {
    func navigationBar(didClickedItem item: NavigationBarItem, atPosition p: ItemPosition)
}

//MARK: -- Bar itself
class NavigationBar: UIView {
    
    weak var dataSource: NavigationBarDataSource?
    weak var dataDelegate: NavigationBarDelegate?
    
    fileprivate var leftItem: UIButton?
    fileprivate var middleItem: UIButton?
    fileprivate var rightItem: UIButton?
    
    func navigationBar() { self.setupSubViews() }
}

fileprivate extension NavigationBar {
    
    func setupSubViews() {
        
        if let item = dataSource?.item(forNavigationBar: self, atPosition: .left) {
            let btn = UIButton(type: .custom)
            btn.adjustsImageWhenHighlighted = false
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
            self.addSubview(btn)
            btn.snp.makeConstraints { (maker) in
                maker.left.equalTo(self).offset(10.0)
                maker.centerY.equalTo(self.snp.bottom).offset(22.0)
                maker.size.equalTo(CGSize(width: 50.0, height: 30.0))
            }
        }
        
        if let item = dataSource?.item(forNavigationBar: self, atPosition: .middle) {
            
        }
        
        if let item = dataSource?.item(forNavigationBar: self, atPosition: .right) {
            
        }
    }
}
