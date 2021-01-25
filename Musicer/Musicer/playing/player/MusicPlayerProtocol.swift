//
//  MusicPlayerProtocol.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/18.
//

import UIKit

enum PlayerState {
    case play
    case pause
}

struct Music: Equatable {
    var fileURL: URL
    var duration: UInt
    var songName: String
    var albumName: String?
    var albumImage: UIImage?
    var singer: String?
    
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
    
    
    /// 播放音乐时发生错误的回调
    /// - Note:
    ///   需要注意的是，当发生错误的时候，内部只是把错误回调到外界了，使用者自己去处理相关的业务逻辑。
    ///   包括暂停播放、弹窗提示等
    /// - Parameters:
    ///   - player: MusicPlayer 实例
    ///   - error: 具体的错误
    func audioPlayer(_ player: MusicPlayer, didErrorOccur error: MUError)
    
    /// 播放器状态发生改变时的回调函数
    /// - Note:
    ///   不要在这个回调方法中根据状态再次调用播放或暂停，内部已经处理。如果调用的话会造成递归死循环！
    ///   该回调只是用来根据状态更新 UI 的
    /// - Parameters:
    ///   - player: MusicPlayer 实例
    ///   - state: 播放器状态改变后的状态值
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
