//
//  KKAuthorizedCamera.h
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedBase.h"
#import <AVFoundation/AVFoundation.h>

@interface KKAuthorizedCamera : KKAuthorizedBase

+ (KKAuthorizedCamera*_Nonnull)defaultManager;

#pragma mark ==================================================
#pragma mark == 相机
#pragma mark ==================================================
/*
 检查是否授权【相机】
 #import <AVFoundation/AVFoundation.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isCameraAuthorized_ShowAlert:(BOOL)showAlert
                          andAPPName:(nullable NSString *)appName;

@end
