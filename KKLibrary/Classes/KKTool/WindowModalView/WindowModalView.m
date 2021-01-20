//
//  WindowModalView.m
//  GouUseCore
//
//  Created by beartech on 2018/1/5.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "WindowModalView.h"
#import "KKCategory.h"
#import "KKButton.h"
#import "KKLibraryDefine.h"

#define KKWM_ButtonHeight 90.0f

static WindowModalView  *static_WindowModalView;
static UIWindow  *WindowModalView_currentKeyWindow;

@interface WindowModalView ()

@property (nonatomic,strong)UIButton *backgroundButton;
@property (nonatomic,strong)UIScrollView *contentScrollView;
@property (nonatomic,assign)id<WindowModalViewDelegate> delegate;
@property (nonatomic,strong)NSArray *itemArray;


@end

@implementation WindowModalView

/**
 展示一个从底部Modal出来的视图
 
 @param aItemArray WindowModalViewItem数组
 @param aDelegate 代理
 @return WindowModalView
 */
+ (WindowModalView*)showWithItems:(NSArray<WindowModalViewItem*>*)aItemArray
                         delegate:(id<WindowModalViewDelegate>)aDelegate{
    
    WindowModalView *modalView = [[WindowModalView alloc] initWithItems:aItemArray delegate:aDelegate];
    modalView.tag = 20180105;
    static_WindowModalView = modalView;
    [modalView show];
    return modalView;
}


#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (instancetype)initWithItems:(NSArray<WindowModalViewItem*>*)aItemArray
                     delegate:(id<WindowModalViewDelegate>)aDelegate
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        self.delegate = aDelegate;
        self.itemArray = aItemArray;
        
        //背景
        self.backgroundButton = [[UIButton alloc] initWithFrame:self.bounds];
        self.backgroundButton.backgroundColor = [UIColor blackColor];
        self.backgroundButton.alpha = 0.3;
        self.backgroundButton.exclusiveTouch = YES;
        [self.backgroundButton addTarget:self action:@selector(backgroundButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backgroundButton];

        
        NSInteger countPerRow = 3;
        CGFloat offsetX = 0;
        CGFloat offsetY = 15;
        CGFloat frameWidth = self.frame.size.width/countPerRow;
        CGFloat frameHeight = KKWM_ButtonHeight;

        //ScrollView
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-(frameHeight+frameHeight+30)-KKSafeAreaBottomHeight, self.frame.size.width, frameHeight+frameHeight+30+KKSafeAreaBottomHeight)];
        self.contentScrollView.backgroundColor = [UIColor whiteColor];
        self.contentScrollView.pagingEnabled = YES;
        [self addSubview:self.contentScrollView];
        if (@available(iOS 11.0, *)) {
            self.contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }

        NSInteger rowIndex = 0;
        NSInteger pageIndex = 0;
        for (NSInteger i=0; i<[self.itemArray count]; i++) {
            
            WindowModalViewItem *item = [self.itemArray objectAtIndex:i];
            
            KKButton *button = [[KKButton alloc] initWithFrame:CGRectMake(offsetX+pageIndex*self.frame.size.width, offsetY, frameWidth, frameHeight) type:KKButtonType_ImgTopTitleBottom_Center];
            button.imageViewSize = CGSizeMake(50, 50);
            button.spaceBetweenImgTitle = 10;
            button.edgeInsets = UIEdgeInsetsZero;
            button.textLabel.font = [UIFont systemFontOfSize:13];
            button.tag = 9999+i;
            [button setImage:item.image
                       title:item.title
                  titleColor:item.titleColor?item.titleColor:[UIColor colorWithHexString:@"#333333"]
             backgroundColor:nil
                    forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentScrollView addSubview:button];
            
                //判断个数是否是当前行的最后一个
            if ((i%countPerRow)==(countPerRow-1)) {
                
                    //第一行最后一个
                if (rowIndex==0) {
                    offsetX = 0;
                    offsetY = offsetY + frameHeight;
                    rowIndex = 1;
                }
                    //第二行最后一个
                else{
                    offsetX = 0;
                    offsetY = 15;
                    rowIndex = 0;
                    pageIndex = pageIndex + 1;
                }
            }
            else{
                offsetX = offsetX + frameWidth;
            }
        }
    }
    return self;
}

- (void)backgroundButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WindowModalView_backgroundClicked:)]) {
        [self.delegate WindowModalView_backgroundClicked:self];
    }
    [self hide];
}

- (void)buttonClicked:(KKButton*)aButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(WindowModalView:clickedButtonAtIndex: item:)]) {
        [self.delegate WindowModalView:self clickedButtonAtIndex:aButton.tag-9999 item:[self.itemArray objectAtIndex:aButton.tag-9999]];
    }
    [self hide];
}

- (void)show{
    
    for (UIWindow *subWindow in [[UIApplication sharedApplication] windows]) {
        [subWindow endEditing:YES];
    }
    self.windowLevel = UIWindowLevelAlert;
    if (WindowModalView_currentKeyWindow==nil) {
        WindowModalView_currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    }
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
    
    CGFloat height = KKWM_ButtonHeight+KKWM_ButtonHeight+30;
    CGRect frame0 = CGRectMake(0, KKApplicationHeight, self.frame.size.width, height);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentScrollView.frame = frame0;
        self.backgroundButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self resignKeyWindow];
        self.alpha = 0;
        static_WindowModalView = nil;
        if (WindowModalView_currentKeyWindow) {
            [WindowModalView_currentKeyWindow makeKeyWindow];
        }
        WindowModalView_currentKeyWindow = nil;
    }];
}

@end
