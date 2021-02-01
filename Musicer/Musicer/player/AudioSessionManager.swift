//
//  AudioSessionManager.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/19.
//

import AVFoundation

class AudioSessionManager: NSObject {
    
    weak var delegate: AudioSessionDelegate?
    
    override init() {
        super.init()
        self.addObserver()
    }
    
    deinit {
        self.removeObserver()
    }
}

extension AudioSessionManager {
    
    /// 设置 AVAudioSession 的 category、mode、options
     func setCategory() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,
                                                            mode: .default,
                                                            options: [.allowBluetoothA2DP, .defaultToSpeaker])
        } catch let error {
            ffprint("AudioSession Set Category Failed! Reason: \(error.localizedDescription)")
        }
    }
    
    /// 激活 AudioSession
    /// - Note:
    ///   与设置 session 的 category 的时机不同，session 的激活最好是在真正要播放的时候进行，这样既不影响自己 app 的播放，
    ///   也不至于把别的 app 的播放给抢占了
    func active() {
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            ffprint("AudioSession Active Failed! Reason: \(error.localizedDescription)")
        }
    }
    
    /// 使 AudioSession 失活
    /// - Note:
    ///   在干掉播放器的时候，可以手动释放激活的 AudioSession，当然这一步并不是必须的
    func deActive() {
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error {
            ffprint("AudioSession Deactive Failed! Reason: \(error.localizedDescription)")
        }
    }
}

fileprivate extension AudioSessionManager {
    
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(interruptionHandle(noti:)),
                                               name: AVAudioSession.interruptionNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(interruptionHandle(noti:)),
                                               name: AVAudioSession.silenceSecondaryAudioHintNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(routeChange(noti:)),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: AVAudioSession.interruptionNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: AVAudioSession.silenceSecondaryAudioHintNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: AVAudioSession.routeChangeNotification,
                                                  object: nil)
    }
    
    //MARK: -- 打断处理
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
    
    func didErrorOccur(_ error: MUError) {
        self.delegate?.sessionManager(self, didErrorOccur: error)
    }
    
    //MARK: -- 外设改变处理
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

