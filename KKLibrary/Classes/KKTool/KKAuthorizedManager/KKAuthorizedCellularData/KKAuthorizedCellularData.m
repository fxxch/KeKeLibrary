//
//  KKAuthorizedCellularData.m
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedCellularData.h"

@implementation KKAuthorizedCellularData

+ (KKAuthorizedCellularData *)defaultManager{
    static KKAuthorizedCellularData *KKAuthorizedCellularData_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAuthorizedCellularData_default = [[self alloc] init];
    });
    return KKAuthorizedCellularData_default;
}

#pragma mark ==================================================
#pragma mark == 蜂窝移动网络
#pragma mark ==================================================
/*
检查是否授权【媒体库音乐】
#import <CoreTelephony/CTCellularData.h>
@param showAlert 如果没有授权，是否显示提示框
@param appName 应用名称，不传的话，从CFBundleDisplayName读取
*/
- (BOOL)isCellularDataAuthorized_ShowAlert:(BOOL)showAlert
                                andAPPName:(nullable NSString *)appName{
    
    __block BOOL accessGranted = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted:
                //DLog(@"Restricrted / 受限制的");
                accessGranted = NO;
                dispatch_semaphore_signal(sema);
                break;
            case kCTCellularDataNotRestricted:
                //DLog(@"Not Restricted /不受限制的");
                accessGranted = YES;
                dispatch_semaphore_signal(sema);
                break;
            case kCTCellularDataRestrictedStateUnknown:
                //DLog(@"Unknown/不明网路");
                accessGranted = NO;
                dispatch_semaphore_signal(sema);
                break;
            default:
                accessGranted = NO;
                dispatch_semaphore_signal(sema);
                break;
        };
    };
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    if (accessGranted==NO && showAlert) {
        [KKAuthorizedCellularData.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_CellularData
                                                                 appName:appName];
    }
    return accessGranted;
}


@end
