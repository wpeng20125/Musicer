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

class PlayControllingCardAssist: UIView {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = R.color.mu_color_clear()
        self.setupSubViews()
    }
    
    weak var delegate: PlayControllingCardAssistDelegate?
    
    func show() { self.animate(showing: true) }
    
    func hide() { self.animate(showing: false) }
    
    //MARK: -- lazy
    private lazy var puller: UIImageView = {
        let pull = UIImageView()
        pull.isUserInteractionEnabled = true
        pull.image = R.image.mu_image_control_pull()
        pull.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pullerTriggered(_:))))
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(pullerTriggered(_:)))
        pan.edges = .bottom
        pull.addGestureRecognizer(pan)
        return pull
    }()
}

fileprivate extension PlayControllingCardAssist {
    
    func setupSubViews() {
        
        self.addSubview(self.puller)
        self.puller.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 30.0, height: 20.0))
        }
    }
    
    func animate(showing show: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.h_y = show ? Double(kScreenHeight) - 20.0 - kSafeAreaInsetBottom : Double(kScreenHeight)
        } completion: { (complete) in }
    }
    
    //MARK: -- puller gesture
    @objc func pullerTriggered(_ gesture: UIGestureRecognizer) {
        if !gesture.isKind(of: UITapGestureRecognizer.self) {
            if gesture.state != .began { return }
        }
        self.delegate?.assistGestureTriggered(self)
    }
}
