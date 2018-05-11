//
//  UIViewController+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIViewController+KKCategory.h"
#import <objc/runtime.h>
#import "KKCategory.h"

@implementation UIViewController (KKCategory)

+ (void)load{

    Method sys_Method_viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method sys_Method_viewDidAppear = class_getInstanceMethod(self, @selector(viewDidAppear:));
    Method sys_Method_viewWillDisappear = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    Method sys_Method_viewDidDisappear = class_getInstanceMethod(self, @selector(viewDidDisappear:));
    
    Method kk_Method_viewWillAppear = class_getInstanceMethod(self, @selector(kk_viewWillAppear:));
    Method kk_Method_viewDidAppear = class_getInstanceMethod(self, @selector(kk_viewDidAppear:));
    Method kk_Method_viewWillDisappear = class_getInstanceMethod(self, @selector(kk_viewWillDisappear:));
    Method kk_Method_viewDidDisappear = class_getInstanceMethod(self, @selector(kk_viewDidDisappear:));
    
    method_exchangeImplementations(sys_Method_viewWillAppear, kk_Method_viewWillAppear);
    method_exchangeImplementations(sys_Method_viewDidAppear, kk_Method_viewDidAppear);
    method_exchangeImplementations(sys_Method_viewWillDisappear, kk_Method_viewWillDisappear);
    method_exchangeImplementations(sys_Method_viewDidDisappear, kk_Method_viewDidDisappear);
}

- (void)kk_viewWillAppear:(BOOL)animated{
    [self kk_viewWillAppear:animated];

    for (UIView *subView in [self.view subviews]) {
        if (subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewWillAppear:)]) {
            [subView viewWillAppear:animated];
        }
    }
}

- (void)kk_viewDidAppear:(BOOL)animated{
    [self kk_viewDidAppear:animated];
    
    for (UIView *subView in [self.view subviews]) {
        if (subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewDidAppear:)]) {
            [subView viewDidAppear:animated];
        }
    }
}

- (void)kk_viewWillDisappear:(BOOL)animated{
    [self kk_viewWillDisappear:animated];
    
    for (UIView *subView in [self.view subviews]) {
        if (subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewWillDisappear:)]) {
            [subView viewWillDisappear:animated];
        }
    }
}

- (void)kk_viewDidDisappear:(BOOL)animated{
    [self kk_viewDidDisappear:animated];
    
    for (UIView *subView in [self.view subviews]) {
        if (subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewDidDisappear:)]) {
            [subView viewDidDisappear:animated];
        }
    }
}

@end
