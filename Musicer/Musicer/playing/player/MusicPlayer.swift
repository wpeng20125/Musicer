//
//  MusicPlayer.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/13.
//

import UIKit
import AVFoundation

class MusicPlayer: NSObject {
    
    weak var dataSource: MusicPlayerDataSource?
    weak var delegate: MusicPlayerDelegate?
    
    // private
    private var player: AVAudioPlayer?
    private var timer: DispatchSourceTimer?
    private var music: Music?
}

//MARK: -- 播放控制
extension MusicPlayer {
    
    /**
     该函数返回的是一个单例
     */
    static let `default` = MusicPlayer()
    
    func reloadData() { self.reload_data() }
    
    /**
     播放
     */
    func play() { self.play_music() }
    
    /**
     暂停
     */
    func pause() { self.pause_music() }
    
    /**
     停止，停止播放会释放 player
     */
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
        self.player = player
        if !self.player!.prepareToPlay() {
            self.delegate?.audioPlayer(self, didErrorOccur: MUError.some(desc: "播放器准备失败"))
        }
    }
    
    func play_music() {
        guard let player = self.player else { return }
        player.play()
        self.startTimer()
    }
    
    func pause_music() {
        guard let player = self.player else { return }
        player.pause()
        self.cancelTimer()
    }
    
    func stop_music() {
        guard let player = self.player else { return }
        player.stop()
        self.player = nil
        self.music = nil
        self.cancelTimer()
    }
}

//MARK: -- 计时器
fileprivate extension MusicPlayer {
    
    func startTimer() {
        self.timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.global())
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
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
}
