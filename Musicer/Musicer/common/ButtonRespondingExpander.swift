//
//  ButtonRespondingExpander.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/12.
//

import UIKit

extension UIButton {
    
    private struct AssociatedObjectKey {
        static var edgeInsetsKey = "edgeInsetsKey"
    }
    
    func expand(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        let inset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        let num = NSNumber(uiEdgeInsets: inset)
        objc_setAssociatedObject(self, &AssociatedObjectKey.edgeInsetsKey, num, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let wrappedInset = objc_getAssociatedObject(self, &AssociatedObjectKey.edgeInsetsKey) as? UIEdgeInsets
        guard let unwrappedInset = wrappedInset else { return super.point(inside: point, with: event) }
        let expanded_x = self.frame.origin.x - unwrappedInset.left
        let expanded_y = self.frame.origin.y - unwrappedInset.top
        let expanded_w = self.frame.size.width + unwrappedInset.left + unwrappedInset.right
        let expanded_h = self.frame.size.height + unwrappedInset.top + unwrappedInset.bottom
        let expanded_rect = CGRect(x: expanded_x, y: expanded_y, width: expanded_w, height: expanded_h)
        let convertPoint = self.convert(point, to: self.superview)
        if expanded_rect.contains(convertPoint) { return true }
        return super.point(inside: point, with: event)
    }
}
