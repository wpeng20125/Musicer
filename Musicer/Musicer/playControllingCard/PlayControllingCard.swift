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
    func playControllingCard(_ card: PlayControllingCard, willDisplay byShowing: Bool)
    func playControllingCard(_ card: PlayControllingCard, displayCompleted byShowing: Bool)
    func playControllingCard(_ card: PlayControllingCard, playingModeChanged mode: PlayingMode)
    func playControllingCard(_ card: PlayControllingCard, playingStateChanged state: PlayingState)
}

fileprivate let CardHeight = 200.0 + SafeAreaInsetBottom

class PlayControllingCard: UIView {
    
    //MARK: -- public
    weak var delegate: PlayControllingCardDelegate?
    
    /**
     创建一个标准尺寸的 card
     */
    static func standardCard()->PlayControllingCard { self.initCard() }
    
    /**
     播放
     */
    func play() { self.startPlay() }
    
    /**
     暂停播放
     */
    func pause() { self.pausePlay() }
    
    /**
     停止播放
     */
    func stop() { self.stopPlay() }
    
    /**
     显示控制卡片
     */
    func show() { self.showCard(true) }
    
    /**
     隐藏控制卡片
     */
    func hide() { self.showCard(false) }
    
    /**
     设置进度条
     */
    func setProgress(_ progress: Float) { self.progressView.setProgress(progress, animated: true) }
    
    //MARK: -- private
    fileprivate let ButtonSize = CGSize(width: 35.0, height: 35.0)
    fileprivate var isShowing: Bool = false
    fileprivate var playingMode: PlayingMode = .squence
    fileprivate var playingState: PlayingState = .defaulty
    
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
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        btn.expand(5.0, 5.0, 5.0, 5.0)
        return btn
    }()
    
    private lazy var lastBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.last.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play_last(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        btn.expand(5.0, 5.0, 5.0, 5.0)
        return btn
    }()
    
    private lazy var playBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.play.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setBackgroundImage(R.image.mu_image_play(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        btn.expand(5.0, 5.0, 5.0, 5.0)
        return btn
    }()
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.next.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play_next(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        btn.expand(5.0, 5.0, 5.0, 5.0)
        return btn
    }()
    
    private lazy var currentListBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.currentList.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_folder_current(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        btn.expand(5.0, 5.0, 5.0, 5.0)
        return btn
    }()
    
    private lazy var allListBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.allList.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_folder_all(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        btn.expand(5.0, 5.0, 5.0, 5.0)
        return btn
    }()
    
    private lazy var faverBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.favourite.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_folder_favourite(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        btn.expand(5.0, 5.0, 5.0, 5.0)
        return btn
    }()
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = ButtonTag.adding.rawValue
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_add(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        btn.expand(5.0, 5.0, 5.0, 5.0)
        return btn
    }()
}

//MARK: -- layout subviews
fileprivate extension PlayControllingCard {
    
    static func initCard()->PlayControllingCard {
        let card = PlayControllingCard(frame: CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: CardHeight))
        card.backgroundColor = R.color.mu_color_clear()
        let swip = UISwipeGestureRecognizer(target: card, action: #selector(swipDown(gesture:)))
        swip.direction = .down
        card.addGestureRecognizer(swip)
        card.setupSubViews()
        card.addNotification()
        return card
    }
    
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
            make.size.equalTo(CGSize(width: ButtonSize.width + 5.0, height: ButtonSize.height + 5.0))
        }
        
        self.bgView.addSubview(self.modeBtn)
        self.modeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.playBtn)
            make.centerX.equalTo(self.progressView.snp.leading)
            make.size.equalTo(CGSize(width: ButtonSize.width, height: ButtonSize.height))
        }
        
        self.bgView.addSubview(self.currentListBtn)
        self.currentListBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.playBtn)
            make.centerX.equalTo(self.progressView.snp.trailing)
            make.size.equalTo(ButtonSize)
        }
        
        let margin = (ScreenWidth / 2 - 30.0) / 2
        self.bgView.addSubview(self.lastBtn)
        self.lastBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.playBtn)
            make.centerX.equalTo(self.playBtn).offset(-margin)
            make.size.equalTo(ButtonSize)
        }
        
        self.bgView.addSubview(self.nextBtn)
        self.nextBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.playBtn)
            make.centerX.equalTo(self.playBtn).offset(margin)
            make.size.equalTo(ButtonSize)
        }
        
        self.bgView.addSubview(self.faverBtn)
        self.faverBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.progressView.snp.top).offset(-25.0)
            make.centerX.equalTo(self.bgView)
            make.size.equalTo(ButtonSize)
        }
        
        self.bgView.addSubview(self.allListBtn)
        self.allListBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.faverBtn)
            make.centerX.equalTo(self.faverBtn).offset(-margin)
            make.size.equalTo(ButtonSize)
        }
        
        self.bgView.addSubview(self.addBtn)
        self.addBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.faverBtn)
            make.centerX.equalTo(self.faverBtn).offset(margin)
            make.size.equalTo(ButtonSize)
        }
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: OperationQueue.main) { (noti) in
            if self.playingState == .playing { self.pausePlayingAnimation() }
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { (noti) in
            if self.playingState == .playing { self.startPlayingAnimation() }
        }
    }
    
    
    
}

