//
//  KKViewController.h
//  LawBooksChinaiPad
//
//  Created by liubo on 13-3-26.
//  Copyright (c) 2013年 刘 波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (StatusBar)
- (UIStatusBarStyle)preferredStatusBarStyle;
@end


@interface KKViewController : UIViewController

@property (nonatomic,assign)BOOL autoProceeKeyboard;
@property (nonatomic,assign)BOOL endEditingWhenTouchBackground;
@property (nonatomic,strong)NSMutableDictionary *superParmsDictionary;

- (void)setStatusBarHidden:(BOOL)hidden;

- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;

- (void)setStatusBarHidden:(BOOL)hidden
            statusBarStyle:(UIStatusBarStyle)barStyle
             withAnimation:(UIStatusBarAnimation)animation;

/**
 初始化
 @param aParms 初始化需要的参数
 @return 返回实例对象
 */
- (instancetype)initWithParms:(NSDictionary*)aParms;

#pragma mark ============================================================
#pragma mark == 边缘返回
#pragma mark ============================================================
- (void)openInteractivePopGestureRecognizer;

- (void)closeInteractivePopGestureRecognizer;

#pragma mark ****************************************
#pragma mark 默认导航返回样式
#pragma mark ****************************************
- (UIButton*)showNavigationDefaultBackButton_ForNavDismiss;

- (UIButton*)showNavigationDefaultBackButton_ForNavPopBack;

- (UIButton*)showNavigationDefaultBackButton_ForVCDismiss;

#pragma mark ****************************************
#pragma mark 返回事件
#pragma mark ****************************************
- (void)navigationControllerDismiss;

- (void)navigationControllerPopBack;

- (void)viewControllerDismiss;

#pragma mark ****************************************
#pragma mark 设置导航
#pragma mark ****************************************
- (UIButton*)setNavLeftButtonImage:(UIImage *)image
                    highlightImage:(UIImage *)highlightImage
                          selector:(SEL)selecter;

- (UIButton*)setNavLeftButtonTitle:(NSString *)title
                          selector:(SEL)selecter;

- (UIButton*)setNavRightButtonImage:(UIImage *)image
                     highlightImage:(UIImage *)highlightImage
                           selector:(SEL)selecter;

- (UIButton*)setNavRightButtonTitle:(NSString *)title
                           selector:(SEL)selecter;

- (UIButton*)setNavLeftButtonForFixedSpaceWithSize:(CGSize)size;

- (UIButton*)setNavRightButtonForFixedSpaceWithWithSize:(CGSize)size;

/**
 打开导航条的阴影，可以在 [super viewWillAppear:animated];之后调用
 */
- (void)openNavigationBarShadow;

/**
 关闭导航条的阴影，可以在 [super viewWillAppear:animated];之后调用
 */
- (void)closeNavigationBarShadow;


#pragma mark ==================================================
#pragma mark == 键盘相关
#pragma mark ==================================================
/*监听键盘事件
 - (void)viewDidAppear:(BOOL)animated{
 [super viewDidAppear:animated];
 [self addKeyboardNotification];
 }
 */

- (void)addKeyboardNotification;
/*取消监听键盘事件
 - (void)viewWillDisappear:(BOOL)animated{
 [super viewWillDisappear:animated];
 [self removeKeyboardNotification];
 }
 */
- (void)removeKeyboardNotification;

/* 子类处理 */
- (void)keyboardWillShowWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect;

/* 子类处理 */
- (void)keyboardWillHideWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect;


@end
