//
//  UIView+Helper.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/13.
//

import UIKit

extension UIView {
    
    func addRoundCorner(withRadius radius: Float) {
        let p: UIRectCorner = UIRectCorner.init([.topLeft, .topRight, .bottomLeft, .bottomRight])
        self.addRoundCorner(withRadius: radius, position: p, bounds: self.bounds)
    }
    
    func addRoundCorner(withRadius radius: Float, position p: UIRectCorner) {
        self.addRoundCorner(withRadius: radius, position: p, bounds: self.bounds)
    }
    
    func addRoundCorner(withRadius radius: Float, position p: UIRectCorner, bounds b: CGRect) {
        
    }
}
