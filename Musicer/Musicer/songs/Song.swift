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

struct Song {
    var name: String?
    var fileName: String
    var author: String? = "Unknown"
    var duration: Float = 0
    var format: FFormat?
    var album: (name: String?, local: UIImage?)
}
