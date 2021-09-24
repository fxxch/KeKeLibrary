//
//  SceneDelegate.m
//  IOTDemo
//
//  Created by 刘波 on 2020/8/23.
//

#import "SceneDelegate.h"
#import "RootViewController.h"
#import "SmartHomeCaptureViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


/*
__IPHONE_OS_VERSION_MAX_ALLOWED 这个宏得到的是当前开发环境的系统SDK版本(Base SDK)
__IPHONE_OS_VERSION_MIN_REQUIRED 这个宏它是当前项目选择的最低支持的版本(Deployment Target)

这两个宏在开发时用处比较大，比如 根据不同的开发环境编译不同的代码

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// 在 iOS10.0 及以上的开发环境 编译此部分代码
#else
// 在低于 iOS10.0 的开发环境 编译此部分代码
#endif
*/

/*
 #if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
 #error WMToast requires deployment target iOS 8.0 or higher
 #endif
*/

#ifdef  __IPHONE_OS_VERSION_MIN_REQUIRED
    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_13_0
    //大于某版本的时候代码在这里定义

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    if ([scene isKindOfClass:[UIWindowScene class]]) {
//        RootViewController *vc = [[RootViewController alloc] init];
        SmartHomeCaptureViewController *vc = [[SmartHomeCaptureViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        UIWindowScene *windowScene = (UIWindowScene*)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

    #else
    //更低版本的代码定义
    #endif
#endif


@end
