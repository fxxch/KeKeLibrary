//
//  KKNetWorkObserver.h
//  ProjectK
//
//  Created by liubo on 14-1-7.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

extern NSString *const KKNotificationName_NetWorkStatusWillChange;
extern NSString *const KKNotificationName_NetWorkStatusDidChanged;



@interface KKNetWorkObserver : NSObject

@property(nonatomic,assign)NetworkStatus    status;

+ (KKNetWorkObserver *)sharedInstance;

- (BOOL)isReachable;

@end
