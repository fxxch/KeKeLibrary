//
//  KKAlertView.m
//  CEDongLi
//
//  Created by liubo on 15/11/1.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "KKAlertView.h"
#import "KKFileCacheManager.h"
#import "KKUserDefaultsManager.h"
#import "KKCategory.h"
#import <objc/runtime.h>
#import "KKButton.h"
#import "KKLibraryDefine.h"
#import "KKLocalizationManager.h"

#pragma mark - ==================================================
#pragma mark    其他扩展
#pragma mark   ==================================================

@interface KKAlertView_VC : UIViewController

@property (nonatomic,assign)UIStatusBarStyle statusBarStyle;

- (instancetype)initWithUIStatusBarStyle:(UIStatusBarStyle)aStyle;

@end

@implementation KKAlertView_VC

- (instancetype)initWithUIStatusBarStyle:(UIStatusBarStyle)aStyle{
    self = [super init];
    if (self) {
        self.statusBarStyle = aStyle;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.view.userInteractionEnabled = NO;
    self.view.hidden = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return self.statusBarStyle;
}

@end


#define NotificationName_ShowKKAlertView @"NotificationName_ShowKKAlertView"
#define NotificationName_HideKKAlertView @"NotificationName_HideKKAlertView"

#define KKAlertView_AllShowingViews       @"KKAlertView_AllShowingViews"

#define KKAlertView_Title         @"KKAlertView_Title"
#define KKAlertView_SubTitle      @"KKAlertView_SubTitle"
#define KKAlertView_Message       @"KKAlertView_Message"
#define KKAlertView_ButtonsArray  @"KKAlertView_ButtonsArray"

#define KKAlert_ButtonTitleFont [UIFont boldSystemFontOfSize:16]
#define KKAlert_TextMinHeight 50

static NSMutableDictionary  *KKAlertView_nowIsShowing;
static UIWindow  *KKAlertView_currentKeyWindow;

@interface KKAlertView ()<UITextViewDelegate>{
    __weak id<KKAlertViewDelegate> _myDelegate;
    Class delegateClass;

}

@property (nonatomic,strong)UIButton *backgroundBlackButton;
@property (nonatomic,strong)UIView *myBackgroundView;
@property (nonatomic,strong)UILabel *myTitleLabel;
@property (nonatomic,strong)UILabel *mySubTitleLabel;
@property (nonatomic,strong)UITextView *myMessageTextView;
@property (nonatomic,strong)NSMutableArray *buttonTitlesArray;

@property (nonatomic,weak)id<KKAlertViewDelegate> myDelegate;


@property (nonatomic,copy)NSString *myTitleString;
@property (nonatomic,copy)NSString *mySubTitleString;
@property (nonatomic,copy)NSString *myMessageString;

@property (nonatomic,copy)NSString *myShowingIdentifier;

@property (nonatomic,weak)UINavigationController *myNavigationController;

@end

@implementation KKAlertView
@synthesize myDelegate = _myDelegate;

- (void)dealloc
{

}

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (instancetype)initWithTitle:(NSString *)aTitle
                     subTitle:(NSString*)aSubTitle
                      message:(NSString *)aMessage
                     delegate:(id /**<KKAlertViewDelegate>*/)aDelegate
                 buttonTitles:(NSString *)aButtonTitles, ...
{
    
    NSMutableArray *in_buttonArray = [NSMutableArray array];
    va_list args;
    va_start(args, aButtonTitles);
    if (aButtonTitles) {
        [in_buttonArray addObject:[NSString stringWithFormat:@"%@",aButtonTitles]];
        
        NSString *otherString;
        while ( (otherString = va_arg(args, NSString*)) ) {
            //依次取得各参数
            [in_buttonArray addObject:[NSString stringWithFormat:@"%@",otherString]];
        }
    }
    va_end(args);

    /* 已经展示了一个一模一样的了，就不能再展示了 */
    if ([KKAlertView isHaveSameViewShowingWithTitle:aTitle
                                           subTitle:aSubTitle
                                            message:aMessage
                                  buttonTitlesArray:in_buttonArray]) {
        return nil;
    }
    
    return [self initWithTitle:aTitle
                      subTitle:aSubTitle
                       message:aMessage
                      delegate:aDelegate
             buttonTitlesArray:in_buttonArray];
}

- (instancetype)initWithTitle:(NSString *)aTitle
                     subTitle:(NSString*)aSubTitle
                      message:(NSString *)aMessage
                     delegate:(id /**<KKAlertViewDelegate>*/)aDelegate
            buttonTitlesArray:(NSArray *)aButtonTitlesArray
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        
        [self observeNotification:NotificationName_ShowKKAlertView selector:@selector(Notification_ShowAlertView:)];
        [self observeNotification:NotificationName_HideKKAlertView selector:@selector(Notification_HideAlertView:)];
        
        self.buttonTitlesArray = [[NSMutableArray alloc] init];
        [self.buttonTitlesArray addObjectsFromArray:aButtonTitlesArray];
        
        NSString *identifier = [KKAlertView saveShowingViewWithTitle:aTitle
                                                            subTitle:aSubTitle
                                                             message:aMessage
                                                   buttonTitlesArray:self.buttonTitlesArray];
        self.myShowingIdentifier = [[NSString alloc] initWithFormat:@"%@",identifier];
        
        //        va_list args;
        //        va_start(args, buttonTitles);
        //        if (buttonTitles) {
        //            [buttonTitlesArray addObject:[NSString stringWithFormat:@"%@",buttonTitles]];
        //
        //            NSString *otherString;
        //            while ( (otherString = va_arg(args, NSString*)) ) {
        //                //依次取得各参数
        //                [buttonTitlesArray addObject:[NSString stringWithFormat:@"%@",otherString]];
        //            }
        //        }
        //        va_end(args);
        
        [self setDelegate:aDelegate];
        self.myTitleString = aTitle;
        if (self.myTitleString == nil) {
            self.myTitleString = KKLibLocalizable_Common_Notice;
        }
        self.mySubTitleString = aSubTitle;
        self.myMessageString = aMessage;
        
        
        self.backgroundBlackButton = [[UIButton alloc] initWithFrame:self.bounds];
        self.backgroundBlackButton.backgroundColor = [UIColor blackColor];
        self.backgroundBlackButton.exclusiveTouch = YES;
        [self.backgroundBlackButton addTarget:self action:@selector(backgroundButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backgroundBlackButton];
        
        self.myBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width-100, 1000)];
        self.myBackgroundView.backgroundColor = [UIColor whiteColor];
        [self.myBackgroundView setCornerRadius:8.0];
        [self.myBackgroundView setBorderColor:[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0] width:0.5];
        self.myBackgroundView.userInteractionEnabled = YES;
        [self addSubview:self.myBackgroundView];
        
        
        //标题
        self.myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        [self.myTitleLabel clearBackgroundColor];
        self.myTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.myTitleLabel.textColor = [UIColor darkTextColor];
        self.myTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.myTitleLabel.numberOfLines = 0;
        self.myTitleLabel.text = self.myTitleString;
        [self.myBackgroundView addSubview:self.myTitleLabel];
        
        //副标题
        self.mySubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        [self.mySubTitleLabel clearBackgroundColor];
        self.mySubTitleLabel.font = [UIFont systemFontOfSize:13];
        self.mySubTitleLabel.textColor = [UIColor grayColor];
        self.mySubTitleLabel.numberOfLines = 0;
        self.mySubTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.mySubTitleLabel.text = self.mySubTitleString;
        [self.myBackgroundView addSubview:self.mySubTitleLabel];
        
        
        //文字
        self.myMessageTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        self.myMessageTextView.backgroundColor = [UIColor clearColor];
        self.myMessageTextView.delegate = self;
        self.myMessageTextView.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
        self.myMessageTextView.textAlignment = NSTextAlignmentCenter;
        self.myMessageTextView.font = [UIFont systemFontOfSize:15];
        self.myMessageTextView.text = self.myMessageString;
        [self.myBackgroundView addSubview:self.myMessageTextView];
        
        
        [self reloadUI:NO];
    }
    return self;
}


