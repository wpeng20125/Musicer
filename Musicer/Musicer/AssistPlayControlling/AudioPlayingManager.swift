//
//  PlayingAssistManager.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/27.
//

import UIKit
import AVFoundation

class AudioPlayingManager: NSObject {
    
    private override init() { }
    
    //MARK: -- readonly
    private(set) var listName: String?
    private(set) var songs: [Song]?
    private(set) var playingIndex = 0
    private(set) var isAssistShowing = false
    
    //MARK: -- private
    private var player: MusicPlayer?
    private var assist: PlayControllingAssist?
}

extension AudioPlayingManager {
    
    /// 返回一个单例对象
    static let `default` = AudioPlayingManager()
    
    /// 设置 AVAudioSession 的 category、mode、options
    /// - Note:
    ///   设置 category 最好是在 application 的生命周期方法中进行，冷启动的时候在 didFinishLaunchingWithOptions 中设置
    ///   前后台切换的时候，可以判断当前的 session 是否被其他 app 占用，以决定是否重新设置
    func setAudioSessionCategory() {
        self.config()
        self.player?.setCategory()
    }
    
    /// 开始播放歌曲
    /// - Parameters:
    ///   - songs: 歌曲列表
    ///   - index: 将要播放的歌曲在列表中的索引
    func letsPlay(songs: [Song], withPlayingIndex index: Int, forList list: String) {
        self.config()
        guard self.isAssistShowing else {
            self.prepare(data: songs, withPlayingIndex: index, forList: list)
            self.showAssist { self.player!.play() }
            return
        }
        guard self.listName == list && self.playingIndex == index else {
            self.prepare(data: songs, withPlayingIndex: index, forList: list)
            self.player?.pause()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { self.player?.play() }
            return
        }
    }
    
    /// 停止播放
    func letsStop() { self.stopPlay() }
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
    
    func prepare(data songs: [Song], withPlayingIndex index: Int, forList list: String) {
        self.songs = songs
        self.playingIndex = index
        self.listName = list
        self.player?.reloadData()
        self.assist?.reloadData()
    }
    
    func showAssist(complete: @escaping ()->Void) {
        self.isAssistShowing = true
        guard let unwrappedAssist = self.assist else { return }
        UIApplication.shared.windows.first?.addSubview(unwrappedAssist)
        unwrappedAssist.show({ flag in
            if flag { complete() }
        })
    }
    
    func hideAssist(complete: @escaping ()->Void) {
        self.isAssistShowing = false
        self.assist?.hide({ flag in
            if flag { complete() }
        })
    }
    
    func playNext(afterDelay: Bool) {
        guard let unwrappedPlayer = self.player, let unwrappedAssist = self.assist else { return }
        guard let unwrappedSongs = self.songs else { return }
        unwrappedPlayer.pause()
        if unwrappedSongs.count - 1 == self.playingIndex {  return }
        let closure = {
            self.playingIndex += 1
            unwrappedPlayer.reloadData()
            unwrappedAssist.reloadData()
            unwrappedPlayer.play()
        }
        if afterDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {  closure() }
        }else {
            closure()
        }
    }
    
    func playLast() {
        guard let unwrappedPlayer = self.player, let unwrappedAssist = self.assist else { return }
        unwrappedPlayer.pause()
        if 0 == self.playingIndex {  return }
        self.playingIndex -= 1
        unwrappedPlayer.reloadData()
        unwrappedAssist.reloadData()
        unwrappedPlayer.play()
    }
    
    func stop() {
        let alert = UIAlertController(title: "关闭浮窗？",
                                      message: "关闭悬浮窗后,\n正在播放的音乐将停止播放！",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "再听一会儿", style: .cancel, handler: nil)
        let confiem = UIAlertAction(title: "不想听了", style: .destructive) { (action) in
            self.stopPlay()
        }
        alert.addAction(cancel)
        alert.addAction(confiem)
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func stopPlay() {
        self.hideAssist {
            self.player?.stop()
            self.playingIndex = 0;
            self.assist?.removeFromSuperview()
            self.assist = nil
            self.player = nil
            self.songs = nil;
            self.listName = nil;
        }
    }
}

//MARK: -- PlayControllingAssistDataSource / PlayControllingAssistDelegate
extension AudioPlayingManager: PlayControllingAssistDataSource, PlayControllingAssistDelegate {
    
    func imageToDisplayForPlayControllingAssist(_ assist: PlayControllingAssist) -> UIImage? {
        guard let unwrappedSongs = self.songs else { return nil }
        return unwrappedSongs[self.playingIndex].album.image
    }
    
    func disableNextButtonForPlayControllingAssist(_ assist: PlayControllingAssist) -> Bool {
        guard let unwrappedSongs = self.songs else { return true }
        return unwrappedSongs.count - 1 == self.playingIndex
    }
    
    func disableLastButtonForPlayControllingAssist(_ assist: PlayControllingAssist) -> Bool {
        return 0 == self.playingIndex
    }
    
    func playControllingAssist(_ assist: PlayControllingAssist, didTriggerAction action: AssistActionType) {
        guard let unwrappedPlayer = self.player else { return }
        switch action {
        case .play:
            unwrappedPlayer.play()
        case .pause:
            unwrappedPlayer.pause()
        case .next:
            self.playNext(afterDelay: false)
        case .last:
            self.playLast()
        case .stop:
            self.stop()
        }
    }
    
    func playControllingAssistCalloutPlayingController() {
        
    }
}

//MARK: -- MusicPlayerDataSource / MusicPlayerDelegate
extension AudioPlayingManager: MusicPlayerDataSource, MusicPlayerDelegate {
    
    func musicToPlay(forPlayer player: MusicPlayer) -> Music? {
        guard let unwrappedSongs = self.songs else { return nil }
        let song = unwrappedSongs[self.playingIndex]
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
        guard let unwrappedAssist = self.assist else { return }
        switch state {
        case .play:
            unwrappedAssist.play()
        case .pause:
            unwrappedAssist.pause()
        }
    }
    
    func audioPlayer(_ player: MusicPlayer, playingByProgress progress: Float) {
        guard let unwrappedAssist = self.assist else { return }
        unwrappedAssist.updateProgress(progress: progress)
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
