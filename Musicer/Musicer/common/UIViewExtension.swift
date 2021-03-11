//
//  UIView+Helper.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/13.
//

import UIKit

extension UIView {
    
    // handy frame setter
    var kw_x: Double {
        set {
            var f = self.frame
            f.origin.x = CGFloat(newValue)
            self.frame = f
        }
        get {
            Double(self.frame.origin.x)
        }
    }
    
    var kw_y: Double {
        set {
            var f = self.frame
            f.origin.y = CGFloat(newValue)
            self.frame = f
        }
        get {
            Double(self.frame.origin.y)
        }
    }
    
    var kw_w: Double {
        set {
            var f = self.frame
            f.size.width = CGFloat(newValue)
            self.frame = f
        }
        get {
            Double(self.frame.size.width)
        }
    }
    
    var kw_h: Double {
        set {
            var f = self.frame
            f.size.height = CGFloat(newValue)
            self.frame = f
        }
        get {
            Double(self.frame.size.height)
        }
    }
    
    var kw_size: CGSize {
        set {
            var f = self.frame
            f.size = newValue
            self.frame = f
        }
        get {
            self.frame.size
        }
    }
    
    // init with backgroundColor
    convenience init(backgroundColor: UIColor?) {
        self.init()
        if let color = backgroundColor { self.backgroundColor = color }
    }
}
