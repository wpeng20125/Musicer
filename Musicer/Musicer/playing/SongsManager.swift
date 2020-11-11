//
//  SongsManager.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/11.
//

import UIKit

class SongsManager: NSObject {
    
    static let `default` = SongsManager()
    
    private(set) var totalList: [String:Song]? = nil
    private(set) var favouriteList: [String:Song]? = nil
}

fileprivate extension SongsManager {
    
}
