//
//  KKGetIPAddress.m
//  TCWeiBoSDKDemo
//
//  Created by wang ying on 12-8-19.
//  Copyright (c) 2012年 bysft. All rights reserved.
//

#include "KKGetIPAddress.h"

@implementation KKGetIPAddress

+ (NSString *)deviceIPAdress{
    KK_InitAddresses();
    KK_GetIPAddresses();
    KK_GetHWAddresses();
    return [NSString stringWithFormat:@"%s", KK_ip_names[1]];
}

+ (NSArray *)allIPAdress{
    KK_InitAddresses();
    KK_GetIPAddresses();
    KK_GetHWAddresses();
    
    NSMutableArray *returnArray = [NSMutableArray array];
    for (int i=0; i<MAXADDRS; ++i)  {
        if (KK_ip_names[i]) {
            [returnArray addObject:[NSString stringWithFormat:@"%s", KK_ip_names[i]]];
        }
        else{
            break;
        }
    }
    return returnArray;
}

@end







