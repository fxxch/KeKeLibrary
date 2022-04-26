//
//  KKViewController.m
//  LawBooksChinaiPad
//
//  Created by liubo on 13-3-26.
//  Copyright (c) 2013年 刘 波. All rights reserved.
//

#import "KKViewController.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KKLibraryDefine.h"
#import "KLTNavigationController.h"
#import "KKButton.h"

#define KKNavigationBarButtonTitleFont [UIFont systemFontOfSize:14]

@implementation UINavigationController (StatusBar)

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden{
    return self.topViewController;
}

@end

NSNotificationName const NotificationName_ViewControllerWillDealloc = @"NotificationName_ViewControllerWillDealloc";

@interface KKViewController (){
    NSMutableDictionary *_superParmsDictionary;
}

@property (nonatomic,assign)BOOL kk_needHideStatusBar;
@property (nonatomic,assign)UIStatusBarStyle kk_statusBarStyle;
@property (nonatomic,assign)UIStatusBarAnimation kk_statusBarAnimation;

@end

@implementation KKViewController
@synthesize superParmsDictionary = _superParmsDictionary;

#pragma mark ==================================================
#pragma mark == 内存相关
#pragma mark ==================================================
- (void)dealloc{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self kk_postNotification:NotificationName_ViewControllerWillDealloc object:self];
    [KKFileCacheManager deleteCacheDataInCacheDirectory:NSStringFromClass([self class])];
    [KKFileCacheManager deleteCacheDirectory:NSStringFromClass([self class])];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.kk_statusBarStyle = UIStatusBarStyleDefault;
        self.kk_statusBarAnimation = UIStatusBarAnimationFade;
        self.kk_needHideStatusBar = NO;
    }
    return self;
}

/**
 初始化
 @param aParms 初始化需要的参数
 @return 返回实例对象
 */
