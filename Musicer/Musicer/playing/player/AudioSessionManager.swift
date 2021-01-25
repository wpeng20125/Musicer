//
//  AudioSessionManager.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/19.
//

import AVFoundation

class AudioSessionManager: NSObject {
    
    weak var delegate: AudioSessionDelegate?
    
    /// 当前应用程序的 audiosession 是否是激活状态
    private var isAudioSessionActive: Bool = false
}

extension AudioSessionManager {
    
    /// 配置 session
    func configSession() {
        if self.isAudioSessionActive { return }
        self.addInterruptionHandler()
        self.addRouteChangeHandler()
    }
    
    /// 释放 session
    func releaseSession() {
        self.isAudioSessionActive = false
        self.removeInterruptionHandler()
        self.removeRouteChangeHandler()
    }
}

//MARK: -- 打断处理
fileprivate extension AudioSessionManager {
    
    func addInterruptionHandler() {
        // do active
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,
                                                            mode: .default,
                                                            options: [.allowBluetoothA2DP, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
            self.didErrorOccur(MUError.some(desc: "AudioSession 激活失败"))
            return
        }
        // add observer
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(interruptionHandle(noti:)),
                                               name: AVAudioSession.interruptionNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(interruptionHandle(noti:)),
                                               name: AVAudioSession.silenceSecondaryAudioHintNotification,
                                               object: nil)
        self.isAudioSessionActive = true
    }
    
    func removeInterruptionHandler() {
        // deactive
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch _ {
            self.didErrorOccur(MUError.some(desc: "AudioSession 失活失败"))
            return
        }
        NotificationCenter.default.removeObserver(self,
                                                  name: AVAudioSession.interruptionNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: AVAudioSession.silenceSecondaryAudioHintNotification,
                                                  object: nil)
        self.isAudioSessionActive = false
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
        self.isAudioSessionActive = false
        self.delegate?.sessionManager(self, didInterruptionStateChange: .begin)
    }
    
    func interruptionFinish() {
        self.delegate?.sessionManager(self, didInterruptionStateChange: .end)
    }
    
    func didErrorOccur(_ error: MUError) {
        self.delegate?.sessionManager(self, didErrorOccur: error)
    }
}

//MARK: -- 外设改变
fileprivate extension AudioSessionManager {
    
    func addRouteChangeHandler() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(routeChange(noti:)),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: nil)
    }
    
    func removeRouteChangeHandler() {
        NotificationCenter.default.removeObserver(self,
                                                  name: AVAudioSession.routeChangeNotification,
                                                  object: nil)
    }
    
    @objc func routeChange(noti: Notification) {
        guard let userInfo = noti.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else { return }
        
        var playing = true
        if reason == .oldDeviceUnavailable {
            if let priviousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                playing = priviousRoute.outputs.filter({$0.portType == .headphones}).isEmpty
            }
        }
        self.delegate?.sessionManager(self, shouldContinuePlayingWithRouteChanged: playing)
    }
}
