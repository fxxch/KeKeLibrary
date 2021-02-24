//
//  KKAuthorizedMicrophone.h
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedBase.h"
#import <AVFoundation/AVFoundation.h>

@interface KKAuthorizedMicrophone : KKAuthorizedBase

+ (KKAuthorizedMicrophone*_Nonnull)defaultManager;

#pragma mark ==================================================
#pragma mark == 麦克风
#pragma mark ==================================================
/*
 检查是否授权【麦克风】
 #import <AVFoundation/AVFoundation.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isMicrophoneAuthorized_ShowAlert:(BOOL)showAlert
                              andAPPName:(nullable NSString *)appName;

@end
