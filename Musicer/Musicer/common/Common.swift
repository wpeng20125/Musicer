//
//  Common.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/14.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

var HasSafeArea : (has: Bool, inset: UIEdgeInsets) {
    let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let version = UIDevice.current.systemVersion
    let idx = version.firstIndex(of: ".") ?? version.endIndex
    guard let floatVersion = Float(String(version[..<idx])) else { return (false, inset) }
    if floatVersion < 11.0 { return (false, inset) }
    guard let unwrapedWindow = UIApplication.shared.delegate!.window! else { return (false, inset) }
    return (unwrapedWindow.safeAreaInsets.bottom > 0, unwrapedWindow.safeAreaInsets)
}

let SafeAreaInsetBottom = HasSafeArea.has ? HasSafeArea.inset.bottom : 0
let SafeAreaInsetTop = HasSafeArea.has ? HasSafeArea.inset.top : 0
let TitleBarHeight = HasSafeArea.has ? (HasSafeArea.inset.top + 44.0) : 64.0
let TabBarHeight = HasSafeArea.has ? (HasSafeArea.inset.bottom + 49.0) : 49.0






func ffprint<T>(_ msg: T, _ file: String = #file, _ line:Int = #line, _ method: String = #function) {
    #if DEBUG
    print("""
*************************************** Print Start ***************************************
 File : \((file as NSString).lastPathComponent)
 Line : \(line)
 Func : \(method)
 Info : \(msg)
*************************************** Print End *****************************************\n\n
""")
    #endif
}
