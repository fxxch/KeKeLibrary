//
//  UIControl+KKCategory.m
//  KKLibrary
//
//  Created by liubo on 2018/5/11.
//  Copyright © 2018年 KKLibrary. All rights reserved.
//

#import "UIControl+KKCategory.h"
#import <objc/runtime.h>

@implementation UIControl (KKCategory)

// 因category不能添加属性，只能通过关联对象的方式。
- (NSTimeInterval)kk_acceptEventTime {
    return  [objc_getAssociatedObject(self, @"UIControl_acceptEventTime") doubleValue];
}

- (void)setKk_acceptEventTime:(NSTimeInterval)kk_acceptEventTime {
    objc_setAssociatedObject(self, @"UIControl_acceptEventTime", @(kk_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// 在load时执行hook
+ (void)load {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        SEL sys_SEL = @selector(sendAction:to:forEvent:);
        SEL my_SEL = @selector(cs_sendAction:to:forEvent:);

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

- (void)cs_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    //设置1.0秒的时间间隔，一秒之内只允许点击一次
//    CGFloat time1 = [NSDate date].timeIntervalSince1970;
//    CGFloat time2 = self.kk_acceptEventTime;
//
//    if (time1 - time2  < 1.0) {
//        return;
//    }
    
//    self.kk_acceptEventTime = [NSDate date].timeIntervalSince1970;

    [self cs_sendAction:action to:target forEvent:event];
}

@end
