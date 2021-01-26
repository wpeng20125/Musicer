//
//  PlayControllingView.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/26.
//

import UIKit

class PlayControllingView: UIView {

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setSubViews()
    }
    
    //MARK: -- lazy
    private lazy var iconView: UIImageView = {
        let imgV = UIImageView(frame: CGRect(x: 5.0, y: 5.0, width: 50.0, height: 50.0))
        imgV.image = UIImage(named: "AppIcon")
        return imgV
    }()
    
    private lazy var lastBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.mu_image_assist_last_enabled(), for: .normal)
        btn.setImage(R.image.mu_image_assist_last_disabled(), for: .disabled)
        btn.addTarget(self, action: #selector(lastMusic(btn:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var playBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.mu_image_assist_play(), for: .normal)
        btn.setImage(R.image.mu_image_assist_pause(), for: .selected)
        btn.addTarget(self, action: #selector(playMusic(btn:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.mu_image_assist_next_enabled(), for: .normal)
        btn.setImage(R.image.mu_image_assist_next_disabled(), for: .disabled)
        btn.addTarget(self, action: #selector(nextMusic(btn:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(R.image.mu_image_assist_close(), for: .normal)
        btn.addTarget(self, action: #selector(stopMusic(btn:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: 25.0, y:25.0),
                                radius: 24.0,
                                startAngle: CGFloat(-Double.pi / 2),
                                endAngle: CGFloat(Double.pi * 1.5),
                                clockwise: true)
        layer.bounds = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        layer.position = CGPoint(x: 30.0, y: 30.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2.0
        layer.strokeColor = UIColor.red.cgColor
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.path = path.cgPath
        return layer
    }()
}

//MARK: -- add subview
fileprivate extension PlayControllingView {
    
    func setSubViews() {
        
        self.iconView.layer.cornerRadius = 25.0
        self.iconView.layer.masksToBounds = true
        self.iconView.layer.borderWidth = 2.0
        self.iconView.layer.borderColor = R.color.mu_color_lavender()?.cgColor
        self.addSubview(self.iconView)
        
        self.layer.addSublayer(self.progressLayer);
        
        self.addSubview(self.lastBtn)
        self.lastBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconView.snp.right).offset(5.0)
            make.centerY.equalTo(self.iconView)
            make.size.equalTo(CGSize(width: 25.0, height: 30.0))
        }
        
        self.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.lastBtn.snp.right).offset(2.5)
            make.centerY.equalTo(self.lastBtn)
            make.size.equalTo(CGSize(width: 30.0, height: 30.0))
        }
        
        self.addSubview(self.nextBtn)
        self.nextBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.playBtn.snp.right).offset(2.5)
            make.centerY.equalTo(self.playBtn)
            make.size.equalTo(CGSize(width: 25.0, height: 30.0))
            
        }
        
        self.addSubview(self.closeBtn)
        self.closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10.0)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 15.0, height: 15.0))
        }
    }
    
    @objc func playMusic(btn: UIButton) {
        ffprint("play")
        CATransaction.begin()
        CATransaction.setCompletionBlock { btn.isSelected = !btn.isSelected }
        self.rotation(layer: btn.layer)
        CATransaction.commit()
    }
    
    @objc func nextMusic(btn: UIButton) {
        ffprint("next")
        self.zoom(layer: btn.layer)
    }
    
    @objc func lastMusic(btn: UIButton) {
        ffprint("last")
        self.zoom(layer: btn.layer)
    }
    
    @objc func stopMusic(btn: UIButton) {
        ffprint("stop")
        self.zoom(layer: btn.layer)
    }
}

//MARK: -- Animations
extension PlayControllingView {
    
    // btn scale
    func zoom(layer: CALayer) {
        let zoom = CABasicAnimation(keyPath: "transform.scale")
        zoom.duration = 0.1
        zoom.fromValue = 1.0
        zoom.toValue = 0.7
        zoom.autoreverses = true
        zoom.isRemovedOnCompletion = true
        layer.add(zoom, forKey: "k_zoom_aniamtion_key")
    }
    
    // btn rotation
    func rotation(layer: CALayer) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.duration = 0.25
        rotation.fromValue = 0
        rotation.toValue = Double.pi
        rotation.autoreverses = true
        rotation.isRemovedOnCompletion = true
        layer.add(rotation, forKey: "k_rotation_aniamtion_key")
    }
    
    // icon rotation
    func startPlayingAnimation() {
        guard nil != self.iconView.layer.animation(forKey: "k_clockwise_rotation_animation_key") else {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.duration = 3
            animation.fromValue = 0
            animation.toValue = Double.pi * 2
            animation.repeatCount = MAXFLOAT
            animation.isRemovedOnCompletion = false
            self.iconView.layer.add(animation, forKey: "k_clockwise_rotation_animation_key")
            return
        }
        let pausedTime = self.iconView.layer.timeOffset
        self.iconView.layer.speed = 1.0
        self.iconView.layer.timeOffset = 0
        self.iconView.layer.beginTime = 0
        self.iconView.layer.beginTime = self.iconView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    }
    
    func pausePlayingAnimation() {
        guard nil != self.iconView.layer.animation(forKey: "k_clockwise_rotation_animation_key") else { return }
        guard 0 != self.iconView.layer.speed else { return }
        let pausedTime = self.iconView.layer.convertTime(CACurrentMediaTime(), from: nil)
        self.iconView.layer.speed = 0
        self.iconView.layer.timeOffset = pausedTime
    }
    
    func stopPlayingAnimation() {
        self.iconView.layer.removeAllAnimations()
    }
    
}
