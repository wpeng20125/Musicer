//
//  PlayingController.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/10.
//

import UIKit

class PlayingController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { self.assist.show() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_gray_dark()
        self.configure()
        
        self.view.addSubview(self.modeBtn)
        self.modeBtn.h_x = 200
        self.modeBtn.h_y = 200
        self.modeBtn.h_size = CGSize(width: 30, height: 30.0)
        self.modeBtn.expand(50, 50, 50, 50)
    }

    private lazy var modeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(R.image.mu_image_play_squence(), for: .normal)
        btn.addTarget(self, action: #selector(click(atButton:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func click(atButton sender: UIButton) {
        print("hello world")
    }
    
    //MARK: -- lazy
    private var assist: PlayControllingCardAssist = { return PlayControllingCardAssist() }()
    private var card: PlayControllingCard = { return PlayControllingCard() }()
}

fileprivate extension PlayingController {
    
    func configure() {
        
        self.assist.delegate = self
        self.view.addSubview(self.assist)
        
        self.card.delegate = self
        self.view.addSubview(self.card)
    }
    
}

extension PlayingController: PlayControllingCardAssistDelegate, PlayControllingCardDelegate {
    
    //MARK: -- PlayControllingCardAssistDelegate
    func assistGestureTriggered(_ assist: PlayControllingCardAssist) {
        self.card.show()
        assist.hide()
    }
    
    //MARK: -- PlayControllingCardDelegate
    func playControllingCardPlayNextSong(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardPlayLastSong(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardUploadSongs(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardShowAllList(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardShowCurrentList(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardFavouriteThisSong(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCard(_ card: PlayControllingCard, playingModeChanged mode: PlayingMode) {
        
    }
    
    func playControllingCard(_ card: PlayControllingCard, playingStateChanged state: PlayingState) {
        
    }

    func playControllingCard(_ card: PlayControllingCard, displayCompleted showing: Bool) {
        guard showing else {
            self.assist.show()
            return
        }
        self.assist.hide()
    }
}
