//
//  Song.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/11.
//

import UIKit

enum FFormat {
    case mp3(desc: String)
}

struct Song: Equatable {
    var name: String = "Unknown"
    var fileName: String
    var fileURL: URL
    var author: String? = "Unknown"
    var duration: Float = 0
    var format: FFormat?
    var album: (name: String?, image: UIImage?)
    
    static func == (lhs: Song, rhs: Song) -> Bool { lhs.fileURL == rhs.fileURL }
}
