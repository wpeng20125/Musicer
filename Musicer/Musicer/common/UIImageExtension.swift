//
//  ImageExtension.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/22.
//

import UIKit

extension UIImage {
    
    /// 返回一张给定 size 的 image。
    ///
    /// - Parameters:
    ///   - targetSize: 目标尺寸
    /// - Returns: 符合目标尺寸的图片
    func resize(_ targetSize: CGSize)->UIImage? { self.resizeImage(size: targetSize) }
    
}

fileprivate extension UIImage {
    
    func resizeImage(size: CGSize)->UIImage? {
        return UIGraphicsImageRenderer(size: size).image { (context) in
            self.drawAsPattern(in: CGRect(origin: .zero, size: size))
        }
    }
}
