//
//  Common.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/14.
//

import UIKit

enum MUError {
    case none(info: String)
    case some(desc: String)
}

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

var HasSafeArea : (has: Bool, inset: UIEdgeInsets) {
    let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let version = UIDevice.current.systemVersion
    let idx = version.firstIndex(of: ".") ?? version.endIndex
    guard let unwrappedFloatVersion = Float(String(version[..<idx])) else { return (false, inset) }
    if unwrappedFloatVersion < 11.0 { return (false, inset) }
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

// 时间戳相关
typealias Timestamp = Date
typealias TimestampValue = Double
extension Timestamp {
    /// 返回一个当前的时间戳，这个方法返回的是一个原始的时间戳，可能带小数点
    static func current()->TimestampValue { Date().timeIntervalSince1970 }
    /// 返回一个任意时间的时间戳，这个方法返回的是一个原始的时间戳，可能带小数点
    func custom()->TimestampValue { self.timeIntervalSince1970 }
}
extension TimestampValue {
    /// 返回一个 秒 级的时间戳，四舍五入取整
    func sec()->String { "\(Int(roundl(self)))" }
    /// 返回一个 毫秒 级的时间戳，四舍五入取整
    func millisec()->String { "\(Int(roundl(self * 1000)))" }
    /// 返回一个 微秒 级的时间戳，四舍五入取整
    func microsec()->String { "\(Int(roundl(self * 1000 * 1000)))" }
}
