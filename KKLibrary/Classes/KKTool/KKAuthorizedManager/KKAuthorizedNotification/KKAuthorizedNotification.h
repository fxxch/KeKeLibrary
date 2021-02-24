//
//  KKAuthorizedNotification.h
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedBase.h"
#import <UserNotifications/UserNotifications.h>

@interface KKAuthorizedNotification : KKAuthorizedBase

+ (KKAuthorizedNotification*_Nonnull)defaultManager;

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
                                andAPPName:(nullable NSString *)appName;


@end
