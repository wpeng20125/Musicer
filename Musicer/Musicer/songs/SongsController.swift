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
                self.table.reload(songs: self.songs)
                ffprint("\(wrappedName)歌单中的歌曲文件加载完毕")
            }
        }
    }
    
    func delete(song: Song, withFile flag: Bool) {
        Toaster.showLoading()
        let error = SongManager.default.delete(song: song, from: self.listName!, withFile: flag)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            Toaster.hideLoading()
            switch error {
            case let .some(desc):
                Toaster.flash(withText: desc)
            case let .none(info):
                self.songs = self.songs.filter{ $0.fileName != song.fileName }
                self.table.reload(songs: self.songs)
                Toaster.flash(withText: info)
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
        guard let wrappedName = self.listName else { return }
        AudioPlayingManager.default.letsPlay(songs: self.songs, withPlayingIndex: index, forList: wrappedName)
    }
    
    func songsTable(_ table: SongsTable, addSongToListWithIndex index: Int) {
        
    }
    
    func songsTable(_ table: SongsTable, deleteSongWithIndex index: Int) {
        
        #warning("TODO: 删除的时候需要判断是否是当前正在播放的歌曲；如果删除的是播放器持有的列表中的一首的时候，播放器列表要跟着更新！！")
        
        let alert = UIAlertController(title: "是否删除歌曲文件?",
                                      message: "删除歌曲文件，同时也会把该歌曲\n从所有包含该歌曲的歌单中移除。",
                                      preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.table.reloadCell(index: index)
        }
        let deleteRef = UIAlertAction(title: "仅从本歌单移除", style: .default) { (action) in
            self.delete(song: self.songs[index], withFile: false)
        }
        let deleteFile = UIAlertAction(title: "同时删除文件", style: .destructive) { (action) in
            self.delete(song: self.songs[index], withFile: true)
        }
        alert.addAction(deleteRef)
        alert.addAction(deleteFile)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
