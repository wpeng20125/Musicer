//
//  PlayControllingCard.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/21.
//

import UIKit

enum PlayingMode: Int {
    case squence = 1, singleLoop, squenceLoop, random
}

enum PlayingState {
    case defaulty, playing, pause
}

fileprivate enum ButtonTag: Int {
    case play = 1, next, last, mode, currentList, allList, favourite, adding
}

protocol PlayControllingCardDelegate: NSObjectProtocol {
    
    func playControllingCardPlayNextSong(_ card: PlayControllingCard)
    func playControllingCardPlayLastSong(_ card: PlayControllingCard)
    func playControllingCardUploadSongs(_ card: PlayControllingCard)
    func playControllingCardShowAllList(_ card: PlayControllingCard)
    func playControllingCardShowCurrentList(_ card: PlayControllingCard)
    func playControllingCardFavouriteThisSong(_ card: PlayControllingCard)
    func playControllingCard(_ card: PlayControllingCard, displayCompleted byShowing: Bool)
    func playControllingCard(_ card: PlayControllingCard, playingModeChanged mode: PlayingMode)
    func playControllingCard(_ card: PlayControllingCard, playingStateChanged state: PlayingState)
}

class PlayControllingCard: UIView {
    
    static let CardHeight = 200.0 + SafeAreaInsetBottom
    private let w_h: CGFloat = 30.0
    
    //MARK: -- 各个button的tag
    let PlayingBtnTag = 1000
    let NextBtnTag = 1010
    let LastBtnTag = 1020
    let ModeBtnTag = 1030
    let CurrentListBtnTag = 1040
    
    //MARK: -- public
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        let f = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: CGFloat(PlayControllingCard.CardHeight))
        super.init(frame: f)
        self.backgroundColor = R.color.mu_color_clear()
        self.setupSubViews()
        let swipper = UISwipeGestureRecognizer(target: self, action: #selector(swipDown(gesture:)))
        swipper.direction = .down
        self.addGestureRecognizer(swipper)
        
    }
    
    weak var delegate: PlayControllingCardDelegate?
    private(set) var isShowing: Bool = false
    private(set) var playingMode: PlayingMode = .squence
    private(set) var playingState: PlayingState = .defaulty

    func show() { self.showCard(true) }
    
    func hide() { self.showCard(false) }
    
    //MARK: -- lazy
    private lazy var bgView: UIView = {
        let backgroundVeiw = UIView()
        backgroundVeiw.backgroundColor = R.color.mu_color_orange_light()
        backgroundVeiw.layer.cornerRadius = 10.0
        backgroundVeiw.layer.masksToBounds = true
        return backgroundVeiw
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = R.color.mu_color_orange_light()
        progress.trackTintColor = R.color.mu_color_progress_bg()
        progress.transform = CGAffineTransform(scaleX: 1, y: 1.5)
        progress.layer.cornerRadius = progress.bounds.height / 2
        progress.layer.masksToBounds = true
        return progress
    }()
    
    private lazy var modeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.mode.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play_squence(), for: .normal)
        btn.h_size = CGSize(width: w_h, height: w_h)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var lastBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.last.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play_last(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var playBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.play.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.next.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play_next(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var currentListBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.currentList.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_folder_current(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var allListBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.allList.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_folder_all(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var faverBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.favourite.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_folder_favourite(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.adding.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_add(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        return btn
    }()
}

//MARK: -- layout subviews
fileprivate extension PlayControllingCard {
    
    func setupSubViews() {
        
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.bgView.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgView).offset(100.0)
            make.centerX.equalTo(self.bgView)
            make.width.equalTo(ScreenWidth - 30.0 * 2)
        }
    
        self.bgView.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.progressView.snp.bottom).offset(25.0)
            make.centerX.equalTo(self.bgView)
            make.size.equalTo(CGSize(width: w_h, height: w_h))
        }
        
        self.bgView.addSubview(self.modeBtn)
        self.modeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.playBtn)
            make.centerX.equalTo(self.progressView.snp.leading)
            make.size.equalTo(CGSize(width: w_h + 5.0, height: w_h + 5.0))
        }
        
        self.bgView.addSubview(self.currentListBtn)
        self.currentListBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.playBtn)
            make.centerX.equalTo(self.progressView.snp.trailing)
            make.size.equalTo(CGSize(width: w_h, height: w_h))
        }
        
        let margin = (ScreenWidth / 2 - 30.0) / 2
        self.bgView.addSubview(self.lastBtn)
        self.lastBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.playBtn)
            make.centerX.equalTo(self.playBtn).offset(-margin)
            make.size.equalTo(CGSize(width: w_h, height: w_h))
        }
        
        self.bgView.addSubview(self.nextBtn)
        self.nextBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.playBtn)
            make.centerX.equalTo(self.playBtn).offset(margin)
            make.size.equalTo(CGSize(width: w_h, height: w_h))
        }
        
        self.bgView.addSubview(self.faverBtn)
        self.faverBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.progressView.snp.top).offset(-25.0)
            make.centerX.equalTo(self.bgView)
            make.size.equalTo(CGSize(width: w_h, height: w_h))
        }
        
        self.bgView.addSubview(self.allListBtn)
        self.allListBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.faverBtn)
            make.centerX.equalTo(self.faverBtn).offset(-margin)
            make.size.equalTo(CGSize(width: w_h, height: w_h))
        }
        
        self.bgView.addSubview(self.addBtn)
        self.addBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.faverBtn)
            make.centerX.equalTo(self.faverBtn).offset(margin)
            make.size.equalTo(CGSize(width: w_h, height: w_h))
        }
    }
}

