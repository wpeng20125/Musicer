//
//  PlayingController.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/10.
//

import UIKit

class PlayingController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { self.assist.show() }
        self.loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_gray_dark()
        self.configure()
    }
    
    //MARK: -- lazy
    private lazy var titleBar: TitleBar = { TitleBar() }()
    private lazy var table: SongsTable = { SongsTable() }()
    private lazy var assist: PlayControllingCardAssist = { PlayControllingCardAssist.standardAssist() }()
    private lazy var card: PlayControllingCard = { PlayControllingCard.standardCard() }()
    
    // data
    private lazy var currentList: [Song] = { [] }()
}

//MARK: -- setup subviews
fileprivate extension PlayingController {
    
    func configure() {
        
        self.titleBar.dataSource = self
        self.titleBar.backgroundColor = R.color.mu_color_orange_light()
        self.view.addSubview(self.titleBar)
        self.titleBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(TitleBarHeight)
        }
        self.titleBar.configure()
        
        self.view.addSubview(self.table)
        self.table.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleBar.snp.bottom)
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
    
    func loadData() {
        Toaster.showLoading()
        var songs = [Song]()
        for i in 0..<20 {
            let title = "这是第 -- \(i+1) -- 首歌曲"
            let song = Song(name: title, author: "汪峰", authorPortrait: (R.image.mu_image_portrait_placeholder()!, nil), album: (R.image.mu_image_portrait_placeholder()!, nil))
            songs.append(song)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            Toaster.hideLoading()
            self.table.reload(songs)
        }
    }
}

//MARK: -- delegate
extension PlayingController: PlayControllingCardAssistDelegate, PlayControllingCardDelegate, TitleBarDataSource {
    
    //MARK: -- TitleBarDataSource
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        if p != .middle { return nil }
        let item = ItemProperty()
        item.title = "当前播放列表"
        item.titleColor = R.color.mu_color_white()
        item.fontSize = 16.0
        return item
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
        
    }
    
    func playControllingCardShowAllList(_ card: PlayControllingCard) {
        
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
                make.bottom.equalTo(self.view).offset(byShowing ? -card.h : 0)
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
}
