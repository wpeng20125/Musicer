//
//  Common.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/14.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

let kSystemVersion = Float(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)!

var IsIPhoneX : Bool {
    if kSystemVersion < 11.0 { return false }
    guard let unwrapedWindow = UIApplication.shared.delegate!.window! else { return false }
    return unwrapedWindow.safeAreaInsets.bottom > 0
}

let kSafeAreaInsetBottom = IsIPhoneX ? 34.0 : 0
let kSafeAreaInsetTop = IsIPhoneX ? 44.0 : 0
let kTitleBarHeight = IsIPhoneX ? 88.0 : 64.0
let kTabBarHeight = IsIPhoneX ? 83.0 : 49.0
