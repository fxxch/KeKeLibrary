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
+ (nullable NSString *)kk_bundleIdentifier;

+ (nullable NSString *)kk_bundleName;

+ (nullable NSString *)kk_bundleBuildVersion;

+ (nullable NSString *)kk_bundleVersion;

+ (float)kk_bundleMiniumOSVersion;

+ (nullable NSString *)kk_bundlePath;

+ (int)kk_buildXcodeVersion;

+ (nullable NSBundle*)kk_kkLibraryBundle;

#pragma mark ==================================================
#pragma mark ==路径相关
#pragma mark ==================================================
+ (nullable NSString *)kk_homeDirectory;

+ (nullable NSString *)kk_documentDirectory;

+ (nullable NSString *)kk_libaryDirectory;

+ (nullable NSString *)kk_tmpDirectory;

+ (nullable NSString *)kk_temporaryDirectory;

+ (nullable NSString *)kk_cachesDirectory;

#pragma mark ==================================================
#pragma mark == 获取图片资源
#pragma mark ==================================================
+ (nullable UIImage*)kk_imageInBundle:(NSString*_Nullable)aBundleName
                            imageName:(NSString*_Nullable)aImageName;

+ (nullable UIImage*)kk_imageInBundle:(NSString*_Nullable)aBundleName
                            imageName:(NSString*_Nullable)aImageName
                             basePath:(NSString*_Nullable)aBasePath;

@end
