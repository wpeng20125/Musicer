//
//  AudioSessionProtocol.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/20.
//

import Foundation

enum AudioInterruptionState {
    case begin
    case end
}

protocol AudioSessionDelegate: NSObjectProtocol {
    
    /// 播放过程中发生中断的回调
    ///
    /// - Parameters:
    ///   - manager: AudioSessionManager 实例
    ///   - state: 表示中断的状态，开始和结束
    func sessionManager(_ manager: AudioSessionManager, didInterruptionStateChange state: AudioInterruptionState)
    
    /// 播放过程中，输出设备发生改变时的回调
    /// - Parameters:
    ///   - manager: AudioSessionManager 实例
    ///   - continue: 表示输出外设发生改变之后，是否需要继续播放
    func sessionManager(_ manager: AudioSessionManager, shouldContinuePlayingWithRouteChanged continuePlay: Bool)
    
    /// 发生错误的回调
    /// - Parameters:
    ///   - manager: AudioSessionManager 实例
    ///   - error: 错误情况
    func sessionManager(_ manager: AudioSessionManager, didErrorOccur error: MUError)
}

