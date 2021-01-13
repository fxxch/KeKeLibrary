//
//  KKAuthorizedManager.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKAuthorizedManager.h"
#import <Contacts/Contacts.h>
#import <Photos/PHPhotoLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreTelephony/CTCellularData.h>
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KKLibraryDefine.h"
#import "KKTool.h"

/**
 *  KKAuthorizedType
 */
typedef NS_ENUM(NSInteger,KKAuthorizedType) {
    
    KKAuthorizedType_AddressBook = 1,/* 通讯录 */
    
    KKAuthorizedType_Album = 2,/* 手机相册 */

    KKAuthorizedType_Camera = 3,/* 手机相册 */

    KKAuthorizedType_Location = 4,/* 地理位置 */
    
    KKAuthorizedType_Microphone = 5,/* 麦克风 */

    KKAuthorizedType_Notification = 6,/* 通知中心 */
    
    KKAuthorizedType_Music = 7,/* 媒体库音乐 */
    
    KKAuthorizedType_CellularData = 8,/* 蜂窝移动网络 */
};


@implementation KKAuthorizedManager

+ (KKAuthorizedManager *_Nonnull)defaultManager{
    static KKAuthorizedManager *KKAuthorizedManager_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAuthorizedManager_default = [[self alloc] init];
    });
    return KKAuthorizedManager_default;
}

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
                               andAPPName:(nullable NSString *)appName{
        
    CNAuthorizationStatus author = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    //用户尚未做出授权选择
    if (author == CNAuthorizationStatusNotDetermined) {
        
        __block BOOL accessGranted = NO;
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        // 初始化并创建通讯录对象，记得释放内存
        CNContactStore *addressBook = [[CNContactStore alloc]init];
        [addressBook requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        return accessGranted;
    }
    //用户已经授权同意——同意访问
    else if (author == CNAuthorizationStatusAuthorized) {
        return YES;
    }
    else {
        if (showAlert) {
            [KKAuthorizedManager.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_AddressBook
                                                                     appName:appName];
        }
        return NO;
    }
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
            [KKAuthorizedManager.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Album
                                                                     appName:appName];
        }
        return NO;
    }
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
            [KKAuthorizedManager.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Camera
                                                                     appName:appName];
        }
        return NO;
    }
}

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
                            andAPPName:(nullable NSString *)appName{
    
    if ([CLLocationManager locationServicesEnabled]==NO) {
        if (showAlert) {
            [KKAuthorizedManager.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Location
                                                                     appName:appName];
        }
        return NO;
    }
    else{
        CLAuthorizationStatus author = [CLLocationManager authorizationStatus];
        
        //用户尚未做出授权选择
        if (author == kCLAuthorizationStatusNotDetermined) {
            
            [KKAuthorizedManager.defaultManager showLocationAuthorized_WithLocationManager:nil];
            
            return YES;
        }
        //用户已经授权同意——同意访问【始终】
        else if (author == kCLAuthorizationStatusAuthorizedAlways) {
            return YES;
        }
        //用户已经授权同意——同意访问【使用期间】
        else if (author == kCLAuthorizationStatusAuthorizedWhenInUse) {
            return YES;
        }
        else {
            if (showAlert) {
                [KKAuthorizedManager.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Location
                                                                         appName:appName];
            }
            return NO;
        }
    }
}

