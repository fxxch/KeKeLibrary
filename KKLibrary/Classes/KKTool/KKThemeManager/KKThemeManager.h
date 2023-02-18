//
//  KKThemeManager.h
//  KKLibrary_Demo
//
//  Created by liubo on 14/12/1.
//  Copyright (c) 2014年 KeKeStudio. All rights reserved.
//

#import "KKResourceManager.h"

UIKIT_EXTERN  NSNotificationName const NotificationName_KKThemeChanged;

#define KKThemeImage(key)         [KKThemeManager imageWithKey:key inBundle:(KKThemeManager.sharedInstance.currentThemeName)]
#define KKThemeImagePath(key)     [KKThemeManager imagePathWithKey:key inBundle:(KKThemeManager.sharedInstance.currentThemeName)]
#define KKThemeGifImagePath(key)  [KKThemeManager gifImagePathWithKey:key inBundle:(KKThemeManager.sharedInstance.currentThemeName)]
#define KKThemeColor(key)         [KKThemeManager colorWithKey:key inBundle:(KKThemeManager.sharedInstance.currentThemeName)]
#define KKThemeFont(key)          [KKThemeManager fontWithKey:key inBundle:(KKThemeManager.sharedInstance.currentThemeName)]

/**
 默认主题包配置
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
#define DefaultThemeBundleName    @"Default.bundle"

@interface KKThemeManager : KKResourceManager

///  初始化默认会设置主题（默认bundle文件名 Default.bundle，注意项目工程里面配着该文件）
///  如果想用另外的Bundle文件名字，请设置
@property (nonatomic, copy) NSString *currentThemeName;

+ (KKThemeManager *)sharedInstance;

@end
