//
//  PlayControllingAssist.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/25.
//

import UIKit

fileprivate let SelfW: CGFloat = 180.0
fileprivate let SelfH: CGFloat = 60.0

class PlayControllingAssist: UIView {
    
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        let f = CGRect(x: ScreenWidth, y: (ScreenHeight - SelfH) / 2, width: SelfH, height: SelfH)
        super.init(frame: f)
        
        self.backgroundColor = R.color.mu_color_lavender_alpha_8()
        self.layer.cornerRadius = SelfH / 2.0
        self.layer.masksToBounds = true
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:))))
        
        self.addSubview(self.assistView)
        self.assistView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    weak var dataSource: PlayControllingAssistDataSource?
    weak var delegate: PlayControllingAssistDelegate?
    
    /// 悬浮窗停留的位置
    private(set) var loc: AssistPosition = .right
    /// 悬浮窗默认为折叠状态
    private var isFold: Bool = true
    
    //MARK: -- lazy
    private lazy var assistView: PlayControllingView = {
        let assist = PlayControllingView()
        assist.delegate = self
        return assist
    }()
}

extension PlayControllingAssist {
    
    /// 刷新数据
    func reloadData() {
        if let unwrappedImg = self.dataSource?.imageToDisplayForPlayControllingAssist(self) {
            self.assistView.setImage(img: unwrappedImg)
        }
        if let unwrappedDisable = self.dataSource?.disableNextButtonForPlayControllingAssist(self) {
            self.assistView.disableNext(unwrappedDisable)
        }
        if let unwrappedDisable = self.dataSource?.disableLastButtonForPlayControllingAssist(self) {
            self.assistView.disableLast(unwrappedDisable)
        }
    }
    
    /// 播放
    func play() {
        self.assistView.play()
    }
    
    /// 暂停
    func pause() {
        self.assistView.pause()
    }
    
    /// 更新进度
    func updateProgress(progress: Float) {
        self.assistView.updateProgress(progress: progress)
    }
    
    /// 展示
    func show(_ complete: @escaping (Bool)->Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.kw_x = Double(ScreenWidth) - self.kw_w
        } completion: { flag in
            complete(flag)
        }
    }
    
    /// 隐藏
    func hide(_ complete: @escaping (Bool)->Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            switch self.loc {
            case .top: self.kw_y = -self.kw_h
            case .left: self.kw_x = -self.kw_w
            case .bottom: self.kw_y = Double(ScreenHeight)
            case .right: self.kw_x = Double(ScreenWidth)
            }
        } completion: { flag in
            complete(flag)
        }
    }
}

fileprivate extension PlayControllingAssist {
    
    /// 折叠
    @objc func fold() {
        self.isFold = true
        self.assistView.coverView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            
            switch self.loc {
            case .right:
                self.kw_x = Double(ScreenWidth) - Double(SelfH)
                self.kw_w = Double(SelfH)
            default:
                self.kw_w = Double(SelfH)
            }
            
            self.assistView.lastBtn.alpha = 0
            self.assistView.playBtn.alpha = 0
            self.assistView.nextBtn.alpha = 0
            self.assistView.closeBtn.alpha = 0
        } completion: { complete in
            self.assistView.coverView.isHidden = true
        }
    }
    
    /// 展开
    func unfold() {
        self.isFold = false
        self.assistView.coverView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            switch self.loc {
            case .left:
                self.kw_w = Double(SelfW)
            case .right:
                self.kw_x = Double(ScreenWidth) - Double(SelfW)
                self.kw_w = Double(SelfW)
            case .top,
                 .bottom:
                if (CGFloat(self.kw_x) + SelfW) < ScreenWidth {
                    self.kw_w = Double(SelfW)
                }else {
                    self.kw_x = Double(ScreenWidth) - Double(SelfW)
                    self.kw_w = Double(SelfW)
                }
            }
            
            self.assistView.lastBtn.alpha = 1.0
            self.assistView.playBtn.alpha = 1.0
            self.assistView.nextBtn.alpha = 1.0
            self.assistView.closeBtn.alpha = 1.0
        } completion: { [self] complete in
            self.assistView.coverView.isHidden = true
            DispatchQueue.main.async {
                self.perform(#selector(fold), with: nil, afterDelay: 3.0, inModes: [.common])
            }
        }
    }
    
}

//MARK: -- PlayControllingViewDelegate
extension PlayControllingAssist: PlayControllingViewDelegate {
    
    func playControllingView_tapIcon() {
        if self.isFold {
            self.unfold()
        }else {
            
        }
    }
    
