//
//  KKActionSheet.m
//  CEDongLi
//
//  Created by liubo on 15/11/13.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "KKActionSheet.h"
#import "KKFileCacheManager.h"
#import "KKUserDefaultsManager.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import <objc/runtime.h>
#import "KKLibraryDefine.h"

#pragma mark - ==================================================
#pragma mark    其他扩展
#pragma mark   ==================================================

@interface KKActionSheet_VC : UIViewController

@property (nonatomic,assign)UIStatusBarStyle statusBarStyle;

- (instancetype)initWithUIStatusBarStyle:(UIStatusBarStyle)aStyle;

@end

@implementation KKActionSheet_VC

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

#define KKActionSheet_AllShowingViews       @"KKActionSheet_AllShowingViews"

#define KKActionSheet_Title               @"KKActionSheet_Title"
#define KKActionSheet_SubTitle            @"KKActionSheet_SubTitle"
//#define KKActionSheet_Message             @"KKActionSheet_Message"
#define KKActionSheet_ButtonsArray        @"KKActionSheet_ButtonsArray"
#define KKActionSheet_CancelButtonsTitle  @"KKActionSheet_CancelButtonsTitle"

#define KKA_ButtonTitleFont [UIFont boldSystemFontOfSize:16]
#define KKA_TextMinHeight 30
#define KKA_ButtonHeight 49

static NSMutableDictionary  *static_KKActSheet_allShowing;
static UIWindow  *KKActionSheet_currentKeyWindow;

@interface KKActionSheet ()<UITextViewDelegate>{
    __weak id<KKActionSheetDelegate> _myDelegate;
    Class delegateClass;
}

@property (nonatomic,strong)UIButton *backgroundBlackButton;
@property (nonatomic,strong)UIView *myBackgroundView;
@property (nonatomic,strong)UILabel *myTitleLabel;
@property (nonatomic,strong)UILabel *mySubTitleLabel;
@property (nonatomic,strong)NSMutableArray *buttonTitlesArray;
@property (nonatomic,copy)NSString *myCancelButtonTitle;
@property (nonatomic,strong)UIButton *cancelButton;

@property (nonatomic,weak)id<KKActionSheetDelegate> myDelegate;


@property (nonatomic,copy)NSString *myTitleString;
@property (nonatomic,copy)NSString *mySubTitleString;

@property (nonatomic,copy)NSString *myShowingIdentifier;

@end

@implementation KKActionSheet
@synthesize myDelegate = _myDelegate;

- (void)dealloc{
    [KKActionSheet deleteShowingViewWithIdentifier:self.myShowingIdentifier];
    self.myShowingIdentifier = nil;
}

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (instancetype)initWithTitle:(NSString *)aTitle
                     subTitle:(NSString*)aSubTitle
                     delegate:(id /**<KKActionSheetDelegate>*/)aDelegate
            cancelButtonTitle:(NSString *)aCancelButtonTitle
            otherButtonTitles:(NSString *)aOtherButtonTitles, ... {
    
    
    
    NSMutableArray *in_buttonArray = [NSMutableArray array];
    va_list args;
    va_start(args, aOtherButtonTitles);
    if (aOtherButtonTitles) {
        [in_buttonArray addObject:[NSString stringWithFormat:@"%@",aOtherButtonTitles]];
        
        NSString *otherString;
        while ( (otherString = va_arg(args, NSString*)) ) {
            if (otherString && [otherString isKindOfClass:[NSString class]]) {
                //依次取得各参数
                [in_buttonArray addObject:[NSString stringWithFormat:@"%@",otherString]];
            }
        }
    }
    va_end(args);
    
    /* 已经展示了一个一模一样的了，就不能再展示了 */
    if ([KKActionSheet isHaveSameViewShowingWithTitle:aTitle
                                             subTitle:aSubTitle
                                    buttonTitlesArray:in_buttonArray
                                    cancelButtonTitle:aCancelButtonTitle]) {
        return nil;
    }

    return [self initWithTitle:aTitle
                      subTitle:aSubTitle
                      delegate:aDelegate
             cancelButtonTitle:aCancelButtonTitle
        otherButtonTitlesArray:in_buttonArray];
}

