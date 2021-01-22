//
//  AudioRemoteControlManager.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/21.
//

import Foundation
import MediaPlayer

class AudioRemoteControlManager: NSObject {
    
    weak var dataSource: AudioRemoteControlDataSource?
    weak var delegate: AudioRemoteControlDelegate?
    
    //MARK: -- private
    private var playCommand: Any?
    private var pauseCommand: Any?
    private var nextCommand: Any?
    private var lastCommand: Any?
    private var seekCommand: Any?
    
    private var nowPlayingInfo: NowPlayingInfo?
}

extension AudioRemoteControlManager {
    
    /// 配置远程控制事件的监听
    func configRemoteControl() { self.addRemoteControlHandler() }
    
    /// 设置锁屏显示的信息，该方法只需播放歌曲的时候设置一次即可，需要更新的话使用 updateNowPlayingInfo 方法
    func configNowPlayingInfo() { self.setNowPlayingInfo() }
    
    /// 更新锁屏显示的信息
    func updateNowPlayingInfo() { self.refreshNowPlayingInfo() }
    
    /// 清除锁屏显示信息
    func clearNowPlayingInfo() { self.removeRemoteControlHandler() }
}

fileprivate extension AudioRemoteControlManager {
    
    func addRemoteControlHandler() {
        // 播放
        self.playCommand = MPRemoteCommandCenter.shared().playCommand.addTarget(handler: {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.remote_play()
            return .success
        })
        // 暂停
        self.pauseCommand = MPRemoteCommandCenter.shared().pauseCommand.addTarget(handler: {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.remote_pause()
            return .success
        })
        // 下一曲
        self.nextCommand = MPRemoteCommandCenter.shared().nextTrackCommand.addTarget(handler: {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.remote_next()
            return .success
        })
        // 上一曲
        self.lastCommand = MPRemoteCommandCenter.shared().previousTrackCommand.addTarget(handler: {[weak self] (event) -> MPRemoteCommandHandlerStatus in
            self?.remote_last()
            return .success
        })
        // 拖拽进度条
        self.seekCommand = MPRemoteCommandCenter.shared().changePlaybackPositionCommand.addTarget(handler: { (event) -> MPRemoteCommandHandlerStatus in
            guard let seekEvent = event as? MPChangePlaybackPositionCommandEvent,
                  let playingInfo = self.nowPlayingInfo else {
                return .commandFailed
            }
            let progres = Float(seekEvent.positionTime) / playingInfo.duration
            self.remote_seek(progres)
            return .success
        })
    }
    
    func removeRemoteControlHandler() {
        // remove command
        MPRemoteCommandCenter.shared().playCommand.removeTarget(self.playCommand)
        MPRemoteCommandCenter.shared().pauseCommand.removeTarget(self.pauseCommand)
        MPRemoteCommandCenter.shared().nextTrackCommand.removeTarget(self.nextCommand)
        MPRemoteCommandCenter.shared().previousTrackCommand.removeTarget(self.lastCommand)
        MPRemoteCommandCenter.shared().changePlaybackPositionCommand.removeTarget(self.seekCommand)
        // reset nowPlayingInfo
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
    
    func setNowPlayingInfo() {
        guard let info = self.dataSource?.remoteControlNowPlayingInfo() else { return }
        self.nowPlayingInfo = info;
        var nowPlayingInfo = [String : Any]()
        // 歌曲名称
        nowPlayingInfo[MPMediaItemPropertyTitle] = info.songName
        // 专辑名称
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = info.albumName
        // 歌手
        nowPlayingInfo[MPMediaItemPropertyArtist] = info.singer
        // 专辑封面
        let artwork = MPMediaItemArtwork(boundsSize: info.albumImage.size) { (size) -> UIImage in
            guard let image = info.albumImage.resize(size) else { return info.albumImage }
            return image
        }
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func refreshNowPlayingInfo() {
        
    }
}

fileprivate extension AudioRemoteControlManager {
    
    func remote_play() {
        
    }
    
    func remote_pause() {
        
    }
    
    func remote_next() {
        
    }
    
    func remote_last() {
        
    }
    
    func remote_seek(_ progress: Float) {
        self.delegate?.remoteControl(didTriggerAction: .seek, withParam: progress)
    }
}
