//
//  KKViewController.m
//  LawBooksChinaiPad
//
//  Created by liubo on 13-3-26.
//  Copyright (c) 2013年 刘 波. All rights reserved.
//

#import "KKViewController.h"
#import "KKUIToolbar.h"
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

@interface KKViewController ()<KKUIToolbarDelegate>{
    NSMutableDictionary *_superParmsDictionary;
}

@property (nonatomic,assign)BOOL kk_needHideStatusBar;
@property (nonatomic,assign)UIStatusBarStyle kk_statusBarStyle;
@property (nonatomic,assign)UIStatusBarAnimation kk_statusBarAnimation;

@property (nonatomic,weak)UIView *kk_beginEditeView;
@property (nonatomic,assign)CGFloat  kk_mainScrollOriginContentOffsetY;
@property (nonatomic,assign)CGSize  kk_mainScrollOriginContentSize;
@property (nonatomic,assign)CGFloat kk_keyboardHeightAlways;
@property (nonatomic,assign)CGFloat kk_keyboardAnimationTimeAlways;
@property (nonatomic,assign)CGFloat kk_keyboardHeight;
@property (nonatomic,assign)CGFloat kk_keyboardAnimationTime;

@end

@implementation KKViewController
@synthesize superParmsDictionary = _superParmsDictionary;

#pragma mark ==================================================
#pragma mark == 内存相关
#pragma mark ==================================================
- (void)dealloc{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self postNotification:NotificationName_ViewControllerWillDealloc object:self];
    [KKFileCacheManager deleteCacheDataInCacheDirectory:NSStringFromClass([self class])];
    [KKFileCacheManager deleteCacheDirectory:NSStringFromClass([self class])];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.autoProceeKeyboard = YES;
        self.endEditingWhenTouchBackground = YES;
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
        
        self.autoProceeKeyboard = YES;
        self.endEditingWhenTouchBackground = YES;
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
    [self forceCloseDarkStyle];
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
#pragma mark == 点击背景关闭键盘
#pragma mark ==================================================
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (_endEditingWhenTouchBackground) {
        [self.view endEditing:YES];
    }
}

#pragma mark ============================================================
#pragma mark == 边缘返回
#pragma mark ============================================================
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

- (void)handleNotification:(NSString *)name object:(id)obejct userInfo:(NSDictionary *)userInfo {
    if ([name isEqualToString:NotificationThemeDidChange]) {
        if ([self respondsToSelector:@selector(changeTheme)]) {
            [self changeTheme];
        }
    } else if ([name isEqualToString:NotificationLocalizationDidChange]) {
        if ([self respondsToSelector:@selector(changeLocalization)]) {
            [self changeLocalization];
        }
    }
}

#pragma mark ============================================================
#pragma mark == 导航栏
#pragma mark ============================================================
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
    [self.navigationController.navigationBar setShadowColor:[UIColor grayColor]
                                                    opacity:0.3
                                                     offset:CGSizeMake(0, 5)
                                                 blurRadius:5
                                                 shadowPath:nil];
}

/**
 关闭导航条的阴影，可以在 [super viewWillAppear:animated];之后调用
 */
