//
//  AudioSessionProtocol.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/20.
//

import Foundation

enum AudioInterruptionState {
    case begin
    case end
}

protocol AudioSessionDelegate: NSObjectProtocol {
    
    func sessionManager(_ manager: AudioSessionManager, didInterruptionStateChange state: AudioInterruptionState)
}