- (void)setDelegate:(id<KKAlertViewDelegate>)aDelegate{
    if (_myDelegate) {
        return;
    }
    _myDelegate = aDelegate;
    delegateClass = object_getClass(_myDelegate);
}

- (void)show{

    UIStatusBarStyle style = [UIApplication sharedApplication].statusBarStyle;
    self.rootViewController = [[KKAlertView_VC alloc] initWithUIStatusBarStyle:style];

    for (UIWindow *subWindow in [[UIApplication sharedApplication] windows]) {
        [subWindow endEditing:YES];
    }
    
//    UIWindow *window = [UIWindow currentKeyWindow];
//    [window resignFirstResponder];
//    [window addSubview:self];
    
    [self postNotification:NotificationName_HideKKAlertView object:self.myShowingIdentifier];

    CGFloat selfAlpha = 0.5;
//    if ([[UIWindow currentKeyWindow] isKindOfClass:[self class]]) {
//        selfAlpha = 0;
//    }
    
    if (KKAlertView_nowIsShowing==nil) {
        KKAlertView_nowIsShowing = [[NSMutableDictionary alloc] init];
    }
    [KKAlertView_nowIsShowing setObject:self forKey:self.myShowingIdentifier];
    self.windowLevel = UIWindowLevelAlert;
    if (KKAlertView_currentKeyWindow==nil) {
        KKAlertView_currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    }
    [self makeKeyAndVisible];

    self.backgroundBlackButton.alpha = 0;
    
    self.myBackgroundView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateWithDuration:0.25 animations:^{
        self.myBackgroundView.transform = CGAffineTransformMakeScale(1, 1);
        self.backgroundBlackButton.alpha = selfAlpha;
    } completion:^(BOOL finished) {

    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.myBackgroundView.transform = CGAffineTransformScale(self.transform, 1.0, 1.0);
        self.myBackgroundView.transform = CGAffineTransformScale(self.transform, 0.001, 0.001);
        self.backgroundBlackButton.alpha = 0;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
        [self resignKeyWindow];
        self.alpha = 0;
        //移除自己
        [KKAlertView deleteShowingViewWithIdentifier:self.myShowingIdentifier];
        //通知显示下一个
        [KKAlertView showNextAlertView];
        
//        [self reease];
        [KKAlertView_nowIsShowing removeObjectForKey:self.myShowingIdentifier];
        if ([KKAlertView_nowIsShowing count]==0) {
            KKAlertView_nowIsShowing = nil;
            if (KKAlertView_currentKeyWindow) {
                [KKAlertView_currentKeyWindow makeKeyWindow];
            }
            KKAlertView_currentKeyWindow = nil;
        }
    }];
}


