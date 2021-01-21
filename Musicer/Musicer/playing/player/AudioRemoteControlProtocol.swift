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
    var albumName: String
    var albumImage: UIImage
    var singer: String
}

enum NowPlayingAction {
    case play
    case pause
    case next
    case last
    case seek
}

protocol AudioRemoteControlDataSource: NSObjectProtocol {
    
    /**
     返回锁屏时的播放信息
     
     @return  返回的是需要设置到锁屏界面的信息，播放同一首歌曲设置一次即可，切歌的时候再次刷新即可
     */
    func remoteControlNowPlayingInfo()->NowPlayingInfo
    
    /**
     播放过程中的实时进度
     
     @return  返回的实时的播放进度，以 秒 为单位
     */
    func remoteControlNowPlayingProgress()->UInt
}

protocol AudioRemoteControlDelegate: NSObjectProtocol {
    /**
     远程控制事件的代理回调
     
     @param   action   远程控制事件类型
     @param   param  远程控制事件触发时可能传递的参数。比如拖动进度条，回调进度
     */
    func remoteControl(didTriggerAction action: NowPlayingAction, withParam param: Any?)
}
