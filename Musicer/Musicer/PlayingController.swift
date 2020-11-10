//
//  PlayingController.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/10.
//

import UIKit

class PlayingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = R.color.mu_color_gray_dark()
        self.configure()
    }

    //MARK: -- lazy
    private var assist: PlayControllingCardAssist = { return PlayControllingCardAssist() }()
    private var card: PlayControllingCard = { return PlayControllingCard() }()
}

fileprivate extension PlayingController {
    
    func configure() {
        
        self.view.addSubview(self.assist)
        self.assist.delegate = self
        self.assist.h_x = 0
        self.assist.h_y = Double(kScreenHeight) - 20.0 - kSafeAreaInsetBottom
        self.assist.h_w = Double(kScreenWidth)
        self.assist.h_h = 20.0 + kSafeAreaInsetBottom
        
        self.card.delegate = self
        self.view.addSubview(self.card)
        self.card.h_x = 0
        self.card.h_y = Double(kScreenHeight)
        self.card.h_size = CGSize(width: Double(kScreenWidth), height: 200.0 + kSafeAreaInsetBottom)
        
    }
    
}

extension PlayingController: PlayControllingCardAssistDelegate, PlayControllingCardDelegate {
    
    //MARK: -- PlayControllingCardAssistDelegate
    func assistGestureTriggered(_ assist: PlayControllingCardAssist) {
        self.card.show()
        assist.hide()
    }
    
    func palyControllingCardSwipGestureDidTriggered(_ card: PlayControllingCard) {
        assist.show()
    }
}
