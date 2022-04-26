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
#import "KKFileCacheManager.h"
#import "UIImage+KKCategory.h"

NSAttributedStringKey const NotificationThemeDidChange = @"NotificationThemeDidChange";
NSAttributedStringKey const NotificationLocalizationDidChange = @"NotificationLocalizationDidChange";

@implementation NSObject (KKCategory)


#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
/**
 监听通知
 
 @param name 通知名称
 @param selector 处理事件
 */
- (void)kk_observeNotification:(nullable NSString *)name
                      selector:(nullable SEL)selector {
    if (name && selector) {
        [self kk_unobserveNotification:name];
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
- (void)kk_unobserveNotification:(nullable NSString *)name {
    if ([NSString kk_isStringNotEmpty:name]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:name
                                                      object:nil];
    }
}

/**
 取消所有监听通知
 
 */
- (void)kk_unobserveAllNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 发送通知
 
 @param name 通知名称
 */
- (void)kk_postNotification:(nullable NSString *)name {
    if ([NSString kk_isStringNotEmpty:name]) {
        [self kk_postNotification:name object:nil];
    }
}

/**
 发送通知
 
 @param name 通知名称
 @param object 对象
 */
- (void)kk_postNotification:(nullable NSString *)name
                     object:(nullable id)object {
    if ([NSString kk_isStringNotEmpty:name]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    }
}

/**
 发送通知
 
 @param name 通知名称
 @param object 对象
 @param userInfo 信息
 */
- (void)kk_postNotification:(nullable NSString *)name
                     object:(nullable id)object
                   userInfo:(nullable NSDictionary *)userInfo {
    if ([NSString kk_isStringNotEmpty:name]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
    }
}

#pragma mark ==================================================
#pragma mark == 调用苹果系统应用的方法，打电话、发邮件、发短信、打开URL等
#pragma mark ==================================================
/**
 打开URL
 
 @param url url
 */
- (void)kk_openURL:(nullable NSURL *)url {

    NSDictionary *options = [NSDictionary dictionary];
    [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
        
    }];
}


/**
 发邮件
 
 @param mail mail
 */
- (void)kk_sendMail:(nullable NSString *)mail {
    NSString *url = [NSString stringWithFormat:@"mailto://%@", mail];
    [self kk_openURL:[NSURL URLWithString:url]];
}

/**
 发短信
 
 @param number number
 */
- (void)kk_sendSMS:(nullable NSString *)number {
    NSString *url = [NSString stringWithFormat:@"sms://%@", number];
    [self kk_openURL:[NSURL URLWithString:url]];
}

/**
 打电话
 
 @param number number
 */
- (void)kk_callNumber:(nullable NSString *)number {
    NSString *url = [NSString stringWithFormat:@"tel://%@", number];
    [self kk_openURL:[NSURL URLWithString:url]];
}


#pragma mark ==================================================
#pragma mark == 图片相关
#pragma mark ==================================================
/**
 返回应用的Logo图片

 @return Logo图片
 */
+(UIImage*)kk_appIconImage{
    NSDictionary *mainBundle_infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *CFBundleIcons = [mainBundle_infoDictionary objectForKey:@"CFBundleIcons"];
    NSDictionary *CFBundlePrimaryIcon = [CFBundleIcons objectForKey:@"CFBundlePrimaryIcon"];
    NSArray *CFBundleIconFiles = [CFBundlePrimaryIcon objectForKey:@"CFBundleIconFiles"];
    NSString *fileName = nil;
    if (CFBundleIconFiles && [CFBundleIconFiles count]>0) {
        fileName = [CFBundleIconFiles lastObject];
    }
    if (!fileName) {
        fileName = @"icon180";
    }
    
    return [UIImage imageNamed:fileName];
}


@end

