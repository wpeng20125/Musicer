//
//  Toaster.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/16.
//

import UIKit

fileprivate let kLoadingImageViewTagOne: Int = 9788
fileprivate let kLoadingImageViewTagTwo: Int = 9799

fileprivate let kCustomBackgroundViewW: CGFloat = 100.0
fileprivate let kCustomBackgroundViewH: CGFloat = 100.0
fileprivate let kTipToastInset: CGFloat = 10.0
fileprivate let kTipLblInset: CGFloat = 10.0
fileprivate let kTipTextInset: CGFloat = 2.5

class Toaster: NSObject {
    
    static func flash(withText text: String, backgroundColor color: UIColor? = R.color.mu_color_black_alpha_8()) {
        guard text.count > 0 else { return }
        self.make(withBackgroundColor: color)
        self.makeTipToast(withText: text)
        self.show(comlete: { DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { self.hide() } })
    }
    
    static func showLoading(withBackgroundColor color: UIColor? = R.color.mu_color_clear()) {
        self.make(withBackgroundColor: color)
        self.makeLoading()
        self.show(comlete: { self.startAnimation() })
    }
    
    static func hideLoading() {
        self.stopAnimation()
        self.hide()
    }
}

fileprivate extension Toaster {
    
    static  func make(withBackgroundColor color: UIColor?) {
        let backgroundView = TBackgoundView(color)
        UIApplication.shared.windows.first?.addSubview(backgroundView)
    }
    
    static func show(comlete cp: @escaping ()->Void) {
        guard let subviews = UIApplication.shared.windows.first?.subviews else { return }
        var unwrappedBackground: TBackgoundView? = nil
        for subview in subviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            unwrappedBackground = subview as? TBackgoundView
            break
        }
        guard let background = unwrappedBackground else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            background.alpha = 1.0
        } completion: { (complete) in
            guard complete else { return }
            cp()
        }
    }
    
    static func hide() {
        guard let subviews = UIApplication.shared.windows.first?.subviews else { return }
        var unwrappedBackground: TBackgoundView? = nil
        for subview in subviews {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            unwrappedBackground = subview as? TBackgoundView
            break
        }
        guard let background = unwrappedBackground else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            background.alpha = 0
        } completion: { (complete) in
            background.removeFromSuperview()
        }
    }
}

//MARK: -- tip toast
fileprivate extension Toaster {
    
    static func makeTipToast(withText text: String) {

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
        
        guard let subviews = UIApplication.shared.windows.first?.subviews else { return }
        for subview in subviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            guard let backgroundView = subview as? TBackgoundView else { return }
            backgroundView.customBackgroundView.addSubview(lbl)
            backgroundView.customBackgroundView.kw_x = Double(x)
            backgroundView.customBackgroundView.kw_y = Double(y)
            backgroundView.customBackgroundView.kw_w = Double(w)
            backgroundView.customBackgroundView.kw_h = Double(h)
            break
        }
    }
}

//MARK: -- loading toast
fileprivate extension Toaster {
    
    static func makeLoading() {
                
        guard let subviews = UIApplication.shared.windows.first?.subviews else { return }
        for subview in subviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            if let customBgView = (subview as? TBackgoundView)?.customBackgroundView {
                
                let imgView_one = UIImageView()
                imgView_one.image = R.image.mu_image_toast_loading_2()
                imgView_one.kw_x = (customBgView.kw_w - 50.0) / 2
                imgView_one.kw_y = (customBgView.kw_h - 50.0) / 2
                imgView_one.kw_size = CGSize(width: 50.0, height: 50.0)
                imgView_one.tag = kLoadingImageViewTagOne
                customBgView.addSubview(imgView_one)
                
                let imgView_two = UIImageView()
                imgView_two.image = R.image.mu_image_toast_loading_1()
                imgView_two.kw_x = (customBgView.kw_w - 70.0) / 2
                imgView_two.kw_y = (customBgView.kw_h - 70.0) / 2
                imgView_two.kw_size = CGSize(width: 70.0, height: 70.0)
                imgView_two.tag = kLoadingImageViewTagTwo
                customBgView.addSubview(imgView_two)
                
                break
            }
        }
    }
    
    static func startAnimation() {
        guard let subviews = UIApplication.shared.windows.first?.subviews else { return }
        var unwrappedImgViewOne: UIImageView? = nil
        var unwrappedImgViewTwo: UIImageView? = nil
        for subview in subviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            if let customBgView = (subview as? TBackgoundView)?.customBackgroundView {
                unwrappedImgViewOne = customBgView.viewWithTag(kLoadingImageViewTagOne) as? UIImageView
                unwrappedImgViewTwo = customBgView.viewWithTag(kLoadingImageViewTagTwo) as? UIImageView
                break
            }
        }
        guard let imgView_one = unwrappedImgViewOne else { return }
        guard let imgView_two = unwrappedImgViewTwo else { return }
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
    
    static func stopAnimation() {
        guard let subviews = UIApplication.shared.windows.first?.subviews else { return }
        var unwrappedImgViewOne: UIImageView? = nil
        var unwrappedImgViewTwo: UIImageView? = nil
        for subview in subviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            if let customBgView = (subview as? TBackgoundView)?.customBackgroundView {
                unwrappedImgViewOne = customBgView.viewWithTag(kLoadingImageViewTagOne) as? UIImageView
                unwrappedImgViewTwo = customBgView.viewWithTag(kLoadingImageViewTagTwo) as? UIImageView
                break
            }
        }
        guard let imgView_one = unwrappedImgViewOne else { return }
        imgView_one.layer.removeAllAnimations()
        guard let imgView_two = unwrappedImgViewTwo else { return }
        imgView_two.layer.removeAllAnimations()
    }
}

fileprivate class TBackgoundView: UIView {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    init(_ color: UIColor?) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = R.color.mu_color_clear()
        self.alpha = 0
        self.customBackgroundView.backgroundColor = color
        self.addSubview(self.customBackgroundView)
    }
    
    lazy var customBackgroundView: UIView = {
        let x = (ScreenWidth - kCustomBackgroundViewW) / 2
        let y = (ScreenHeight - kCustomBackgroundViewH) / 2
        let cusBgView = UIView(frame: CGRect(x: x, y: y, width: kCustomBackgroundViewW, height: kCustomBackgroundViewH))
        cusBgView.layer.cornerRadius = 10.0
        cusBgView.layer.masksToBounds = true
        return cusBgView
    }()
}

