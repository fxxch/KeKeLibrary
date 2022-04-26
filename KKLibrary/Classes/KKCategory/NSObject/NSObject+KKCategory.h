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
- (void)kk_observeNotification:(nullable NSString *)name
                      selector:(nullable SEL)selector;


/**
 取消监听通知
 
 @param name 通知名称
 */
- (void)kk_unobserveNotification:(nullable NSString *)name;

/**
 取消所有监听通知
 
 */
- (void)kk_unobserveAllNotification;

/**
 发送通知
 
 @param name 通知名称
 */
- (void)kk_postNotification:(nullable NSString *)name;

/**
 发送通知
 
 @param name 通知名称
 @param object 对象
 */
- (void)kk_postNotification:(nullable NSString *)name
                     object:(nullable id)object;

/**
 发送通知
 
 @param name 通知名称
 @param object 对象
 @param userInfo 信息
 */
- (void)kk_postNotification:(nullable NSString *)name
                     object:(nullable id)object
                   userInfo:(nullable NSDictionary *)userInfo;

#pragma mark ==================================================
#pragma mark == 调用苹果系统应用的方法，打电话、发邮件、发短信、打开URL等
#pragma mark ==================================================
/**
 打开URL
 
 @param url url
 */
- (void)kk_openURL:(nullable NSURL *)url;


/**
 发邮件
 
 @param mail mail
 */
- (void)kk_sendMail:(nullable NSString *)mail;

/**
 发短信
 
 @param number number
 */
- (void)kk_sendSMS:(nullable NSString *)number;

/**
 打电话
 
 @param number number
 */
- (void)kk_callNumber:(nullable NSString *)number;

#pragma mark ==================================================
#pragma mark == 图片相关
#pragma mark ==================================================
/**
 返回应用的Logo图片
 
 @return Logo图片
 */
+(UIImage*_Nullable)kk_appIconImage;


@end
