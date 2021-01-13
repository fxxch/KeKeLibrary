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

@interface KKLocalizationManager : NSObject {
     NSArray *_localizationList;
}

+ (KKLocalizationManager *_Nonnull)shared;

#pragma mark ==================================================
#pragma mark == Public Method
#pragma mark ==================================================
/* 可适配的的语言 */
- (NSArray *_Nullable)languages;

/* 当前语言 */
- (NSString *_Nullable)currentLanguage;

/* 更改语言 */
- (void)changeLocalization:(NSString *_Nullable)language;

/* 获取国际化语言（不带参数） */
- (NSString *_Nullable)localStringWithKey:(NSString *_Nullable)key;

/* 获取国际化语言（带参数） */
- (NSString *_Nullable)localStringWithKeyAndParameter:(NSString *_Nullable)key, ...;

@end