- (void)closeNavigationBarShadow{
    [self.navigationController.navigationBar setShadowColor:[UIColor clearColor]
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


#pragma mark ============================================================
#pragma mark == 状态栏
#pragma mark ============================================================
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


#pragma mark ****************************************
#pragma mark 默认导航返回样式
#pragma mark ****************************************
- (KKButton*)showNavigationDefaultBackButton_ForNavDismiss{
    return [self setNavLeftButtonImage:KKThemeImage(@"btn_NavBack") highlightImage:nil selector:@selector(navigationControllerDismiss)];
}

- (KKButton*)showNavigationDefaultBackButton_ForNavPopBack{
    return [self setNavLeftButtonImage:KKThemeImage(@"btn_NavBack") highlightImage:nil selector:@selector(navigationControllerPopBack)];
}

- (KKButton*)showNavigationDefaultBackButton_ForVCDismiss{
    return [self setNavLeftButtonImage:KKThemeImage(@"btn_NavBack") highlightImage:nil selector:@selector(viewControllerDismiss)];
}

#pragma mark ****************************************
#pragma mark 返回事件
#pragma mark ****************************************
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

#pragma mark ****************************************
#pragma mark 设置导航
#pragma mark ****************************************
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
    if ([UIDevice isSystemVersionBigerThan:@"11.0"]) {
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
    CGSize size = [title sizeWithFont:KKNavigationBarButtonTitleFont maxWidth:KKApplicationWidth];
    
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
    if ([UIDevice isSystemVersionBigerThan:@"11.0"]) {
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
    if ([UIDevice isSystemVersionBigerThan:@"11.0"]) {
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
    CGSize size = [title sizeWithFont:KKNavigationBarButtonTitleFont maxWidth:KKApplicationWidth];
    
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
    if ([UIDevice isSystemVersionBigerThan:@"11.0"]) {
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
    if ([UIDevice isSystemVersionBigerThan:@"11.0"]) {
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
    if ([UIDevice isSystemVersionBigerThan:@"11.0"]) {
        //        negativeSeperator.width = -22;
    }
    else{
        negativeSeperator.width = 0;
    }
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
    return button;
}


#pragma mark ****************************************
#pragma mark Keyboard 监听
#pragma mark ****************************************
- (void)addKeyboardNotification{
    
    [self removeKeyboardNotification];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    
    //监听键盘高度的变换
    [defaultCenter addObserver:self
                      selector:@selector(kk_UIKeyboardWillShowNotification:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(kk_UIKeyboardWillHideNotification:)
                          name:UIKeyboardWillHideNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(kk_UIKeyboardWillChangeFrameNotification:)
                          name:UIKeyboardWillChangeFrameNotification
                        object:nil];
    
    if (self.autoProceeKeyboard) {
        //UITextField、UITextView
        [defaultCenter addObserver:self
                          selector:@selector(kk_textFieldViewDidBeginEditing:)
                              name:UITextFieldTextDidBeginEditingNotification
                            object:nil];
        [defaultCenter addObserver:self
                          selector:@selector(kk_textFieldViewDidEndEditing:)
                              name:UITextFieldTextDidEndEditingNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(kk_textFieldViewDidBeginEditing:)
                              name:UITextViewTextDidBeginEditingNotification
                            object:nil];
        [defaultCenter addObserver:self
                          selector:@selector(kk_textFieldViewDidEndEditing:)
                              name:UITextViewTextDidEndEditingNotification
                            object:nil];
    }
}

- (void)removeKeyboardNotification{
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    //监听键盘高度的变换
    [defaultCenter removeObserver:self
                             name:UIKeyboardWillShowNotification object:nil];
    
    [defaultCenter removeObserver:self
                             name:UIKeyboardWillHideNotification object:nil];
    
    [defaultCenter removeObserver:self
                             name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (self.autoProceeKeyboard) {
        //UITextField、UITextView
        [defaultCenter removeObserver:self
                                 name:UITextFieldTextDidBeginEditingNotification
                               object:nil];
        
        [defaultCenter removeObserver:self
                                 name:UITextFieldTextDidEndEditingNotification
                               object:nil];
        
        [defaultCenter removeObserver:self
                                 name:UITextViewTextDidBeginEditingNotification
                               object:nil];
        
        [defaultCenter removeObserver:self
                                 name:UITextViewTextDidEndEditingNotification
                               object:nil];
    }
}

- (void)kk_UIKeyboardWillShowNotification:(NSNotification*)aNotice{
    [self keyboardWillShow:aNotice];
}

- (void)kk_UIKeyboardWillChangeFrameNotification:(NSNotification*)aNotice{
    [self keyboardWillShow:aNotice];
}

- (void)kk_UIKeyboardWillHideNotification:(NSNotification*)aNotice{
    [self keyboardWillHide:aNotice];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    keyboradAnimationDuration = animationDuration;//键盘两种高度 216  252
    
    [self keyboardWillShowWithAnimationDuration:animationDuration keyBoardRect:keyboardRect];
}

- (void)keyboardWillShowWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect{
    
    if (self.autoProceeKeyboard==NO) {
        return;
    }
    
    self.kk_keyboardHeightAlways = keyBoardRect.size.height;
    self.kk_keyboardAnimationTimeAlways = animationDuration;
    
    if (_kk_beginEditeView==nil) {
        self.kk_keyboardHeight = keyBoardRect.size.height;
        self.kk_keyboardAnimationTime = animationDuration;
        return;
    }
    else{
        self.kk_keyboardHeight = 0;
        self.kk_keyboardAnimationTime = 0;
    }
    
    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:_kk_beginEditeView];
    if (mainScrollView==nil) {
        return;
    }
    
    if (CGSizeEqualToSize(self.kk_mainScrollOriginContentSize, CGSizeZero)) {
        if (CGSizeEqualToSize(mainScrollView.contentSize, CGSizeZero)) {
            self.kk_mainScrollOriginContentSize = mainScrollView.frame.size;
        }
    }
    
    self.kk_mainScrollOriginContentOffsetY = mainScrollView.contentOffset.y;
    
    CGFloat selfViewHeight = self.view.frame.size.height;
    
    CGRect scrollViewRectToSelfView = [mainScrollView convertRect:mainScrollView.bounds toView:self.view];
    //本身键盘就没有挡住scrollView，更不可能挡住输入源，所以可以不用处理
    if (scrollViewRectToSelfView.origin.y+scrollViewRectToSelfView.size.height < (selfViewHeight-keyBoardRect.size.height)) {
        return;
    }
    
    //键盘弹出完全挡住了ScrollView本身，这时候随便怎么设置scrollView的contentOffset也无济于事
    if (scrollViewRectToSelfView.origin.y+scrollViewRectToSelfView.size.height < (selfViewHeight-keyBoardRect.size.height)) {
        return;
    }
    
    //本身键盘就没有挡住输入源，可以不用处理
    CGRect beginEditeViewRectToSelfView = [_kk_beginEditeView convertRect:_kk_beginEditeView.bounds toView:self.view];
    if (beginEditeViewRectToSelfView.origin.y+_kk_beginEditeView.frame.size.height<(selfViewHeight-keyBoardRect.size.height)) {
        return;
    }
    //键盘挡住了部分scrollView,但输入源刚好在没有挡住那部分，可以不用处理
    if ( beginEditeViewRectToSelfView.origin.y +  _kk_beginEditeView.frame.size.height + keyBoardRect.size.height-selfViewHeight<=0){
        return;
    }
    
    CGRect frame00 = [_kk_beginEditeView convertRect:_kk_beginEditeView.bounds toView:mainScrollView];
    
    CGFloat newContentOffsetY = scrollViewRectToSelfView.origin.y +
    frame00.origin.y +
    _kk_beginEditeView.frame.size.height +
    keyBoardRect.size.height -
    selfViewHeight+10;
    
    if (mainScrollView.contentOffset.y<newContentOffsetY) {
        [mainScrollView setContentOffset:CGPointMake(0, MAX(newContentOffsetY, 0)) animated:YES];
    }
    
    CGSize contentSize = self.kk_mainScrollOriginContentSize;
    contentSize.height = contentSize.height + self.kk_keyboardHeightAlways+10;
    mainScrollView.contentSize = contentSize;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self keyboardWillHideWithAnimationDuration:animationDuration keyBoardRect:keyboardRect];
}

- (void)keyboardWillHideWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect{
    if (self.autoProceeKeyboard==NO) {
        return;
    }
    
    if (self.kk_beginEditeView==nil) {
        return;
    }
    
    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:self.kk_beginEditeView];
    if (mainScrollView==nil) {
        return;
    }
    
    mainScrollView.contentSize = self.kk_mainScrollOriginContentSize;
    
//    if (mainScrollView.contentOffset.y+mainScrollView.frame.size.height>mainScrollView.contentSize.height) {
//        CGFloat newContentOffsetY = MAX(mainScrollView.contentSize.height-mainScrollView.frame.size.height, 0);
//        [mainScrollView setContentOffset:CGPointMake(0, newContentOffsetY) animated:YES];
//    }
    
    [mainScrollView setContentOffset:CGPointMake(0, self.kk_mainScrollOriginContentOffsetY) animated:YES];

    self.kk_mainScrollOriginContentOffsetY = 0;
    self.kk_mainScrollOriginContentSize = CGSizeZero;
    self.kk_beginEditeView = nil;
}

- (void)kk_textFieldViewDidBeginEditing:(NSNotification*)aNotice{
    self.kk_beginEditeView = aNotice.object;
    
    if (self.kk_keyboardHeight>1) {
        [self keyboardWillShowWithAnimationDuration:self.kk_keyboardAnimationTime keyBoardRect:CGRectMake(0, 0, KKApplicationWidth, self.kk_keyboardHeight)];
    }
    
    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:self.kk_beginEditeView];
    if ([mainScrollView isKindOfClass:[UITableView class]]) {
        [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_None delegate:self targetView:self.kk_beginEditeView];
    }
    else{
        NSMutableArray *array = [NSMutableArray array];
        
        for (UIView *subView in [mainScrollView subviews]) {
            if (([subView isKindOfClass:[UITextView class]] && [(UITextView*)subView isEditable]) ||
                ([subView isKindOfClass:[UITextField class]] && [(UITextField*)subView isUserInteractionEnabled]) ) {
                                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                [dic setObject:subView forKey:@"view"];
                NSString *frameKey = [NSString stringWithFormat:@"%4ld_%4ld",(long)subView.frame.origin.y,(long)subView.frame.origin.x];
                [dic setObject:frameKey forKey:@"frame"];
                
                [array addObject:dic];
            }
        }
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"frame" ascending:YES]];
        [array sortUsingDescriptors:sortDescriptors];
        
        if ([array count]<=1) {
            [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_None delegate:self targetView:self.kk_beginEditeView];
        }
        else{
            for (NSInteger i=0; i<[array count]; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                UIView *view = [dic objectForKey:@"view"];
                if (view==self.kk_beginEditeView) {
                    if (i==[array count]-1) {
                        [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_PreviousYES_NextNO delegate:self targetView:self.kk_beginEditeView];
                    }
                    else if (i==0){
                        [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_PreviousNO_NextYES delegate:self targetView:self.kk_beginEditeView];
                    }
                    else{
                        [KKUIToolbar toolBarForStyle:KKUIToolbarStyle_PreviousYES_NextYES delegate:self targetView:self.kk_beginEditeView];
                    }
                    break;
                }
            }
        }
    }
    
}

- (void)kk_textFieldViewDidEndEditing:(NSNotification*)aNotice{
    
}

- (void)KKUIToolbar_PreviousButtonClicked:(KKUIToolbar*)aToolbar{
    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:self.kk_beginEditeView];
    
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *subView in [mainScrollView subviews]) {
        if ([subView isKindOfClass:[UITextView class]] ||
            [subView isKindOfClass:[UITextField class]] ) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic setObject:subView forKey:@"view"];
            NSString *frameKey = [NSString stringWithFormat:@"%4ld_%4ld",(long)subView.frame.origin.y,(long)subView.frame.origin.x];
            [dic setObject:frameKey forKey:@"frame"];
            
            [array addObject:dic];
        }
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"frame" ascending:YES]];
    [array sortUsingDescriptors:sortDescriptors];
    
    UIView *viewPrevious = nil;
    for (NSInteger i=0; i<[array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        UIView *view = [dic objectForKey:@"view"];
        if (view==self.kk_beginEditeView) {
            NSDictionary *dic0 = [array objectAtIndex:i-1];
            viewPrevious = [dic0 objectForKey:@"view"];
            [viewPrevious becomeFirstResponder];
            break;
        }
    }
}

