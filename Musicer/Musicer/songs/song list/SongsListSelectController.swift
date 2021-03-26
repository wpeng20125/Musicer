//
//  SongsListSelectController.swift
//  Musicer
//
//  Created by 王朋 on 2021/3/23.
//

import UIKit

class SongsListSelectController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubViews()
        self.refresh()
    }
    
    var sourceList: String? // 是从哪个列表跳转过来的，必传参数
    var addedSong: Song?    // 要添加到某个列表的歌曲，必传参数
    
    private lazy var selectView: SongsListSelectView = { SongsListSelectView() }()
}

fileprivate extension SongsListSelectController {
    
    func setupSubViews() {
        let titleBar = TitleBar()
        titleBar.dataSource = self
        titleBar.delegate = self
        titleBar.backgroundColor = R.color.mu_color_orange_light()
        self.view.addSubview(titleBar)
        titleBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(64.0)
        }
        titleBar.configure()
        
        self.selectView.selectRow = {[unowned self] (name) in
            self.addSong(name)
        }
        self.view.addSubview(self.selectView)
        self.selectView.snp.makeConstraints { (make) in
            make.top.equalTo(titleBar.snp.bottom);
            make.left.bottom.right.equalTo(self.view)
        }
    }
    
    func refresh() {
        var lists = SongManager.default.totalLists()
        guard let unwrappedSourceList = self.sourceList else {
            Toaster.flash(withText: "sourceList 参数为空")
            return
        }
        lists = lists.filter { $0 != k_list_name_toatl && $0 != unwrappedSourceList }
        if unwrappedSourceList != k_list_name_found { // 如果不是从 我喜欢的 歌单过来，则要保证 我喜欢的 歌单处于最上面的位置
            guard let unwrappedIndex = lists.firstIndex(of: k_list_name_found) else { return }
            if 0 != unwrappedIndex {
                lists.remove(at: unwrappedIndex)
                lists.insert(k_list_name_found, at: 0)
            }
        }
        self.selectView.refresh(withListNames: lists)
    }
    
    func addSong(_ toList: String) {
        guard let unwrappedSong = self.addedSong else {
            Toaster.flash(withText: "addedSong 参数为空")
            return
        }
        let error = SongManager.default.addSong(song: unwrappedSong, toList: toList)
        switch error {
        case let .some(desc):
            Toaster.flash(withText: desc)
            return
        default: ()
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension SongsListSelectController: TitleBarDataSource, TitleBarDelegate {
    
    //MARK: -- TitleBarDataSource / TitleBarDelegate
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        let property = ItemProperty()
        switch p {
        case .left:
            return nil
        case .middle:
            property.title = "请选择歌单"
            property.titleColor = R.color.mu_color_white()
            property.fontSize = 16.0
            return property
        case .right:
            property.title = "取消"
            property.itemSize = CGSize(width: 40.0, height: 20.0)
            property.titleColor = R.color.mu_color_white()
            property.fontSize = 16.0
            return property
        }
    }
    
    func itemDidClick(atPosition p: ItemPosition) {
        switch p {
        case .right: self.dismiss(animated: true, completion: nil)
        default: return
        }
    }
}
