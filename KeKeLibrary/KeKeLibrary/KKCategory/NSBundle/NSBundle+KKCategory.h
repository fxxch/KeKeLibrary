//
//  NSBundle+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define NSBundle_FilePathForName(FileName)  [[NSBundle mainBundle] pathForResource:FileName ofType:nil]

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
