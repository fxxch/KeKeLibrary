//
//  KKWindowActionView.m
//  GouUseCore
//
//  Created by liubo on 2018/1/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKWindowActionView.h"
#import "KKCategory.h"
#import "KKButton.h"
#import <objc/runtime.h>

#pragma mark - ==================================================
#pragma mark    其他扩展
#pragma mark   ==================================================

@interface KKWindowActionView_VC : UIViewController

@property (nonatomic,assign)UIStatusBarStyle statusBarStyle;

- (instancetype)initWithUIStatusBarStyle:(UIStatusBarStyle)aStyle;

@end

@implementation KKWindowActionView_VC

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


#define ButtonHeight 50.0f

static KKWindowActionView  *static_KKWindowActionView;

@interface KKWindowActionView (){
    __weak id<KKWindowActionViewDelegate> _myDelegate;
    Class delegateClass;
}

@property (nonatomic,strong)UIButton *backgroundButton;
@property (nonatomic,strong)UIScrollView *contentScrollView;
@property (nonatomic,weak)id<KKWindowActionViewDelegate> myDelegate;
@property (nonatomic,strong)NSMutableArray *itemArray;


@end

@implementation KKWindowActionView
@synthesize myDelegate = _myDelegate;

/**
 展示一个从底部Modal出来的视图
 
 @param aItemArray KKWindowActionViewItem数组
 @param aDelegate 代理
 @return KKWindowActionView
 */
+ (KKWindowActionView*)showWithItems:(NSArray<KKWindowActionViewItem*>*)aItemArray
                            delegate:(id<KKWindowActionViewDelegate>)aDelegate
{
    KKWindowActionView *modalView = [[KKWindowActionView alloc] initWithItems:aItemArray delegate:aDelegate];
    static_KKWindowActionView = modalView;
    [modalView show];
    return modalView;
}

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (instancetype)initWithItems:(NSArray<KKWindowActionViewItem*>*)aItemArray
                     delegate:(id<KKWindowActionViewDelegate>)aDelegate
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setDelegate:aDelegate];
        
        self.itemArray = [[NSMutableArray alloc] init];
        [self.itemArray addObjectsFromArray:aItemArray];
        
        //背景
        self.backgroundButton = [[UIButton alloc] initWithFrame:self.bounds];
        self.backgroundButton.backgroundColor = [UIColor blackColor];
        self.backgroundButton.alpha = 0.3;
        self.backgroundButton.exclusiveTouch = YES;
        [self.backgroundButton addTarget:self action:@selector(backgroundButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backgroundButton];
        
        
        CGFloat offsetX = 0;
        CGFloat offsetY = 0;
        CGFloat frameWidth = self.frame.size.width;
        CGFloat frameHeight = (ButtonHeight*[aItemArray count]);
        
        //ScrollView
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-(ButtonHeight*[aItemArray count])-KKSafeAreaBottomHeight, frameWidth, frameHeight+KKSafeAreaBottomHeight)];
        self.contentScrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentScrollView];
        
        for (NSInteger i=0; i<[aItemArray count]; i++) {
            
            KKWindowActionViewItem *item = [aItemArray objectAtIndex:i];
            
            KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(offsetX, offsetY, frameWidth, ButtonHeight) type:KKButtonType_ImgLeftTitleRight_Left];
            button.imageViewSize = CGSizeMake(25, 25);
            button.spaceBetweenImgTitle = 30;
            button.edgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            button.textLabel.font = [UIFont systemFontOfSize:15];
            
            button.buttonType = KKButtonType_ImgLeftTitleRight_Center;
            button.imageViewSize = CGSizeMake(0, 0);
            button.spaceBetweenImgTitle = 0;
            button.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            button.textLabel.font = [UIFont systemFontOfSize:19];

            button.tag = 9999+i;
            [button setImage:item.image
                       title:item.title
                  titleColor:item.titleColor?item.titleColor:[UIColor colorWithHexString:@"#333333"]
             backgroundColor:nil
                    forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentScrollView addSubview:button];
            button.bottomLineView.frame = CGRectMake(0, button.frame.size.height-1.0, button.frame.size.width, 1.0);
            button.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
            
            offsetY = offsetY + ButtonHeight;
        }
    }
    return self;
}

- (void)backgroundButtonClicked{
    Class currentClass = object_getClass(_myDelegate);
    if ((currentClass == delegateClass) && [_myDelegate respondsToSelector:@selector(KKWindowActionView_backgroundClicked:)]) {
        [_myDelegate KKWindowActionView_backgroundClicked:self];
    }

    [self hide];
}

- (void)buttonClicked:(KKButton*)aButton{
    
    Class currentClass = object_getClass(_myDelegate);
    if ((currentClass == delegateClass) && [_myDelegate respondsToSelector:@selector(KKWindowActionView:clickedIndex:item:)]) {

        NSInteger index = aButton.tag-9999;
        
        [_myDelegate KKWindowActionView:self
                           clickedIndex:index
                                   item:[self.itemArray objectAtIndex:index]];

    }

    [self hide];
}

- (void)show{
    
    UIStatusBarStyle style = [UIApplication sharedApplication].statusBarStyle;
    self.rootViewController = [[KKWindowActionView_VC alloc] initWithUIStatusBarStyle:style];
    
    for (UIWindow *subWindow in [[UIApplication sharedApplication] windows]) {
        [subWindow endEditing:YES];
    }
    self.windowLevel = UIWindowLevelAlert;
    [self makeKeyAndVisible];
    
    CGRect frame0 = CGRectMake(0, KKApplicationHeight, self.frame.size.width, self.contentScrollView.frame.size.height);
    CGRect frame1 = self.contentScrollView.frame;
    
    self.contentScrollView.frame = frame0;
    self.backgroundButton.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentScrollView.frame = frame1;
        self.backgroundButton.alpha = 0.3;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide{
    
    CGFloat height = ButtonHeight+ButtonHeight+30;
    CGRect frame0 = CGRectMake(0, KKApplicationHeight, self.frame.size.width, height);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentScrollView.frame = frame0;
        self.backgroundButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self resignKeyWindow];
        self.alpha = 0;
        static_KKWindowActionView = nil;
        
    }];
}

- (void)setDelegate:(id<KKWindowActionViewDelegate>)aDelegate{
    if (_myDelegate) {
        return;
    }
    _myDelegate = aDelegate;
    delegateClass = object_getClass(_myDelegate);
}

@end


