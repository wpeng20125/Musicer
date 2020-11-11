//
//  Toaster.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/16.
//

import UIKit

fileprivate let kBackgroundViewTag: Int = 1000
fileprivate let kCustomBackgroundViewTag: Int = 1010
fileprivate let kLoadingImageViewTagOne: Int = 1020
fileprivate let kLoadingImageViewTagTwo: Int = 1030

fileprivate let kCustomBackgroundViewW: CGFloat = 100.0
fileprivate let kCustomBackgroundViewH: CGFloat = 100.0
fileprivate let kTipToastInset: CGFloat = 10.0
fileprivate let kTipLblInset: CGFloat = 10.0
fileprivate let kTipTextInset: CGFloat = 2.5

class Toaster: NSObject {
        
    func flash(withText text: String) {
        self.make()
        self.makeTipToast(withText: text)
        self.show(comlete: { DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { self.hide() } })
    }
    
    func showLoading() {
        self.make()
        self.makeLoading()
        self.show(comlete: { self.startAnimation() })
    }
    
    func hideLoading() {
        self.stopAnimation()
        self.hide()
    }
}

fileprivate extension Toaster {
    
    private func make() {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        backgroundView.backgroundColor = R.color.mu_color_clear()
        backgroundView.tag = kBackgroundViewTag
        backgroundView.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(backgroundView)
        
        let x = (ScreenWidth - kCustomBackgroundViewW) / 2
        let y = (ScreenHeight - kCustomBackgroundViewH) / 2
        let customBackgroundView = UIView(frame: CGRect(x: x, y: y, width: kCustomBackgroundViewW, height: kCustomBackgroundViewH))
        customBackgroundView.backgroundColor = R.color.mu_color_gray_dark()
        customBackgroundView.layer.cornerRadius = 10.0
        customBackgroundView.layer.masksToBounds = true
        customBackgroundView.tag = kCustomBackgroundViewTag
        backgroundView.addSubview(customBackgroundView)
    }
    
    func show(comlete cp: @escaping ()->Void) {
        guard let background = UIApplication.shared.keyWindow?.viewWithTag(kBackgroundViewTag) else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            background.alpha = 1.0
        } completion: { (complete) in
            guard complete else { return }
            cp()
        }
    }
    
    func hide() {
        guard let background = UIApplication.shared.keyWindow?.viewWithTag(kBackgroundViewTag) else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            background.alpha = 0
        } completion: { (complete) in
            background.removeFromSuperview()
        }
    }
}

//MARK: -- tip toast
fileprivate extension Toaster {
    
    func makeTipToast(withText text: String) {

        let str = NSString(string: text)
        let maxWidth = ScreenWidth - kTipToastInset * 2 - kTipLblInset * 2 - kTipTextInset * 2
        var textHeight: CGFloat = 30.0
        var textWidth = str.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: textHeight),
                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                         attributes: [.font : UIFont.systemFont(ofSize: 15.0)],
                                         context: nil).size.width
        if textWidth > maxWidth {
            textWidth = maxWidth
            textHeight = str.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)),
                                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                                          attributes: [.font : UIFont.systemFont(ofSize: 15.0)],
                                          context: nil).size.height
            if textHeight < 30.0 { textHeight = 30.0 }
        }
        
        let w = textWidth + kTipLblInset * 2 + kTipTextInset * 2
        let h = textHeight + kTipLblInset * 2 + kTipTextInset * 2
        let x = (ScreenWidth - w) / 2
        let y = (ScreenHeight - h) / 2
        
        let lblW = textWidth + kTipTextInset * 2
        let lblH = textHeight + kTipTextInset * 2
        let lbl = UILabel(frame: CGRect(x: (w - lblW) / 2, y: (h - lblH) / 2, width: lblW, height: lblH))
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 15.0)
        lbl.textColor = R.color.mu_color_white()
        
        guard let customBackgroundView = UIApplication.shared.keyWindow?.viewWithTag(kCustomBackgroundViewTag) else { return }
        customBackgroundView.addSubview(lbl)

        customBackgroundView.h_x = Double(x)
        customBackgroundView.h_y = Double(y)
        customBackgroundView.h_w = Double(w)
        customBackgroundView.h_h = Double(h)
    }
}

//MARK: -- loading toast
fileprivate extension Toaster {
    
    func makeLoading() {
        guard let ground = UIApplication.shared.keyWindow?.viewWithTag(kBackgroundViewTag) else { return }
        ground.backgroundColor = R.color.mu_color_black_with_alpha()
        
        guard let customBackgroundView = UIApplication.shared.keyWindow?.viewWithTag(kCustomBackgroundViewTag) else { return }
        customBackgroundView.backgroundColor = R.color.mu_color_clear()
        
        let imgView_one = UIImageView()
        imgView_one.image = R.image.mu_image_toast_loading_2()
        imgView_one.h_x = (customBackgroundView.h_w - 50.0) / 2
        imgView_one.h_y = (customBackgroundView.h_h - 50.0) / 2
        imgView_one.h_size = CGSize(width: 50.0, height: 50.0)
        imgView_one.tag = kLoadingImageViewTagOne
        customBackgroundView.addSubview(imgView_one)
        
        let imgView_two = UIImageView()
        imgView_two.image = R.image.mu_image_toast_loading_1()
        imgView_two.h_x = (customBackgroundView.h_w - 70.0) / 2
        imgView_two.h_y = (customBackgroundView.h_h - 70.0) / 2
        imgView_two.h_size = CGSize(width: 70.0, height: 70.0)
        imgView_two.tag = kLoadingImageViewTagTwo
        customBackgroundView.addSubview(imgView_two)
    }
    
    func startAnimation() {
        guard let imgView_one = UIApplication.shared.keyWindow?.viewWithTag(kLoadingImageViewTagOne) else { return }
        guard let imgView_two = UIApplication.shared.keyWindow?.viewWithTag(kLoadingImageViewTagTwo) else { return }
        let animation_one = CABasicAnimation(keyPath: "transform.rotation.z")
        animation_one.duration = 1
        animation_one.fromValue = 0
        animation_one.toValue = Double.pi * 2
        animation_one.repeatCount = MAXFLOAT
        imgView_one.layer.add(animation_one, forKey: "kClockwiseRotationAnimationKey")
        
        let animation_two = CABasicAnimation(keyPath: "transform.rotation.z")
        animation_two.duration = 1
        animation_two.fromValue = 0
        animation_two.toValue = -Double.pi * 2
        animation_two.repeatCount = MAXFLOAT
        imgView_two.layer.add(animation_two, forKey: "kAnticlockwiseRotationAnimationKey")
    }
    
    func stopAnimation() {
        guard let imgView_one = UIApplication.shared.keyWindow?.viewWithTag(kLoadingImageViewTagOne) else { return }
        guard let imgView_two = UIApplication.shared.keyWindow?.viewWithTag(kLoadingImageViewTagTwo) else { return }
        imgView_one.layer.removeAllAnimations()
        imgView_two.layer.removeAllAnimations()
    }
}
