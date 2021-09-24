//
//  NetworkHelper.h
//  KKLibraryDemo_Pod
//
//  Created by liubo on 2021/7/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkHelper : NSObject

+ (NetworkHelper*)defaultManager;


- (NSString*)getInternetfaceFormated;

//检查当前是否连网
+ (BOOL)whetherConnectedNetwork;

//获取网络状态
+ (NSString *)getNetworkType;

//获取网络信号强度（dBm）
+ (NSString *)getSignalStrength;

+ (NSString *)getSignalStrengthBar;

@end

NS_ASSUME_NONNULL_END
