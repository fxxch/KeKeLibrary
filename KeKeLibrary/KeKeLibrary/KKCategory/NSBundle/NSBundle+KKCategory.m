//
//  NSBundle+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSBundle+KKCategory.h"
#import "KKAlertView.h"
#import "NSDictionary+KKCategory.h"
#import "UIView+KKCategory.h"

@implementation NSBundle (KKCategory)

#pragma mark ==================================================
#pragma mark ==Bundle相关
#pragma mark ==================================================
+ (nullable NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (nullable NSString *)bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (nullable NSString *)bundleBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (nullable NSString *)bundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (float)bundleMiniumOSVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"MinimumOSVersion"] floatValue];
}

+ (nullable NSString *)bundlePath {
    return [[NSBundle mainBundle] bundlePath];
}

/*编译信息相关*/
+ (int)buildXcodeVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"DTXcode"] intValue];
}


#pragma mark ==================================================
#pragma mark ==路径相关
#pragma mark ==================================================
+ (nullable NSString *)homeDirectory {
    return NSHomeDirectory();
}

+ (nullable NSString *)documentDirectory {
    return [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
}

+ (nullable NSString *)libaryDirectory {
    return [NSString stringWithFormat:@"%@/Library", NSHomeDirectory()];
}

+ (nullable NSString *)tmpDirectory {
    return [NSString stringWithFormat:@"%@/tmp", NSHomeDirectory()];
}

+ (nullable NSString *)temporaryDirectory {
    return NSTemporaryDirectory();
}

+ (nullable NSString *)cachesDirectory {
    return [NSString stringWithFormat:@"%@/Library/Caches", NSHomeDirectory()];
}

#pragma mark ==================================================
#pragma mark ==检查新版本
#pragma mark ==================================================
+ (void)checkAppVersionWithAppid:(nullable NSString *)appid needShowNewVersionMessage:(BOOL)needShow completed:(CheckAppVersionCompletedBlock _Nullable )completedBlock{
    
    NSString *urlPath = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appid];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ([data length]>0 && !error ) {
            NSDictionary *appInfo = [NSDictionary dictionaryFromJSONData:data];
            NSDictionary *result = nil;
            if ([appInfo valueForKey:@"results"]) {
                NSArray *arrary = [appInfo valueForKey:@"results"];
                if (arrary && [arrary count]>0) {
                    result = [arrary objectAtIndex:0];
                }
            }
            
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *versionsInAppStore = [result valueForKey:@"version"];
                    if (versionsInAppStore) {
                        if ([[NSBundle bundleVersion] compare:versionsInAppStore options:NSNumericSearch] == NSOrderedAscending) {
                            
                            if (needShow) {
                                [NSBundle showAlertWithAppStoreVersion:versionsInAppStore
                                                               appleID:appid
                                                           description:[result valueForKey:@"description"]
                                                            updateInfo:[result valueForKey:@"releaseNotes"]];
                            }
                            if(completedBlock){
                                completedBlock(YES,versionsInAppStore,appid,[result valueForKey:@"description"],[result valueForKey:@"releaseNotes"]);
                            }
                        }
                        else {
                            if(completedBlock){
                                completedBlock(NO,versionsInAppStore,appid,[result valueForKey:@"description"],[result valueForKey:@"releaseNotes"]);
                            }
                        }
                    }
                    else {
                        if(completedBlock){
                            completedBlock(NO,versionsInAppStore,appid,[result valueForKey:@"description"],[result valueForKey:@"releaseNotes"]);
                        }
                    }
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(completedBlock){
                        completedBlock(NO,nil,appid,nil,nil);
                    }
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(completedBlock){
                    completedBlock(NO,nil,appid,nil,nil);
                }
            });
        }
        
    }];
}

+ (void)showAlertWithAppStoreVersion:(nullable NSString *)appStoreVersion appleID:(nullable NSString *)appleID description:(nullable NSString *)description updateInfo:(nullable NSString *)updateInfo {
    NSString *message = [NSString stringWithFormat:@"内容介绍:\n%@\n\n更新内容:\n%@", description, updateInfo];
    
    KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:@"新版本提示" subTitle:[NSString stringWithFormat:@"当前应用有新版本(%@)可以下载，是否前往更新？", appStoreVersion] message:message delegate:self buttonTitles:@"取消",@"更新", nil];
    
    [alertView setTagInfo:appleID];
    [alertView show];
}

- (void)KKAlertView:(KKAlertView*)aAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        NSString *urlPath = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", aAlertView.tagInfo];
        NSURL *url = [NSURL URLWithString:urlPath];
        [[UIApplication sharedApplication] openURL:url];
    }
}

/*检查新版本  结束*/

@end
