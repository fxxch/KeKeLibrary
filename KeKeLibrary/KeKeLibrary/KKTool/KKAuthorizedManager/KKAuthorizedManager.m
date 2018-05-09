//
//  KKAuthorizedManager.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKAuthorizedManager.h"
#import <Contacts/Contacts.h>
//#import <AddressBook/AddressBook.h>
#import <UserNotifications/UserNotifications.h>
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KeKeLibraryDefine.h"
#import "KKTool.h"

#define KKAlertView_JumpToSetting_AddressBook   2017082201
#define KKAlertView_JumpToSetting_Album         2017082202
#define KKAlertView_JumpToSetting_Camera        2017082203
#define KKAlertView_JumpToSetting_Location      2017082204
#define KKAlertView_JumpToSetting_Microphone    2017082205
#define KKAlertView_JumpToSetting_Notification  2017082206


@implementation KKAuthorizedManager

/*
 检查是否授权【通讯录】
 #import <AddressBook/AddressBook.h>
 */
+ (BOOL)isAddressBookAuthorized_ShowAlert:(BOOL)showAlert andAPPName:(nullable NSString *)appName{
    
    BOOL Authorized = NO;
    
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
        
        Authorized = accessGranted;
        
        //        __block BOOL accessGranted = NO;
        //        // 初始化并创建通讯录对象，记得释放内存
        //        ABAddressBookRef addressBook = nil;
        //        if (&ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        //            //等待同意后向下执行
        //            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        //            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        //                accessGranted = granted;
        //                dispatch_semaphore_signal(sema);
        //            });
        //            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //            CFRelease((__bridge CFTypeRef)(sema));
        //        }
        //        else { // we're on iOS 5 or older
        //            accessGranted = YES;
        //        }
        //        Authorized = accessGranted;
    }
    //其他原因未被授权——可能是家长控制权限
    else if (author == CNAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                //app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (!app_Name) {
                    app_Name = appName;
                }
                //                NSString *message = [NSString stringWithFormat:@"《%@》%@%@%@",app_Name,KILocalization(@"没有权限访问您的通讯录，请在 设置--→隐私--→通讯录 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                NSString *message = [NSString stringWithFormat:@"%@\"%@\"%@",KILocalization(@"请在手机通讯录设置中，将"),app_Name,KILocalization(@"的权限设为允许")];
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                alertView.tag = KKAlertView_JumpToSetting_AddressBook;
                [alertView show];
                
                UIButton *button = [alertView buttonAtIndex:0];
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
        });
        
        Authorized = NO;
    }
    //用户已经明确拒绝——拒绝访问
    else if (author == CNAuthorizationStatusDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                // app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (!app_Name) {
                    app_Name = appName;
                }
                //                NSString *message = [NSString stringWithFormat:@"《%@》%@%@%@",app_Name,KILocalization(@"没有权限访问您的通讯录，请在 设置--→隐私--→通讯录 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                NSString *message = [NSString stringWithFormat:@"%@\"%@\"%@",KILocalization(@"请在手机通讯录设置中，将"),app_Name,KILocalization(@"的权限设为允许")];
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                alertView.tag = KKAlertView_JumpToSetting_AddressBook;
                [alertView show];
                
                UIButton *button = [alertView buttonAtIndex:0];
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
        });
        Authorized = NO;
    }
    //用户已经授权同意——同意访问
    else if (author == CNAuthorizationStatusAuthorized) {
        Authorized = YES;
    }
    else {
        Authorized = NO;
    }
    
    return Authorized;
}

/*
 检查是否授权【相册】
 #import <AssetsLibrary/AssetsLibrary.h>
 */
+ (void)isAlbumAuthorized_ShowAlert:(BOOL)showAlert block:(void(^_Nullable)(BOOL authorized))block{
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    
    //用户尚未做出授权选择
    if (author == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case PHAuthorizationStatusAuthorized:
                    {
                        block(YES);
                        break;
                    }
                    default:
                    {
                        if (showAlert) {
                            // app名称
                            NSString *app_Name = @"";
                            app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                            //                NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的手机相册，请在 设置--→隐私--→照片 里面为"),app_Name,KILocalization(@"开启权限。")];
                            
                            NSString *message = [NSString stringWithFormat:@"%@\"%@\"%@",KILocalization(@"请在手机相册设置中，将"),app_Name,KILocalization(@"的权限设为允许")];
                            KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                            alertView.tag = KKAlertView_JumpToSetting_Album;
                            [alertView show];
                            
                            UIButton *button = [alertView buttonAtIndex:0];
                            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        }
                        block(NO);
                        break;
                    }
                }
            });
        }];
    }
    else if (author == PHAuthorizationStatusAuthorized) {
        block(YES);
    }
    //其他原因未被授权——可能是家长控制权限
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                
                // app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                //                NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的手机相册，请在 设置--→隐私--→照片 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                NSString *message = [NSString stringWithFormat:@"%@\"%@\"%@",KILocalization(@"请在手机相册设置中，将"),app_Name,KILocalization(@"的权限设为允许")];
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                alertView.tag = KKAlertView_JumpToSetting_Album;
                [alertView show];
                
                UIButton *button = [alertView buttonAtIndex:0];
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                
                
                block(NO);
            }
        });
    }
}


