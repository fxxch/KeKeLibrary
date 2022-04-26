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
#import "KKView.h"

@implementation UIViewController (KKCategory)

+ (void)load{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //viewWillAppear
        SEL sys_SEL_viewWillAppear = @selector(viewWillAppear:);
        Method sys_Method_viewWillAppear = class_getInstanceMethod(self, sys_SEL_viewWillAppear);
        SEL my_SEL_viewWillAppear = @selector(kk_viewWillAppear:);
        Method my_Method_viewWillAppear = class_getInstanceMethod(self, my_SEL_viewWillAppear);
        BOOL didAddMethod_viewWillAppear = class_addMethod([self class],
                                                           sys_SEL_viewWillAppear,
                                                           method_getImplementation(my_Method_viewWillAppear),
                                                           method_getTypeEncoding(my_Method_viewWillAppear));
        
        if (didAddMethod_viewWillAppear) {
            class_replaceMethod([self class],
                                my_SEL_viewWillAppear,
                                method_getImplementation(sys_Method_viewWillAppear),
                                method_getTypeEncoding(sys_Method_viewWillAppear));
        }
        method_exchangeImplementations(sys_Method_viewWillAppear, my_Method_viewWillAppear);

        //viewDidAppear
        SEL sys_SEL_viewDidAppear = @selector(viewDidAppear:);
        Method sys_Method_viewDidAppear = class_getInstanceMethod(self, sys_SEL_viewDidAppear);
        SEL my_SEL_viewDidAppear = @selector(kk_viewDidAppear:);
        Method my_Method_viewDidAppear = class_getInstanceMethod(self, my_SEL_viewDidAppear);
        BOOL didAddMethod_viewDidAppear = class_addMethod([self class],
                                                           sys_SEL_viewDidAppear,
                                                           method_getImplementation(my_Method_viewDidAppear),
                                                           method_getTypeEncoding(my_Method_viewDidAppear));
        
        if (didAddMethod_viewDidAppear) {
            class_replaceMethod([self class],
                                my_SEL_viewDidAppear,
                                method_getImplementation(sys_Method_viewDidAppear),
                                method_getTypeEncoding(sys_Method_viewDidAppear));
        }
        method_exchangeImplementations(sys_Method_viewDidAppear, my_Method_viewDidAppear);

        //viewWillDisappear
        SEL sys_SEL_viewWillDisappear = @selector(viewWillDisappear:);
        Method sys_Method_viewWillDisappear = class_getInstanceMethod(self, sys_SEL_viewWillDisappear);
        SEL my_SEL_viewWillDisappear = @selector(kk_viewWillDisappear:);
        Method my_Method_viewWillDisappear = class_getInstanceMethod(self, my_SEL_viewWillDisappear);
        BOOL didAddMethod_viewWillDisappear = class_addMethod([self class],
                                                          sys_SEL_viewWillDisappear,
                                                          method_getImplementation(my_Method_viewWillDisappear),
                                                          method_getTypeEncoding(my_Method_viewWillDisappear));
        
        if (didAddMethod_viewWillDisappear) {
            class_replaceMethod([self class],
                                my_SEL_viewWillDisappear,
                                method_getImplementation(sys_Method_viewWillDisappear),
                                method_getTypeEncoding(sys_Method_viewWillDisappear));
        }
        method_exchangeImplementations(sys_Method_viewWillDisappear, my_Method_viewWillDisappear);

        //viewDidDisappear
        SEL sys_SEL_viewDidDisappear = @selector(viewDidDisappear:);
        Method sys_Method_viewDidDisappear = class_getInstanceMethod(self, sys_SEL_viewDidDisappear);
        SEL my_SEL_viewDidDisappear = @selector(kk_viewDidDisappear:);
        Method my_Method_viewDidDisappear = class_getInstanceMethod(self, my_SEL_viewDidDisappear);
        BOOL didAddMethod_viewDidDisappear = class_addMethod([self class],
                                                          sys_SEL_viewDidDisappear,
                                                          method_getImplementation(my_Method_viewDidDisappear),
                                                          method_getTypeEncoding(my_Method_viewDidDisappear));
        
        if (didAddMethod_viewDidDisappear) {
            class_replaceMethod([self class],
                                my_SEL_viewDidDisappear,
                                method_getImplementation(sys_Method_viewDidDisappear),
                                method_getTypeEncoding(sys_Method_viewDidDisappear));
        }
        method_exchangeImplementations(sys_Method_viewDidDisappear, my_Method_viewDidDisappear);

//        //presentViewController:animated:completion:
//        SEL sys_SEL_presentViewController = @selector(presentViewController:animated:completion:);
//        Method sys_Method_presentViewController = class_getInstanceMethod(self, sys_SEL_presentViewController);
//        SEL my_SEL_presentViewController = @selector(kk_presentViewController:animated:completion:);
//        Method my_Method_presentViewController = class_getInstanceMethod(self, my_SEL_presentViewController);
//        BOOL didAddMethod_presentViewController = class_addMethod([self class],
//                                                          sys_SEL_presentViewController,
//                                                          method_getImplementation(my_Method_presentViewController),
//                                                          method_getTypeEncoding(my_Method_presentViewController));
//
//        if (didAddMethod_presentViewController) {
//            class_replaceMethod([self class],
//                                my_SEL_presentViewController,
//                                method_getImplementation(sys_Method_presentViewController),
//                                method_getTypeEncoding(sys_Method_presentViewController));
//        }
//        method_exchangeImplementations(sys_Method_presentViewController, my_Method_presentViewController);
    });
}

- (void)kk_viewWillAppear:(BOOL)animated{
    [self kk_viewWillAppear:animated];

    for (UIView *subView in [self.view subviews]) {
        if ([subView isKindOfClass:[KKView class]] &&
            subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewWillAppear:)]) {
            [subView viewWillAppear:animated];
        }
    }
}

- (void)kk_viewDidAppear:(BOOL)animated{
    [self kk_viewDidAppear:animated];
    
    for (UIView *subView in [self.view subviews]) {
        if ([subView isKindOfClass:[KKView class]] &&
            subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewDidAppear:)]) {
            [subView viewDidAppear:animated];
        }
    }
}

- (void)kk_viewWillDisappear:(BOOL)animated{
    [self kk_viewWillDisappear:animated];
    
    for (UIView *subView in [self.view subviews]) {
        if ([subView isKindOfClass:[KKView class]] &&
            subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewWillDisappear:)]) {
            [subView viewWillDisappear:animated];
        }
    }
}

- (void)kk_viewDidDisappear:(BOOL)animated{
    [self kk_viewDidDisappear:animated];
    
    for (UIView *subView in [self.view subviews]) {
        if ([subView isKindOfClass:[KKView class]] &&
            subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewDidDisappear:)]) {
            [subView viewDidDisappear:animated];
        }
    }
}

//- (void)kk_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
//    viewControllerToPresent.modalPresentationStyle =  UIModalPresentationFullScreen;
//    [self kk_presentViewController:viewControllerToPresent animated:flag completion:completion];
//}

- (void)kk_fullPresentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion{
    viewControllerToPresent.modalPresentationStyle =  UIModalPresentationFullScreen;
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
