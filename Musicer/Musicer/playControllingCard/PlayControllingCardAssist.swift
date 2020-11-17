//
//  PlayControllingCardAssist.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/10.
//

import UIKit

protocol PlayControllingCardAssistDelegate: NSObjectProtocol {
    func assistGestureTriggered(_ assist: PlayControllingCardAssist)
}

fileprivate let AssistHeight = 50.0 + SafeAreaInsetBottom

class PlayControllingCardAssist: UIView {
    
    //MARK: -- public
    weak var delegate: PlayControllingCardAssistDelegate?
        
    static func standardAssist()->PlayControllingCardAssist { self.initAssist() }
    
    func show() { self.animate(showing: true) }
    
    func hide() { self.animate(showing: false) }
    
    //MARK: -- private
    fileprivate var isShowing: Bool = false
    
    //MARK: -- lazy
    private lazy var puller: UIImageView = {
        let pull = UIImageView()
        pull.isUserInteractionEnabled = true
        pull.image = R.image.mu_image_control_pull()
        return pull
    }()
}

fileprivate extension PlayControllingCardAssist {
    
    static func initAssist()->PlayControllingCardAssist {
        let f = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: AssistHeight)
        let assist = PlayControllingCardAssist(frame: f)
        assist.backgroundColor = R.color.mu_color_clear()
        let swip = UISwipeGestureRecognizer(target: assist, action: #selector(pullerTriggered(_:)))
        swip.direction = .up
        assist.addGestureRecognizer(swip)
        assist.setupSubViews()
        return assist
    }
    
    func setupSubViews() {
        self.addSubview(self.puller)
        self.puller.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10.0)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 30.0, height: 25.0))
        }
    }
    
    func animate(showing show: Bool) {
        if (show && self.isShowing) || (!show && !self.isShowing) { return }
        self.isShowing = show
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.alpha = show ? 1.0 : 0
            self.y = show ? Double(ScreenHeight - AssistHeight) : Double(ScreenHeight)
        } completion: { (complete) in
            if show {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { self.startShaking() }
            }else {
                self.stopShaking()
            }
        }
    }
    
    func startShaking() {
        guard let animation = self.shakingAnimation() else { return }
        self.puller.layer.add(animation, forKey: "")
    }
    
    func stopShaking() {
        self.puller.layer.removeAllAnimations()
    }
    
    func shakingAnimation()->CAAnimationGroup? {
        
        let pathAnimation = CABasicAnimation(keyPath: "position.y")
        pathAnimation.duration = 0.5
        pathAnimation.fromValue = self.puller.y + self.puller.h / 2
        pathAnimation.toValue = self.puller.h / 2
        pathAnimation.autoreverses = true
        pathAnimation.repeatCount = MAXFLOAT
        
        let zoomAnimation = CABasicAnimation(keyPath: "transform.scale")
        zoomAnimation.duration = 0.5
        zoomAnimation.fromValue = 1.0
        zoomAnimation.toValue = 1.02
        zoomAnimation.autoreverses = true
        zoomAnimation.repeatCount = MAXFLOAT
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [pathAnimation, zoomAnimation]
        animationGroup.duration = 0.5
        animationGroup.autoreverses = true
        animationGroup.repeatCount = MAXFLOAT
        animationGroup.isRemovedOnCompletion = false
        
        return animationGroup
    }
    
    //MARK: -- puller gesture
    @objc func pullerTriggered(_ gesture: UIGestureRecognizer) {
        self.delegate?.assistGestureTriggered(self)
    }
}
