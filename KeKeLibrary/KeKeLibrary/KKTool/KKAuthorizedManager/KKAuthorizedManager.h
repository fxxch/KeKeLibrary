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

/*
 检查是否授权【通讯录】
 #import <AddressBook/AddressBook.h>
 */
+ (BOOL)isAddressBookAuthorized_ShowAlert:(BOOL)showAlert andAPPName:(nullable NSString *)appName;

/*
 检查是否授权【相册】
 #import <AssetsLibrary/AssetsLibrary.h>
 */
+ (void)isAlbumAuthorized_ShowAlert:(BOOL)showAlert block:(void(^_Nullable)(BOOL authorized))block;


/*
 检查是否授权【相机】
 #import <AVFoundation/AVFoundation.h>
 */
+ (BOOL)isCameraAuthorized_ShowAlert:(BOOL)showAlert;


/*
 检查是否授权【地理位置】
 #import <MapKit/MapKit.h>
 */
+ (BOOL)isLocationAuthorized_ShowAlert:(BOOL)showAlert;

+ (void)showLocationAuthorized_WithLocationManager:(nullable CLLocationManager*)myLocationManager;

/*
 设置后台定位开启 【地理位置】
 #import <MapKit/MapKit.h>
 */
+ (void)setAllowsBackgroundLocationUpdates:(BOOL)allowsBackgroundLocationUpdates
                        forLocationManager:(nonnull CLLocationManager*)aLocationManager;


/*
 检查是否授权【麦克风】
 #import <AVFoundation/AVFoundation.h>
 */
+ (BOOL)isMicrophoneAuthorized_ShowAlert:(BOOL)showAlert;

/*
 检查是否授权【通知中心】
 */
+ (BOOL)isNotificationAuthorized_ShowAlert:(BOOL)showAlert;


@end