    func playControllingView_play() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fold), object: nil)
        DispatchQueue.main.async { [self] in
            self.perform(#selector(fold), with: nil, afterDelay: 3.0, inModes: [.common])
        }
        self.delegate?.playControllingAssist(self, didTriggerAction: .play)
    }
    
    func playControllingView_pause() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fold), object: nil)
        DispatchQueue.main.async { [self] in
            self.perform(#selector(fold), with: nil, afterDelay: 3.0, inModes: [.common])
        }
        self.delegate?.playControllingAssist(self, didTriggerAction: .pause)
    }
    
    func playControllingView_last() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fold), object: nil)
        DispatchQueue.main.async { [self] in
            self.perform(#selector(fold), with: nil, afterDelay: 3.0, inModes: [.common])
        }
        self.delegate?.playControllingAssist(self, didTriggerAction: .last)
    }
    
    func playControllingView_next() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fold), object: nil)
        DispatchQueue.main.async { [self] in
            self.perform(#selector(fold), with: nil, afterDelay: 3.0, inModes: [.common])
        }
        self.delegate?.playControllingAssist(self, didTriggerAction: .next)
    }
    
    func playControllingView_close() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fold), object: nil)
        DispatchQueue.main.async { [self] in
            self.perform(#selector(fold), with: nil, afterDelay: 3.0, inModes: [.common])
        }
        self.delegate?.playControllingAssist(self, didTriggerAction: .stop)
    }
}


//MARK: -- 手势
fileprivate extension PlayControllingAssist {
    
    @objc func panGesture(pan: UIPanGestureRecognizer) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fold), object: nil)
        switch pan.state {
        case .changed:
            self.center = pan.location(in: UIApplication.shared.windows.first)
        case .ended, .cancelled, .failed:
            var point = pan.location(in: UIApplication.shared.windows.first)
            if point.x <= ScreenWidth / 2 {
                if point.y <= ScreenHeight / 2 {  //左上区域
                    if point.x <= point.y {
                        point.x = CGFloat(self.kw_w) / 2
                        if point.y < (SafeAreaInsetTop + CGFloat(self.kw_h) / 2) {
                            point.y = SafeAreaInsetTop + CGFloat(self.kw_h) / 2
                        }
                    }else {
                        point.y = SafeAreaInsetTop + CGFloat(self.kw_h) / 2
                        if point.x < CGFloat(self.kw_w) / 2 {
                            point.x = CGFloat(self.kw_w) / 2
                        }
                    }
                }else {  //左下区域
                    if point.x <= (ScreenHeight - SafeAreaInsetBottom - point.y) {
                        point.x = CGFloat(self.kw_w) / 2
                        if point.y > (ScreenHeight - SafeAreaInsetBottom - CGFloat(self.kw_h) / 2) {
                            point.y = ScreenHeight - SafeAreaInsetBottom - CGFloat(self.kw_h) / 2
                        }
                    }else {
                        point.y = ScreenHeight - SafeAreaInsetBottom - CGFloat(self.kw_h) / 2
                        if (point.x < CGFloat(self.kw_w) / 2) {
                            point.x = CGFloat(self.kw_w) / 2
                        }
                    }
                }
            }else {
                if point.y <= ScreenHeight / 2 {  //右上区域
                    if (ScreenWidth - point.x) <= point.y {
                        point.x = ScreenWidth - CGFloat(self.kw_w) / 2
                        if (point.y < SafeAreaInsetTop + CGFloat(self.kw_h) / 2) {
                            point.y = SafeAreaInsetTop + CGFloat(self.kw_h) / 2
                        }
                    }else {
                        point.y = SafeAreaInsetTop + CGFloat(self.kw_h) / 2
                        if point.x > (ScreenWidth - CGFloat(self.kw_w) / 2) {
                            point.x = ScreenWidth - CGFloat(self.kw_w) / 2
                        }
                    }
                }else {  //右下区域
                    if (ScreenWidth - point.x) <= (ScreenHeight - SafeAreaInsetBottom - point.y) {
                        point.x = ScreenWidth - CGFloat(self.kw_w) / 2
                        if point.y > (ScreenHeight - SafeAreaInsetBottom - CGFloat(self.kw_h) / 2) {
                            point.y = ScreenHeight - SafeAreaInsetBottom - CGFloat(self.kw_h) / 2
                        }
                    }else {
                        point.y = ScreenHeight - SafeAreaInsetBottom - CGFloat(self.kw_h) / 2
                        if point.x > (ScreenWidth - CGFloat(self.kw_w) / 2) {
                            point.x = ScreenWidth - CGFloat(self.kw_w) / 2
                        }
                    }
                }
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.center = point
            }) { (complete) in
                guard complete else { return }
                if 0 == self.kw_x {
                    self.loc = .left
                }else if (Double(ScreenWidth) - self.kw_w) == self.kw_x {
                    self.loc = .right
                }else if Double(SafeAreaInsetTop) == self.kw_y {
                    self.loc = .top
                }else {
                    self.loc = .bottom
                }
                DispatchQueue.main.async { [self] in
                    self.perform(#selector(fold), with: nil, afterDelay: 3.0, inModes: [.common])
                }
            }
        default: ()
        }
    }
}
