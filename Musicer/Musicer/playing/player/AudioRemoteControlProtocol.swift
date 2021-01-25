//
//  AudioRemoteControlProtocol.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/21.
//

import Foundation
import UIKit

struct NowPlayingInfo {
    var songName: String
    var duration: UInt
    var singer: String?
    var albumName: String?
    var albumImage: UIImage?
}

enum NowPlayingAction {
    case play
    case pause
    case next
    case last
    case seek
}

protocol AudioRemoteControlDataSource: NSObjectProtocol {

    /// 锁屏页面上需要显示的播放信息
    ///
    /// 需要注意的是这个数据源方法只需在播放一首歌开始的时候设置即可
    ///
    /// - Returns: NowPlayingInfo
    func remoteControlNowPlayingInfo()->NowPlayingInfo?
    
    /// 播放过程中的实时进度
    ///
    /// 进入后台播放时，在锁屏页上也会实时的显示进度，这个进度的更新是在播放的时候随着播放器的进度不断地通过 AudioRemoteControlManager
    /// 的  updateNowPlayingInfo() 函数进行触发并设置的
    ///
    /// - Returns: 返回的实时的播放进度，以 秒 为单位
    func remoteControlNowPlayingProgress()->UInt
}

protocol AudioRemoteControlDelegate: NSObjectProtocol {
    
    /// 远程控制事件的代理回调
    ///
    /// 发生远程控制事件时，有可能会进行一些参数的传递，这些参数使用 param 字段进行传递。
    /// 比如拖拽锁屏页上的进度条，此时需要把进度回调给播放器
    ///
    /// - Parameters:
    ///   - action: 远程控制事件类型
    ///   - param: 远程控制事件触发时可能传递的参数
    func remoteControl(didTriggerAction action: NowPlayingAction, withParam param: Any?)
}
