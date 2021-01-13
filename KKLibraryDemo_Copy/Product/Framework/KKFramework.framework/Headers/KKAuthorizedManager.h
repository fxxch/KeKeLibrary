//
//  KKAuthorizedManager.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface KKAuthorizedManager : NSObject

+ (KKAuthorizedManager*_Nonnull)defaultManager;

#pragma mark ==================================================
#pragma mark == 通讯录
#pragma mark ==================================================
/*
 检查是否授权【通讯录】
 #import <Contacts/CNContact.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
*/
- (BOOL)isAddressBookAuthorized_ShowAlert:(BOOL)showAlert
                               andAPPName:(nullable NSString *)appName;

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
                         andAPPName:(nullable NSString *)appName;

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
                          andAPPName:(nullable NSString *)appName;

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
                              andAPPName:(nullable NSString *)appName;

#pragma mark ==================================================
#pragma mark == 通知中心
#pragma mark ==================================================
/*
 检查是否授权【通知中心】
 #import <UserNotifications/UserNotifications.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isNotificationAuthorized_ShowAlert:(BOOL)showAlert
                                andAPPName:(nullable NSString *)appName;

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
                         andAPPName:(nullable NSString *)appName;

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
                                andAPPName:(nullable NSString *)appName;

@end