- (void)KKUIToolbar_NextButtonClicked:(KKUIToolbar*)aToolbar{
    UIScrollView *mainScrollView = [self kk_superScrollViewOfView:self.kk_beginEditeView];
    
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *subView in [mainScrollView subviews]) {
        if ([subView isKindOfClass:[UITextView class]] ||
            [subView isKindOfClass:[UITextField class]] ) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            [dic setObject:subView forKey:@"view"];
            NSString *frameKey = [NSString stringWithFormat:@"%4ld_%4ld",(long)subView.frame.origin.y,(long)subView.frame.origin.x];
            [dic setObject:frameKey forKey:@"frame"];
            
            [array addObject:dic];
        }
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"frame" ascending:YES]];
    [array sortUsingDescriptors:sortDescriptors];
    
    UIView *viewPrevious = nil;
    for (NSInteger i=0; i<[array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        UIView *view = [dic objectForKey:@"view"];
        if (view==self.kk_beginEditeView) {
            NSDictionary *dic0 = [array objectAtIndex:i+1];
            viewPrevious = [dic0 objectForKey:@"view"];
            [viewPrevious becomeFirstResponder];
            break;
        }
    }
}

- (void)KKUIToolbar_DoneButtonClicked:(KKUIToolbar*)aToolbar{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (UIScrollView*)kk_superScrollViewOfView:(UIView*)aView{
    
    UIScrollView *superScrollView = nil;
    
    UIView *superview = aView.superview;
    
    while (superview){
        
        NSString *string = NSStringFromClass([superview class]);
        if ([string isEqualToString:@"UIScrollView"] ||
            [string isEqualToString:@"UITableView"] ||
            [string isEqualToString:@"UICollectionView"] ) {
            superScrollView = (UIScrollView*)superview;
            break;
        }
        else{
            superview = superview.superview;
        }
    }
    return superScrollView;
}


#pragma mark ****************************************
#pragma mark 屏幕方向
#pragma mark ****************************************
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