/**
 弹出一个提示框，用户点击确定之后，NavigationController 就pop回到上一个页面
 @param aMessage 需要展示的提示文字
 @param aNavigationController 当前的导航控制器NavigationController
 */
+ (void)showKKAlertViewWithMessage:(NSString*)aMessage
               whenFinishedPopback:(UINavigationController*)aNavigationController{
    KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil
                                                       subTitle:nil
                                                        message:aMessage
                                                       delegate:nil
                                                   buttonTitles:KKLibLocalizable_Common_OK,nil];
    alertView.myNavigationController = aNavigationController;
    alertView.tag = 20170512;
    [alertView show];
}


#pragma mark ==================================================
#pragma mark == 绘制界面
#pragma mark ==================================================
/**
 重载会重新布局titleLabel , subTitleLabel ,messageTextView,同时所有的button将会被移除，并重新添置新的。所以，如果要设置button的样式，请在reload之后设置button样式
 */
- (void)reload{
    [self reloadUI:YES];
}

- (void)reloadUI:(BOOL)aForReload{
    CGFloat Y = 0;
    //添加文字
    Y = [self setAllText:aForReload];
    //添加按钮
    [self setAllButton:Y forReload:aForReload];
}

/**
 添加文字
 @return 返回展示所有文字需要的高度
 */
