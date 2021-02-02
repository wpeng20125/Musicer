//
//  SongsController.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/19.
//

import UIKit

class SongsController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_gray_dark()
        self.setupSubViews()
        self.refresh()
    }

    var listName: String?
    var editable: Bool = false
    
    //MARK: -- private lazy
    private(set) lazy var table: SongsTable = { SongsTable() }()
    private lazy var songs: Array<Song> = { Array<Song>() }()
}

fileprivate extension SongsController {
    
    func setupSubViews() {
        
        let titleBar = TitleBar()
        titleBar.dataSource = self
        titleBar.delegate = self
        titleBar.backgroundColor = R.color.mu_color_orange_light()
        self.view.addSubview(titleBar)
        titleBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(TitleBarHeight)
        }
        titleBar.configure()
        
        self.table.dataSource = self
        self.table.delegate = self
        self.view.addSubview(self.table)
        self.table.snp.makeConstraints { (make) in
            make.top.equalTo(titleBar.snp.bottom)
            make.left.bottom.right.equalTo(self.view)
        }
    }
    
    func refresh() {
        guard let wrappedName = self.listName else { return }
        Toaster.showLoading()
        ffprint("正在加载\(wrappedName)歌单中的歌曲文件")
        SongManager.default.songs(forList: wrappedName) { (songs) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Toaster.hideLoading()
                guard let wrappedSongs = songs else {
                    Toaster.flash(withText: "暂无歌曲数据")
                    return
                }
                self.songs = wrappedSongs
                self.table.reload(self.songs)
                ffprint("\(wrappedName)歌单中的歌曲文件加载完毕")
            }
        }
    }
    
}

extension SongsController: TitleBarDataSource, TitleBarDelegate,SongsTableDataSource ,SongsTableDelegate {
    
    //MARK: -- TitleBarDataSource / TitleBarDelegate
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        let property = ItemProperty()
        switch p {
        case .left:
            property.image = R.image.mu_image_nav_back()
            return property
        case .middle:
            property.title = self.listName
            property.titleColor = R.color.mu_color_white()
            property.fontSize = 16.0
            return property
        case .right:
            return nil
        }
    }
    
    func itemDidClick(atPosition p: ItemPosition) {
        switch p {
        case .left: self.navigationController?.popViewController(animated: true)
        case .right: return
        default: return
        }
    }
    
    //MARK: -- SongsTableDataSource / SongsTableDelegate
    func couldCellBeEditableForSongsTbale(_ table: SongsTable) -> Bool {
        guard let wrappedName = self.listName else { return false }
        guard wrappedName == k_list_name_toatl else { return true }
        return false
    }
    
    func songsTable(_ table: SongsTable, didSelectAtIndex index: Int) {
        
    }
    
    func songsTable(_ table: SongsTable, addSongToListWithIndex index: Int) {
        
    }
    
    func songsTable(_ table: SongsTable, deleteSongWithIndex index: Int) {
        
    }
}
