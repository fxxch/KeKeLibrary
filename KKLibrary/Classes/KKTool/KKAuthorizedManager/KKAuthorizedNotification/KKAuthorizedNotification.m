//
//  KKAuthorizedNotification.m
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedNotification.h"

@implementation KKAuthorizedNotification

+ (KKAuthorizedNotification *)defaultManager{
    static KKAuthorizedNotification *KKAuthorizedNotification_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAuthorizedNotification_default = [[self alloc] init];
    });
    return KKAuthorizedNotification_default;
}

#pragma mark ==================================================
#pragma mark == 通知中心
#pragma mark ==================================================
/*
 检查是否授权【通知中心】
 #import <UserNotifications/UserNotifications.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isNotificationAuthorized_ShowAlert:(BOOL)showAlert
                                andAPPName:(nullable NSString *)appName{

    __block BOOL accessGranted = NO;
    //等待同意后向下执行
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    // 初始化并创建通讯录对象，记得释放内存
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {

        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            accessGranted = YES;
        }
        else{
            accessGranted = NO;
        }
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (accessGranted) {
        return YES;
    }
    else{
        if (showAlert) {
            [KKAuthorizedNotification.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Notification
                                                                     appName:appName];
        }
        return NO;
    }
}


@end
