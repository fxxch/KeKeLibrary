//
//  AppDelegate.m
//  IOTDemo
//
//  Created by 刘波 on 2020/8/23.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    RootViewController *vc = [[RootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    [self registerAppleNotification];
    
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    return YES;

}


#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}


//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

#pragma mark ==================================================
#pragma mark === 苹果APNS【注册】
#pragma mark ==================================================
/**
 ①注册推送通知
 */
- (void)registerAppleNotification{
    //iOS 10
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setDelegate:self];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |
                                             UNAuthorizationOptionSound |
                                             UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        //用户未授权
        if (granted==NO) {
            KKLogWarning(@"用户拒绝开启远程通知");
        }
        if (error) {
            KKAlertView *alert = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:[NSString stringWithFormat:@"Error in registration. Error: %@", error] delegate:nil buttonTitles:@"OK",nil];
            [alert show];
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [self reloadApplicationIconBadgeNumber];
}

- (void)reloadApplicationIconBadgeNumber{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


#pragma mark ==================================================
#pragma mark === 苹果APNS【DeviceToken】
#pragma mark ==================================================
/**
 ②-1注册推送通知成功 返回DeviceToken
 
 @param application application
 @param deviceToken deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    KKLogDebugFormat(@"deviceToken: %@",token);
    //保存token
    [KKUserDefaultsManager setObject:token forKey:@"KKUserDefaultsManagerKey_DeviceToken" identifier:nil];
}


/**
 ②-2注册推送通知失败 返回错误信息
 
 @param application application
 @param error error
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    KKAlertView *alert = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:[NSString stringWithFormat:@"Error in registration. Error: %@", error] delegate:nil buttonTitles:@"OK",nil];
    [alert show];
}

#pragma mark ==================================================
#pragma mark === 苹果APNS【数据处理】
#pragma mark ==================================================
/*💖 ③-1当程序在前台运行，接收到消息不会有消息提示（提示框或横幅）。会触发此方法(iOS 10+)*/
// The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)){
    
    //====================测试====================
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSString *message = [NSString stringWithFormat:@"💖userNotificationCenter_willPresentNotification_withCompletionHandler:%@",userInfo];
    [self debugAPNSMessage:message];
    
    // 通知不弹出
    //    completionHandler(UNNotificationPresentationOptionNone);
    // 通知弹出
    completionHandler(UNNotificationPresentationOptionBadge);
}

/*💖 ③-2触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)*/
// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler __API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0)) __API_UNAVAILABLE(tvos){
    
    //====================测试====================
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSString *message = [NSString stringWithFormat:@"💖userNotificationCenter_didReceiveNotificationResponse_withCompletionHandler:%@",userInfo];
    [self debugAPNSMessage:message];
    
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        KKLogDebug(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        //        [self Aliyun_handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        KKLogDebug(@"User dismissed the notification.");
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1]) {
        KKLogDebug(@"User custom action1.");
    }
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2]) {
        KKLogDebug(@"User custom action2.");
    }
    
    completionHandler();
}

// The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings. Add UNAuthorizationOptionProvidesAppNotificationSettings as an option in requestAuthorizationWithOptions:completionHandler: to add a button to inline notification settings view and the notification settings view in Settings. The notification will be nil when opened from Settings.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification __API_AVAILABLE(macos(10.14), ios(12.0)) __API_UNAVAILABLE(watchos, tvos){
    
}

/* 💖 ③-3程序未启动，用户收到离线推送消息，点击消息启动App，会走didFinishLaunchingWithOptions的方法得到消息内容。*/
- (void)checkRemoteNotification_FromApplicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //4、若由远程通知启动，则UIApplicationLaunchOptionsRemoteNotificationKey对应的是启动应用程序的的远程通知信息userInfo（NSDictionary）；
    NSDictionary *remoteNotificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if([NSDictionary isDictionaryNotEmpty:remoteNotificationInfo])
        {
        //====================测试====================
        NSString *message = [NSString stringWithFormat:@"💖receiveRemoteNotification_FromApplicationDidFinishLaunchingWithOptions:%@",remoteNotificationInfo];
        [self debugAPNSMessage:message];
        
        //处理消息
        [self application:[UIApplication sharedApplication] receiveRemoteNotification_WithUserInfo:remoteNotificationInfo];
        }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSString *aMessage = [NSString stringWithFormat:@"💖application_didReceiveRemoteNotification_fetchCompletionHandler:%@",userInfo];
    KKLogDebugFormat(@"%@",aMessage);
    [self debugAPNSMessage:aMessage];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

/**
 【开发者处理】处理收到的远程推送消息通知
 
 @param application application
 @param userInfo userInfo
 */
- (void)application:(UIApplication*)application receiveRemoteNotification_WithUserInfo:(NSDictionary *)userInfo{
    
    NSDictionary *extra = [userInfo validDictionaryForKey:@"extra"];
    KKLogDebugFormat(@"%@",extra);
}

- (void)debugAPNSMessage:(NSString*)aMessage{
    KKLogDebugFormat(@"%@",aMessage);
    [self performSelector:@selector(showAPNSMessageAlert:) withObject:aMessage afterDelay:1.0];
}

- (void)showAPNSMessageAlert:(NSString*)aMessage{
    KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:aMessage delegate:nil buttonTitles:@"OK",nil];
    [alertView show];
}

@end
