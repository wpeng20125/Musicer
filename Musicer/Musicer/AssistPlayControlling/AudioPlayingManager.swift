//
//  PlayingAssistManager.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/27.
//

import UIKit
import AVFoundation

class AudioPlayingManager: NSObject {
    
    override init() {
        super.init()
        self.config()
    }
    
    private var player: MusicPlayer?
    private var assist: PlayControllingAssist?
    
    private var songs: [Song]?
    private var playingIndex = 0
    private var isAssistShowing = false
}

extension AudioPlayingManager {
    
    /// 返回一个单例对象
    static let `default` = AudioPlayingManager()
    
    /// 设置 AVAudioSession 的 category、mode、options
    /// - Note:
    ///   设置 category 最好是在 application 的生命周期方法中进行，冷启动的时候在 didFinishLaunchingWithOptions 中设置
    ///   前后台切换的时候，可以判断当前的 session 是否被其他 app 占用，以决定是否重新设置
    func setAudioSessionCategory() {
        self.player?.setCategory()
    }
    
    /// 开始播放歌曲
    /// - Parameters:
    ///   - songs: 歌曲列表
    ///   - index: 将要播放的歌曲在列表中的索引
    func letsPlay(songs: [Song], withPlayingIndex index: Int) {
        self.config()
        self.songs = songs
        self.playingIndex = index
        self.player?.reloadData()
        self.assist?.reloadData()
        if !self.isAssistShowing {
            self.showAssist { self.player!.play() }
        }else {
            self.player?.pause()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { self.player?.play() }
        }
    }
}

fileprivate extension AudioPlayingManager {
    
    func config() {
        if nil == self.player {
            self.player = MusicPlayer()
            self.player!.dataSource = self
            self.player!.delegate = self
        }
        if nil == self.assist {
            self.assist = PlayControllingAssist()
            self.assist!.dataSource = self
            self.assist!.delegate = self
        }
    }
    
    func showAssist(complete: @escaping ()->Void) {
        self.isAssistShowing = true
        guard let wrappedAssist = self.assist else { return }
        UIApplication.shared.windows.first?.addSubview(wrappedAssist)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            wrappedAssist.kw_x = Double(ScreenWidth) - wrappedAssist.kw_w
        } completion: { (flag) in
            if flag { complete() }
        }
    }
    
    func hideAssist() {
        self.isAssistShowing = false
        guard let wrappedAssist = self.assist else { return }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            switch wrappedAssist.loc {
            case .top:
                wrappedAssist.kw_y = -wrappedAssist.kw_h
            case .left:
                wrappedAssist.kw_x = -wrappedAssist.kw_w
            case .bottom:
                wrappedAssist.kw_y = Double(ScreenHeight)
            case .right:
                wrappedAssist.kw_x = Double(ScreenWidth)
            }
        } completion: { (flag) in
            wrappedAssist.removeFromSuperview()
            self.assist = nil
        }
    }
    
    func playNext(afterDelay: Bool) {
        guard let wrappedPlayer = self.player, let wrappedAssist = self.assist else { return }
        guard let songs = self.songs else { return }
        wrappedPlayer.pause()
        if songs.count - 1 == self.playingIndex {  return }
        let closure = {
            self.playingIndex += 1
            wrappedPlayer.reloadData()
            wrappedAssist.reloadData()
            wrappedPlayer.play()
        }
        if afterDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {  closure() }
        }else {
            closure()
        }
    }
    
    func playLast() {
        guard let wrappedPlayer = self.player, let wrappedAssist = self.assist else { return }
        wrappedPlayer.pause()
        if 0 == self.playingIndex {  return }
        self.playingIndex -= 1
        wrappedPlayer.reloadData()
        wrappedAssist.reloadData()
        wrappedPlayer.play()
    }
    
    func stopPlay() {
        let alert = UIAlertController(title: "",
                                      message: "关闭悬浮窗并停止播放！",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "再听一会儿", style: .cancel, handler: nil)
        let confiem = UIAlertAction(title: "不想听了", style: .default) { (action) in
            self.hideAssist()
            if let wrappedPlayer = self.player { wrappedPlayer.stop() }
            self.player = nil
        }
        alert.addAction(cancel)
        alert.addAction(confiem)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

//MARK: -- PlayControllingAssistDataSource / PlayControllingAssistDelegate
extension AudioPlayingManager: PlayControllingAssistDataSource, PlayControllingAssistDelegate {
    
    func imageToDisplayForPlayControllingAssist(_ assist: PlayControllingAssist) -> UIImage? {
        guard let songs = self.songs else { return nil }
        return songs[self.playingIndex].album.image
    }
    
    func disableNextButtonForPlayControllingAssist(_ assist: PlayControllingAssist) -> Bool {
        guard let songs = self.songs else { return true }
        return songs.count - 1 == self.playingIndex
    }
    
    func disableLastButtonForPlayControllingAssist(_ assist: PlayControllingAssist) -> Bool {
        return 0 == self.playingIndex
    }
    
    func playControllingAssist(_ assist: PlayControllingAssist, didTriggerAction action: AssistActionType) {
        guard let wrappedPlayer = self.player else { return }
        switch action {
        case .play:
            wrappedPlayer.play()
        case .pause:
            wrappedPlayer.pause()
        case .next:
            self.playNext(afterDelay: false)
        case .last:
            self.playLast()
        case .stop:
            self.stopPlay()
        }
    }
}

//MARK: -- MusicPlayerDataSource / MusicPlayerDelegate
extension AudioPlayingManager: MusicPlayerDataSource, MusicPlayerDelegate {
    
    func musicToPlay(forPlayer player: MusicPlayer) -> Music? {
        guard let songs = self.songs else { return nil }
        let song = songs[self.playingIndex]
        let music = Music(fileURL: song.fileURL,
                          duration: UInt(ceilf(song.duration)),
                          songName: song.name,
                          albumName: song.album.name,
                          albumImage: song.album.image,
                          singer: song.author)
        return music
    }
    
    func audioPlayer(_ player: MusicPlayer, didErrorOccur error: MUError) {
        switch error {
        case let .some(desc): Toaster.flash(withText: desc)
        default: ()
        }
        player.pause()
    }
    
    func audioPlayer(_ player: MusicPlayer, stateChanged state: PlayerState) {
        guard let wrappedAssist = self.assist else { return }
        switch state {
        case .play:
            wrappedAssist.play()
        case .pause:
            wrappedAssist.pause()
        }
    }
    
    func audioPlayer(_ player: MusicPlayer, playingByProgress progress: Float) {
        guard let wrappedAssist = self.assist else { return }
        wrappedAssist.updateProgress(progress: progress)
    }
    
    func audioPlayer(_ player: MusicPlayer, didFinishPlayingMusic music: Music) {
        self.playNext(afterDelay: true)
    }
    
    func audioPlayer(_ player: MusicPlayer, willPlayNextMusic current: Music) {
        self.playNext(afterDelay: false)
    }
    
    func audioPlayer(_ player: MusicPlayer, willPlayLastMusic current: Music) {
        self.playLast()
    }
}
