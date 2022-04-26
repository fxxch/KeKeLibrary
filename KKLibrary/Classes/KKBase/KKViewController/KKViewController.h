//
//  KKViewController.h
//  LawBooksChinaiPad
//
//  Created by liubo on 13-3-26.
//  Copyright (c) 2013年 刘 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKButton;

@interface UINavigationController (StatusBar)

@end



UIKIT_EXTERN NSNotificationName const NotificationName_ViewControllerWillDealloc;


@interface KKViewController : UIViewController

@property (nonatomic,strong)NSMutableDictionary *superParmsDictionary;

/**
 初始化
 @param aParms 初始化需要的参数
 @return 返回实例对象
 */
- (instancetype)initWithParms:(NSDictionary*)aParms;

#pragma mark ==================================================
#pragma mark == 强制关闭黑暗模式
#pragma mark ==================================================
- (void)forceCloseDarkStyle;

#pragma mark ==================================================
#pragma mark == 边缘返回
#pragma mark ==================================================
- (void)openInteractivePopGestureRecognizer;

- (void)closeInteractivePopGestureRecognizer;

#pragma mark ==================================================
#pragma mark == StatusBar
#pragma mark ==================================================
- (void)setStatusBarHidden:(BOOL)hidden;

- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;

- (void)setStatusBarHidden:(BOOL)hidden
            statusBarStyle:(UIStatusBarStyle)barStyle
             withAnimation:(UIStatusBarAnimation)animation;

#pragma mark ==================================================
#pragma mark == Back Event
#pragma mark ==================================================
- (void)navigationControllerDismiss;

- (void)navigationControllerPopBack;

- (void)viewControllerDismiss;

#pragma mark ==================================================
#pragma mark == NavigationBar UI
#pragma mark ==================================================
/* 子类可重写该方法，不重写的话默认是白色 */
- (UIColor*)kk_DefaultNavigationBarBackgroundColor;

/**
 打开导航条的阴影，可以在 [super viewWillAppear:animated];之后调用
 */
- (void)openNavigationBarShadow;

/**
 关闭导航条的阴影，可以在 [super viewWillAppear:animated];之后调用
 */
- (void)closeNavigationBarShadow;

- (void)closeNavigationBarTranslucent;

- (void)openNavigationBarTranslucent;

#pragma mark ==================================================
#pragma mark == NavigationBar Button
#pragma mark ==================================================
- (KKButton*)setNavLeftButtonImage:(UIImage *)image
                    highlightImage:(UIImage *)highlightImage
                          selector:(SEL)selecter;

- (KKButton*)setNavLeftButtonTitle:(NSString *)title
                        titleColor:(UIColor *)tColor
                          selector:(SEL)selecter;

- (KKButton*)setNavLeftButtonTitle:(NSString *)title
                          selector:(SEL)selecter;

- (KKButton*)setNavRightButtonImage:(UIImage *)image
                     highlightImage:(UIImage *)highlightImage
                           selector:(SEL)selecter;

- (KKButton*)setNavRightButtonTitle:(NSString *)title
                         titleColor:(UIColor *)tColor
                           selector:(SEL)selecter;

- (KKButton*)setNavRightButtonTitle:(NSString *)title
                           selector:(SEL)selecter;

- (KKButton*)setNavLeftButtonForFixedSpaceWithSize:(CGSize)size;

- (KKButton*)setNavRightButtonForFixedSpaceWithWithSize:(CGSize)size;



@end
