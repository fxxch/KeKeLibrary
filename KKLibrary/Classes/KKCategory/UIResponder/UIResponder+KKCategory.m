//
//  UIResponder+KKCategory.m
//  YouJia
//
//  Created by liubo on 2018/7/18.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "UIResponder+KKCategory.h"
#import <objc/runtime.h>

@implementation UIResponder (KKCategory)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL sys_SEL = NSSelectorFromString(@"dealloc");
        SEL my_SEL = @selector(kk_dealloc);
        
        Method sys_Method   = class_getInstanceMethod(self, sys_SEL);
        Method my_Method    = class_getInstanceMethod(self, my_SEL);
        
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

- (void)kk_dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self kk_dealloc];
}

@end
