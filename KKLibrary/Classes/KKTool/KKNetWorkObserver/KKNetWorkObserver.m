//
//  KKNetWorkObserver.m
//  ProjectK
//
//  Created by liubo on 14-1-7.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "KKNetWorkObserver.h"
//#import "KKAlertView.h"

NSNotificationName const KKNotificationName_NetWorkStatusWillChange = @"KKNotificationName_NetWorkStatusWillChange";
NSNotificationName const KKNotificationName_NetWorkStatusDidChanged = @"KKNotificationName_NetWorkStatusDidChanged";

NSAttributedStringKey const KKNetWorkObserverNotificationKeyOldValue = @"oldValue";
NSAttributedStringKey const KKNetWorkObserverNotificationKeyNewValue = @"newValue";

@interface KKNetWorkObserver()<UIAlertViewDelegate>

@property(nonatomic,strong)KKReachability    *kkreachability;
//@property(nonatomic,assign)BOOL    isShowingAlertView;

@end


@implementation KKNetWorkObserver
@synthesize status;
//@synthesize isShowingAlertView;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (KKNetWorkObserver *_Nonnull)sharedInstance {
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
        self.kkreachability = [KKReachability kkreachabilityWithHostName:host];
        [self.kkreachability startNotifier];
        status = KKReachableViaWiFi;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(kkreachabilityChanaged:)
                                                     name:kKKReachabilityChangedNotification
                                                   object:nil];
    }
    return self ;
}

#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (BOOL)isReachable{
    if ([self.kkreachability currentKKReachabilityStatus]==KKNotReachable) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)kkreachabilityChanaged:(NSNotification *)noti {
    KKReachability *kkreachability = [noti object];
    if ([kkreachability isKindOfClass:[KKReachability class]]) {
        [self updateInterfaceWithKKReachability:kkreachability];
    }
}

- (void)updateInterfaceWithKKReachability:(KKReachability *)kkreachability {
    KKNetworkStatus newStatus = [kkreachability currentKKReachabilityStatus];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)status] forKey:KKNetWorkObserverNotificationKeyOldValue];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)newStatus] forKey:KKNetWorkObserverNotificationKeyNewValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:KKNotificationName_NetWorkStatusWillChange
                                                        object:nil
                                                      userInfo:dic];
    status = newStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:KKNotificationName_NetWorkStatusDidChanged object:[NSNumber numberWithInteger:status]];

    if (newStatus==KKNotReachable) {
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

//- (void)KKAlertView:(KKAlertView*)aAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    isShowingAlertView = NO;
//}



@end
