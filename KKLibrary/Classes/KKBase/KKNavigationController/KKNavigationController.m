//
//  KKNavigationController.m
//  LawBooksChinaiPad
//
//  Created by liubo on 13-3-26.
//  Copyright (c) 2013年 刘 波. All rights reserved.
//

#import "KKNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "KKViewController.h"

@interface KKNavigationController ()

@property (nonatomic,assign)BOOL kk_needHideStatusBarApplication;
@property (nonatomic,assign)UIStatusBarStyle kk_statusBarStyleApplication;

@end

@implementation KKNavigationController


#pragma mark ==================================================
#pragma mark == 内存相关
#pragma mark ==================================================
- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (instancetype)init{
    self = [super init];
    if (self) {
        self.kk_needHideStatusBarApplication = UIApplication.sharedApplication.statusBarHidden;
        self.kk_statusBarStyleApplication = UIApplication.sharedApplication.statusBarStyle;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    [attributes setValue:[UIFont systemFontOfSize:16]
                  forKey:NSFontAttributeName];
    
    [attributes setObject:[UIColor blackColor]
                   forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = attributes;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.viewControllers.lastObject isKindOfClass:[KKViewController class]]) {
        [(KKViewController*)self.viewControllers.lastObject setStatusBarHidden:self.kk_needHideStatusBarApplication statusBarStyle:self.kk_statusBarStyleApplication withAnimation:UIStatusBarAnimationNone];
    }
}


//是否自动旋转
//返回导航控制器的顶层视图控制器的自动旋转属性，因为导航控制器是以栈的原因叠加VC的
//topViewController是其最顶层的视图控制器，
-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

//支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

//默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden{
    return self.topViewController;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count == 1){
        return NO;
    }
    return YES;
}
@end





