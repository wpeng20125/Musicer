//
//  PlayingController+delegate.swift
//  Musicer
//
//  Created by 王朋 on 2020/11/19.
//

import UIKit

extension PlayingController:
    PlayControllingCardAssistDelegate,
    PlayControllingCardDelegate,
    TitleBarDataSource,
    SongsTableDelegate
{
    
    //MARK: -- TitleBarDataSource
    func property(forNavigationBar nav: TitleBar, atPosition p: ItemPosition) -> ItemProperty? {
        if p != .middle { return nil }
        let item = ItemProperty()
        item.title = "当前播放列表"
        item.titleColor = R.color.mu_color_white()
        item.fontSize = 16.0
        return item
    }
    
    //MARK: -- PlayControllingCardAssistDelegate
    func assistGestureTriggered(_ assist: PlayControllingCardAssist) {
        self.card.show()
        assist.hide()
    }
    
    //MARK: -- PlayControllingCardDelegate
    func playControllingCardPlayNextSong(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardPlayLastSong(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardUploadSongs(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardShowAllList(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardShowCurrentList(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCardFavouriteThisSong(_ card: PlayControllingCard) {
        
    }
    
    func playControllingCard(_ card: PlayControllingCard, playingModeChanged mode: PlayingMode) {
        
    }
    
    func playControllingCard(_ card: PlayControllingCard, playingStateChanged state: PlayingState) {
        
    }
    
    func playControllingCard(_ card: PlayControllingCard, willDisplay byShowing: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.table.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.view).offset(byShowing ? -card.h : 0)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func playControllingCard(_ card: PlayControllingCard, displayCompleted byShowing: Bool) {
        guard byShowing else {
            self.assist.show()
            return
        }
        self.assist.hide()
    }
    
    //MARK: -- SongsTableDelegate
    func songsTable(_ table: SongsTable, didSelectSong song: Song) {
        self.card.play()
    }
}
