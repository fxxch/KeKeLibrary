//
//  KKAuthorizedMicrophone.m
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedMicrophone.h"

@implementation KKAuthorizedMicrophone

+ (KKAuthorizedMicrophone *)defaultManager{
    static KKAuthorizedMicrophone *KKAuthorizedMicrophone_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAuthorizedMicrophone_default = [[self alloc] init];
    });
    return KKAuthorizedMicrophone_default;
}

#pragma mark ==================================================
#pragma mark == 麦克风
#pragma mark ==================================================
/*
 检查是否授权【麦克风】
 #import <AVFoundation/AVFoundation.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isMicrophoneAuthorized_ShowAlert:(BOOL)showAlert
                              andAPPName:(nullable NSString *)appName{
    
    AVAudioSession *avSession = [AVAudioSession sharedInstance];

    __block BOOL accessGranted = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [avSession requestRecordPermission:^(BOOL available) {
        accessGranted = available;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    if (accessGranted==NO && showAlert) {
        [KKAuthorizedMicrophone.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Microphone
                                                                 appName:appName];
    }
    
    return accessGranted;
}


@end
