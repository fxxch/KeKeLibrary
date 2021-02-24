//
//  KKAuthorizedMusic.m
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedMusic.h"

@implementation KKAuthorizedMusic

+ (KKAuthorizedMusic *)defaultManager{
    static KKAuthorizedMusic *KKAuthorizedMusic_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAuthorizedMusic_default = [[self alloc] init];
    });
    return KKAuthorizedMusic_default;
}

#pragma mark ==================================================
#pragma mark == 媒体库音乐
#pragma mark ==================================================
/*
 检查是否授权【媒体库音乐】
 #import <MediaPlayer/MediaPlayer.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isMusicAuthorized_ShowAlert:(BOOL)showAlert
                         andAPPName:(nullable NSString *)appName{

    // 请求媒体资料库权限
    MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];

    //未授权
    if (authStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {

        __block BOOL accessGranted = NO;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
           
            if (status==MPMediaLibraryAuthorizationStatusAuthorized) {
                accessGranted = YES;
            }
            else{
                accessGranted = NO;
            }
            
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        return accessGranted;
    }
    //已授权
    else if(authStatus == MPMediaLibraryAuthorizationStatusAuthorized){
        return YES;
    }
    else{
        if (showAlert) {
            [KKAuthorizedMusic.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Music
                                                                     appName:appName];
        }
        return NO;
    }
}

@end