- (void)showLocationAuthorized_WithLocationManager:(nullable CLLocationManager*)myLocationManager{
    
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined) {
        
        NSString *NSLocationAlwaysUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"];
        
        NSString *NSLocationWhenInUseUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
        
        NSString *NSLocationAlwaysAndWhenInUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUsageDescription"];
                
        if ([UIDevice isSystemVersionSmallerThan:@"8.0"]) {
            KKLogWarning(@"systemVersion<8 can not support");
        }
        else if ([UIDevice isSystemVersionBigerThan:@"8.0"] && [UIDevice isSystemVersionSmallerThan:@"11.0"]){
            if (NSLocationAlwaysUsageDescription) {
                [myLocationManager requestAlwaysAuthorization];
            }
            else if (NSLocationWhenInUseUsageDescription){
                [myLocationManager  requestWhenInUseAuthorization];
            }
            else{
                KKLogWarning(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
        else{
            if (NSLocationAlwaysAndWhenInUsageDescription) {
                [myLocationManager requestAlwaysAuthorization];
            }
            else if (NSLocationAlwaysUsageDescription) {
                [myLocationManager requestAlwaysAuthorization];
            }
            else if (NSLocationWhenInUseUsageDescription){
                [myLocationManager  requestWhenInUseAuthorization];
            }
            else{
                KKLogWarning(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
}

/*
 设置后台定位开启 【地理位置】
 #import <MapKit/MapKit.h>
 */
- (void)setAllowsBackgroundLocationUpdates:(BOOL)allowsBackgroundLocationUpdates
                        forLocationManager:(nonnull CLLocationManager*)aLocationManager{
    
    
    NSString *NSLocationAlwaysUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"];
    
    NSString *NSLocationWhenInUseUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
    
    NSString *NSLocationAlwaysAndWhenInUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUsageDescription"];
        
    if ([UIDevice isSystemVersionSmallerThan:@"8.0"]) {
        KKLogWarning(@"systemVersion<8 can not support");
    }
    else if ([UIDevice isSystemVersionBigerThan:@"8.0"] && [UIDevice isSystemVersionSmallerThan:@"11.0"]){
        if (NSLocationAlwaysUsageDescription) {
            
            //设置允许后台定位参数，保持不会被系统挂起
            [aLocationManager setPausesLocationUpdatesAutomatically:NO];
            
            //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
            if ([UIDevice isSystemVersionBigerThan:@"9.0"]) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSArray *UIBackgroundModes = [infoDictionary validArrayForKey:@"UIBackgroundModes"];
                //audio、fetch、location、remote-notification
                if ([UIBackgroundModes containsObject:@"location"]) {
                    aLocationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates;
                }
            }
            
        }
        else if (NSLocationWhenInUseUsageDescription){
            
        }
        else{
            KKLogWarning(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    else{
        if (NSLocationAlwaysAndWhenInUsageDescription) {
            
            //设置允许后台定位参数，保持不会被系统挂起
            [aLocationManager setPausesLocationUpdatesAutomatically:NO];
            
            //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
            if ([UIDevice isSystemVersionBigerThan:@"9.0"]) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSArray *UIBackgroundModes = [infoDictionary validArrayForKey:@"UIBackgroundModes"];
                //audio、fetch、location、remote-notification
                if ([UIBackgroundModes containsObject:@"location"]) {
                    aLocationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates;
                }
            }
            
        }
        else if (NSLocationAlwaysUsageDescription) {
            
            //设置允许后台定位参数，保持不会被系统挂起
            [aLocationManager setPausesLocationUpdatesAutomatically:NO];
            
            //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
            if ([UIDevice isSystemVersionBigerThan:@"9.0"]) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSArray *UIBackgroundModes = [infoDictionary validArrayForKey:@"UIBackgroundModes"];
                //audio、fetch、location、remote-notification
                if ([UIBackgroundModes containsObject:@"location"]) {
                    aLocationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates;
                }
            }
            
        }
        else if (NSLocationWhenInUseUsageDescription){
            
        }
        else{
            
        }
    }
    
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
        [KKAuthorizedManager.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Microphone
                                                                 appName:appName];
    }
    
    return accessGranted;
}

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
                                andAPPName:(nullable NSString *)appName{

    __block BOOL accessGranted = NO;
    //等待同意后向下执行
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    // 初始化并创建通讯录对象，记得释放内存
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {

        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            accessGranted = YES;
        }
        else{
            accessGranted = NO;
        }
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (accessGranted) {
        return YES;
    }
    else{
        if (showAlert) {
            [KKAuthorizedManager.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Notification
                                                                     appName:appName];
        }
        return NO;
    }
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
            [KKAuthorizedManager.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Music
                                                                     appName:appName];
        }
        return NO;
    }
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
        [KKAuthorizedManager.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_CellularData
                                                                 appName:appName];
    }
    return accessGranted;
}

#pragma mark ==================================================
#pragma mark == 授权失败弹窗
#pragma mark ==================================================
- (void)showAuthorizedFailedWithType:(KKAuthorizedType)aType appName:(NSString*)aAppName{
    
    //app名称
    __block NSString *app_Name = @"";
    app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    if ([NSString isStringEmpty:app_Name]) {
        app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    if ([NSString isStringEmpty:app_Name]) {
        app_Name = aAppName;
    }

    __block NSInteger AlertViewTag = 2017082200+aType;
    
    __block NSString *moreString = nil;
    switch (aType) {
        case KKAuthorizedType_AddressBook:{
            moreString = KKLibLocalizable_Authorized_AddressBook;
            break;
        }
        case KKAuthorizedType_Album:{
            moreString = KKLibLocalizable_Authorized_Album;
            break;
        }
        case KKAuthorizedType_Camera:{
            moreString = KKLibLocalizable_Authorized_Camera;
            break;
        }
        case KKAuthorizedType_Location:{
            moreString = KKLibLocalizable_Authorized_Location;
            break;
        }
        case KKAuthorizedType_Microphone:{
            moreString = KKLibLocalizable_Authorized_Microphone;
            break;
        }
        case KKAuthorizedType_Notification:{
            moreString = KKLibLocalizable_Authorized_Notification;
            break;
        }
        case KKAuthorizedType_Music:{
            moreString = KKLibLocalizable_Authorized_Music;
            break;
        }
        case KKAuthorizedType_CellularData:{
            moreString = KKLibLocalizable_Authorized_CellularData;
            break;
        }
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *message = [NSString stringWithFormat:@"%@ %@",app_Name,moreString];
        
        KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:KKLocalization(@"KKLibLocalizable.Authorized.title") subTitle:nil message:message delegate:self buttonTitles:KKLibLocalizable_Authorized_OK,KKLibLocalizable_Authorized_Go,nil];
        alertView.tag = AlertViewTag;
        [alertView show];
        
        KKButton *button = [alertView buttonAtIndex:0];
        [button setTitleColor:[UIColor colorWithHexString:@"#1296DB"] forState:UIControlStateNormal];
        KKButton *button1 = [alertView buttonAtIndex:1];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#1296DB"]forState:UIControlStateNormal];
    });
}

- (void)KKAlertView:(KKAlertView*_Nonnull)aAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex{
    if (aButtonIndex==1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (url) {
            [NSObject openURL:url];
        }
    }
}

@end
