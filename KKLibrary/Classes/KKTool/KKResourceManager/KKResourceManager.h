//
//  KKResourceManager.h
//  KKLibrary_Demo
//
//  Created by liubo on 14/12/1.
//  Copyright (c) 2014年 KeKeStudio. All rights reserved.
//
/**
 资源配置格式
 1、一个Bundle文件（Default.bundle）
 2、里面有文件夹和资源文件，以及plist文件，整体结构如下：
    Default.bundle
        Base/
            navBack@2x.png
            navBack@3x.png
        Home/
            item1@2x.png
            item1@3x.png
         theme.plist  //里面配置key-value键值对，eg: key: navBack value: Base/navBack.png，代码就会在Bundle文件里面，在Base路径下面根据当前手机分辨率，自动找到对应的navBack.png、navBack@2x.png、navBack@3x.png
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KKResourceImage(key, bundleName)         [KKResourceManager imageWithKey:key inBundle:(bundleName)]
#define KKResourceImagePath(key, bundleName)     [KKResourceManager imagePathWithKey:key inBundle:(bundleName)]
#define KKResourceGifImagePath(key, bundleName)  [KKResourceManager gifImagePathWithKey:key inBundle:(bundleName)]
#define KKResourceColor(key, bundleName)         [KKResourceManager colorWithKey:key inBundle:(bundleName)]
#define KKResourceFont(key, bundleName)          [KKResourceManager fontWithKey:key inBundle:(bundleName)]

@interface KKResourceManager : NSObject

+ (NSString*)loadThemeBundlePath_withBundleFileName:(NSString*)aBundleFileName;

+ (NSDictionary*)loadThemeInformation_withBundleFileName:(NSString*)aBundleFileName;

#pragma mark ==================================================
#pragma mark == 获取资源
#pragma mark ==================================================
// navBack => Base/navBack.png
+ (NSString*)imagePathWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName;

// navBack => Base/navBack.png
+ (UIImage*)imageWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName;

// navBack => Base/navBack.gif
+ (NSString*)gifImagePathWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName;

// pingfang16 => PingFang,16
+ (UIFont*)fontWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName;

/*key对应的value的值格式：
 #RGB、#ARGB 、#RRGGBB 、#AARRGGBB 、R,G,B,A
*/
+ (UIColor*)colorWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName;

@end
