//
//  PlayControllingView.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/26.
//

import UIKit

protocol PlayControllingViewDelegate: NSObjectProtocol {
    /// 播放
    func playControllingView_play()
    /// 暂停
    func playControllingView_pause()
    /// 上一曲
    func playControllingView_last()
    /// 下一曲
    func playControllingView_next()
    /// 停止
    func playControllingView_close()
}

class PlayControllingView: UIView {
    
    weak var delegate: PlayControllingViewDelegate?

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
        btn.isSelected = true
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
    
    private lazy var coverView: UIView = {
        let cover = UIView()
        cover.backgroundColor = UIColor.clear
        return cover
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

//MARK: -- public
extension PlayControllingView {
    
    func setImage(img: UIImage) {
        self.iconView.image = img;
    }
    
    func play() {
        if !self.playBtn.isSelected { return }
        self.playBtn.isSelected = false
        self.startPlayingAnimation()
    }
    
    func pause() {
        if self.playBtn.isSelected { return }
        self.playBtn.isSelected = true
        self.pausePlayingAnimation()
    }
    
    func disableNext(_ disable: Bool) {
        self.nextBtn.isEnabled = !disable
    }
    
    func disableLast(_ disable: Bool) {
        self.lastBtn.isEnabled = !disable
    }
    
    func updateProgress(progress: Float) {
        if progress < 0 { return }
        self.progressLayer.strokeEnd = progress > 1.0 ? 1.0 : CGFloat(progress);
    }
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
            make.size.equalTo(CGSize(width: 25.0, height: 25.0))
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
            make.size.equalTo(CGSize(width: 25.0, height: 25.0))
            
        }
        
        self.addSubview(self.closeBtn)
        self.closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10.0)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 15.0, height: 15.0))
        }
        
        self.coverView.isHidden = true
        self.addSubview(self.coverView)
        self.coverView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    // actions
    @objc func playMusic(btn: UIButton) {
        self.coverView.isHidden = false
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.coverView.isHidden = true
            btn.isSelected = !btn.isSelected
            if btn.isSelected {
                self.pausePlayingAnimation()
                self.delegate?.playControllingView_pause()
            } else {
                self.startPlayingAnimation()
                self.delegate?.playControllingView_play()
            }
        }
        self.rotation(layer: btn.layer, clockwise: btn.isSelected)
        CATransaction.commit()
    }
    
    @objc func nextMusic(btn: UIButton) {
        self.coverView.isHidden = false
        self.pause()
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.coverView.isHidden = true
            self.delegate?.playControllingView_next()
            self.play()
        }
        self.rotation(layer: self.playBtn.layer, clockwise: true)
        self.zoom(layer: btn.layer)
        CATransaction.commit()
    }
    
    @objc func lastMusic(btn: UIButton) {
        self.coverView.isHidden = false
        self.pause()
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.coverView.isHidden = true
            self.delegate?.playControllingView_last()
            self.play()
        }
        self.rotation(layer: self.playBtn.layer, clockwise: false)
        self.zoom(layer: btn.layer)
        CATransaction.commit()
    }
    
    @objc func stopMusic(btn: UIButton) {
        self.coverView.isHidden = false
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.coverView.isHidden = true
            self.delegate?.playControllingView_close()
        }
        self.zoom(layer: btn.layer)
        CATransaction.commit()
    }
}

//MARK: -- Animations
fileprivate extension PlayControllingView {
    
    // btn scale
    func zoom(layer: CALayer) {
        let zoom = CABasicAnimation(keyPath: "transform.scale")
        zoom.duration = 0.1
        zoom.fromValue = 1.0
        zoom.toValue = 0.6
        zoom.autoreverses = true
        zoom.isRemovedOnCompletion = true
        layer.add(zoom, forKey: "k_zoom_aniamtion_key")
    }
    
    // btn rotation
    func rotation(layer: CALayer, clockwise: Bool) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.duration = 0.25
        rotation.fromValue = 0
        rotation.toValue = clockwise ? Double.pi : -Double.pi
        rotation.autoreverses = true
        rotation.isRemovedOnCompletion = true
        layer.add(rotation, forKey: "k_rotation_aniamtion_key")
    }
    
    // icon rotation
    func startPlayingAnimation() {
        guard nil != self.iconView.layer.animation(forKey: "k_clockwise_rotation_animation_key") else {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.duration = 5
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
