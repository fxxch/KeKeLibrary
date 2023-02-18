//
//  KKLocalizationManager.h
//  BM
//
//  Created by liubo on 2019/12/28.
//  Copyright © 2019 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSNotificationName const _Nonnull NotificationName_KKLocalizationDidChanged;

/* 获取国际化语言（不带参数） */
#define KKLocalization(key) [[KKLocalizationManager shared] localStringWithKey:key]

/* 获取国际化语言（带参数） */
#define KKLocalizationWithFormat(format, ...) [[KKLocalizationManager shared] localStringWithKeyAndParameter:format,##__VA_ARGS__]

@interface KKLocalizationManager : NSObject

/**
 从 [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] 读取出来的字符串是
 zh-Hans-CN,
 ja-CN,
 en-US
 而实际对应的语言文件包（localizationName）是：
 zh-Hans.lproj
 ja.lproj
 en.lproj
 所以在这里需要建立一个关系表，默认值追加了以上三个，使用的时候可以自己追加更多
 */
@property (nonatomic , strong) NSMutableDictionary * _Nonnull appleLanguages_localizationName_Dic;


+ (KKLocalizationManager *_Nonnull)shared;

#pragma mark ==================================================
#pragma mark == Public Method
#pragma mark ==================================================
/* 当前语言 返回当前的AppleLanguage*/
- (NSString *_Nullable)currentAppleLanguageLanguage;

/* 更改语言 传入新的AppleLanguage*/
- (void)changeLocalization:(NSString *_Nullable)appleLanguage;

/* 设置语言是否跟随系统，默认是跟随系统语言切换的 */
- (void)setLanguageFollowSystem:(BOOL)followSystem;

/* 获取国际化语言（不带参数） */
- (NSString *_Nullable)localStringWithKey:(NSString *_Nullable)key;

/* 获取国际化语言（带参数） */
- (NSString *_Nullable)localStringWithKeyAndParameter:(NSString *_Nullable)key, ...;

@end