//MARK: -- Actions
fileprivate extension PlayControllingCard {
    
    //MARK: -- playing controlling button action
    @objc func click(atButton sender: UIButton) {
        guard let tag = ButtonTag(rawValue: sender.tag) else { return }
        switch tag {
        case .play:
            if self.playingState == .defaulty || self.playingState == .pause  {
                self.playingState = .playing
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.startPlayingAnimation()
                }
            }else if self.playingState == .playing {
                self.playingState = .pause
                self.stopPlayingAnimation()
            }
            self.delegate?.playControllingCard(self, playingStateChanged: self.playingState)
        case .next:
            self.delegate?.playControllingCardPlayNextSong(self)
        case .last:
            self.delegate?.playControllingCardPlayLastSong(self)
        case .adding:
            self.delegate?.playControllingCardUploadSongs(self)
        case .allList:
            self.delegate?.playControllingCardShowAllList(self)
        case .currentList:
            self.delegate?.playControllingCardShowCurrentList(self)
        case .favourite:
            self.delegate?.playControllingCardFavouriteThisSong(self)
        case .mode:
            if self.playingMode == .squence {
                self.playingMode = .squenceLoop
                self.modeBtn.setImage(R.image.mu_image_play_list_loop(), for: .normal)
            }else if self.playingMode == .squenceLoop {
                self.playingMode = .random
                self.modeBtn.setImage(R.image.mu_image_play_random(), for: .normal)
            }else if self.playingMode == .random {
                self.playingMode = .singleLoop
                self.modeBtn.setImage(R.image.mu_image_play_single_loop(), for: .normal)
            }else if self.playingMode == .singleLoop {
                self.playingMode = .squence
                self.modeBtn.setImage(R.image.mu_image_play_squence(), for: .normal)
            }
            self.delegate?.playControllingCard(self, playingModeChanged: self.playingMode)
        }
        let zoom = CABasicAnimation(keyPath: "transform.scale")
        zoom.duration = 0.09
        zoom.fromValue = 1.0
        zoom.toValue = 0.7
        zoom.autoreverses = true
        zoom.isRemovedOnCompletion = true
        sender.layer.add(zoom, forKey: "kZoomAniamtionKey")
    }
    
    //MARK: -- swip gesture
    @objc func swipDown(gesture: UISwipeGestureRecognizer) {
        self.hide()
    }
}

//MARK: --  animations
fileprivate extension PlayControllingCard {
    
    func showCard(_ show: Bool) {
        if (show && self.isShowing) || (!show && !self.isShowing) { return }
        self.isShowing = show
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.h_y = show ? Double(ScreenHeight - PlayControllingCard.CardHeight) : Double(ScreenHeight)
        } completion: { (complete) in
            self.delegate?.playControllingCard(self, displayCompleted: show)
        }
    }
    
    func startPlayingAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 5
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.repeatCount = MAXFLOAT
        self.playBtn.layer.add(animation, forKey: "kClockwiseRotationAnimationKey")
    }
    
    func stopPlayingAnimation() {
        self.playBtn.layer.removeAllAnimations()
    }
}

