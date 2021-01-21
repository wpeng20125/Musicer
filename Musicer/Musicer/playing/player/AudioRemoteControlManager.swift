//
//  AudioRemoteControlManager.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/21.
//

import Foundation
import MediaPlayer

class AudioRemoteControlManager: NSObject {
    
    //MARK: -- lzay
    private lazy var playCommand: Any = {
        MPRemoteCommandCenter.shared().playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.remote_play()
            return .success
        }
    }()
    
    private lazy var pauseCommand: Any = {
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.remote_pause()
            return .success
        }
    }()
    
    private lazy var nextCommand: Any = {
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.remote_next()
            return .success
        }
    }()
    
    private lazy var lastCommand: Any = {
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.remote_last()
            return .success
        }
    }()
}

extension AudioRemoteControlManager {
    
    func addRemoteControlHandler() {
        
    }
    
    func removeRemoteControlHandler() {
        
    }
    
    func remote_setInfo() {
        
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
        
    }
}