- (instancetype)initWithTitle:(NSString *)aTitle
                     subTitle:(NSString*)aSubTitle
                     delegate:(id /**<KKActionSheetDelegate>*/)aDelegate
            cancelButtonTitle:(NSString *)aCancelButtonTitle
       otherButtonTitlesArray:(NSArray *)aOtherButtonTitlesArray{
    
    if ([KKActionSheet isHaveSameViewShowingWithTitle:aTitle
                                             subTitle:aSubTitle
                                    buttonTitlesArray:aOtherButtonTitlesArray
                                    cancelButtonTitle:aCancelButtonTitle]) {
        return nil;
    }

    
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        
        self.buttonTitlesArray = [[NSMutableArray alloc] init];
        [self.buttonTitlesArray addObjectsFromArray:aOtherButtonTitlesArray];
        
        self.myCancelButtonTitle =aCancelButtonTitle;
        
        NSString *identifier = [KKActionSheet saveShowingViewWithTitle:aTitle
                                                              subTitle:aSubTitle
                                                     buttonTitlesArray:aOtherButtonTitlesArray
                                                     cancelButtonTitle:aCancelButtonTitle];
        self.myShowingIdentifier = [[NSString alloc] initWithFormat:@"%@",identifier];

        [self setDelegate:aDelegate];
        self.myTitleString = aTitle;
        self.mySubTitleString = aSubTitle;
        
        self.backgroundBlackButton = [[UIButton alloc] initWithFrame:self.bounds];
        self.backgroundBlackButton.backgroundColor = [UIColor blackColor];
        self.backgroundBlackButton.exclusiveTouch = YES;
        [self.backgroundBlackButton addTarget:self action:@selector(backgroundButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backgroundBlackButton];
        
        self.myBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-30, 1000)];
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
        
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KKScreenHeight-55, KKApplicationWidth-100, 40)];
        self.cancelButton.titleLabel.font = KKA_ButtonTitleFont;
        [self.cancelButton setTitle:self.myCancelButtonTitle?self.myCancelButtonTitle:KKLibLocalizable_Common_Cancel forState:UIControlStateNormal];
        self.cancelButton.exclusiveTouch = YES;
        [self.cancelButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.cancelButton setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        self.cancelButton.tag = 1100;
        [self.cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        [self reload];
    }
    return self;
}

- (void)setDelegate:(id<KKActionSheetDelegate>)aDelegate{
    if (_myDelegate) {
        return;
    }
    _myDelegate = aDelegate;
    delegateClass = object_getClass(_myDelegate);
}

