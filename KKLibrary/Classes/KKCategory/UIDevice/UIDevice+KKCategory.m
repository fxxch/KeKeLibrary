//
//  UIDevice+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIDevice+KKCategory.h"
#include <sys/sysctl.h>
#include <sys/utsname.h>
//#import <ifaddrs.h>
//#import <arpa/inet.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AudioToolbox/AudioToolbox.h>
#import "KKLog.h"
#import "UIWindow+KKCategory.h"

@implementation UIDevice (KKCategory)

/**
 判断屏幕旋转是否关闭
 */
- (BOOL)kk_isProtraitLocked {
    UIApplication *app = [UIApplication sharedApplication];
    UIView *foregroundView = [[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"];
    BOOL isOn = NO;
    for (UIView *childView in foregroundView.subviews) {
        @try {
            if ([@"UIStatusBarIndicatorItemView" isEqualToString:NSStringFromClass([childView class])]) {
                NSString *description = childView.description;
                if ([description rangeOfString:@"RotationLock"].length>0) {
                    isOn = YES;
                    break;
                }
//                id item = [childView valueForKey:@"item"];
//                int type = [[item valueForKey:@"type"] intValue];
//                /*
//                 UIStatusBarItem.type
//                 0, 时间
//                 3, 信号强度
//                 4, 运营商
//                 6, 网络
//                 8, 电池
//                 9, 电量百分比
//                 12, 蓝牙
//                 14, 闹钟
//                 18, 竖屏锁定
//                 34, 耳机
//                 */
//                if (type == 18) {
//                    isOn = YES;
//                }
            }
        }@catch (NSException *e) {}
    }
    return isOn;
}

/**
 振动设备
 */
- (void)kk_vibrateDevice {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

/**
 判断是否是iPhoneX（是否是刘海屏）
 
 @return 结果
 */
- (BOOL)kk_isiPhoneX{
    BOOL result = YES;
    if (@available(iOS 11.0, *)) {\
        result = [UIWindow kk_currentKeyWindow].safeAreaInsets.bottom > 0.0;
    }
    else{
        CGSize iPhone = [UIScreen mainScreen].nativeBounds.size;
        CGFloat iPhone_Scale = [UIScreen mainScreen].scale;
        CGSize iPhone_size = CGSizeMake(iPhone.width/iPhone_Scale, iPhone.height/iPhone_Scale);
        //iPhone4 4S 3G 3GS
        if (CGSizeEqualToSize(iPhone_size, CGSizeMake(320, 480))) {
            return NO;
        }
        //iPhone5 5S 5C SE1
        else if (CGSizeEqualToSize(iPhone_size, CGSizeMake(320, 568))) {
            return NO;
        }
        //iPhone678 SE2 SE3
        else if (CGSizeEqualToSize(iPhone_size, CGSizeMake(375, 667)) ) {
            return NO;
        }
        //iPhone678P
        else if (CGSizeEqualToSize(iPhone_size, CGSizeMake(414, 736)) ) {
            return NO;
        }
        else {
            return YES;
        }
    }
    return result;
}

/**
 设备种类
 
 @return 结果
 */
- (UIUserInterfaceIdiom)kk_deviceType{    
    return [[UIDevice currentDevice] userInterfaceIdiom];
}

/**
 磁盘总空间大小
 
 @return 磁盘总空间大小
 */
- (CGFloat)kk_diskOfAllSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
        KKLogWarningFormat(@"error: %@", KKValidString(error.localizedDescription));
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}

/**
 磁盘可用空间大小
 
 @return 磁盘可用空间大小
 */
- (CGFloat)kk_diskOfFreeSizeMBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
        KKLogWarningFormat(@"error: %@", KKValidString(error.localizedDescription));
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemFreeSize];
        size = [number floatValue]/1024/1024;
    }
    return size;
}

/// 判断系统版本是否 >= 某个版本
/// @param aVersion 版本号，例如：12.4.2
+ (BOOL)kk_isSystemVersionBigerThan:(NSString*_Nullable)aVersion{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion isEqualToString:aVersion]) {
        return true;
    } else {
        // 所以最好的方法就是用整个字符串直接比较
        if ([systemVersion compare:aVersion options:NSNumericSearch] == NSOrderedDescending) {
            return true;
        }
        else{
            return false;
        }
    }
}

/// 判断系统版本是否 < 某个版本
/// @param aVersion 版本号，例如：12.4.2
+ (BOOL)kk_isSystemVersionSmallerThan:(NSString*_Nullable)aVersion{
    return ![UIDevice kk_isSystemVersionBigerThan:aVersion];
}

@end
