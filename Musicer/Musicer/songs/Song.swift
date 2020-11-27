//
//  Song.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/11.
//

import UIKit

struct Song {
    var name: String
    var format: String
    var author: String?
    var duration: Float
    var authorPortrait: (local: UIImage, remote: String?)
    var album: (local: UIImage, remote: String?)
}
