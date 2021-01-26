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
    
    static let sharedAssist = PlayControllingAssist()
    
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        let f = CGRect(x: ScreenWidth - SelfW, y: ScreenHeight - SelfH - SafeAreaInsetBottom, width: SelfW, height: SelfH)
        super.init(frame: f)
        self.defaultConfiguration()
    }
}

fileprivate extension PlayControllingAssist {
    
    func defaultConfiguration() {
        self.backgroundColor = R.color.mu_color_lavender_alpha_8()
        self.layer.cornerRadius = SelfH / 2.0
        self.layer.masksToBounds = true
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:))))
        
        self.addSubview(PlayControllingView(frame: self.bounds))
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
            }, completion: nil)
        default: ()
        }
    }
}