/*
 检查是否授权【相机】
 #import <AVFoundation/AVFoundation.h>
 */
+ (BOOL)isCameraAuthorized_ShowAlert:(BOOL)showAlert{
    
    BOOL Authorized = NO;
    
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
        //        CFRelease((__bridge CFTypeRef)(sema));
        //        dispatch_release(sema);
        Authorized = accessGranted;
    }
    //其他原因未被授权——可能是家长控制权限
    else if (author == AVAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                //app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                //                NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的相机，请在 设置--→隐私--→相机 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                
                NSString *message = [NSString stringWithFormat:@"%@\"%@\"%@",KILocalization(@"请在手机拍照设置中，将"),app_Name,KILocalization(@"的权限设为允许")];
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                alertView.tag = KKAlertView_JumpToSetting_Camera;
                [alertView show];
                
                UIButton *button = [alertView buttonAtIndex:0];
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
        });
        
        Authorized = NO;
    }
    //用户已经明确拒绝——拒绝访问
    else if (author == AVAuthorizationStatusDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                // app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                //                NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的相机，请在 设置--→隐私--→相机 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                NSString *message = [NSString stringWithFormat:@"%@\"%@\"%@",KILocalization(@"请在手机拍照设置中，将"),app_Name,KILocalization(@"的权限设为允许")];
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                alertView.tag = KKAlertView_JumpToSetting_Camera;
                [alertView show];
                
                UIButton *button = [alertView buttonAtIndex:0];
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
        });
        Authorized = NO;
    }
    //用户已经授权同意——同意访问
    else if (author == AVAuthorizationStatusAuthorized) {
        Authorized = YES;
    }
    else {
        Authorized = NO;
    }
    
    return Authorized;
}


/*
 检查是否授权【地理位置】
 #import <MapKit/MapKit.h>
 */
+ (BOOL)isLocationAuthorized_ShowAlert:(BOOL)showAlert{
    
    //    if ([CLLocationManager locationServicesEnabled]==NO) {
    //        return NO;
    //    }
    
    BOOL Authorized = NO;
    
    if (![CLLocationManager locationServicesEnabled]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                //                NSString *message = [NSString stringWithFormat:@"请在系统设置中开启定位服务（设置>隐私>定位服务>开启%@）",APP_NAME];
                
                NSString *message = KILocalization(@"请打开“定位服务”以便考勤能准确获取您的位置信息");
                
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                alertView.tag = KKAlertView_JumpToSetting_Location;
                [alertView show];
                
                UIButton *button = [alertView buttonAtIndex:0];
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
        });
        Authorized = NO;
    }
    else{
        CLAuthorizationStatus author = [CLLocationManager authorizationStatus];
        
        //用户尚未做出授权选择
        if (author == kCLAuthorizationStatusNotDetermined) {
            
            [KKAuthorizedManager showLocationAuthorized_WithLocationManager:nil];
            
            Authorized = YES;
        }
        //其他原因未被授权——可能是家长控制权限
        else if (author == kCLAuthorizationStatusRestricted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (showAlert) {
                    //app名称
                    NSString *app_Name = @"";
                    app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                    //                    NSString *message = [NSString stringWithFormat:@"请在系统设置中开启定位服务（设置>隐私>定位服务>开启%@）",app_Name];
                    
                    NSString *message = KILocalization(@"请打开“定位服务”以便考勤能准确获取您的位置信息");
                    
                    KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                    alertView.tag = KKAlertView_JumpToSetting_Location;
                    [alertView show];
                    
                    UIButton *button = [alertView buttonAtIndex:0];
                    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
            });
            
            Authorized = NO;
        }
        //用户已经明确拒绝——拒绝访问
        else if (author == kCLAuthorizationStatusDenied){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (showAlert) {
                    // app名称
                    NSString *app_Name = @"";
                    app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                    //                    NSString *message = [NSString stringWithFormat:@"请在系统设置中开启定位服务（设置>隐私>定位服务>开启%@）",app_Name];
                    
                    NSString *message = KILocalization(@"请打开“定位服务”以便考勤能准确获取您的位置信息");
                    
                    KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                    alertView.tag = KKAlertView_JumpToSetting_Location;
                    [alertView show];
                    
                    UIButton *button = [alertView buttonAtIndex:0];
                    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
            });
            Authorized = NO;
        }
        //用户已经授权同意——同意访问【始终】
        else if (author == kCLAuthorizationStatusAuthorizedAlways) {
            Authorized = YES;
        }
        //用户已经授权同意——同意访问【使用期间】
        else if (author == kCLAuthorizationStatusAuthorizedWhenInUse) {
            Authorized = YES;
        }
        else {
            Authorized = NO;
        }
    }
    
    return Authorized;
}

