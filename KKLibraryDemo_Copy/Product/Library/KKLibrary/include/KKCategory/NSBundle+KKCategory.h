//
//  NSBundle+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (KKCategory)

#pragma mark ==================================================
#pragma mark ==Bundle相关
#pragma mark ==================================================
+ (nullable NSString *)bundleIdentifier;

+ (nullable NSString *)bundleName;

+ (nullable NSString *)bundleBuildVersion;

+ (nullable NSString *)bundleVersion;

+ (float)bundleMiniumOSVersion;

+ (nullable NSString *)bundlePath;

+ (int)buildXcodeVersion;

+ (nullable NSBundle*)kkLibraryBundle;

#pragma mark ==================================================
#pragma mark ==路径相关
#pragma mark ==================================================
+ (nullable NSString *)homeDirectory;

+ (nullable NSString *)documentDirectory;

+ (nullable NSString *)libaryDirectory;

+ (nullable NSString *)tmpDirectory;

+ (nullable NSString *)temporaryDirectory;

+ (nullable NSString *)cachesDirectory;

#pragma mark ==================================================
#pragma mark == 获取图片资源
#pragma mark ==================================================
+ (nullable UIImage*)imageInBundle:(NSString*_Nullable)aBundleName
                         imageName:(NSString*_Nullable)aImageName;

#pragma mark ==================================================
#pragma mark ==检查新版本
#pragma mark ==================================================
typedef void(^CheckAppVersionCompletedBlock)(BOOL haveNewVersion,
                                             NSString * _Nullable newVersion,
                                             NSString * _Nullable appID,
                                             NSString * _Nullable newVersionDescription,
                                             NSString * _Nullable releaseNotes);

+ (void)checkAppVersionWithAppid:(nullable NSString *)appid
       needShowNewVersionMessage:(BOOL)needShow
                       completed:(CheckAppVersionCompletedBlock _Nullable )completedBlock;

@end
