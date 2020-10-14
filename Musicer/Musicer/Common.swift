//
//  Common.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/14.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

let SystemVersion = Float(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)!

var IsIPhoneX : Bool {
    if SystemVersion < 11.0 { return false }
    guard let unwrapedWindow = UIApplication.shared.delegate!.window! else { return false }
    return unwrapedWindow.safeAreaInsets.bottom > 0
}

let SafeAreaInsetBottom = IsIPhoneX ? 34.0 : 0
let SafeAreaInsetTop = IsIPhoneX ? 44.0 : 0
let NavigationBarHeight = IsIPhoneX ? 88.0 : 64.0
let TabBarHeight = IsIPhoneX ? 83.0 : 49.0
