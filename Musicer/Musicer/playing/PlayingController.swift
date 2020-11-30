//
//  PlayingController.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/10.
//

import UIKit
import AVFoundation

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
    private(set) lazy var table: SongsTable = { SongsTable() }()
    private(set) lazy var assist: PlayControllingCardAssist = { PlayControllingCardAssist.standardAssist() }()
    private(set) lazy var card: PlayControllingCard = { PlayControllingCard.standardCard() }()
    
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
        ffprint("正在加载本地歌曲文件")
        Toaster.showLoading()
        var songs = [Song]()
        for i in 0..<20 {
            let title = "这是第 -- \(i+1) -- 首歌曲"
            let song = Song(name: title, fileName: "", author: "汪峰", duration: 10, album: ("", R.image.mu_image_portrait_placeholder()!))
            songs.append(song)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            Toaster.hideLoading()
            self.table.reload(songs)
            ffprint("本地歌曲文件加载完毕")
        }
        
        
        let names = ["那英 - 雾里看花","那英 - 默","汪峰 - 旅途","汪峰 - 沧浪之歌","汪峰 - 像个孩子"]
        SongsManager.shared.map(names) { (songs) in
            print(songs)
        }
        
        
    }
}
