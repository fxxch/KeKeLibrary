//
//  KKNetWorkObserver.m
//  ProjectK
//
//  Created by liubo on 14-1-7.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "KKNetWorkObserver.h"
#import "KKAlertView.h"

NSString *const KKNotificationName_NetWorkStatusWillChange = @"KKNotificationName_NetWorkStatusWillChange";
NSString *const KKNotificationName_NetWorkStatusDidChanged = @"KKNotificationName_NetWorkStatusDidChanged";


@interface KKNetWorkObserver()<UIAlertViewDelegate>

@property(nonatomic,strong)Reachability    *reachability;
//@property(nonatomic,assign)BOOL    isShowingAlertView;

@end


@implementation KKNetWorkObserver
@synthesize status;
//@synthesize isShowingAlertView;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (KKNetWorkObserver *)sharedInstance {
    static KKNetWorkObserver *KKNETWORK_OBSERVER = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKNETWORK_OBSERVER = [[self alloc] init];
    });
    return KKNETWORK_OBSERVER;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *host = @"www.baidu.com";
        self.reachability = [Reachability reachabilityWithHostName:host];
        [self.reachability startNotifier];
        status = ReachableViaWiFi;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanaged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    return self ;
}

#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (BOOL)isReachable{
    if ([self.reachability currentReachabilityStatus]==NotReachable) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)reachabilityChanaged:(NSNotification *)noti {
    Reachability *reachability = [noti object];
    if ([reachability isKindOfClass:[Reachability class]]) {
        [self updateInterfaceWithReachability:reachability];
    }
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    NetworkStatus newStatus = [reachability currentReachabilityStatus];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:status] forKey:@"oldNetworkStatus"];
    [dic setObject:[NSNumber numberWithInt:newStatus] forKey:@"newNetworkStatus"];
    [[NSNotificationCenter defaultCenter] postNotificationName:KKNotificationName_NetWorkStatusWillChange
                                                        object:nil
                                                      userInfo:dic];
    status = newStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:KKNotificationName_NetWorkStatusDidChanged object:[NSNumber numberWithInteger:status]];

    if (newStatus==NotReachable) {
//        KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:@"温馨提示" subTitle:nil message:@"亲，网络连接好像出了点状况，请检查您的网络连接。" delegate:self buttonTitles:@"确定",nil];
//        [alertView show];
//        
//        UIButton *button = [alertView buttonAtIndex:0];
//        [button setTitleColor:KKTheme_GreenColor forState:UIControlStateNormal];
    }

//    if (newStatus==NotReachable && isShowingAlertView == NO) {
//        KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:@"温馨提示" subTitle:nil message:@"亲，网络连接好像出了点状况，请检查您的网络连接。" delegate:self buttonTitles:@"确定",nil];
//        [alertView show];
//        [alertView release];
//        
//        UIButton *button = [alertView buttonAtIndex:0];
//        [button setTitleColor:KKTheme_GreenColor forState:UIControlStateNormal];
//        
//        isShowingAlertView = YES;
//    }
    
}

- (void)KKAlertView:(KKAlertView*)aAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    isShowingAlertView = NO;
}



@end
