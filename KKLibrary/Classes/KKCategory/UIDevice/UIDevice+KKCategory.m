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

@implementation UIDevice (KKCategory)

/**
 判断屏幕旋转是否关闭
 */
- (BOOL)isProtraitLocked {
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
- (void)vibrateDevice {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

/**
 判断是否是iPhoneX（是否是刘海屏）
 
 @return 结果
 */
- (BOOL)isiPhoneX{
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
        
//        // iPhone4、iPhone4S
//        CGSize iPhone4_Size = CGSizeMake(640,960);
//        // iPhone5、iPhone5C、iPhone5S、iPhoneSE
//        CGSize iPhone5_Size = CGSizeMake(640,1136);
//        // iPhone6、iPhone6S、iPhone7、iPhone8、iPhoneSE2
//        CGSize iPhone678_Size = CGSizeMake(750,1334);
//        // iPhone6P、iPhone6SP、iPhone7P、iPhone8P
//        CGSize iPhone678P_Size = CGSizeMake(1242,2208);
        
        // iPhoneX、iPhoneXS、iPhone11Pro、iPhone12Mini
        CGSize iPhoneX_Size = CGSizeMake(1125, 2436);
        // iPhoneXR、iPhone11、
        CGSize iPhoneXR_Size = CGSizeMake(828,1792);
        // iPhoneXSMax、iPhone11ProMax
        CGSize iPhoneXSMAX_Size = CGSizeMake(1242, 2688);
        // iPhone12、iPhone12Pro
        CGSize iPhone12_Size = CGSizeMake(1170, 2532);
        // iPhone12ProMax
        CGSize iPhone12ProMax_Size = CGSizeMake(1284, 2778);
        
        if (CGSizeEqualToSize(iPhoneX_Size, screenSize) ||
            CGSizeEqualToSize(iPhoneXR_Size, screenSize) ||
            CGSizeEqualToSize(iPhoneXSMAX_Size, screenSize)  ||
            CGSizeEqualToSize(iPhone12_Size, screenSize)  ||
            CGSizeEqualToSize(iPhone12ProMax_Size, screenSize) ) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

/**
 设备信息
 
 @return 结果
 */
- (nullable NSString*)deviceType{
    //方法1
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceName rangeOfString:@"AppleTV"].length>0) {
        return @"AppleTV";
    }
    else if ([deviceName rangeOfString:@"Watch"].length>0){
        return @"Apple Watch";
    }
    else if ([deviceName rangeOfString:@"iPod"].length>0){
        return @"iPod touch";
    }
    else if ([deviceName rangeOfString:@"iPad"].length>0){
        return @"iPad";
    }
    else if ([deviceName rangeOfString:@"iPhone"].length>0){
        return @"iPhone";
    }
    else{
        return deviceName;
    }
}


/**
 设备版本
 
 @return 结果
 */
- (nullable NSString*)deviceVersion{
    //方法1
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPad
    if ([deviceName isEqualToString:@"iPad1,1"]) return @"iPad 1";
    if ([deviceName isEqualToString:@"iPad1,2"]) return @"iPad 1 (3G)";
    if ([deviceName isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([deviceName isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([deviceName isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([deviceName isEqualToString:@"iPad2,4"]) return @"iPad 2 (Mid 2012)";
    if ([deviceName isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    if ([deviceName isEqualToString:@"iPad2,6"]) return @"iPad Mini (GSM)";
    if ([deviceName isEqualToString:@"iPad2,7"]) return @"iPad Mini (Global)";
    if ([deviceName isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    if ([deviceName isEqualToString:@"iPad3,2"]) return @"iPad 3 (CDMA)";
    if ([deviceName isEqualToString:@"iPad3,3"]) return @"iPad 3 (GSM)";
    if ([deviceName isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([deviceName isEqualToString:@"iPad3,5"]) return @"iPad 4 (GSM)";
    if ([deviceName isEqualToString:@"iPad3,6"]) return @"iPad 4 (Global)";
    if ([deviceName isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    if ([deviceName isEqualToString:@"iPad4,2"]) return @"iPad Air (Cellular)";
    if ([deviceName isEqualToString:@"iPad4,3"]) return @"iPad Air (China)";
    if ([deviceName isEqualToString:@"iPad4,4"]) return @"iPad Mini 2 (WiFi)";
    if ([deviceName isEqualToString:@"iPad4,5"]) return @"iPad Mini 2 (Cellular)";
    if ([deviceName isEqualToString:@"iPad4,6"]) return @"iPad Mini 2 (China)";
    if ([deviceName isEqualToString:@"iPad4,7"]) return @"iPad Mini 3 (WiFi)";
    if ([deviceName isEqualToString:@"iPad4,8"]) return @"iPad Mini 3 (Cellular)";
    if ([deviceName isEqualToString:@"iPad4,9"]) return @"iPad Mini 3 (China)";
    if ([deviceName isEqualToString:@"iPad5,1"]) return @"iPad Mini 4 (WiFi)";
    if ([deviceName isEqualToString:@"iPad5,2"]) return @"iPad Mini 4 (Cellular)";
    if ([deviceName isEqualToString:@"iPad5,3"]) return @"iPad Air 2 (WiFi)";
    if ([deviceName isEqualToString:@"iPad5,4"]) return @"iPad Air 2 (Cellular)";
    if ([deviceName isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7-inch (WiFi)";
    if ([deviceName isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch (Cellular)";
    if ([deviceName isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9-inch (WiFi)";
    if ([deviceName isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch (Cellular)";
    if ([deviceName isEqualToString:@"iPad6,11"])return @"iPad 5 (WiFi)";
    if ([deviceName isEqualToString:@"iPad6,12"])return @"iPad 5 (Cellular)";
    if ([deviceName isEqualToString:@"iPad7,1"]) return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceName isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceName isEqualToString:@"iPad7,3"]) return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceName isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5 inch (Cellular)";
    
    
    //iPhone
    if ([deviceName isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([deviceName isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceName isEqualToString:@"iPhone2,1"]) return @"iPhone 3G[S]";
    if ([deviceName isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (GSM)";
    if ([deviceName isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (GSM / 2012)";
    if ([deviceName isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (CDMA)";
    if ([deviceName isEqualToString:@"iPhone4,1"]) return @"iPhone 4[S]";
    if ([deviceName isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM)";
    if ([deviceName isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (Global)(GSM+CDMA)";
    if ([deviceName isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (GSM)";
    if ([deviceName isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (Global)(GSM+CDMA)";
    if ([deviceName isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (GSM)";
    if ([deviceName isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (Global)(GSM+CDMA)";
    if ([deviceName isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceName isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([deviceName isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([deviceName isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([deviceName isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    //国行、日版、港行iPhone 7
    if ([deviceName isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (GSM/Global)(国行、日版、港行)";
    //港行、国行iPhone 7 Plus
    if ([deviceName isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus(GSM/Global)(港行、国行)";
    //美版、台版iPhone 7
    if ([deviceName isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (GSM/Global)(美版、台版)";
    //美版、台版iPhone 7 Plus
    if ([deviceName isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus(GSM/Global)(美版、台版)";
    //国行(A1863)、日行(A1906)iPhone 8
    if ([deviceName isEqualToString:@"iPhone10,1"]) return @"iPhone 8(国行(A1863)、日行(A1906))";
    //国行(A1864)、日行(A1898)iPhone 8 Plus
    if ([deviceName isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus(国行(A1864)、日行(A1898))";
    //国行(A1865)、日行(A1902)iPhone X
    if ([deviceName isEqualToString:@"iPhone10,3"]) return @"iPhone X (GSM/Global)(国行(A1865)、日行(A1902)iPhone X)";
    //美版(Global/A1905)iPhone 8
    if ([deviceName isEqualToString:@"iPhone10,4"]) return @"iPhone 8 (GSM/Global)(美版(Global/A1905))";
    //美版(Global/A1897)iPhone 8 Plus
    if ([deviceName isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus(GSM/Global)(美版(Global/A1897))";
    //美版(Global/A1901)iPhone X
    if ([deviceName isEqualToString:@"iPhone10,6"]) return @"iPhone X (美版(Global/A1901))";
    //iPhone XS
    if ([deviceName isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    //iPhone XSMAX
    if ([deviceName isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([deviceName isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    //iPhone XR
    if ([deviceName isEqualToString:@"iPhone11,8"]) return @"iPhone XR";

    
    //iPod
    if ([deviceName isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([deviceName isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([deviceName isEqualToString:@"iPod3,1"])   return @"iPod Touch 3";
    if ([deviceName isEqualToString:@"iPod4,1"])   return @"iPod Touch 4";
    if ([deviceName isEqualToString:@"iPod5,1"])   return @"iPod Touch 5";
    if ([deviceName isEqualToString:@"iPod7,1"])   return @"iPod Touch 6";
    
    //Watch
    if ([deviceName isEqualToString:@"Watch1,1"])  return @"Apple Watch (38mm)";
    if ([deviceName isEqualToString:@"Watch1,2"])  return @"Apple Watch (42mm)";
    if ([deviceName isEqualToString:@"Watch2,3"])  return @"Apple Watch Series 2 (38mm)";
    if ([deviceName isEqualToString:@"Watch2,4"])  return @"Apple Watch Series 2 (42mm)";
    if ([deviceName isEqualToString:@"Watch2,6"])  return @"Apple Watch Series 1 (38mm)";
    if ([deviceName isEqualToString:@"Watch2,7"])  return @"Apple Watch Series 1 (42mm)";
    
    //AppleTV
    if ([deviceName isEqualToString:@"AppleTV2,1"]) return @"Apple TV 2G";
    if ([deviceName isEqualToString:@"AppleTV3,1"]) return @"Apple TV 3";
    if ([deviceName isEqualToString:@"AppleTV3,2"]) return @"Apple TV 3 (2013)";
    if ([deviceName isEqualToString:@"AppleTV5,3"]) return @"Apple TV 4 (2015)";
    
    //模拟器
    if ([deviceName isEqualToString:@"i386"])       return @"Simulator";
    if ([deviceName isEqualToString:@"x86_64"])     return @"Simulator";
    
    return deviceName;
    
    //    //方法2
    //    size_t size;
    //    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    //    char *machine = (char*)malloc(size);
    //    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    //    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    //    free(machine);
    //    return platform;
}

/**
 磁盘总空间大小
 
 @return 磁盘总空间大小
 */
- (CGFloat)diskOfAllSizeMBytes{
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
- (CGFloat)diskOfFreeSizeMBytes{
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
+ (BOOL)isSystemVersionBigerThan:(NSString*_Nullable)aVersion{
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
+ (BOOL)isSystemVersionSmallerThan:(NSString*_Nullable)aVersion{
    return ![UIDevice isSystemVersionBigerThan:aVersion];
}

@end
