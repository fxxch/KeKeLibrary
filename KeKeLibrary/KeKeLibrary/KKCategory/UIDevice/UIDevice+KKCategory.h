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
 振动设备
 */
- (void)vibrateDevice;

/**
 判断是否是iPhoneX
 
 @return 结果
 */
- (BOOL)isiPhoneX;

/**
 设备信息
 
 @return 结果
 */
- (nullable NSString*)deviceType;

/**
 设备版本
 
 @return 结果
 */
- (nullable NSString*)deviceVersion;
/**
 磁盘总空间大小
 
 @return 磁盘总空间大小
 */
- (CGFloat)diskOfAllSizeMBytes;

/**
 磁盘可用空间大小
 
 @return 磁盘可用空间大小
 */
- (CGFloat)diskOfFreeSizeMBytes;

/**
 返回当前设备的IP地址
 
 @return IP地址
 */
- (NSString*_Nonnull)ipAddress;

@end
