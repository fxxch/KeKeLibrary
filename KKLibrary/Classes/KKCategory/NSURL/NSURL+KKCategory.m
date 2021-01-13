//
//  NSURL+KKCategory.m
//  YouJia
//
//  Created by liubo on 2018/7/18.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "NSURL+KKCategory.h"
#import <objc/runtime.h>
#import "NSString+KKCategory.h"

@implementation NSURL (KKCategory)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //初始化
        SEL sys_SEL_init = @selector(initWithString:);
        SEL my_SEL_init = @selector(kk_initWithString:);
        
        Method sys_Method_init   = class_getInstanceMethod(self, sys_SEL_init);
        Method my_Method_init    = class_getInstanceMethod(self, my_SEL_init);
        
        BOOL didAddMethod_init = class_addMethod([self class],
                                            sys_SEL_init,
                                            method_getImplementation(my_Method_init),
                                            method_getTypeEncoding(my_Method_init));
        
        if (didAddMethod_init) {
            class_replaceMethod([self class],
                                my_SEL_init,
                                method_getImplementation(sys_Method_init),
                                method_getTypeEncoding(sys_Method_init));
        }
        method_exchangeImplementations(sys_Method_init, my_Method_init);

        
        //类方法初始化
        SEL sys_SEL = @selector(URLWithString:);
        SEL my_SEL = @selector(kk_URLWithString:);
        
        Method sys_Method   = class_getClassMethod([self class], sys_SEL);
        Method my_Method    = class_getClassMethod([self class], my_SEL);
        
        BOOL didAddMethod = class_addMethod([self class],
                                            sys_SEL,
                                            method_getImplementation(my_Method),
                                            method_getTypeEncoding(my_Method));
        
        if (didAddMethod) {
            class_replaceMethod([self class],
                                my_SEL,
                                method_getImplementation(sys_Method),
                                method_getTypeEncoding(sys_Method));
        }
        method_exchangeImplementations(sys_Method, my_Method);
        
    });
    
}

- (nullable instancetype)kk_initWithString:(NSString*)URLString{
    
    //如果有中文字符，先进行URLEncoded
    if ([URLString isHaveChineseCharacter]) {
        return [self kk_initWithString:[URLString KKURLEncodedString]];
    }
    else{
        return [self kk_initWithString:URLString];
    }
}

+ (nullable instancetype)kk_URLWithString:(NSString*)URLString{

    NSString *resultString = nil;
    if ([URLString.lowercaseString hasPrefix:@"file:///"]) {
        resultString = URLString;
    }
    else{
        if ([URLString.lowercaseString hasPrefix:@"var/mobile/"] ||
            [URLString.lowercaseString hasPrefix:@"/var/mobile/"] ||
            [URLString.lowercaseString hasPrefix:@"users/"] ||
            [URLString.lowercaseString hasPrefix:@"/users/"]) {
            NSURL *fileURL = [NSURL fileURLWithPath:URLString];
            resultString = [fileURL absoluteString];
        }
        else {
            resultString = URLString;
        }
    }

    //如果有中文字符，先进行URLEncoded
    if ([resultString isHaveChineseCharacter]) {
        return [self kk_URLWithString:[resultString KKURLEncodedString]];
    }
    else{
        return [self kk_URLWithString:resultString];
    }
}

@end