- (CGFloat)setAllText:(BOOL)aForReload{
    
    self.myTitleLabel.frame = CGRectZero;
    self.mySubTitleLabel.frame = CGRectZero;
    self.myMessageTextView.frame = CGRectZero;
    
    CGFloat Y = 0;
    
    //只有标题
    if ([NSString isStringNotEmpty:self.myTitleString] &&
        [NSString isStringEmpty:self.mySubTitleString] &&
        [NSString isStringEmpty:self.myMessageString]) {
        
        CGSize titleSize = [self.myTitleString sizeWithFont:self.myTitleLabel.font maxSize:CGSizeMake(self.myBackgroundView.frame.size.width-20, 1000)];

        if (titleSize.height>=KKAlert_TextMinHeight) {
            Y = Y + 15;
            
            self.myTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, titleSize.height);
            self.myTitleLabel.text = self.myTitleString;
            Y = Y + titleSize.height;
            
            Y = Y + 15;
        }
        else{
            self.myTitleLabel.frame = CGRectMake(10, (80-titleSize.height)/2.0, self.myBackgroundView.frame.size.width-20, titleSize.height);
            self.myTitleLabel.text = self.myTitleString;
            
            Y = Y + 80;
        }
    }
    //只有副标题
    else if([NSString isStringEmpty:self.myTitleString] &&
            [NSString isStringNotEmpty:self.mySubTitleString] &&
            [NSString isStringEmpty:self.myMessageString]){
        
        CGSize subTitleSize = [self.mySubTitleString sizeWithFont:self.mySubTitleLabel.font maxSize:CGSizeMake(self.myBackgroundView.frame.size.width-20, 1000)];

        if (subTitleSize.height>=KKAlert_TextMinHeight) {
            Y = Y + 15;
            
            self.mySubTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, subTitleSize.height);
            self.mySubTitleLabel.text = self.mySubTitleString;
            Y = Y + subTitleSize.height;
            
            Y = Y + 15;
        }
        else{
            self.mySubTitleLabel.frame = CGRectMake(10, (80-subTitleSize.height)/2.0, self.myBackgroundView.frame.size.width-20, subTitleSize.height);
            self.mySubTitleLabel.text = self.mySubTitleString;
            
            Y = Y + 80;
        }

    }
    //只有文字
    else if([NSString isStringEmpty:self.myTitleString] &&
            [NSString isStringEmpty:self.mySubTitleString] &&
            [NSString isStringNotEmpty:self.myMessageString]){
        
        CGSize messageSize = [self.myMessageTextView sizeThatFits:CGSizeMake(self.myBackgroundView.frame.size.width-20, MAXFLOAT)];
        
        if (messageSize.height>=KKAlert_TextMinHeight) {
            Y = Y + 15;
            
            self.myMessageTextView.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
            self.myMessageTextView.text = self.myMessageString;
            Y = Y + MIN(messageSize.height, 250);
            
            Y = Y + 15;
        }
        else{
            self.myMessageTextView.frame = CGRectMake(10,  (80-messageSize.height)/2.0, self.myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
            self.myMessageTextView.text = self.myMessageString;
            
            Y = Y + 80;
        }
        
        if (aForReload==NO) {
            CGSize fontSize = [UIFont sizeOfFont:self.myMessageTextView.font];
            if (messageSize.height<=fontSize.height*2) {
                self.myMessageTextView.textAlignment = NSTextAlignmentCenter;
            }
            else{
                self.myMessageTextView.textAlignment = NSTextAlignmentLeft;
            }
        }
        
    }
    //标题+副标题
    else if([NSString isStringNotEmpty:self.myTitleString] &&
            [NSString isStringNotEmpty:self.mySubTitleString] &&
            [NSString isStringEmpty:self.myMessageString]){
        
        Y = Y + 15;
        
        CGSize titleSize = [self.myTitleString sizeWithFont:self.myTitleLabel.font maxSize:CGSizeMake(self.myBackgroundView.frame.size.width-20, 1000)];
        self.myTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, titleSize.height);
        self.myTitleLabel.text = self.myTitleString;
        Y = Y + titleSize.height;
        
        Y = Y + 10;

        CGSize subTitleSize = [self.mySubTitleString sizeWithFont:self.mySubTitleLabel.font maxSize:CGSizeMake(self.myBackgroundView.frame.size.width-20, 1000)];
        self.mySubTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, subTitleSize.height);
        self.mySubTitleLabel.text = self.mySubTitleString;
        Y = Y + subTitleSize.height;
        
        Y = Y + 15;

    }
    //标题+文字
    else if([NSString isStringNotEmpty:self.myTitleString] &&
            [NSString isStringEmpty:self.mySubTitleString] &&
            [NSString isStringNotEmpty:self.myMessageString]){
        
        Y = Y + 15;
        
        CGSize titleSize = [self.myTitleString sizeWithFont:self.myTitleLabel.font maxSize:CGSizeMake(self.myBackgroundView.frame.size.width-20, 1000)];
        self.myTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, titleSize.height);
        self.myTitleLabel.text = self.myTitleString;
        Y = Y + titleSize.height;
        
        Y = Y + 10;
        
        CGSize messageSize = [self.myMessageTextView sizeThatFits:CGSizeMake(self.myBackgroundView.frame.size.width-20, MAXFLOAT)];
        self.myMessageTextView.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
        self.myMessageTextView.text = self.myMessageString;
        Y = Y + MIN(messageSize.height, 250);
        
        Y = Y + 15;

        if (aForReload==NO) {
            CGSize fontSize = [UIFont sizeOfFont:self.myMessageTextView.font];
            if (messageSize.height<fontSize.height*2) {
                self.myMessageTextView.textAlignment = NSTextAlignmentCenter;
            }
            else{
                self.myMessageTextView.textAlignment = NSTextAlignmentLeft;
            }
        }
    }
    //副标题+文字
    else if([NSString isStringEmpty:self.myTitleString] &&
            [NSString isStringNotEmpty:self.mySubTitleString] &&
            [NSString isStringNotEmpty:self.myMessageString]){
        
        Y = Y + 15;
        
        CGSize subTitleSize = [self.mySubTitleString sizeWithFont:self.mySubTitleLabel.font maxSize:CGSizeMake(self.myBackgroundView.frame.size.width-20, 1000)];
        self.mySubTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, subTitleSize.height);
        self.mySubTitleLabel.text = self.mySubTitleString;
        Y = Y + subTitleSize.height;
        
        Y = Y + 10;
        
        CGSize messageSize = [self.myMessageTextView sizeThatFits:CGSizeMake(self.myBackgroundView.frame.size.width-20, MAXFLOAT)];
        self.myMessageTextView.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
        self.myMessageTextView.text = self.myMessageString;
        Y = Y + MIN(messageSize.height, 250);
        
        Y = Y + 15;
        
        if (aForReload==NO) {
            CGSize fontSize = [UIFont sizeOfFont:self.myMessageTextView.font];
            if (messageSize.height<=fontSize.height*2) {
                self.myMessageTextView.textAlignment = NSTextAlignmentCenter;
            }
            else{
                self.myMessageTextView.textAlignment = NSTextAlignmentLeft;
            }
        }
    }
    //标题+副标题+文字
    else if([NSString isStringNotEmpty:self.myTitleString] &&
            [NSString isStringNotEmpty:self.mySubTitleString] &&
            [NSString isStringNotEmpty:self.myMessageString]){
        
        Y = Y + 15;
        
        CGSize titleSize = [self.myTitleString sizeWithFont:self.myTitleLabel.font maxSize:CGSizeMake(self.myBackgroundView.frame.size.width-20, 1000)];
        self.myTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, titleSize.height);
        self.myTitleLabel.text = self.myTitleString;
        Y = Y + titleSize.height;

        Y = Y + 10;

        CGSize subTitleSize = [self.mySubTitleString sizeWithFont:self.mySubTitleLabel.font maxSize:CGSizeMake(self.myBackgroundView.frame.size.width-20, 1000)];
        self.mySubTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, subTitleSize.height);
        self.mySubTitleLabel.text = self.mySubTitleString;
        Y = Y + subTitleSize.height;
        
        Y = Y + 10;
        
        CGSize messageSize = [self.myMessageTextView sizeThatFits:CGSizeMake(self.myBackgroundView.frame.size.width-20, MAXFLOAT)];
        self.myMessageTextView.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
        self.myMessageTextView.text = self.myMessageString;
        Y = Y + MIN(messageSize.height, 250);
        
        Y = Y + 15;
        
        if (aForReload==NO) {
            CGSize fontSize = [UIFont sizeOfFont:self.myMessageTextView.font];
            if (messageSize.height<=fontSize.height*2) {
                self.myMessageTextView.textAlignment = NSTextAlignmentCenter;
            }
            else{
                self.myMessageTextView.textAlignment = NSTextAlignmentLeft;
            }
        }
    }
    else{
        
    }
    
    return Y;
}

