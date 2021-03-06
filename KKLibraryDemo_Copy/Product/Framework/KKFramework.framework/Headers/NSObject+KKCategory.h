//
//  NSObject+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSAttributedStringKey _Nonnull const NotificationThemeDidChange;
UIKIT_EXTERN NSAttributedStringKey _Nonnull const NotificationLocalizationDidChange;

@interface NSObject (KKCategory)

#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
/**
 监听通知
 
 @param name 通知名称
 @param selector 处理事件
 */
- (void)observeNotification:(nullable NSString *)name
                   selector:(nullable SEL)selector;


/**
 取消监听通知
 
 @param name 通知名称
 */
- (void)unobserveNotification:(nullable NSString *)name;

/**
 取消所有监听通知
 
 */
- (void)unobserveAllNotification;

/**
 发送通知
 
 @param name 通知名称
 */
- (void)postNotification:(nullable NSString *)name;

/**
 发送通知
 
 @param name 通知名称
 @param object 对象
 */
- (void)postNotification:(nullable NSString *)name
                  object:(nullable id)object;

/**
 发送通知
 
 @param name 通知名称
 @param object 对象
 @param userInfo 信息
 */
- (void)postNotification:(nullable NSString *)name
                  object:(nullable id)object
                userInfo:(nullable NSDictionary *)userInfo;

#pragma mark ==================================================
#pragma mark == 主题通知
#pragma mark ==================================================
/**
 监听主题修改通知
 */
- (void)observeThemeChangeNotification;

/**
 取消监听主题修改通知
 */
- (void)unobserveThemeChangeNotification;

/**
 主题修改
 */
- (void)changeTheme;

#pragma mark ==================================================
#pragma mark == 语言通知
#pragma mark ==================================================
/**
 监听语言修改通知
 */
- (void)observeLocalizationChangeNotification;

/**
 取消监听语言修改通知
 */
- (void)unobserveLocalizationChangeNotification;

/**
 语言修改
 */
- (void)changeLocalization;


#pragma mark ==================================================
#pragma mark == 调用苹果系统应用的方法，打电话、发邮件、发短信、打开URL等
#pragma mark ==================================================
/**
 打开URL
 
 @param url url
 */
- (void)openURL:(nullable NSURL *)url;


/**
 发邮件
 
 @param mail mail
 */
- (void)sendMail:(nullable NSString *)mail;

/**
 发短信
 
 @param number number
 */
- (void)sendSMS:(nullable NSString *)number;

/**
 打电话
 
 @param number number
 */
- (void)callNumber:(nullable NSString *)number;

#pragma mark ==================================================
#pragma mark == 图片相关
#pragma mark ==================================================
/**
 返回应用的Logo图片
 
 @return Logo图片
 */
+(UIImage*_Nullable)appIconImage;

/**
 返回占位图片
 
 @return 占位图片
 */
+(UIImage*_Nullable)defaultImage;

/**
 返回占位图片
 
 @param aSize 需要多大的图片
 @return 占位图片
 */
+(UIImage*_Nullable)defaultImage_withSize:(CGSize)aSize;


@end
