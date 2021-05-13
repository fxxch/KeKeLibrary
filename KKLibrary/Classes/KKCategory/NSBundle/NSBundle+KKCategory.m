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
#import "NSObject+KKCategory.h"
#import "NSString+KKCategory.h"
#import "KKLog.h"

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

+ (nullable NSBundle*)kkLibraryBundle{
    NSString *bundlePath_copy = [[NSBundle mainBundle] pathForResource:@"Frameworks/KKFramework.framework" ofType:nil];
    if (bundlePath_copy) {
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath_copy];
        KKLogInfoFormat(@"KKLibraryBundle: %@",bundlePath_copy);
        return bundle;
    }
    else {
        NSString *bundlePath_pod = [[NSBundle mainBundle] pathForResource:@"Frameworks/KeKeLibrary.framework" ofType:nil];
        if (bundlePath_pod) {
            NSBundle *bundle = [NSBundle bundleWithPath:bundlePath_pod];
            KKLogInfoFormat(@"KKLibraryBundle: %@",bundlePath_pod);
            return bundle;
        }
        else{
            KKLogInfoFormat(@"MainBundle");
            return [NSBundle mainBundle];
        }
    }
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
#pragma mark == 获取图片资源
#pragma mark ==================================================
+ (nullable UIImage*)imageInBundle:(NSString*_Nullable)aBundleName
                         imageName:(NSString*_Nullable)aImageName{
    return [NSBundle imageInBundle:aBundleName imageName:aImageName basePath:nil];
}

+ (nullable UIImage*)imageInBundle:(NSString*_Nullable)aBundleName
                         imageName:(NSString*_Nullable)aImageName
                          basePath:(NSString*_Nullable)aBasePath{

    if ([NSString isStringEmpty:aBundleName] ||
        [NSString isStringEmpty:aImageName] ) {
        return nil;
    }
    
    NSString *bundleName = aBundleName;
    if ([bundleName hasSuffix:@".bundle"]==NO) {
        bundleName = [bundleName stringByAppendingString:@".bundle"];
    }
    
    NSString *bundleFilePath = @"";
    bundleFilePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];
    if ([NSString isStringEmpty:bundleFilePath]) {
        if ([NSString isStringNotEmpty:aBasePath]) {
            if ([aBasePath hasSuffix:@"/"]) {
                bundleFilePath = [NSString stringWithFormat:@"%@%@",aBasePath,bundleName];
            }
            else{
                bundleFilePath = [NSString stringWithFormat:@"%@/%@",aBasePath,bundleName];
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:bundleFilePath]==NO) {
                return nil;
            }
        }
        else{
            bundleFilePath = [[NSBundle kkLibraryBundle] pathForResource:bundleName ofType:nil];
        }
    }

    if ([NSString isStringEmpty:bundleFilePath]) {
        return nil;
    }
    
    NSString *imageName = [aImageName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@1x" withString:@""];

    NSString *imageName1 = [NSString stringWithFormat:@"%@.png",imageName];
    NSString *imageName11 = [NSString stringWithFormat:@"%@@1x.png",imageName];
    NSString *imageName2 = [NSString stringWithFormat:@"%@@2x.png",imageName];
    NSString *imageName3 = [NSString stringWithFormat:@"%@@3x.png",imageName];

    NSString *filepath1 = [NSString stringWithFormat:@"%@/%@",bundleFilePath,imageName1];
    NSString *filepath11 = [NSString stringWithFormat:@"%@/%@",bundleFilePath,imageName11];
    NSString *filepath2 = [NSString stringWithFormat:@"%@/%@",bundleFilePath,imageName2];
    NSString *filepath3 = [NSString stringWithFormat:@"%@/%@",bundleFilePath,imageName3];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale==1) {
        UIImage *image = [UIImage imageWithContentsOfFile:filepath1];
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath11];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath2];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath3];
        }
        return image;
    } else if (scale==2){
        UIImage *image = [UIImage imageWithContentsOfFile:filepath2];
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath3];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath1];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath11];
        }
        return image;
    }
    else {
        UIImage *image = [UIImage imageWithContentsOfFile:filepath3];
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath2];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath1];
        }
        if (image==nil) {
            image = [UIImage imageWithContentsOfFile:filepath11];
        }
        return image;
    }
}

#pragma mark ==================================================
#pragma mark ==检查新版本
#pragma mark ==================================================
+ (void)checkAppVersionWithAppid:(nullable NSString *)appid
       needShowNewVersionMessage:(BOOL)needShow
                       completed:(CheckAppVersionCompletedBlock _Nullable )completedBlock{
    
    //获取appStore网络版本号
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", appid]];
//    [request setHTTPMethod:@"GET"];
    
    NSURLRequest *reque = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:reque completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
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
                                [[NSBundle mainBundle] showAlertWithAppStoreVersion:versionsInAppStore
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
    
    //开始任务
    [task resume];
}

- (void)showAlertWithAppStoreVersion:(nullable NSString *)appStoreVersion appleID:(nullable NSString *)appleID description:(nullable NSString *)description updateInfo:(nullable NSString *)updateInfo {
    NSString *message = [NSString stringWithFormat:@"更新内容:\n%@", updateInfo];
    
    KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:@"新版本提示" subTitle:[NSString stringWithFormat:@"有新版本(%@)可以下载，是否前往更新？", appStoreVersion] message:message delegate:self buttonTitles:@"取消",@"更新", nil];
    
    [alertView setTagInfo:appleID];
    [alertView show];
}

- (void)KKAlertView:(KKAlertView*)aAlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        NSString *urlPath = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", aAlertView.tagInfo];
        NSURL *url = [NSURL URLWithString:urlPath];
        [NSObject openURL:url];
    }
}

/*检查新版本  结束*/

@end
