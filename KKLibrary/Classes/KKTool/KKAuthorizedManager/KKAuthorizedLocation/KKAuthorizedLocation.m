//
//  KKAuthorizedLocation.m
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedLocation.h"

@implementation KKAuthorizedLocation

+ (KKAuthorizedLocation *)defaultManager{
    static KKAuthorizedLocation *KKAuthorizedLocation_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAuthorizedLocation_default = [[self alloc] init];
    });
    return KKAuthorizedLocation_default;
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
            [KKAuthorizedLocation.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Location
                                                                     appName:appName];
        }
        return NO;
    }
    else{
        CLAuthorizationStatus author = [CLLocationManager authorizationStatus];
        
        //用户尚未做出授权选择
        if (author == kCLAuthorizationStatusNotDetermined) {
            
            [KKAuthorizedLocation.defaultManager showLocationAuthorized_WithLocationManager:nil];
            
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
                [KKAuthorizedLocation.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_Location
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


@end
