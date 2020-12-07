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
import AVFoundation

class PlayingController: BaseViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { self.assist.show() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_gray_dark()
        self.configure()
        self.refresh()
    }
    
    //MARK: -- lazy
    private(set) lazy var table: SongsTable = { SongsTable() }()
    private(set) lazy var assist: PlayControllingCardAssist = { PlayControllingCardAssist.standardAssist() }()
    private(set) lazy var card: PlayControllingCard = { PlayControllingCard.standardCard() }()
    // data
    private lazy var currentList: [Song] = { [] }()
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
        
        self.view.addSubview(self.table)
        self.table.snp.makeConstraints { (make) in
            make.top.equalTo(titleBar.snp.bottom)
            make.left.bottom.right.equalTo(self.view)
        }
        
        self.assist.delegate = self
        self.view.addSubview(self.assist)
        
        self.card.delegate = self
        self.view.addSubview(self.card)
    }
}

//MARK: -- load data
fileprivate extension PlayingController {
    
    func refresh() {
        ffprint("正在加载本地歌曲文件")
        Toaster.showLoading()
        SongManager.default.songs(forList: k_list_name_toatl) { (songs) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                Toaster.hideLoading()
                guard let wrappedSongs = songs else {
                    Toaster.flash(withText: "暂无歌曲数据", backgroundColor: R.color.mu_color_orange_dark())
                    return
                }
                self.table.reload(wrappedSongs)
                ffprint("本地歌曲文件加载完毕")
            }
        }
    }
}

extension PlayingController: TitleBarDataSource, TitleBarDelegate, PlayControllingCardAssistDelegate, PlayControllingCardDelegate, SongsTableDelegate, LoadingProtocol {
    
    //MARK: -- TitleBarDataSource
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        let item = ItemProperty()
        switch p {
        case .left:
            #if DEBUG
            item.title = "DEBUG"
            item.titleColor = R.color.mu_color_white()
            item.fontSize = 15.0
            item.itemSize = CGSize(width: 60.0, height: 20.0)
            return item
            #else
            return nil
            #endif
        case .middle:
            item.title = "当前播放列表"
            item.titleColor = R.color.mu_color_white()
            item.fontSize = 16.0
            return item
        case .right:
            return nil
        }
    }
    
    func itemDidClick(atPosition p: ItemPosition) {
        switch p {
        case .left:
            #if DEBUG
            FLEXManager.shared.showExplorer()
            #endif
        case .middle: ffprint("")
        case .right: ffprint("")
        }
    }
    
    //MARK: -- LoadingProtocol
    func reload() {
        self.refresh()
    }
    
    //MARK: -- PlayControllingCardAssistDelegate
    func assistGestureTriggered(_ assist: PlayControllingCardAssist) {
        self.card.show()
        assist.hide()
    }
    
    //MARK: -- PlayControllingCardDelegate
    func playControllingCardPlayNextSong(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardPlayLastSong(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardUploadSongs(_ card: PlayControllingCard) {
        let uploader = UploadController()
        uploader.delegate = self
        self.present(uploader, animated: true, completion: nil)
    }
    
    func playControllingCardShowAllList(_ card: PlayControllingCard) {
        let listVc = SongsListController()
        self.navigationController?.pushViewController(listVc, animated: true)
    }
    
    func playControllingCardShowCurrentList(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardFavouriteThisSong(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCard(_ card: PlayControllingCard, playingModeChanged mode: PlayingMode) {
        
    }
    
    func playControllingCard(_ card: PlayControllingCard, playingStateChanged state: PlayingState) {
        
    }
    
    func playControllingCard(_ card: PlayControllingCard, willDisplay byShowing: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.table.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.view).offset(byShowing ? -card.kw_h : 0)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func playControllingCard(_ card: PlayControllingCard, displayCompleted byShowing: Bool) {
        guard byShowing else {
            self.assist.show()
            return
        }
        self.assist.hide()
    }
    
    //MARK: -- SongsTableDelegate
    func songsTable(_ table: SongsTable, didSelectSong song: Song) {
        
    }
}