- (instancetype)initWithParms:(NSDictionary*)aParms{
    self = [super init];
    if (self) {
        _superParmsDictionary = [[NSMutableDictionary alloc] init];
        [_superParmsDictionary setValuesForKeysWithDictionary:aParms];
        
        /* 子类重写此方法，根据传入的参数是否满足要求，判断是否创建成功 */
        //        NSString *axxx = [aParms objectForKey:@"aParms"];
        //        if (!axxx) {
        //            return nil;
        //        }
        //        else{
        //            return self;
        //        }
        
        self.kk_statusBarStyle = UIStatusBarStyleDefault;
        self.kk_statusBarAnimation = UIStatusBarAnimationFade;
        self.kk_needHideStatusBar = NO;
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (void)viewDidLoad{
    [super viewDidLoad];
    [self closeNavigationBarTranslucent];
    [self openInteractivePopGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self kk_initNavigatonBarUI];
//    [self forceCloseDarkStyle];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setStatusBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkInteractivePopGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark ==================================================
#pragma mark == 强制关闭黑暗模式
#pragma mark ==================================================
- (void)forceCloseDarkStyle{
    // 强制关闭暗黑模式
#if defined(__IPHONE_13_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if(@available(iOS 13.0,*)){
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
}

#pragma mark ==================================================
#pragma mark == 边缘返回
#pragma mark ==================================================
- (void)checkInteractivePopGestureRecognizer{
    if ([self.navigationController.viewControllers count]>0 &&
        [self.navigationController.viewControllers objectAtIndex:0]==self) {
        [self closeInteractivePopGestureRecognizer];
    }
    else{
        [self openInteractivePopGestureRecognizer];
    }
}

- (void)openInteractivePopGestureRecognizer{
    //    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if ([self.navigationController isKindOfClass:[KLTNavigationController class]]) {
        ((KLTNavigationController*)self.navigationController).panGestureRec.enabled = YES;
    }
    
}

- (void)closeInteractivePopGestureRecognizer{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if ([self.navigationController isKindOfClass:[KLTNavigationController class]]) {
        ((KLTNavigationController*)self.navigationController).panGestureRec.enabled = NO;
    }
    //    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

#pragma mark ==================================================
#pragma mark == 状态栏
#pragma mark ==================================================
/* 外部调用接口方法 */
- (void)setStatusBarHidden:(BOOL)hidden{
    [self setStatusBarHidden:hidden statusBarStyle:UIApplication.sharedApplication.statusBarStyle withAnimation:UIStatusBarAnimationNone];
}

- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation{
    [self setStatusBarHidden:hidden statusBarStyle:UIApplication.sharedApplication.statusBarStyle withAnimation:animation];
}

- (void)setStatusBarHidden:(BOOL)hidden
            statusBarStyle:(UIStatusBarStyle)barStyle
             withAnimation:(UIStatusBarAnimation)animation{
    self.kk_needHideStatusBar = hidden;
    self.kk_statusBarStyle = barStyle;
    self.kk_statusBarAnimation = animation;
    [self prefersStatusBarHidden];
    [self setNeedsStatusBarAppearanceUpdate];
    UIApplication.sharedApplication.statusBarStyle = self.kk_statusBarStyle;
}

/* 重写方法 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.kk_statusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    return  self.kk_needHideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return self.kk_statusBarAnimation;
}


#pragma mark ==================================================
#pragma mark == Back Event
#pragma mark ==================================================
- (void)navigationControllerDismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)navigationControllerPopBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewControllerDismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark ==================================================
#pragma mark == NavigationBar UI
#pragma mark ==================================================
- (void)kk_initNavigatonBarUI{
    self.extendedLayoutIncludesOpaqueBars = NO;
    /*
     当 automaticallyAdjustsScrollViewInsets 为 NO 时，tableview 是从屏幕的最上边开始，也就是被 导航栏 & 状态栏覆盖
     当 automaticallyAdjustsScrollViewInsets 为 YES 时，也是默认行为，表现就比较正常了，和edgesForExtendedLayout = UIRectEdgeNone 有啥区别？ 不注意可能很难觉察， automaticallyAdjustsScrollViewInsets 为YES 时，tableView 上下滑动时，是可以穿过导航栏&状态栏的，在他们下面有淡淡的浅浅红色
     */
    //self.automaticallyAdjustsScrollViewInsets = YES;
    /*
     在IOS7以后 ViewController 开始使用全屏布局的，而且是默认的行为通常涉及到布局，就离不开这个属性 edgesForExtendedLayout，它是一个类型为UIExtendedEdge的属性，指定边缘要延伸的方向，它的默认值很自然地是UIRectEdgeAll，四周边缘均延伸，就是说，如果即使视图中上有navigationBar，下有tabBar，那么视图仍会延伸覆盖到四周的区域。因为一般为了不让tableView 不延伸到 navigationBar 下面， 属性设置为 UIRectEdgeNone
     
     这时会发现导航栏变灰了，处理如下就OK了，self.navigationController.navigationBar.translucent = NO;
     */
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIColor *navigationBarColor = [self kk_DefaultNavigationBarBackgroundColor];
    [self.navigationController.navigationBar setBarTintColor:navigationBarColor];
    [self.navigationController.navigationBar setTintColor:navigationBarColor];
    [self.navigationController.navigationBar setBackgroundColor:navigationBarColor];
    
    //    [self openNavigationBarShadow];
    [self closeNavigationBarShadow];
    
    //导航栏背景透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //导航栏底部线清除
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

/* 子类可重写该方法，不重写的话默认是白色 */
- (UIColor*)kk_DefaultNavigationBarBackgroundColor{
    return [UIColor whiteColor];
}

/**
 打开导航条的阴影，可以在 [super viewWillAppear:animated];之后调用
 */
- (void)openNavigationBarShadow{
    [self.navigationController.navigationBar kk_setShadowColor:[UIColor grayColor]
                                                       opacity:0.3
                                                        offset:CGSizeMake(0, 5)
                                                    blurRadius:5
                                                    shadowPath:nil];
}

/**
 关闭导航条的阴影，可以在 [super viewWillAppear:animated];之后调用
 */
- (void)closeNavigationBarShadow{
    [self.navigationController.navigationBar kk_setShadowColor:[UIColor clearColor]
                                                       opacity:0.3
                                                        offset:CGSizeMake(0, 5)
                                                    blurRadius:5
                                                    shadowPath:nil];
}

- (void)closeNavigationBarTranslucent{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)openNavigationBarTranslucent{
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark ==================================================
#pragma mark == NavigationBar Button
#pragma mark ==================================================
- (KKButton*)setNavLeftButtonImage:(UIImage *)image
                    highlightImage:(UIImage *)highlightImage
                          selector:(SEL)selecter{
    
    //左导航
    KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44) type:KKButtonType_ImgLeftTitleRight_Left];
    button.imageViewSize = image.size;
    button.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.spaceBetweenImgTitle = 0;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:selecter forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    button.textLabel.font = KKNavigationBarButtonTitleFont;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([UIDevice kk_isSystemVersionBigerThan:@"11.0"]) {
        //        negativeSeperator.width = -25;
    }
    else{
        negativeSeperator.width = 0;
    }
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
    
    return button;
}

- (KKButton*)setNavLeftButtonTitle:(NSString *)title
                          selector:(SEL)selecter{
    
    return [self setNavLeftButtonTitle:title titleColor:[UIColor whiteColor] selector:selecter];
}

- (KKButton*)setNavLeftButtonTitle:(NSString *)title
                        titleColor:(UIColor *)tColor
                          selector:(SEL)selecter{
    
    //左导航
    CGSize size = [title kk_sizeWithFont:KKNavigationBarButtonTitleFont maxWidth:KKApplicationWidth];
    
    KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(0, 0, size.width+10, 44) type:KKButtonType_ImgLeftTitleRight_Left];
    button.imageViewSize = CGSizeZero;
    button.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.spaceBetweenImgTitle = 0;
    [button addTarget:self action:selecter forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:tColor forState:UIControlStateNormal];
    button.textLabel.font = KKNavigationBarButtonTitleFont;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([UIDevice kk_isSystemVersionBigerThan:@"11.0"]) {
        //        negativeSeperator.width = -25;
    }
    else{
        negativeSeperator.width = 0;
    }
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
    
    //左导航
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
    else{
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTitle:nil forState:UIControlStateHighlighted];
    }
    
    return button;
}


