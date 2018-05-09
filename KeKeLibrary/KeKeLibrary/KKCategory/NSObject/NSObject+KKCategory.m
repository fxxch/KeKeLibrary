//
//  NSObject+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSObject+KKCategory.h"
#import <objc/runtime.h>
#import "NSString+KKCategory.h"

NSString * const NotificaitonThemeDidChange = @"NotificaitonThemeDidChange";
NSString * const NotificaitonLocalizationDidChange = @"NotificaitonLocalizationDidChange";

@implementation NSObject (KKCategory)

+ (void)load{

    Method sys_Method = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method my_Method = class_getInstanceMethod(self, @selector(kk_dealloc));
    
    method_exchangeImplementations(sys_Method, my_Method);

}

- (void)kk_dealloc{
#ifdef DEBUG
    NSLog(@"class:%@ 释放了",[self class]);
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
/**
 监听通知
 
 @param name 通知名称
 @param selector 处理事件
 */
- (void)observeNotificaiton:(nullable NSString *)name
                   selector:(nullable SEL)selector {
    if (name && selector) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:selector
                                                     name:name
                                                   object:nil];
    }
}


/**
 取消监听通知
 
 @param name 通知名称
 */
- (void)unobserveNotification:(nullable NSString *)name {
    if ([NSString isStringNotEmpty:name]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:name
                                                      object:nil];
    }
}

/**
 取消所有监听通知
 
 */
- (void)unobserveAllNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 发送通知
 
 @param name 通知名称
 */
- (void)postNotification:(nullable NSString *)name {
    if ([NSString isStringNotEmpty:name]) {
        [self postNotification:name object:nil];
    }
}

/**
 发送通知
 
 @param name 通知名称
 @param object 对象
 */
- (void)postNotification:(nullable NSString *)name
                  object:(nullable id)object {
    if ([NSString isStringNotEmpty:name]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    }
}

/**
 发送通知
 
 @param name 通知名称
 @param object 对象
 @param userInfo 信息
 */
- (void)postNotification:(nullable NSString *)name
                  object:(nullable id)object
                userInfo:(nullable NSDictionary *)userInfo {
    if ([NSString isStringNotEmpty:name]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
    }
}

#pragma mark ==================================================
#pragma mark == 主题通知
#pragma mark ==================================================
/**
 监听主题修改通知
 */
- (void)observeThemeChangeNotificaiton {
    [self changeTheme];
    [self observeNotificaiton:NotificaitonThemeDidChange selector:@selector(changeTheme)];
}

/**
 取消监听主题修改通知
 */
- (void)unobserveThemeChangeNotificaiton {
    [self unobserveNotification:NotificaitonThemeDidChange];
}

/**
 主题修改
 */
- (void)changeTheme {
    //在ViewController、view中重写
}

#pragma mark ==================================================
#pragma mark == 语言通知
#pragma mark ==================================================
/**
 监听语言修改通知
 */
- (void)observeLocalizationChangeNotification {
    [self changeLocalization];
    [self observeNotificaiton:NotificaitonLocalizationDidChange selector:@selector(changeLocalization)];
}

/**
 取消监听语言修改通知
 */
- (void)unobserveLocalizationChangeNotification {
    [self unobserveNotification:NotificaitonLocalizationDidChange];
}

/**
 语言修改
 */
- (void)changeLocalization {
    //在ViewController、view中重写
}


#pragma mark ==================================================
#pragma mark == 调用苹果系统应用的方法，打电话、发邮件、发短信、打开URL等
#pragma mark ==================================================
/**
 打开URL
 
 @param url url
 */
- (void)openURL:(nullable NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}


/**
 发邮件
 
 @param mail mail
 */
- (void)sendMail:(nullable NSString *)mail {
    NSString *url = [NSString stringWithFormat:@"mailto://%@", mail];
    [self openURL:[NSURL URLWithString:url]];
}

/**
 发短信
 
 @param number number
 */
- (void)sendSMS:(nullable NSString *)number {
    NSString *url = [NSString stringWithFormat:@"sms://%@", number];
    [self openURL:[NSURL URLWithString:url]];
}

/**
 打电话
 
 @param number number
 */
- (void)callNumber:(nullable NSString *)number {
    NSString *url = [NSString stringWithFormat:@"tel://%@", number];
    [self openURL:[NSURL URLWithString:url]];
}



@end

