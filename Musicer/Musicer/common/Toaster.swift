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
    
    /// 展示 Toast 提示
    /// - Parameters:
    ///   - text: 提示信息
    ///   - color: 提示框背景色，默认 mu_color_black_alpha_8
    ///   - duration: 提示框停留时间，默认 1.0 秒
    static func flash(withText text: String, backgroundColor color: UIColor? = R.color.mu_color_black_alpha_8(), staying duration: Float = 1.0) {
        guard text.count > 0 else { return }
        self.make(withBackgroundColor: color)
        self.makeTipToast(withText: text)
        let delay = DispatchTime.now() + .milliseconds(Int(fabsf(duration) * 1000))
        self.show(comlete: { DispatchQueue.main.asyncAfter(deadline: delay) { self.hide() } })
    }
    
    /// 展示 Loading 提示框
    /// - Parameter color: 提示框背景色，默认 mu_color_clear
    static func showLoading(withBackgroundColor color: UIColor? = R.color.mu_color_clear()) {
        self.make(withBackgroundColor: color)
        self.makeLoading()
        self.show(comlete: { self.startAnimation() })
    }
    
    /// 隐藏 loading 提示框
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
        guard let unwrappedSubviews = UIApplication.shared.windows.first?.subviews else { return }
        var background: TBackgoundView? = nil
        for subview in unwrappedSubviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            background = subview as? TBackgoundView
            break
        }
        guard let unwrappedBackground = background else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            unwrappedBackground.alpha = 1.0
        } completion: { (complete) in
            guard complete else { return }
            cp()
        }
    }
    
    static func hide() {
        guard let unwrappedSubviews = UIApplication.shared.windows.first?.subviews else { return }
        var background: TBackgoundView? = nil
        for subview in unwrappedSubviews {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            background = subview as? TBackgoundView
            break
        }
        guard let unwrappedBackground = background else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            unwrappedBackground.alpha = 0
        } completion: { (complete) in
            unwrappedBackground.removeFromSuperview()
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
        
        guard let unwrappedSubviews = UIApplication.shared.windows.first?.subviews else { return }
        for subview in unwrappedSubviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            guard let unwrappedBackgroundView = subview as? TBackgoundView else { return }
            unwrappedBackgroundView.customBackgroundView.addSubview(lbl)
            unwrappedBackgroundView.customBackgroundView.kw_x = Double(x)
            unwrappedBackgroundView.customBackgroundView.kw_y = Double(y)
            unwrappedBackgroundView.customBackgroundView.kw_w = Double(w)
            unwrappedBackgroundView.customBackgroundView.kw_h = Double(h)
            break
        }
    }
}

//MARK: -- loading toast
fileprivate extension Toaster {
    
    static func makeLoading() {
                
        guard let unwrappedSubviews = UIApplication.shared.windows.first?.subviews else { return }
        for subview in unwrappedSubviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            if let unwrappedCustomBgView = (subview as? TBackgoundView)?.customBackgroundView {
                
                let imgView_one = UIImageView()
                imgView_one.image = R.image.mu_image_toast_loading_2()
                imgView_one.kw_x = (unwrappedCustomBgView.kw_w - 50.0) / 2
                imgView_one.kw_y = (unwrappedCustomBgView.kw_h - 50.0) / 2
                imgView_one.kw_size = CGSize(width: 50.0, height: 50.0)
                imgView_one.tag = kLoadingImageViewTagOne
                unwrappedCustomBgView.addSubview(imgView_one)
                
                let imgView_two = UIImageView()
                imgView_two.image = R.image.mu_image_toast_loading_1()
                imgView_two.kw_x = (unwrappedCustomBgView.kw_w - 70.0) / 2
                imgView_two.kw_y = (unwrappedCustomBgView.kw_h - 70.0) / 2
                imgView_two.kw_size = CGSize(width: 70.0, height: 70.0)
                imgView_two.tag = kLoadingImageViewTagTwo
                unwrappedCustomBgView.addSubview(imgView_two)
                
                break
            }
        }
    }
    
    static func startAnimation() {
        guard let unwrappedSubviews = UIApplication.shared.windows.first?.subviews else { return }
        var imgViewOne: UIImageView? = nil
        var imgViewTwo: UIImageView? = nil
        for subview in unwrappedSubviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            if let unwrappedCustomBgView = (subview as? TBackgoundView)?.customBackgroundView {
                imgViewOne = unwrappedCustomBgView.viewWithTag(kLoadingImageViewTagOne) as? UIImageView
                imgViewTwo = unwrappedCustomBgView.viewWithTag(kLoadingImageViewTagTwo) as? UIImageView
                break
            }
        }
        guard let unwrappedImgViewOne = imgViewOne,
              let unwrappedImgViewTwo = imgViewTwo else { return }
        let animation_one = CABasicAnimation(keyPath: "transform.rotation.z")
        animation_one.duration = 1
        animation_one.fromValue = 0
        animation_one.toValue = Double.pi * 2
        animation_one.repeatCount = MAXFLOAT
        unwrappedImgViewOne.layer.add(animation_one, forKey: "kClockwiseRotationAnimationKey")
        
        let animation_two = CABasicAnimation(keyPath: "transform.rotation.z")
        animation_two.duration = 1
        animation_two.fromValue = 0
        animation_two.toValue = -Double.pi * 2
        animation_two.repeatCount = MAXFLOAT
        unwrappedImgViewTwo.layer.add(animation_two, forKey: "kAnticlockwiseRotationAnimationKey")
    }
    
    static func stopAnimation() {
        guard let unwrappedSubviews = UIApplication.shared.windows.first?.subviews else { return }
        var imgViewOne: UIImageView? = nil
        var imgViewTwo: UIImageView? = nil
        for subview in unwrappedSubviews.reversed() {
            if !subview.isKind(of: TBackgoundView.self) { continue }
            if let unwrappedCustomBgView = (subview as? TBackgoundView)?.customBackgroundView {
                imgViewOne = unwrappedCustomBgView.viewWithTag(kLoadingImageViewTagOne) as? UIImageView
                imgViewTwo = unwrappedCustomBgView.viewWithTag(kLoadingImageViewTagTwo) as? UIImageView
                break
            }
        }
        if let unwrappedImgViewOne = imgViewOne { unwrappedImgViewOne.layer.removeAllAnimations() }
        if let unwrappedImgViewTwo = imgViewTwo { unwrappedImgViewTwo.layer.removeAllAnimations() }
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