- (void)show{
    
    UIStatusBarStyle style = [UIApplication sharedApplication].statusBarStyle;
    self.rootViewController = [[KKActionSheet_VC alloc] initWithUIStatusBarStyle:style];

    for (UIWindow *subWindow in [[UIApplication sharedApplication] windows]) {
        [subWindow endEditing:YES];
    }
    
    CGFloat selfAlpha = 0.5;
    if ([[[UIApplication sharedApplication] keyWindow] isKindOfClass:[self class]]) {
        selfAlpha = 0;
    }

//    [self retain];
    if (static_KKActSheet_allShowing==nil) {
        static_KKActSheet_allShowing = [[NSMutableDictionary alloc] init];
    }
    [static_KKActSheet_allShowing setObject:self forKey:self.myShowingIdentifier];
    self.windowLevel = UIWindowLevelAlert;
    if (KKActionSheet_currentKeyWindow==nil) {
        KKActionSheet_currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    }
    [self makeKeyAndVisible];
    
    self.backgroundBlackButton.alpha = 0;
    
    CGRect myBackgroundView_Rect_Show = self.myBackgroundView.frame;
    CGRect myBackgroundView_Rect_Hide = self.myBackgroundView.frame;
    myBackgroundView_Rect_Hide.origin.y = myBackgroundView_Rect_Hide.origin.y + KKScreenHeight;
    self.myBackgroundView.frame = myBackgroundView_Rect_Hide;

    CGRect cancelButton_Rect_Show = self.cancelButton.frame;
    CGRect cancelButton_Rect_Hide = self.cancelButton.frame;
    cancelButton_Rect_Hide.origin.y = cancelButton_Rect_Hide.origin.y + KKScreenHeight;
    self.cancelButton.frame = cancelButton_Rect_Hide;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.myBackgroundView.frame = myBackgroundView_Rect_Show;
        self.cancelButton.frame = cancelButton_Rect_Show;
        self.backgroundBlackButton.alpha = selfAlpha;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide{
    
    CGRect myBackgroundView_Rect_Hide = self.myBackgroundView.frame;
    myBackgroundView_Rect_Hide.origin.y = myBackgroundView_Rect_Hide.origin.y + KKScreenHeight;
    
    CGRect cancelButton_Rect_Hide = self.cancelButton.frame;
    cancelButton_Rect_Hide.origin.y = cancelButton_Rect_Hide.origin.y + KKScreenHeight;

    [UIView animateWithDuration:0.25 animations:^{
        self.myBackgroundView.frame = myBackgroundView_Rect_Hide;
        self.cancelButton.frame = cancelButton_Rect_Hide;
        self.backgroundBlackButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.rootViewController = nil;
        [[UIWindow currentKeyWindow] becomeKeyWindow];
        [self resignKeyWindow];
        
        [static_KKActSheet_allShowing removeObjectForKey:self.myShowingIdentifier];
        if ([static_KKActSheet_allShowing count]==0) {
            static_KKActSheet_allShowing = nil;
            if (KKActionSheet_currentKeyWindow) {
                [KKActionSheet_currentKeyWindow makeKeyWindow];
            }
            KKActionSheet_currentKeyWindow = nil;
        }
    }];
}

#pragma mark ==================================================
#pragma mark == 绘制界面
#pragma mark ==================================================
/**
 重载会重新布局titleLabel , subTitleLabel ,messageTextView,同时所有的button将会被移除，并重新添置新的。所以，如果要设置button的样式，请在reload之后设置button样式
 */
- (void)reload{
    CGFloat Y = 0;
    //添加文字
    Y = [self setAllText];
    //添加按钮
    [self setAllButton:Y];
}

/**
 添加文字
 @return 返回展示所有文字需要的高度
 */
- (CGFloat)setAllText{
    
    self.myTitleLabel.frame = CGRectZero;
    self.mySubTitleLabel.frame = CGRectZero;
    
    CGFloat Y = 0;
    
    //只有标题
    if ([NSString isStringNotEmpty:self.myTitleString] &&
        [NSString isStringEmpty:self.mySubTitleString]) {
        
        CGSize titleSize = [UIFont sizeOfFont:self.myTitleLabel.font];
        
        if (titleSize.height>=KKA_TextMinHeight) {
            Y = Y + 15;
            
            self.myTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, titleSize.height);
            self.myTitleLabel.text = self.myTitleString;
            Y = Y + titleSize.height;
            
            Y = Y + 15;
        }
        else{
            self.myTitleLabel.frame = CGRectMake(10, (60-titleSize.height)/2.0, self.myBackgroundView.frame.size.width-20, titleSize.height);
            self.myTitleLabel.text = self.myTitleString;
            
            Y = Y + 60;
        }
    }
    //只有副标题
    else if([NSString isStringEmpty:self.myTitleString] &&
            [NSString isStringNotEmpty:self.mySubTitleString]){
        
        CGSize subTitleSize = [UIFont sizeOfFont:self.mySubTitleLabel.font];
        
        if (subTitleSize.height>=KKA_TextMinHeight) {
            Y = Y + 15;
            
            self.mySubTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, subTitleSize.height);
            self.mySubTitleLabel.text = self.mySubTitleString;
            Y = Y + subTitleSize.height;
            
            Y = Y + 15;
        }
        else{
            self.mySubTitleLabel.frame = CGRectMake(10, (60-subTitleSize.height)/2.0, self.myBackgroundView.frame.size.width-20, subTitleSize.height);
            self.mySubTitleLabel.text = self.mySubTitleString;
            
            Y = Y + 60;
        }
        
    }
    //标题+副标题
    else if([NSString isStringNotEmpty:self.myTitleString] &&
            [NSString isStringNotEmpty:self.mySubTitleString]){
        
        Y = Y + 15;
        
        CGSize titleSize = [UIFont sizeOfFont:self.myTitleLabel.font];
        self.myTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, titleSize.height);
        self.myTitleLabel.text = self.myTitleString;
        Y = Y + titleSize.height;
        
        Y = Y + 10;
        
        CGSize subTitleSize = [UIFont sizeOfFont:self.mySubTitleLabel.font];
        self.mySubTitleLabel.frame = CGRectMake(10, Y, self.myBackgroundView.frame.size.width-20, subTitleSize.height);
        self.mySubTitleLabel.text = self.mySubTitleString;
        Y = Y + subTitleSize.height;
        
        Y = Y + 15;
        
    }
    else{
        
    }
    
    return Y;
}

