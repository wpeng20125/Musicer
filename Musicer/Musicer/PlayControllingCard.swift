//
//  PlayControllingCard.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/21.
//

import UIKit

protocol PlayControllingCardDelegate: NSObjectProtocol {
    
}

enum PlayControllingMode: Int {
    case squence
    case singleLoop
    case squenceLoop
    case random
}

class PlayControllingCard: UIView {
    
    private let w_h: CGFloat = 30.0
    
    weak var delegate: PlayControllingCardDelegate?
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = R.color.mu_color_clear()
        self.setupSubViews()
    }
    
    //MARK: -- lazy
    private lazy var pullBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_control_pull(), for: .normal)
        return btn
    }()
    
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
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play_squence(), for: .normal)
        btn.h_size = CGSize(width: w_h, height: w_h)
        return btn
    }()
    
    private lazy var lastBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play_last(), for: .normal)
        return btn
    }()
    
    private lazy var playBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play(), for: .normal)
        return btn
    }()
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play_next(), for: .normal)
        return btn
    }()
    
    private lazy var currentListBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_folder_current(), for: .normal)
        return btn
    }()
    
    private lazy var allListBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_folder_all(), for: .normal)
        return btn
    }()
    
    private lazy var faverBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_folder_favourite(), for: .normal)
        return btn
    }()
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_songs_add(), for: .normal)
        return btn
    }()
}

//MARK: -- 布局子控件
fileprivate extension PlayControllingCard {
    
    func setupSubViews() {
        
        self.addSubview(self.pullBtn)
        self.pullBtn.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: 30.0, height: 20.0))
        }
        
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { (make) in
            make.top.equalTo(pullBtn.snp.bottom)
            make.left.bottom.right.equalTo(self)
        }
        
        self.bgView.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { (make) in
            make.center.equalTo(self.bgView)
            make.width.equalTo(kScreenWidth - 30.0 * 2)
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
        
        let margin = (kScreenWidth / 2 - 30.0) / 2
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
    
    @objc func click(atButton btn: UIButton) {
        
    }
}

