//
//  UIWindow+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIWindow+KKCategory.h"

@implementation UIWindow (KKCategory)

//获取当前屏幕显示的viewcontroller
- (nullable UIViewController *)currentTopViewController{
    UIViewController *rootViewController = self.rootViewController;
    UIViewController *currentVC = [self getTopViewControllerFrom:rootViewController];
    return currentVC;
}

- (nullable UIViewController *)getTopViewControllerFrom:(nullable UIViewController *)rootVC{
    UIViewController *currentVC;
    //有从rootVC presented出来的视图
    if ([rootVC presentedViewController]) {
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getTopViewControllerFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getTopViewControllerFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

+ (UIWindow*)currentKeyWindow{
    
    UIWindow* window = nil;
    
    if (@available(iOS 13.0, *)) {
       for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
       {
           if (windowScene.activationState == UISceneActivationStateForegroundActive)
           {
               for (UIWindow *subWindow in [windowScene windows]) {
                   if (subWindow.hidden == NO) {
                       window = subWindow;
                       break;
                   }
               }
           }
       }
        
        if (window==nil) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
            {
                if (windowScene.activationState == UISceneActivationStateForegroundInactive)
                {
                    for (UIWindow *subWindow in [windowScene windows]) {
                        if (subWindow.hidden == NO) {
                            window = subWindow;
                            break;
                        }
                    }
                }
            }
        }
    }
    else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    
    return window;
}

@end
