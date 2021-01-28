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
    
    weak var dataSource: PlayControllingAssistDataSource?
    weak var delegate: PlayControllingAssistDelegate?
    /// 悬浮窗停留的位置
    private(set) var loc: AssistPosition = .right
    
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        let f = CGRect(x: ScreenWidth, y: (ScreenHeight - SelfH) / 2, width: SelfW, height: SelfH)
        super.init(frame: f)
        self.backgroundColor = R.color.mu_color_lavender_alpha_8()
        self.layer.cornerRadius = SelfH / 2.0
        self.layer.masksToBounds = true
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:))))
        self.addSubview(self.assistView)
    }
    
    //MARK: -- lazy
    private lazy var assistView: PlayControllingView = {
        let assist = PlayControllingView(frame: self.bounds)
        assist.delegate = self
        return assist
    }()
}

extension PlayControllingAssist {
    
    /// 刷新数据
    func reloadData() {
        if let img = self.dataSource?.imageToDisplayForPlayControllingAssist(self) {
            self.assistView.setImage(img: img)
        }
        if let disable = self.dataSource?.disableNextButtonForPlayControllingAssist(self) {
            self.assistView.disableNext(disable)
        }
        if let disable = self.dataSource?.disableLastButtonForPlayControllingAssist(self) {
            self.assistView.disableLast(disable)
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
}

//MARK: -- PlayControllingViewDelegate
extension PlayControllingAssist: PlayControllingViewDelegate {
    
    func playControllingView_play() {
        self.delegate?.playControllingAssist(self, didTriggerAction: .play)
    }
    
    func playControllingView_pause() {
        self.delegate?.playControllingAssist(self, didTriggerAction: .pause)
    }
    
    func playControllingView_last() {
        self.delegate?.playControllingAssist(self, didTriggerAction: .last)
    }
    
    func playControllingView_next() {
        self.delegate?.playControllingAssist(self, didTriggerAction: .next)
    }
    
    func playControllingView_close() {
        self.delegate?.playControllingAssist(self, didTriggerAction: .stop)
    }
}


//MARK: -- 手势
fileprivate extension PlayControllingAssist {
    
    @objc func panGesture(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .changed:
            self.center = pan.location(in: UIApplication.shared.windows.first)
        case .ended:
            var point = pan.location(in: UIApplication.shared.windows.first)
            if point.x <= ScreenWidth / 2 {
                if point.y <= ScreenHeight / 2 {  //左上区域
                    if point.x <= point.y {
                        point.x = SelfW / 2
                        if point.y < (SafeAreaInsetTop + SelfH / 2) {
                            point.y = SafeAreaInsetTop + SelfH / 2
                        }
                    }else {
                        point.y = SafeAreaInsetTop + SelfH / 2
                        if point.x < SelfW / 2 {
                            point.x = SelfW / 2
                        }
                    }
                }else {  //左下区域
                    if point.x <= (ScreenHeight - SafeAreaInsetBottom - point.y) {
                        point.x = SelfW / 2
                        if point.y > (ScreenHeight - SafeAreaInsetBottom - SelfH / 2) {
                            point.y = ScreenHeight - SafeAreaInsetBottom - SelfH / 2
                        }
                    }else {
                        point.y = ScreenHeight - SafeAreaInsetBottom - SelfH / 2
                        if (point.x < SelfW / 2) {
                            point.x = SelfW / 2
                        }
                    }
                }
            }else {
                if point.y <= ScreenHeight / 2 {  //右上区域
                    if (ScreenWidth - point.x) <= point.y {
                        point.x = ScreenWidth - SelfW / 2
                        if (point.y < SafeAreaInsetTop + SelfH / 2) {
                            point.y = SafeAreaInsetTop + SelfH / 2
                        }
                    }else {
                        point.y = SafeAreaInsetTop + SelfH / 2
                        if point.x > (ScreenWidth - SelfW / 2) {
                            point.x = ScreenWidth - SelfW / 2
                        }
                    }
                }else {  //右下区域
                    if (ScreenWidth - point.x) <= (ScreenHeight - SafeAreaInsetBottom - point.y) {
                        point.x = ScreenWidth - SelfW / 2
                        if point.y > (ScreenHeight - SafeAreaInsetBottom - SelfH / 2) {
                            point.y = ScreenHeight - SafeAreaInsetBottom - SelfH / 2
                        }
                    }else {
                        point.y = ScreenHeight - SafeAreaInsetBottom - SelfH / 2
                        if point.x > (ScreenWidth - SelfW / 2) {
                            point.x = ScreenWidth - SelfW / 2
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
                print(self.loc)
            }
        default: ()
        }
    }
}
