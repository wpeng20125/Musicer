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
    
    /**
     返回将要播放的音乐
     */
    func musicToPlay(forPlayer player: MusicPlayer)->Music
}

protocol MusicPlayerDelegate: NSObjectProtocol {
    
    /**
     发生错误时的回调函数，所有的错误均回调该函数
     */
    func audioPlayer(_ player: MusicPlayer, didErrorOccur error: MUError)
    
    /**
     播放器状态发生改变时的回调函数
     */
    func audioPlayer(_ player: MusicPlayer, stateChanged state: PlayerState)
    
    /**
     播放过程中，播放进度的回调函数
     */
    func audioPlayer(_ player: MusicPlayer, playingByProgress progress: Float)
    
    /**
     播放结束的回调函数，success表示是否成功结束，有可能播放的过程出现解码错误
     */
    func audioPlayer(_ player: MusicPlayer, didFinishPlayingSuccessfully succes: Bool)
}
