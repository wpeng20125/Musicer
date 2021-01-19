//
//  AudioSessionManager.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/19.
//

import AVFoundation

protocol AudioSessionProtocol: NSObjectProtocol {
    
    
}

class AudioSessionManager: NSObject {
    
    func active() {
        
    }
    
    func deActive() {
        
    }
}

//MARK: -- 远程控制
fileprivate extension AudioSessionManager {
    
    func addRemoteControlHandler() {
        
    }
    
    func play() {
        
    }
    
    func pause() {
        
    }
    
    func next() {
        
    }
    
    func last() {
        
    }
    
    func seek() {
        
    }
}

//MARK: -- 打断处理
fileprivate extension AudioSessionManager {
    
    func addInterruptionHandler() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(interruptionHandle(noti:)),
                                               name: AVAudioSession.interruptionNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(interruptionHandle(noti:)),
                                               name: AVAudioSession.silenceSecondaryAudioHintNotification,
                                               object: nil)
    }
    
    @objc func interruptionHandle(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        if AVAudioSession.interruptionNotification == noti.name {
            guard let value = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let type = AVAudioSession.InterruptionType(rawValue: value) else { return }
            switch type {
            case .began: self.interruptionBegin()
            case .ended: self.interruptionFinish()
            default: ()
            }
        }else {
            guard let value = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
                  let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: value) else { return }
            switch type {
            case .begin: self.interruptionBegin()
            case .end: self.interruptionFinish()
            default: ()
            }
        }
    }
    
    func interruptionBegin() {
        
    }
    
    func interruptionFinish() {
        
    }
}

//MARK: -- 播放路径改变
fileprivate extension AudioSessionManager {
    
}