/**
 添加按钮
 @param yOffset 渲染Button的Y起始位置
 */
- (void)setAllButton:(CGFloat)yOffset{
    
    CGFloat Y = yOffset;
    
    for (UIView *subView in [self.myBackgroundView subviews]) {
        if (subView.tag>=1100) {
            [subView removeFromSuperview];
        }
    }
    
    for (NSInteger i=0; i<[self.buttonTitlesArray count]; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y, self.myBackgroundView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        line.tag = 2200 + i;
        [self.myBackgroundView addSubview:line];
        Y = Y+1 ;

        UIButton *button01 = [[UIButton alloc] initWithFrame:CGRectMake(0, Y, self.myBackgroundView.frame.size.width, KKA_ButtonHeight)];
        button01.titleLabel.font = KKA_ButtonTitleFont;
        [button01 setTitle:[self.buttonTitlesArray objectAtIndex:i] forState:UIControlStateNormal];
        [button01 setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        [button01 setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button01 setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        button01.tag = 1101+i;
        button01.exclusiveTouch = YES;
        [button01 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.myBackgroundView addSubview:button01];
        Y = Y + KKA_ButtonHeight;
    }
    
    self.myBackgroundView.frame = CGRectMake(15, KKScreenHeight-15-KKA_ButtonHeight-15-Y, self.frame.size.width-30, Y);
    [self.myBackgroundView setCornerRadius:5];
    
    self.cancelButton.frame = CGRectMake(15, KKScreenHeight-15-KKA_ButtonHeight, self.frame.size.width-30, KKA_ButtonHeight);
    [self.cancelButton setCornerRadius:5];
}

#pragma mark ==================================================
#pragma mark == 外部获取界面元素
#pragma mark ==================================================
- (UIButton*)buttonAtIndex:(NSInteger)aIndex{
    if (aIndex==0) {
        return self.cancelButton;
    }
    else{
        UIView *view = [self.myBackgroundView viewWithTag:1100+aIndex];
        if ([view isKindOfClass:[UIButton class]]) {
            return (UIButton*)view;
        }
        else{
            return nil;
        }
    }
}

- (UILabel*)titleLabel{
    return self.myTitleLabel;
}

- (UILabel*)subTitleLabel{
    return self.mySubTitleLabel;
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
    if ((currentClass == delegateClass) && [_myDelegate respondsToSelector:@selector(KKActionSheet_backgroundClicked:)]) {
        [_myDelegate KKActionSheet_backgroundClicked:self];
    }
}

- (void)buttonClicked:(UIButton*)button{
    NSInteger index = button.tag - 1100;
    
    Class currentClass = object_getClass(_myDelegate);
    if ((currentClass == delegateClass) && [_myDelegate respondsToSelector:@selector(KKActionSheet:clickedButtonAtIndex:)]) {
        [_myDelegate KKActionSheet:self clickedButtonAtIndex:index];
    }
    [self hide];
}

#pragma mark ==================================================
#pragma mark == 校验
#pragma mark ==================================================
+ (BOOL)isHaveSameViewShowingWithTitle:(NSString *)aTitle
                              subTitle:(NSString*)aSubTitle
                     buttonTitlesArray:(NSArray*)aButtonArray
                     cancelButtonTitle:(NSString *)aCancelButtonTitle{
    
    //判断当前有没有KKAlert显示，如果一个都没有就清除缓存信息
    NSArray *windows = [[UIApplication sharedApplication] windows];
    BOOL haveSelfShowing = NO;
    for (NSInteger i=0; i<[windows count]; i++) {
        UIWindow *window = [windows objectAtIndex:i];
        if ([window isKindOfClass:[self class]]) {
            haveSelfShowing = YES;
        }
    }
    if (haveSelfShowing==NO) {
        [KKUserDefaultsManager removeObjectForKey:KKActionSheet_AllShowingViews identifier:nil];
        return NO;
    }
    
    
    //遍历缓存信息
    BOOL haveSameShowing = NO;
    NSDictionary *ShowingAlertViews = [KKUserDefaultsManager objectForKey:KKActionSheet_AllShowingViews identifier:nil];
    if (ShowingAlertViews && [ShowingAlertViews count]>0) {
        NSArray *allViews = [ShowingAlertViews allValues];
        for (NSInteger i=0; i<[allViews count] && haveSameShowing==NO; i++) {
            NSDictionary *viewInformation = [allViews objectAtIndex:i];
            
            NSString *saved_Title = [viewInformation objectForKey:KKActionSheet_Title];
            NSString *saved_SubTitle = [viewInformation objectForKey:KKActionSheet_SubTitle];
            NSString *saved_CancelButtonsTitle = [viewInformation objectForKey:KKActionSheet_CancelButtonsTitle ];

            NSMutableArray *saved_ButtonsArray = [NSMutableArray array];
            NSArray *sArray = [viewInformation objectForKey:KKActionSheet_ButtonsArray];
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
            
            
            if (   ((saved_Title && aTitle && [saved_Title isEqualToString:aTitle]) ||
                    (saved_Title==nil && aTitle==nil))
                
                && ((saved_SubTitle && aSubTitle && [saved_SubTitle isEqualToString:aSubTitle]) ||
                    (saved_SubTitle==nil && aSubTitle==nil))
                
                && ((saved_CancelButtonsTitle && aCancelButtonTitle && [saved_CancelButtonsTitle isEqualToString:aCancelButtonTitle]) ||
                    (saved_CancelButtonsTitle==nil && aCancelButtonTitle==nil))
                
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
                    buttonTitlesArray:(NSArray*)aButtonTitlesArray
                    cancelButtonTitle:(NSString *)aCancelButtonTitle{
    
    
    NSMutableDictionary *viewInformation = [NSMutableDictionary dictionary];
    if (aTitle) {
        [viewInformation setObject:aTitle forKey:KKActionSheet_Title];
    }
    if (aSubTitle) {
        [viewInformation setObject:aSubTitle forKey:KKActionSheet_SubTitle];
    }
    if (aCancelButtonTitle) {
        [viewInformation setObject:aCancelButtonTitle forKey:KKActionSheet_CancelButtonsTitle];
    }
    if (aButtonTitlesArray && [aButtonTitlesArray count]>0) {
        [viewInformation setObject:aButtonTitlesArray forKey:KKActionSheet_ButtonsArray];
    }
    
    NSString *identifier = [KKFileCacheManager createRandomFileName];
    
    NSMutableDictionary *savedViews = [NSMutableDictionary dictionary];
    NSDictionary *ShowingAlertViews = [KKUserDefaultsManager objectForKey:KKActionSheet_AllShowingViews identifier:nil];
    if (ShowingAlertViews && [ShowingAlertViews isKindOfClass:[NSDictionary class]]) {
        [savedViews setValuesForKeysWithDictionary:ShowingAlertViews];
    }
    [savedViews setObject:viewInformation forKey:identifier];
    
    [KKUserDefaultsManager setObject:savedViews forKey:KKActionSheet_AllShowingViews identifier:nil];
    
    return identifier;
}

+ (void)deleteShowingViewWithIdentifier:(NSString*)aIdentifier{
    
    NSMutableDictionary *savedViews = [NSMutableDictionary dictionary];
    NSDictionary *ShowingAlertViews = [KKUserDefaultsManager objectForKey:KKActionSheet_AllShowingViews identifier:nil];
    if (ShowingAlertViews && [ShowingAlertViews isKindOfClass:[NSDictionary class]]) {
        [savedViews setValuesForKeysWithDictionary:ShowingAlertViews];
    }
    [savedViews removeObjectForKey:aIdentifier];
    
    if ([savedViews count]==0) {
        [KKUserDefaultsManager removeObjectForKey:KKActionSheet_AllShowingViews identifier:nil];
    }
    else{
        [KKUserDefaultsManager setObject:savedViews forKey:KKActionSheet_AllShowingViews identifier:nil];
    }
}


@end
