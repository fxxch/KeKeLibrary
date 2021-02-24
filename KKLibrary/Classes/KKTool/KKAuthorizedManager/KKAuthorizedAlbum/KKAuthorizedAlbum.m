//
//  KKAuthorizedAlbum.m
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedAlbum.h"

@implementation KKAuthorizedAlbum

+ (KKAuthorizedAlbum *)defaultManager{
    static KKAuthorizedAlbum *KKAuthorizedAlbum_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAuthorizedAlbum_default = [[self alloc] init];
    });
    return KKAuthorizedAlbum_default;
}


#pragma mark ==================================================
#pragma mark == 相册
#pragma mark ==================================================
/*
 检查是否授权【相册】
 #import <Photos/PHPhotoLibrary.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isAlbumAuthorized_ShowAlert:(BOOL)showAlert
                         andAPPName:(nullable NSString *)appName{
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    
    //用户尚未做出授权选择
    if (author == PHAuthorizationStatusNotDetermined) {
        
        __block BOOL accessGranted = NO;
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            if (status==PHAuthorizationStatusAuthorized) {
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
    else if (author == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    //其他原因未被授权——可能是家长控制权限
    else {
        if (showAlert) {
            [KKAuthorizedAlbum.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Album
                                                                     appName:appName];
        }
        return NO;
    }
}


@end
