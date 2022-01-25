//
//  KKNetWorkHelper.m
//  KKLibrary
//
//  Created by liubo on 2021/9/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKNetWorkHelper.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@interface KKNetWorkHelper ()

@property (nonatomic, assign)long long int lastBytes;
@property (nonatomic, assign)BOOL isFirstRate;

@end

@implementation KKNetWorkHelper

+ (KKNetWorkHelper *)defaultManager{
    static KKNetWorkHelper *NetworkHelper_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NetworkHelper_default = [[self alloc] init];
    });
    return NetworkHelper_default;
}

//检查当前是否连网
+ (BOOL)whetherConnectedNetwork{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;//IP地址
    bzero(&zeroAddress, sizeof(zeroAddress));//将地址转换为0.0.0.0
    zeroAddress.ss_len = sizeof(zeroAddress);//地址长度
    zeroAddress.ss_family = AF_INET;//地址类型为UDP, TCP, etc.
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
        {
        return NO;
        }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}

//获取网络状态
+ (KKNetWorkType)currentNetworkType {
    if (![KKNetWorkHelper whetherConnectedNetwork]) return KKNetWorkType_None;
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    KKNetWorkType type = KKNetWorkType_None;
    for (id subview in subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    type = KKNetWorkType_None;
                    break;
                case 1:
                    type = KKNetWorkType_2G;
                    break;
                case 2:
                    type = KKNetWorkType_3G;
                    break;
                case 3:
                    type = KKNetWorkType_4G;
                    break;
                case 5:
                    type = KKNetWorkType_wifi;
                    break;
            }
        }
    }
    return type;
}

//获取网络信号强度（dBm）
+ (NSString *)getSignalStrength {
    if (![KKNetWorkHelper whetherConnectedNetwork]) return @"";
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    NSString *signalStrength = @"";
    for (id subview in subviews) {
        if(([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) &&
           ([KKNetWorkHelper currentNetworkType] == KKNetWorkType_wifi)  &&
           ([KKNetWorkHelper currentNetworkType] != KKNetWorkType_None) ) {
            dataNetworkItemView = subview;
            signalStrength = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_wifiStrengthRaw"]];
            break;
        }
        if(([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) &&
           ([KKNetWorkHelper currentNetworkType] != KKNetWorkType_wifi)  &&
           ([KKNetWorkHelper currentNetworkType] != KKNetWorkType_None) ) {
            dataNetworkItemView = subview;
            signalStrength = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_signalStrengthRaw"]];
            break;
        }
    }
    return signalStrength;
}

+ (NSString *)getSignalStrengthBar {
    if (![KKNetWorkHelper whetherConnectedNetwork]) return @"";
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;
    NSString *signalStrengthBars = @"";
    for (id subview in subviews) {
        if(([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) &&
           ([KKNetWorkHelper currentNetworkType] == KKNetWorkType_wifi)  &&
           ([KKNetWorkHelper currentNetworkType] != KKNetWorkType_None) ) {
            dataNetworkItemView = subview;
            signalStrengthBars = [NSString stringWithFormat:@"0%@",[dataNetworkItemView valueForKey:@"_wifiStrengthBars"]];
            break;
        }
        if(([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) &&
           ([KKNetWorkHelper currentNetworkType] != KKNetWorkType_wifi)  &&
           ([KKNetWorkHelper currentNetworkType] != KKNetWorkType_None) ) {
            dataNetworkItemView = subview;
            signalStrengthBars = [NSString stringWithFormat:@"1%@",[dataNetworkItemView valueForKey:@"_signalStrengthBars"]];
            break;
        }
    }
    return signalStrengthBars;
}

#pragma mark ==================================================
#pragma mark == 实时网速监控
#pragma mark ==================================================
- (long long int)getInternetfaceBytes{
    
    long long int rate = 0;
    
    long long int currentBytes = [self getInterfaceBytes];
    
    if(self.lastBytes) {
        //用上当前的下行总流量减去上一秒的下行流量达到下行速录
        rate = currentBytes -self.lastBytes;
    }
    else{
        self.isFirstRate=NO;
    }
    //保存上一秒的下行总流量
    self.lastBytes= [self getInterfaceBytes];
    
    return rate;
}

- (long long) getInterfaceBytes{
    
    struct ifaddrs *ifa_list = 0, *ifa;
    
    if (getifaddrs(&ifa_list) == -1){
        return 0;
    }
    
    uint32_t iBytes = 0;//下行
    
    uint32_t oBytes = 0;//上行
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
    if (AF_LINK != ifa->ifa_addr->sa_family)
        continue;
    
    if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
        continue;
    
    if (ifa->ifa_data == 0)
        continue;
    
    /* Not a loopback device. */
    if (strncmp(ifa->ifa_name, "lo", 2)){
        struct if_data *if_data = (struct if_data *)ifa->ifa_data;
        iBytes += if_data->ifi_ibytes;
        oBytes += if_data->ifi_obytes;
    }
    }
    
    freeifaddrs(ifa_list);
    
    NSLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes,oBytes);
    
    return iBytes;
}

- (NSString*)getInternetfaceBytes_Formated{
    
    long long int rate = [self getInternetfaceBytes];
    
    //格式化一下
    NSString*rateStr = [self formatNetWork:rate];
    NSLog(@"当前网速%@",rateStr);
    return rateStr;
}

- (NSString*)formatNetWork:(long long int)rate {
    
    if(rate <1024) {
        
        return[NSString stringWithFormat:@"%lldB/s", rate];
        
    }else if(rate >=1024&& rate <1024*1024) {
        
        return[NSString stringWithFormat:@"%.1fKB/s", (double)rate /1024];
        
    }else if(rate >=1024*1024 && rate <1024*1024*1024){
        
        return[NSString stringWithFormat:@"%.2fMB/s", (double)rate / (1024*1024)];
        
    }else{
        return@"10Kb/s";
    };
}

@end
