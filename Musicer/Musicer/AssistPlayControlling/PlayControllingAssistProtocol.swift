//
//  AssistPlayerProtocol.swift
//  Musicer
//
//  Created by 王朋 on 2021/1/27.
//

import UIKit

enum AssistActionType {
    case play
    case pause
    case next
    case last
    case stop
}

enum AssistPosition {
    case top
    case left
    case bottom
    case right
}

protocol PlayControllingAssistDataSource: NSObjectProtocol {
    
    /// 该函数的作用是，向外界请求在 assist 上展示的专辑封面图
    /// - Parameters:
    ///   - assist: PlayControllingAssist 实例
    /// - Returns: 返回要展示的一张专辑图片
    func imageToDisplayForPlayControllingAssist(_ assist: PlayControllingAssist)->UIImage?
    
    /// 是否将下一曲按钮置为不可点击状态。
    /// 在进行列表播放的时候，如果播放到列表的最后一首歌曲，此时下一曲按钮应该不能点击， 以免造成数组越界问题
    /// - Parameters:
    ///   - assist: PlayControllingAssist 实例
    /// - Returns: 返回是否禁用下一曲按钮
    func disableNextButtonForPlayControllingAssist(_ assist: PlayControllingAssist)->Bool
    
    /// 是否将上一曲按钮置为不可点击状态。
    /// 在进行列表播放的时候，如果播放列表的第一首歌曲，此时上一曲按钮应该不能点击，以免造成数组越界
    /// - Parameters:
    ///   - assist: PlayControllingAssist 实例
    /// - Returns: 返回是否禁用上一曲按钮的布尔值
    func disableLastButtonForPlayControllingAssist(_ assist: PlayControllingAssist)->Bool
}

protocol PlayControllingAssistDelegate: NSObjectProtocol {
    
    /// 当点击 assist 上的按钮时会触发的事件回调
    /// - Parameters:
    ///   - assist: PlayControllingAssist 实例
    ///   - action: 触发的事件的类型，是一个 AssistActionType 枚举值
    func playControllingAssist(_ assist: PlayControllingAssist, didTriggerAction action: AssistActionType)
    
    /// 调起大播放器页面
    func playControllingAssistCalloutPlayingController()
}
