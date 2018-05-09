//
//  GetIPAddress.m
//  TCWeiBoSDKDemo
//
//  Created by wang ying on 12-8-19.
//  Copyright (c) 2012年 bysft. All rights reserved.
//

#include "GetIPAddress.h"

@implementation GetIPAddress

+ (NSString *)deviceIPAdress{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

+ (NSArray *)allIPAdress{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    NSMutableArray *returnArray = [NSMutableArray array];
    for (int i=0; i<MAXADDRS; ++i)  {
        if (ip_names[i]) {
            [returnArray addObject:[NSString stringWithFormat:@"%s", ip_names[i]]];
        }
        else{
            break;
        }
    }
    return returnArray;
}

@end







