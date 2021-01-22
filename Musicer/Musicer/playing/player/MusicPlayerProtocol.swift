//
//  MusicPlayerProtocol.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/18.
//

import Foundation

enum PlayerState {
    case play
    case pause
    case stop
}

struct Music: Equatable {
    var fileURL: URL
    var duration: Int
    
    static func == (lmc: Music, rmc: Music) -> Bool {
        return lmc.fileURL == rmc.fileURL
    }
}

protocol MusicPlayerDataSource: NSObjectProtocol {
    
    /// 返回将要播放的音乐
    ///
    /// - Parameters:
    ///   - player:  MusicPlayer 实例
    /// - Returns: 返回播放器要播放的音乐
    func musicToPlay(forPlayer player: MusicPlayer)->Music
}

protocol MusicPlayerDelegate: NSObjectProtocol {
    
    /// 发生错误时的回调函数，所有的错误均回调该函数
    func audioPlayer(_ player: MusicPlayer, didErrorOccur error: MUError)
    
    /// 播放器状态发生改变时的回调函数
    ///
    /// - Parameters:
    ///   - player: MusicPlayer 实例
    ///   - state: 播放器状态
    func audioPlayer(_ player: MusicPlayer, stateChanged state: PlayerState)
    
    /// 播放过程中，播放进度的回调函数
    ///
    /// - Parameters:
    ///   - player: MusicPlayer 实例
    ///   - progress: 播放进度
    func audioPlayer(_ player: MusicPlayer, playingByProgress progress: Float)
    
    /// 播放结束的回调函数
    ///
    /// - Parameters:
    ///   - player: MusicPlayer 实例
    ///   - music: 当前正在播放的音乐
    func audioPlayer(_ player: MusicPlayer, didFinishPlayingMusic music: Music)
    
    /// 播放器将要播放下一曲。只有远程控制的时候会触发，比如耳机线控，锁屏控制
    ///
    /// - Parameters:
    ///   - player: MusicPlayer 实例
    ///   - current: 当前正在播放的音乐
    func audioPlayer(_ player: MusicPlayer, willPlayNextMusic current: Music)
    
    /// 播放器将要播放上一曲。只有远程控制的时候会触发，比如耳机线控，锁屏控制
    ///
    /// - Parameters:
    ///   - player: MusicPlayer 实例
    ///   - current: 当前正在播放的音乐
    func audioPlayer(_ player: MusicPlayer, willPlayLastMusic current: Music)
}
