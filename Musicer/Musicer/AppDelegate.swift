//
//  AppDelegate.swift
//  Musicer
//
//  Created by 王朋 on 2020/10/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BaseNavigationController(rootViewController: PlayingListController())
        self.window?.makeKeyAndVisible()
        
        AudioPlayingManager.default.setAudioSessionCategory()
        
        return true
    }
    
    
}
