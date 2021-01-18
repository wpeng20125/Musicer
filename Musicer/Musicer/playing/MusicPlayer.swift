//
//  MusicPlayer.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/13.
//

import UIKit
import AVFoundation

class MusicPlayer {
    
    weak var dataSource: MusicPlayerDataSource?
    weak var delegate: MusicPlayerDelegate?
    
    //MARK: -- private
    private var player: AVAudioPlayer? 
    private var timer: DispatchSourceTimer?
    private var music: Music?
    private var timerSuspended: Bool = false
}

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
        self.player?.play()
        
    }
    
    func pause_music() {
        self.player?.pause()
        
    }
    
    func stop_music() {
        self.player?.stop()
        self.player = nil
        
    }
}

fileprivate extension MusicPlayer {
    
    func configTimer() {
        self.timer = DispatchSource.makeTimerSource(flags: .strict, queue: DispatchQueue.global())
        self.timer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .microseconds(10))
        self.timer?.setEventHandler(handler: { [weak self] in
            self?.updateProgress()
        })
    }
    
    func startTimer() {
        self.timer?.resume()
    }
    
    func cancelTimer() {
        self.timer?.cancel()
        self.timer = nil
    }
    
    func updateProgress() {
        guard let player = self.player else { return }
        guard let music = self.music else { return }
        var progress: Float = 0
        if(music.duration > 0) { progress = Float(player.currentTime) / Float(music.duration) }
        if(progress > 1.0) { progress = 1.0 }
        self.delegate?.audioPlayer(self, playingByProgress: progress)
    }
}
