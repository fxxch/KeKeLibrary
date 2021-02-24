//
//  KKAuthorizedCamera.m
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedCamera.h"

@implementation KKAuthorizedCamera

+ (KKAuthorizedCamera *)defaultManager{
    static KKAuthorizedCamera *KKAuthorizedCamera_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAuthorizedCamera_default = [[self alloc] init];
    });
    return KKAuthorizedCamera_default;
}

#pragma mark ==================================================
#pragma mark == 相机
#pragma mark ==================================================
/*
 检查是否授权【相机】
 #import <AVFoundation/AVFoundation.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isCameraAuthorized_ShowAlert:(BOOL)showAlert
                          andAPPName:(nullable NSString *)appName{
        
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    //用户尚未做出授权选择
    if (author == AVAuthorizationStatusNotDetermined) {
        __block BOOL accessGranted = NO;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

        return accessGranted;
    }
    //用户已经授权同意——同意访问
    else if (author == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    else {
        if (showAlert) {
            [KKAuthorizedCamera.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Camera
                                                                     appName:appName];
        }
        return NO;
    }
}


@end
