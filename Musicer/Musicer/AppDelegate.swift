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
        self.window?.rootViewController = BaseNavigationController(rootViewController: PlayingController())
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //3种状态无法响应事件
     if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) return nil;
    //触摸点若不在当前视图上则无法响应事件
    if ([self pointInside:point withEvent:event] == NO) return nil;
    //从后往前遍历子视图数组
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--)
    {
        // 获取子视图
        UIView *childView = self.subviews[i];
        // 坐标系的转换,把触摸点在当前视图上坐标转换为在子视图上的坐标
        CGPoint childP = [self convertPoint:point toView:childView];
        //询问子视图层级中的最佳响应视图
        UIView *fitView = [childView hitTest:childP withEvent:event];
        if (fitView)
        {
            //如果子视图中有更合适的就返回
            return fitView;
        }
    }
    //没有在子视图中找到更合适的响应视图，那么自身就是最合适的
    return self;
}