//MARK: -- Actions
fileprivate extension PlayControllingCard {
    
    var modeMaps: [PlayingMode : (mode: PlayingMode, img: UIImage?, tip: String)] {
        return [PlayingMode.squence : (PlayingMode.squenceLoop, R.image.mu_image_play_squence_loop(), "列表循环"),
                PlayingMode.squenceLoop : (PlayingMode.random, R.image.mu_image_play_random(), "随机播放"),
                PlayingMode.random : (PlayingMode.singleLoop, R.image.mu_image_play_single_loop(), "单曲循环"),
                PlayingMode.singleLoop : (PlayingMode.squence, R.image.mu_image_play_squence(), "列表播放")]
    }
    
    //MARK: -- playing controlling button action
    @objc func click(atButton sender: UIButton) {
        guard let tag = ButtonTag(rawValue: sender.tag) else { return }
        if tag != .play {
            let zoom = CABasicAnimation(keyPath: "transform.scale")
            zoom.duration = 0.1
            zoom.fromValue = 1.0
            zoom.toValue = 0.7
            zoom.autoreverses = true
            zoom.isRemovedOnCompletion = true
            sender.layer.add(zoom, forKey: "kZoomAniamtionKey")
        }
        switch tag {
        case .play:
            if self.playingState == .playing  {
                self.pause()
            }else {
                self.play()
            }
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
            if let msg = self.modeMaps[self.playingMode]?.tip {
                Toaster.flash(withText: msg, backgroundColor: R.color.mu_color_orange_dark())
            }
            self.modeBtn.setImage(self.modeMaps[self.playingMode]?.img, for: .normal)
            self.playingMode = self.modeMaps[self.playingMode]?.mode ?? .squence
            self.delegate?.playControllingCard(self, playingModeChanged: self.playingMode)
        }
    }
    
    //MARK: -- swip gesture
    @objc func swipDown(gesture: UISwipeGestureRecognizer) {
        self.hide()
    }
}

//MARK: --  animations
fileprivate extension PlayControllingCard {
    
    func startPlay() {
        self.playingState = .playing
        self.startPlayingAnimation()
        self.delegate?.playControllingCard(self, playingStateChanged: .playing)
    }
    
    func pausePlay() {
        self.playingState = .pause
        self.pausePlayingAnimation()
        self.delegate?.playControllingCard(self, playingStateChanged: .pause)
    }
    
    func stopPlay() {
        self.playingState = .defaulty
        self.stopPlayingAnimation()
        self.delegate?.playControllingCard(self, playingStateChanged: .defaulty)
    }
    
    func showCard(_ show: Bool) {
        if (show && self.isShowing) || (!show && !self.isShowing) { return }
        self.isShowing = show
        self.delegate?.playControllingCard(self, willDisplay: self.isShowing)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.y = show ? Double(ScreenHeight - CardHeight) : Double(ScreenHeight)
        } completion: { (complete) in
            self.delegate?.playControllingCard(self, displayCompleted: self.isShowing)
        }
    }
    
    func startPlayingAnimation() {
        guard nil != self.playBtn.layer.animation(forKey: "kClockwiseRotationAnimationKey") else {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.duration = 3
            animation.fromValue = 0
            animation.toValue = Double.pi * 2
            animation.repeatCount = MAXFLOAT
            animation.isRemovedOnCompletion = false
            self.playBtn.layer.add(animation, forKey: "kClockwiseRotationAnimationKey")
            return
        }
        let pausedTime = self.playBtn.layer.timeOffset
        self.playBtn.layer.speed = 1.0
        self.playBtn.layer.timeOffset = 0
        self.playBtn.layer.beginTime = 0
        self.playBtn.layer.beginTime = self.playBtn.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    }
    
    func pausePlayingAnimation() {
        guard nil != self.playBtn.layer.animation(forKey: "kClockwiseRotationAnimationKey") else { return }
        guard 0 != self.playBtn.layer.speed else { return }
        let pausedTime = self.playBtn.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.playBtn.layer.speed = 0
        self.playBtn.layer.timeOffset = pausedTime
    }
    
    func stopPlayingAnimation() {
        self.playBtn.layer.removeAllAnimations()
    }
}

