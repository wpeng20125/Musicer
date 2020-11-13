//
//  FrameHandy.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/22.
//

import UIKit

extension UIView {
    
    var x: Double {
        set {
            var f = self.frame
            f.origin.x = CGFloat(newValue)
            self.frame = f
        }
        get {
            Double(self.frame.origin.x)
        }
    }
    
    var y: Double {
        set {
            var f = self.frame
            f.origin.y = CGFloat(newValue)
            self.frame = f
        }
        get {
            Double(self.frame.origin.y)
        }
    }
    
    var w: Double {
        set {
            var f = self.frame
            f.size.width = CGFloat(newValue)
            self.frame = f
        }
        get {
            Double(self.frame.size.width)
        }
    }
    
    var h: Double {
        set {
            var f = self.frame
            f.size.height = CGFloat(newValue)
            self.frame = f
        }
        get {
            Double(self.frame.size.height)
        }
    }
    
    var size: CGSize {
        set {
            var f = self.frame
            f.size = newValue
            self.frame = f
        }
        get {
            self.frame.size
        }
    }
    
}
