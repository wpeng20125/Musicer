//
//  PlayingAssistManager.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/27.
//

import UIKit

class PlayingAssistManager: NSObject {
    
    //MARK: -- lazy
    private lazy var player: MusicPlayer = {
        let player = MusicPlayer()
        player.dataSource = self
        player.delegate = self
        return player
    }()
    
    private lazy var assist: PlayControllingAssist = {
        let ass = PlayControllingAssist()
        ass.dataSource = self
        ass.delegate = self
        return ass
    }()
    
    private var songs: [Song]?
    private var playingIndex = 0
    private var isAssistShowing = false
}

extension PlayingAssistManager {
    
    /// 返回一个单例对象
    static let `default` = PlayingAssistManager()
    
    func reload(data: [Song], withPlayingSong index: Int) {
        self.songs = data
        self.playingIndex = index
        self.player.reloadData()
        self.assist.reload()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.player.play()
        }
    }
    
    func showAssist() {
        if self.isAssistShowing { return }
        self.isAssistShowing = true
        UIApplication.shared.windows.first?.addSubview(self.assist)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.assist.kw_x = Double(ScreenWidth) - self.assist.kw_w
        }, completion: nil)
    }
}

fileprivate extension PlayingAssistManager {
    
    func playNext() {
        guard let songs = self.songs else { return }
        self.player.pause()
        if songs.count - 1 == self.playingIndex {  return }
        self.playingIndex += 1
        self.player.reloadData()
        self.assist.reload()
        self.player.play()
    }
    
    func playLast() {
        self.player.pause()
        if 0 == self.playingIndex {  return }
        self.playingIndex -= 1
        self.player.reloadData()
        self.assist.reload()
        self.player.play()
    }
    
    func stopPlay() {
        
    }
}

//MARK: -- PlayControllingAssistDataSource / PlayControllingAssistDelegate
extension PlayingAssistManager: PlayControllingAssistDataSource, PlayControllingAssistDelegate {
    
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
        switch action {
        case .play: self.player.play()
        case .pause: self.player.pause()
        case .next: self.playNext()
        case .last: self.playLast()
        case .stop: self.stopPlay()
        }
    }
}

//MARK: -- MusicPlayerDataSource / MusicPlayerDelegate
extension PlayingAssistManager: MusicPlayerDataSource, MusicPlayerDelegate {
    
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
        switch state {
        case .play: self.assist.play()
        case .pause: self.assist.pause()
        }
    }
    
    func audioPlayer(_ player: MusicPlayer, playingByProgress progress: Float) {
        self.assist.updateProgress(progress: progress)
    }
    
    func audioPlayer(_ player: MusicPlayer, didFinishPlayingMusic music: Music) {
        self.playNext()
    }
    
    func audioPlayer(_ player: MusicPlayer, willPlayNextMusic current: Music) {
        self.playNext()
    }
    
    func audioPlayer(_ player: MusicPlayer, willPlayLastMusic current: Music) {
        self.playLast()
    }
}
