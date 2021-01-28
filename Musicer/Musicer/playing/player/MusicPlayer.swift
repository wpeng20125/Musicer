//
//  MusicPlayer.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/13.
//

import UIKit
import AVFoundation
import MediaPlayer

class MusicPlayer: NSObject {
    
    weak var dataSource: MusicPlayerDataSource?
    weak var delegate: MusicPlayerDelegate?
    
    // private
    private var player: AVAudioPlayer?
    private var timer: DispatchSourceTimer?
    private var music: Music?
    
    private lazy var sessionManager: AudioSessionManager = {
        let manager = AudioSessionManager()
        manager.delegate = self
        return manager
    }()
    
    private lazy var remoteControlManager: AudioRemoteControlManager = {
        let manager = AudioRemoteControlManager()
        manager.dataSource = self
        manager.delegate = self
        return manager
    }()
}

//MARK: -- 播放控制
extension MusicPlayer {
    
    /// 设置 AVAudioSession 的 category、mode、options
    func setCategory() { self.sessionManager.setCategory() }
    
    /// 刷新数据源，在进行上一曲/下一曲播放时，通过 MusicPlayerDataSource 提供数据，然后调用该方法刷新播放器数据
    func reloadData() { self.reload_data() }
    
    /// 播放
    func play() { self.play_music() }
    
    /// 暂停
    func pause() { self.pause_music() }
    
    /// 停止，停止播放会释放 player
    func stop() { self.stop_music() }
}

fileprivate extension MusicPlayer {
    
    func reload_data() {
        guard let wrappedMusic = self.dataSource?.musicToPlay(forPlayer: self) else {
            self.delegate?.audioPlayer(self, didErrorOccur: MUError.some(desc: "数据不能为空"))
            return
        }
        self.music = wrappedMusic
        guard let player = try? AVAudioPlayer(contentsOf: self.music!.fileURL) else {
            self.delegate?.audioPlayer(self, didErrorOccur: MUError.some(desc: "播放器初始化失败"))
            return
        }
        player.delegate = self
        self.player = player
        if !self.player!.prepareToPlay() {
            self.delegate?.audioPlayer(self, didErrorOccur: MUError.some(desc: "播放器准备失败"))
        }
    }
    
    func play_music() {
        guard let player = self.player else { return }
        // 配置信息
        self.sessionManager.active()
        self.remoteControlManager.configRemoteControl()
        self.remoteControlManager.configNowPlayingInfo()
        player.play()
        self.startTimer()
        // 回调播放器的状态
        self.delegate?.audioPlayer(self, stateChanged: .play)
    }
    
    func pause_music() {
        guard let player = self.player else { return }
        player.pause()
        self.cancelTimer()
        // 回调播放器的状态
        self.delegate?.audioPlayer(self, stateChanged: .pause)
    }
    
    func stop_music() {
        guard let player = self.player else { return }
        player.stop()
        self.player = nil
        self.music = nil
        self.cancelTimer()
        // 释放 session
        self.sessionManager.deActive()
        // 清除 nowPlayingInfo
        self.remoteControlManager.clearNowPlayingInfo()
    }
}

//MARK: -- 计时器
fileprivate extension MusicPlayer {
    
    func startTimer() {
        self.timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.main)
        self.timer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .microseconds(10))
        self.timer?.setEventHandler(handler: { [weak self] in
            self?.updateProgress()
        })
        self.timer?.resume()
    }
    
    func cancelTimer() {
        if nil == self.timer { return }
        self.timer?.cancel()
        self.timer = nil
    }
    
    func updateProgress() {
        guard let player = self.player else { return }
        var progress: Float = 0
        if(player.duration > 0) { progress = Float(player.currentTime / player.duration) }
        if(progress < 0) { progress = 0 }
        if(progress > 1.0) { progress = 1.0 }
        self.delegate?.audioPlayer(self, playingByProgress: progress)
    }
}

//MARK: -- AVAudioPlayerDelegate
extension MusicPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let wrappedMusic = self.music else { return }
        self.delegate?.audioPlayer(self, didFinishPlayingMusic: wrappedMusic)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.delegate?.audioPlayer(self, didErrorOccur: MUError.some(desc: "音频解码失败"))
    }
}

//MARK: -- AudioSessionDelegate
extension MusicPlayer: AudioSessionDelegate {
    
    func sessionManager(_ manager: AudioSessionManager, didInterruptionStateChange state: AudioInterruptionState) {
        switch state {
        case .begin: self.pause()
        default: ()
        }
    }
    
    func sessionManager(_ manager: AudioSessionManager, shouldContinuePlayingWithRouteChanged continuePlay: Bool) {
        if continuePlay { return }
        self.pause()
    }
    
    func sessionManager(_ manager: AudioSessionManager, didErrorOccur error: MUError) {
        self.delegate?.audioPlayer(self, didErrorOccur: error)
    }
}

//MARK: -- AudioRemoteControlDataSource / AudioRemoteControlDelegate
extension MusicPlayer: AudioRemoteControlDataSource, AudioRemoteControlDelegate {
    
    func remoteControlNowPlayingInfo() -> NowPlayingInfo? {
        guard let music = self.music else { return nil }
        let nowPlayingInfo = NowPlayingInfo(songName: music.songName,
                                            duration: music.duration,
                                            singer: music.singer,
                                            albumName: music.albumName,
                                            albumImage: music.albumImage)
        return nowPlayingInfo
    }
    
    func remoteControl(didTriggerAction action: NowPlayingAction, withParam param: Any?) {
        guard let wrappedMusic = self.music else { return }
        switch action {
        case .play: self.play()
        case .pause: self.pause()
        case .next: self.delegate?.audioPlayer(self, willPlayNextMusic: wrappedMusic)
        case .last: self.delegate?.audioPlayer(self, willPlayLastMusic: wrappedMusic)
        case .seek:
            guard let wrappedProgress = param as? Float else { return }
            guard let music = self.music else { return }
            let sec = ceill(Double(music.duration) * Double(wrappedProgress))
            self.player?.currentTime = sec
        }
    }
}


