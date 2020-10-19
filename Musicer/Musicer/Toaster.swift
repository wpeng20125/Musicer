//
//  Toaster.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/16.
//

import UIKit

fileprivate let kToastInset: CGFloat = 10.0
fileprivate let kTipLblInset: CGFloat = 10.0
fileprivate let kTextInset: CGFloat = 2.5

class Toaster: NSObject {
    
    fileprivate var groundView: UIView?
    fileprivate var tipBgView: UIView?
    
    func flash(withText text: String) {
        self.make(withText: text)
        self.show()
    }
}

fileprivate extension Toaster {
    
    func make(withText text: String) {
        
        self.groundView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        self.groundView!.backgroundColor = R.color.mu_color_alpha_zero()
        UIApplication.shared.keyWindow?.addSubview(self.groundView!)
        
        let str = NSString(string: text)
        let maxWidth = kScreenWidth - kToastInset * 2 - kTipLblInset * 2 - kTextInset * 2
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
        
        let w = textWidth + kTipLblInset * 2 + kTextInset * 2
        let h = textHeight + kTipLblInset * 2 + kTextInset * 2
        let x = (kScreenWidth - w) / 2
        let y = (kScreenHeight - h) / 2
        
        self.tipBgView = UIView(frame: CGRect(x: x, y: y, width: w, height: h))
        self.tipBgView!.backgroundColor = R.color.mu_color_gray()
        self.tipBgView!.layer.cornerRadius = 10.0
        self.tipBgView!.layer.masksToBounds = true
        self.groundView!.addSubview(self.tipBgView!)
        
        let lblW = textWidth + kTextInset * 2
        let lblH = textHeight + kTextInset * 2
        let lbl = UILabel(frame: CGRect(x: (w - lblW) / 2, y: (h - lblH) / 2, width: lblW, height: lblH))
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 15.0)
        lbl.textColor = R.color.mu_color_white()
        self.tipBgView!.addSubview(lbl)
        
        self.tipBgView!.alpha = 0
    }
    
    func show() {
        UIView.animate(withDuration: 0.2) {
            guard let tipView = self.tipBgView else { return }
            tipView.alpha = 1.0
        } completion: { (complete) in
            guard complete else { return }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { self.hide() }
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2) {
            guard let tipView = self.tipBgView else { return }
            tipView.alpha = 0
        } completion: { (complete) in
            guard let ground = self.groundView else { return }
            ground.removeFromSuperview()
            self.groundView = nil
            self.tipBgView = nil
        }
    }
}
