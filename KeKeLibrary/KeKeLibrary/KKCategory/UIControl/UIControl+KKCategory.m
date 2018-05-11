//
//  UIControl+KKCategory.m
//  KeKeLibrary
//
//  Created by liubo on 2018/5/11.
//  Copyright © 2018年 KKLibrary. All rights reserved.
//

#import "UIControl+KKCategory.h"
#import <objc/runtime.h>

@implementation UIControl (KKCategory)

// 因category不能添加属性，只能通过关联对象的方式。
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)kk_acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setKk_acceptEventTime:(NSTimeInterval)kk_acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(kk_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// 在load时执行hook
+ (void)load {
    Method sys_Method   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method my_Method    = class_getInstanceMethod(self, @selector(cs_sendAction:to:forEvent:));
    method_exchangeImplementations(sys_Method, my_Method);
}

- (void)cs_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    //设置1.0秒的时间间隔，一秒之内只允许点击一次
    if ([NSDate date].timeIntervalSince1970 - self.kk_acceptEventTime < 1.0) {
        return;
    }
    
    self.kk_acceptEventTime = [NSDate date].timeIntervalSince1970;

    [self cs_sendAction:action to:target forEvent:event];
}

@end
