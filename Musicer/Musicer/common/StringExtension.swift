//
//  StringExtension.swift
//  Musicer
//
//  Created by 王朋 on 2021/3/26.
//

import Foundation
import CryptoKit

extension String {
    
    func MD5()->String {
        guard let unwrappedData = self.data(using: .utf8) else { return self }
        let s = Insecure.MD5.hash(data: unwrappedData)
        return s.map { String(format: "%02hhx", $0) }.joined()
    }
}
