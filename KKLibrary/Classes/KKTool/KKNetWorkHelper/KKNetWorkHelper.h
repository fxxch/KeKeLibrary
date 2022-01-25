//
//  KKNetWorkHelper.h
//  KKLibrary
//
//  Created by liubo on 2021/9/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

/**
 *  KKNetWorkType
 */
typedef NS_ENUM(NSInteger,KKNetWorkType) {
    
    KKNetWorkType_None = 0,/* none */

    KKNetWorkType_wifi = 1,/* WIFI */

    KKNetWorkType_2G = 2,/* 2G */
    
    KKNetWorkType_3G = 3,/* 3G */

    KKNetWorkType_4G = 4,/* 4G */
    
    KKNetWorkType_5G = 5,/* 5G */
};

NS_ASSUME_NONNULL_BEGIN

@interface KKNetWorkHelper : NSObject

+ (KKNetWorkHelper*)defaultManager;

//检查当前是否连网
+ (BOOL)whetherConnectedNetwork;

//获取网络状态
+ (KKNetWorkType)currentNetworkType;

- (long long int)getInternetfaceBytes;
- (NSString*)getInternetfaceBytes_Formated;

//获取网络信号强度（dBm）
+ (NSString *)getSignalStrength;

+ (NSString *)getSignalStrengthBar;

@end

NS_ASSUME_NONNULL_END
