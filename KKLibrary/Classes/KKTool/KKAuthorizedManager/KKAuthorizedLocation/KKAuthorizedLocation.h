//
//  KKAuthorizedLocation.h
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedBase.h"
#import <MapKit/MapKit.h>

@interface KKAuthorizedLocation : KKAuthorizedBase

+ (KKAuthorizedLocation*_Nonnull)defaultManager;

#pragma mark ==================================================
#pragma mark == 地理位置
#pragma mark ==================================================
/*
 检查是否授权【地理位置】
 #import <MapKit/MapKit.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isLocationAuthorized_ShowAlert:(BOOL)showAlert
                            andAPPName:(nullable NSString *)appName;

- (void)showLocationAuthorized_WithLocationManager:(nullable CLLocationManager*)myLocationManager;

/*
 设置后台定位开启 【地理位置】
 #import <MapKit/MapKit.h>
 */
- (void)setAllowsBackgroundLocationUpdates:(BOOL)allowsBackgroundLocationUpdates
                        forLocationManager:(nonnull CLLocationManager*)aLocationManager;

@end
