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
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
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
        guard let unwrappedUserInfo = noti.userInfo else { return }
        if AVAudioSession.interruptionNotification == noti.name {
            guard let unwrappedValue = unwrappedUserInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let unwrappedType = AVAudioSession.InterruptionType(rawValue: unwrappedValue) else { return }
            switch unwrappedType {
            case .began: self.interruptionBegin()
            case .ended: self.interruptionFinish()
            default: ()
            }
        }else {
            guard let unwrappedValue = unwrappedUserInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
                  let unwrappedType = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: unwrappedValue) else { return }
            switch unwrappedType {
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
        guard let unwrappedUserInfo = noti.userInfo,
              let unwrappedReasonValue = unwrappedUserInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let unwrappedReason = AVAudioSession.RouteChangeReason(rawValue: unwrappedReasonValue) else { return }
        
        var playing = true
        if unwrappedReason == .oldDeviceUnavailable {
            if let unwrappedPriviousRoute = unwrappedUserInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                playing = unwrappedPriviousRoute.outputs.filter({$0.portType == .headphones}).isEmpty
            }
        }
        self.delegate?.sessionManager(self, shouldContinuePlayingWithRouteChanged: playing)
    }
}

