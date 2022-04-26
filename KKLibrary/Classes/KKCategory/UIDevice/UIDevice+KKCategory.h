//
//  UIDevice+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (KKCategory)

/**
 判断屏幕旋转是否关闭
 */
- (BOOL)kk_isProtraitLocked;

/**
 振动设备
 */
- (void)kk_vibrateDevice;

/**
 判断是否是iPhoneX
 
 @return 结果
 */
- (BOOL)kk_isiPhoneX;

/**
 设备种类
 
 @return 结果
 */
- (UIUserInterfaceIdiom)kk_deviceType;

/**
 磁盘总空间大小
 
 @return 磁盘总空间大小
 */
- (CGFloat)kk_diskOfAllSizeMBytes;

/**
 磁盘可用空间大小
 
 @return 磁盘可用空间大小
 */
- (CGFloat)kk_diskOfFreeSizeMBytes;

/// 判断系统版本是否 >= 某个版本
/// @param aVersion 版本号，例如：12.4.2
+ (BOOL)kk_isSystemVersionBigerThan:(NSString*_Nullable)aVersion;

/// 判断系统版本是否 < 某个版本
/// @param aVersion 版本号，例如：12.4.2
+ (BOOL)kk_isSystemVersionSmallerThan:(NSString*_Nullable)aVersion;

@end
