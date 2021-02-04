//
//  PlayingController.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/10.
//
#if DEBUG
import FLEX.FLEXManager
#endif

import UIKit

class PlayingController: BaseViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_gray_dark()
        self.configure()
        self.refresh()
    }
    
    //MARK: -- lazy
    private lazy var table: SongsTable = { SongsTable() }()
    private lazy var songs: Array<Song> = { Array<Song>() }()
}

//MARK: -- setup subviews
fileprivate extension PlayingController {
    
    func configure() {
        
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
        
        self.table.delegate = self
        self.view.addSubview(self.table)
        self.table.snp.makeConstraints { (make) in
            make.top.equalTo(titleBar.snp.bottom)
            make.left.bottom.right.equalTo(self.view)
        }
    }
}

//MARK: -- load data
fileprivate extension PlayingController {
    
    func refresh() {
        ffprint("正在加载本地歌曲文件")
        Toaster.showLoading()
        SongManager.default.songs(forList: k_list_name_toatl) { (songs) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Toaster.hideLoading()
                guard let wrappedSongs = songs else {
                    Toaster.flash(withText: "暂无歌曲数据")
                    return
                }
                self.songs = wrappedSongs
                self.table.reload(songs: self.songs)
                ffprint("本地歌曲文件加载完毕")
            }
        }
    }
}

extension PlayingController: TitleBarDataSource, TitleBarDelegate, SongsTableDelegate {
    
    //MARK: -- TitleBarDataSource
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        let item = ItemProperty()
        switch p {
        case .left:
            item.image = R.image.mu_image_song_list()
            return item
        case .middle:
            item.title = "全部歌曲"
            item.titleColor = R.color.mu_color_white()
            item.fontSize = 16.0
            return item
        case .right:
            item.image = R.image.mu_image_add()
            return item
        }
    }
    
    func itemDidClick(atPosition p: ItemPosition) {
        switch p {
        case .left:
            let listVc = SongsListController()
            self.navigationController?.pushViewController(listVc, animated: true)
        case .right:
            let uploaderVc = UploadController()
            uploaderVc.didDismiss = {
                self.refresh()
            }
            self.present(uploaderVc, animated: true, completion: nil)
        default: ()
            #if DEBUG
            FLEXManager.shared.showExplorer()
            #endif
        }
    }
        
    //MARK: -- SongsTableDelegate
    func songsTable(_ table: SongsTable, didSelectAtIndex index: Int) {
        AudioPlayingManager.default.letsPlay(songs: self.songs, withPlayingIndex: index, forList: "")
    }
}