+ (void)showLocationAuthorized_WithLocationManager:(nullable CLLocationManager*)myLocationManager{
    
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined) {
        
        NSString *NSLocationAlwaysUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"];
        
        NSString *NSLocationWhenInUseUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
        
        NSString *NSLocationAlwaysAndWhenInUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUsageDescription"];
        
        CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
        
        if (systemVersion<8) {
            NSLog(@"systemVersion<8 can not support");
        }
        else if ((systemVersion >= 8) && (systemVersion < 11)){
            if (NSLocationAlwaysUsageDescription) {
                [myLocationManager requestAlwaysAuthorization];
            }
            else if (NSLocationWhenInUseUsageDescription){
                [myLocationManager  requestWhenInUseAuthorization];
            }
            else{
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
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
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
}

/*
 设置后台定位开启 【地理位置】
 #import <MapKit/MapKit.h>
 */
+ (void)setAllowsBackgroundLocationUpdates:(BOOL)allowsBackgroundLocationUpdates
                        forLocationManager:(nonnull CLLocationManager*)aLocationManager{
    
    
    NSString *NSLocationAlwaysUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"];
    
    NSString *NSLocationWhenInUseUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"];
    
    NSString *NSLocationAlwaysAndWhenInUsageDescription = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysAndWhenInUsageDescription"];
    
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (systemVersion<8) {
        NSLog(@"systemVersion<8 can not support");
    }
    else if ((systemVersion >= 8) && (systemVersion < 11)){
        if (NSLocationAlwaysUsageDescription) {
            
            //设置允许后台定位参数，保持不会被系统挂起
            [aLocationManager setPausesLocationUpdatesAutomatically:NO];
            
            //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0) {
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
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    else{
        if (NSLocationAlwaysAndWhenInUsageDescription) {
            
            //设置允许后台定位参数，保持不会被系统挂起
            [aLocationManager setPausesLocationUpdatesAutomatically:NO];
            
            //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0) {
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
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0) {
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


/*
 检查是否授权【麦克风】
 #import <AVFoundation/AVFoundation.h>
 */
+ (BOOL)isMicrophoneAuthorized_ShowAlert:(BOOL)showAlert{
    
    __block BOOL Authorized = NO;
    
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        
        //        // 初始化并创建通讯录对象，记得释放内存
        //        ABAddressBookRef addressBook = nil;
        //        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        //        });
        
        __block BOOL accessGranted = NO;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [avSession requestRecordPermission:^(BOOL available) {
            accessGranted = available;
            if (!available) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (showAlert) {
                        //app名称
                        NSString *app_Name = @"";
                        app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                        //                        NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的麦克风，请在 设置--→隐私--→麦克风 里面为"),app_Name,KILocalization(@"开启权限。")];
                        
                        NSString *message = [NSString stringWithFormat:@"%@\"%@\"%@",KILocalization(@"请在手机麦克风设置中，将"),app_Name,KILocalization(@"的权限设为允许")];
                        KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
                        alertView.tag = KKAlertView_JumpToSetting_Microphone;
                        [alertView show];
                        
                        UIButton *button = [alertView buttonAtIndex:0];
                        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    }
                });
            }
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //        CFRelease((__bridge CFTypeRef)(sema));
        //        dispatch_release(sema);
        Authorized = accessGranted;
    }
    return Authorized;
}

/*
 检查是否授权【通知中心】
 */
+ (BOOL)isNotificationAuthorized_ShowAlert:(BOOL)showAlert{
    
    //    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    //        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
    //            NSLog(@"User authed.");
    //        } else {
    //            NSLog(@"User denied.");
    //        }
    //    }];
    
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if(UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    else{
        if (showAlert) {
            NSString *message = KILocalization(@"请打开通知权限以便您能及时收到新消息");
            
            KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:nil buttonTitles:@"取消",@"设置",nil];
            alertView.tag = KKAlertView_JumpToSetting_Notification;
            [alertView show];
        }
        return NO;
    }
}



@end