- (KKButton*)setNavRightButtonImage:(UIImage *)image
                     highlightImage:(UIImage *)highlightImage
                           selector:(SEL)selecter{
    
    //左导航
    KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44) type:KKButtonType_ImgLeftTitleRight_Right];
    button.imageViewSize = image.size;
    button.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    button.spaceBetweenImgTitle = 0;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:selecter forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    button.textLabel.font = KKNavigationBarButtonTitleFont;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([UIDevice kk_isSystemVersionBigerThan:@"11.0"]) {
        //        negativeSeperator.width = -22;
    }
    else{
        negativeSeperator.width = 0;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
    
    return button;
}

- (KKButton*)setNavRightButtonTitle:(NSString *)title
                           selector:(SEL)selecter{
    
    return [self setNavRightButtonTitle:title titleColor:[UIColor whiteColor] selector:selecter];
}

- (KKButton*)setNavRightButtonTitle:(NSString *)title
                         titleColor:(UIColor *)tColor
                           selector:(SEL)selecter{
    //左导航
    CGSize size = [title kk_sizeWithFont:KKNavigationBarButtonTitleFont maxWidth:KKApplicationWidth];
    
    KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(0, 0, size.width+10, 44) type:KKButtonType_ImgLeftTitleRight_Right];
    button.imageViewSize = CGSizeZero;
    button.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.spaceBetweenImgTitle = 0;
    [button addTarget:self action:selecter forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:tColor forState:UIControlStateNormal];
    button.textLabel.font = KKNavigationBarButtonTitleFont;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([UIDevice kk_isSystemVersionBigerThan:@"11.0"]) {
        //        negativeSeperator.width = -22;
    }
    else{
        negativeSeperator.width = 0;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
    
    
    //左导航
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
    else{
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTitle:nil forState:UIControlStateHighlighted];
    }
    
    return button;
}

- (KKButton*)setNavLeftButtonForFixedSpaceWithSize:(CGSize)size{
    //左导航
    KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(0, 0, size.width, 44) type:KKButtonType_ImgLeftTitleRight_Left];
    button.imageViewSize = CGSizeZero;
    button.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.spaceBetweenImgTitle = 0;
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.textLabel.font = KKNavigationBarButtonTitleFont;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([UIDevice kk_isSystemVersionBigerThan:@"11.0"]) {
        //        negativeSeperator.width = -25;
    }
    else{
        negativeSeperator.width = 0;
    }
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
    
    return button;
}

- (KKButton*)setNavRightButtonForFixedSpaceWithWithSize:(CGSize)size{
    //右导航
    KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) type:KKButtonType_ImgLeftTitleRight_Right];
    button.imageViewSize = CGSizeZero;
    button.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    button.spaceBetweenImgTitle = 0;
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.textLabel.font = KKNavigationBarButtonTitleFont;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([UIDevice kk_isSystemVersionBigerThan:@"11.0"]) {
        //        negativeSeperator.width = -22;
    }
    else{
        negativeSeperator.width = 0;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
    return button;
}

#pragma mark ==================================================
#pragma mark == 屏幕方向
#pragma mark ==================================================
//1.决定当前界面是否开启自动转屏，如果返回NO，后面两个方法也不会被调用，只是会支持默认的方向
- (BOOL)shouldAutorotate {
    return YES;
}

//2.返回支持的旋转方向（当前viewcontroller支持哪些转屏方向）
//iPad设备上，默认返回值UIInterfaceOrientationMaskAllButUpSideDwon
//iPad设备上，默认返回值是UIInterfaceOrientationMaskAll
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//3.返回进入界面默认显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


@end