/**
 添加按钮
 @param aYOffset 渲染Button的Y起始位置
 */
- (void)setAllButton:(CGFloat)aYOffset forReload:(BOOL)aForReload{

    CGFloat Y = aYOffset;
    
    for (UIView *subView in [self.myBackgroundView subviews]) {
        if (subView.tag>=1100) {
            [subView removeFromSuperview];
        }
    }
    
    if ([self.buttonTitlesArray count]==0) {
        //按钮
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y-1, self.myBackgroundView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        line.tag = 2200;
        [self.myBackgroundView addSubview:line];
        
        KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(0, Y, self.myBackgroundView.frame.size.width, 50)];
        button.textLabel.font = KKAlert_ButtonTitleFont;
        button.tag = 1100;
        button.exclusiveTouch = YES;
        [button setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
        [button setTitle:KKLibLocalizable_Common_OK forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self.myBackgroundView addSubview:button];
        Y = Y + 50;
        
        self.myBackgroundView.frame = CGRectMake(50, (self.frame.size.height-Y)/2.0, self.frame.size.width-100, Y);
    }
    else if ([self.buttonTitlesArray count]==1) {
        //按钮
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y-1, self.myBackgroundView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        line.tag = 2200;
        [self.myBackgroundView addSubview:line];
        
        KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(0, Y, self.myBackgroundView.frame.size.width, 50)];
        button.exclusiveTouch = YES;
        button.textLabel.font = KKAlert_ButtonTitleFont;
        [button setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
        [button setTitle:[self.buttonTitlesArray objectAtIndex:0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        button.tag = 1100;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.myBackgroundView addSubview:button];
        Y = Y + 50;
        
        self.myBackgroundView.frame = CGRectMake(50, (self.frame.size.height-Y)/2.0, self.frame.size.width-100, Y);
    }
    else if ([self.buttonTitlesArray count]==2){
        //按钮
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y-1, self.myBackgroundView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        line.tag = 2200;
        [self.myBackgroundView addSubview:line];
        
        KKButton *button01 = [[KKButton alloc] initWithFrame:CGRectMake(0, Y, self.myBackgroundView.frame.size.width/2.0-0.5, 50)];
        button01.exclusiveTouch = YES;
        button01.textLabel.font = KKAlert_ButtonTitleFont;
        [button01 setTitle:[self.buttonTitlesArray objectAtIndex:0] forState:UIControlStateNormal];
        [button01 setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
        [button01 setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        button01.tag = 1100;
        [button01 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.myBackgroundView addSubview:button01];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button01.frame), Y, 1, 50)];
        line1.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        line1.tag = 2201;
        [self.myBackgroundView addSubview:line1];
        
        KKButton *button02 = [[KKButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button01.frame)+1, Y, self.myBackgroundView.frame.size.width/2.0-0.5, 50)];
        button02.textLabel.font = KKAlert_ButtonTitleFont;
        [button02 setTitle:[self.buttonTitlesArray objectAtIndex:1] forState:UIControlStateNormal];
        [button02 setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
        [button02 setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        button02.tag = 1101;
        button02.exclusiveTouch = YES;
        [button02 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.myBackgroundView addSubview:button02];
        
        Y = Y + 50;
        
        self.myBackgroundView.frame = CGRectMake(50, (self.frame.size.height-Y)/2.0, self.frame.size.width-100, Y);
    }
    else {
        for (NSInteger i=0; i<[self.buttonTitlesArray count]; i++) {
            KKButton *button01 = [[KKButton alloc] initWithFrame:CGRectMake(0, Y, self.myBackgroundView.frame.size.width, 50)];
            button01.textLabel.font = KKAlert_ButtonTitleFont;
            [button01 setTitle:[self.buttonTitlesArray objectAtIndex:i] forState:UIControlStateNormal];
            [button01 setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
            [button01 setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
            button01.tag = 1100+i;
            button01.exclusiveTouch = YES;
            [button01 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.myBackgroundView addSubview:button01];
            Y = Y + 50;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button01.frame)-1, self.myBackgroundView.frame.size.width, 1)];
            line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
            line.tag = 2200 + i;
            [self.myBackgroundView addSubview:line];
            
        }
        
        self.myBackgroundView.frame = CGRectMake(50, (self.frame.size.height-Y)/2.0, self.frame.size.width-100, Y);
    }
}

