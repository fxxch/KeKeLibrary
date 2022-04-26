//
//  NSBundle+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSBundle+KKCategory.h"
#import "NSDictionary+KKCategory.h"
#import "UIView+KKCategory.h"
#import "NSObject+KKCategory.h"
#import "NSString+KKCategory.h"
#import "KKLog.h"

@implementation NSBundle (KKCategory)

#pragma mark ==================================================
#pragma mark ==Bundle相关
#pragma mark ==================================================
+ (nullable NSString *)kk_bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (nullable NSString *)kk_bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (nullable NSString *)kk_bundleBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (nullable NSString *)kk_bundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (float)kk_bundleMiniumOSVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"MinimumOSVersion"] floatValue];
}

+ (nullable NSString *)kk_bundlePath {
    return [[NSBundle mainBundle] bundlePath];
}

/*编译信息相关*/
+ (int)kk_buildXcodeVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"DTXcode"] intValue];
}

+ (nullable NSBundle*)kk_kkLibraryBundle{
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
+ (nullable NSString *)kk_homeDirectory {
    return NSHomeDirectory();
}

+ (nullable NSString *)kk_documentDirectory {
    return [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
}

+ (nullable NSString *)kk_libaryDirectory {
    return [NSString stringWithFormat:@"%@/Library", NSHomeDirectory()];
}

+ (nullable NSString *)kk_tmpDirectory {
    return [NSString stringWithFormat:@"%@/tmp", NSHomeDirectory()];
}

+ (nullable NSString *)kk_temporaryDirectory {
    return NSTemporaryDirectory();
}

+ (nullable NSString *)kk_cachesDirectory {
    return [NSString stringWithFormat:@"%@/Library/Caches", NSHomeDirectory()];
}

#pragma mark ==================================================
#pragma mark == 获取图片资源
#pragma mark ==================================================
+ (nullable UIImage*)kk_imageInBundle:(NSString*_Nullable)aBundleName
                            imageName:(NSString*_Nullable)aImageName{
    return [NSBundle kk_imageInBundle:aBundleName imageName:aImageName basePath:nil];
}

+ (nullable UIImage*)kk_imageInBundle:(NSString*_Nullable)aBundleName
                            imageName:(NSString*_Nullable)aImageName
                             basePath:(NSString*_Nullable)aBasePath{

    if ([NSString kk_isStringEmpty:aBundleName] ||
        [NSString kk_isStringEmpty:aImageName] ) {
        return nil;
    }
    
    NSString *bundleName = aBundleName;
    if ([bundleName hasSuffix:@".bundle"]==NO) {
        bundleName = [bundleName stringByAppendingString:@".bundle"];
    }
    
    NSString *bundleFilePath = @"";
    bundleFilePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:nil];
    if ([NSString kk_isStringEmpty:bundleFilePath]) {
        if ([NSString kk_isStringNotEmpty:aBasePath]) {
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
            bundleFilePath = [[NSBundle kk_kkLibraryBundle] pathForResource:bundleName ofType:nil];
        }
    }

    if ([NSString kk_isStringEmpty:bundleFilePath]) {
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

@end
