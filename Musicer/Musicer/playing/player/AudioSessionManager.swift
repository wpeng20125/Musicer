//
//  AudioSessionManager.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/19.
//

import AVFoundation

class AudioSessionManager: NSObject {
    
    weak var delegate: AudioSessionDelegate?
    
}

extension AudioSessionManager {
    
    /// 激活 session
    func active() {
        
    }
    
    /// 释放 session
    func deActive() {
        
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
    
    func removeInterruptionHandler() {
        NotificationCenter.default.removeObserver(self,
                                                  name: AVAudioSession.interruptionNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
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
        self.delegate?.sessionManager(self, didInterruptionStateChange: .begin)
    }
    
    func interruptionFinish() {
        self.delegate?.sessionManager(self, didInterruptionStateChange: .end)
    }
}

//MARK: -- 播放路径改变
fileprivate extension AudioSessionManager {
    
}