#pragma mark ==================================================
#pragma mark == 外部获取界面元素
#pragma mark ==================================================
- (KKButton*)buttonAtIndex:(NSInteger)aIndex{
    UIView *view = [self.myBackgroundView viewWithTag:1100+aIndex];
    if ([view isKindOfClass:[KKButton class]]) {
        return (KKButton*)view;
    }
    else{
        return nil;
    }
}

- (UILabel*)titleLabel{
    return self.myTitleLabel;
}

- (UILabel*)subTitleLabel{
    return self.mySubTitleLabel;
}

- (UITextView*)messageTextView{
    return self.myMessageTextView;
}

#pragma mark ==================================================
#pragma mark == 通知（当有多个需要展示的时候，第一个展示完毕会发出通知，通知下一个要展示的对象）
#pragma mark ==================================================
- (void)Notification_ShowAlertView:(NSNotification*)aNotice{
    NSString *identifier = aNotice.object;
    if ([identifier isEqualToString:self.myShowingIdentifier]) {
        self.hidden = NO;
    }
    else{
        self.hidden = YES;
    }
}

- (void)Notification_HideAlertView:(NSNotification*)aNotice{
    NSString *identifier = aNotice.object;
    if ([identifier isEqualToString:self.myShowingIdentifier]) {
        self.hidden = NO;
    }
    else{
        self.hidden = YES;
    }
}


#pragma mark ==================================================
#pragma mark == UITextViewDelegate
#pragma mark ==================================================
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{

}

- (void)textViewDidEndEditing:(UITextView *)textView{

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView{

}


#pragma mark ==================================================
#pragma mark == 事件
#pragma mark ==================================================
- (void)backgroundButtonClicked{
    Class currentClass = object_getClass(_myDelegate);
    if ((currentClass == delegateClass) && [_myDelegate respondsToSelector:@selector(KKAlertView_backgroundClicked:)]) {
        [_myDelegate KKAlertView_backgroundClicked:self];
    }
}

- (void)buttonClicked:(KKButton*)button{
    
    if (self.myNavigationController &&
        self.tag == 20170512) {
        [self.myNavigationController popViewControllerAnimated:YES];
    }
    else{
        NSInteger index = button.tag - 1100;
        
        Class currentClass = object_getClass(_myDelegate);
        if ((currentClass == delegateClass) && [_myDelegate respondsToSelector:@selector(KKAlertView:clickedButtonAtIndex:)]) {
            [_myDelegate KKAlertView:self clickedButtonAtIndex:index];
        }
    }
    
    [self hide];
}

#pragma mark ==================================================
#pragma mark == 校验
#pragma mark ==================================================
+ (BOOL)isHaveSameViewShowingWithTitle:(NSString *)aTitle
                              subTitle:(NSString*)aSubTitle
                               message:(NSString *)aMessage
                     buttonTitlesArray:(NSArray*)aButtonArray{

    //判断当前有没有KKAlert显示，如果一个都没有就清除缓存信息
    NSArray *windows = [[UIApplication sharedApplication] windows];
    BOOL haveSelfShowing = NO;
    for (NSInteger i=0; i<[windows count]; i++) {
        UIWindow *window = [windows objectAtIndex:i];
        if ([window isKindOfClass:[KKAlertView class]]) {
            haveSelfShowing = YES;
        }
    }
    if (haveSelfShowing==NO) {
        [KKUserDefaultsManager removeObjectForKey:KKAlertView_AllShowingViews identifier:nil];
        return NO;
    }
    
    
    //遍历缓存信息
    BOOL haveSameShowing = NO;
    NSDictionary *ShowingAlertViews = [KKUserDefaultsManager objectForKey:KKAlertView_AllShowingViews identifier:nil];
    if (ShowingAlertViews && [ShowingAlertViews count]>0) {
        NSArray *allViews = [ShowingAlertViews allValues];
        for (NSInteger i=0; i<[allViews count] && haveSameShowing==NO; i++) {
            NSDictionary *viewInformation = [allViews objectAtIndex:i];
            
            NSString *saved_Title = [viewInformation objectForKey:KKAlertView_Title];
            NSString *saved_SubTitle = [viewInformation objectForKey:KKAlertView_SubTitle];
            NSString *saved_Message = [viewInformation objectForKey:KKAlertView_Message ];
            NSMutableArray *saved_ButtonsArray = [NSMutableArray array];
            NSArray *sArray = [viewInformation objectForKey:KKAlertView_ButtonsArray];
            if (sArray && [sArray isKindOfClass:[NSArray class]]) {
                [saved_ButtonsArray addObjectsFromArray:sArray];
            }
            
            BOOL isButtonSame = YES;
            if ([aButtonArray count]==[saved_ButtonsArray count]) {
                for (NSInteger i=0; i<[saved_ButtonsArray count] && isButtonSame==YES; i++) {
                    NSString *t1 = [aButtonArray objectAtIndex:i];
                    NSString *t2 = [saved_ButtonsArray objectAtIndex:i];
                    if (![t1 isEqualToString:t2]) {
                        isButtonSame = NO;
                        break;
                    }
                }
            }
            else{
                isButtonSame = NO;
            }
            
            
            if (   ((saved_Title && aTitle && [saved_Title isEqualToString:aTitle]) || (saved_Title==nil && aTitle==nil))
                && ((saved_SubTitle && aSubTitle && [saved_SubTitle isEqualToString:aSubTitle]) || (saved_SubTitle==nil && aSubTitle==nil))
                && ((saved_Message && aMessage && [saved_Message isEqualToString:aMessage]) || (saved_Message==nil && aMessage==nil))
                && isButtonSame==YES
                ) {
                
                haveSameShowing = YES;
                
            }
        }
    }
    
    return haveSameShowing;
}

+ (NSString*)saveShowingViewWithTitle:(NSString *)aTitle
                             subTitle:(NSString*)aSubTitle
                              message:(NSString *)aMessage
                    buttonTitlesArray:(NSArray*)aButtonTitlesArray{
    
    
    NSMutableDictionary *viewInformation = [NSMutableDictionary dictionary];
    if (aTitle) {
        [viewInformation setObject:aTitle forKey:KKAlertView_Title];
    }
    if (aSubTitle) {
        [viewInformation setObject:aSubTitle forKey:KKAlertView_SubTitle];
    }
    if (aMessage) {
        [viewInformation setObject:aMessage forKey:KKAlertView_Message];
    }
    if (aButtonTitlesArray && [aButtonTitlesArray count]>0) {
        [viewInformation setObject:aButtonTitlesArray forKey:KKAlertView_ButtonsArray];
    }
    
    NSString *identifier = [KKFileCacheManager createRandomFileName];
    
    NSMutableDictionary *savedViews = [NSMutableDictionary dictionary];
    NSDictionary *ShowingAlertViews = [KKUserDefaultsManager objectForKey:KKAlertView_AllShowingViews identifier:nil];
    if (ShowingAlertViews && [ShowingAlertViews isKindOfClass:[NSDictionary class]]) {
        [savedViews setValuesForKeysWithDictionary:ShowingAlertViews];
    }
    [savedViews setObject:viewInformation forKey:identifier];
    
    [KKUserDefaultsManager setObject:savedViews forKey:KKAlertView_AllShowingViews identifier:nil];
    
    return identifier;
}

+ (void)deleteShowingViewWithIdentifier:(NSString*)aIdentifier{
    
    NSMutableDictionary *savedViews = [NSMutableDictionary dictionary];
    NSDictionary *ShowingAlertViews = [KKUserDefaultsManager objectForKey:KKAlertView_AllShowingViews identifier:nil];
    if (ShowingAlertViews && [ShowingAlertViews isKindOfClass:[NSDictionary class]]) {
        [savedViews setValuesForKeysWithDictionary:ShowingAlertViews];
    }
    [savedViews removeObjectForKey:aIdentifier];
    
    if ([savedViews count]==0) {
        [KKUserDefaultsManager removeObjectForKey:KKAlertView_AllShowingViews identifier:nil];
    }
    else{
        [KKUserDefaultsManager setObject:savedViews forKey:KKAlertView_AllShowingViews identifier:nil];
    }
    
}

+ (void)showNextAlertView{
    NSMutableDictionary *savedViews = [NSMutableDictionary dictionary];
    NSDictionary *ShowingAlertViews = [KKUserDefaultsManager objectForKey:KKAlertView_AllShowingViews identifier:nil];
    if (ShowingAlertViews && [ShowingAlertViews isKindOfClass:[NSDictionary class]]) {
        [savedViews setValuesForKeysWithDictionary:ShowingAlertViews];
    }
    
    if ([savedViews count]==0) {
        [KKUserDefaultsManager removeObjectForKey:KKAlertView_AllShowingViews identifier:nil];
    }
    else{
        NSArray *allKeys = [savedViews allKeys];
        NSString *identifier = [allKeys lastObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_ShowKKAlertView object:identifier];
    }
}

@end
