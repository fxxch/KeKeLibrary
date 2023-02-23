//
//  KKWaitingView.m
//  GouUseCore
//
//  Created by liubo on 2017/8/9.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKWaitingView.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKSharedInstance.h"
#import "KKLog.h"

#define KKWaitingView_TagWindow 2017080901
#define KKWaitingView_TagView 2017080902
#define KKWaitingView_OffsetY 0


@interface KKWaitingView ()

@end

@implementation KKWaitingView

+ (KKWaitingView*)showInView:(UIView*)aView
                        text:(NSString*)aText{

    [KKWaitingView hideForView:aView animation:NO];
    
    KKWaitingView *subView = [[KKWaitingView alloc] initWithFrame:aView.bounds
                                                             text:aText];
    if ([aView isKindOfClass:[UIWindow class]]) {
        subView.tag = KKWaitingView_TagWindow;
    }
    else{
        subView.tag = KKWaitingView_TagView;
    }
    [aView addSubview:subView];
    [aView bringSubviewToFront:subView];
    subView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    return subView;
}

+ (void)hideForView:(UIView*)aView{
    [KKWaitingView hideForView:aView animation:YES];
}

+ (void)hideForView:(UIView*)aView animation:(BOOL)animation{
    
    KKWaitingView *subView = nil;
    if ([aView isKindOfClass:[UIWindow class]]) {
        subView = (KKWaitingView*)[aView viewWithTag:KKWaitingView_TagWindow];
    }
    else{
        subView = (KKWaitingView*)[aView viewWithTag:KKWaitingView_TagView];
    }

    if (subView) {
        [subView kk_bringToFront];
        
        if (animation) {
            [UIView animateWithDuration:0.25 animations:^{
                subView.alpha = 0;
            } completion:^(BOOL finished) {
                [subView removeFromSuperview];
            }];
        }
        else{
            [subView removeFromSuperview];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString*)aText{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = aText;
        self.backgroundColor = [UIColor clearColor];
        [[UIWindow kk_currentKeyWindow] endEditing:YES];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.superview) {
        self.frame = self.superview.bounds;
        [self kk_removeAllSubviews];
        [self initUI];
    }
}

- (void)initUI{
    //黑色背景
    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
    button.backgroundColor = [UIColor clearColor];
    button.alpha = 0.6;
    [self addSubview:button];
    
    if ([NSString kk_isStringNotEmpty:self.text]) {
        CGFloat img_width = 40;
        CGFloat img_height = 40;
        CGFloat spaceBetweenX = 15;
        CGFloat spaceBetweenY = 15;

        UIColor *textColor = [UIColor whiteColor];
        UIFont  *textFont = [UIFont systemFontOfSize:15];
        CGSize  textSize = CGSizeZero;
        CGFloat boxHeight = 0;
        for (NSInteger line=1; line<100; line++) {
            CGFloat textH = [UIFont kk_heightForFont:textFont numberOfLines:line];
            CGFloat box_Height = spaceBetweenY+img_height+spaceBetweenY+textH+spaceBetweenY;
            CGFloat width = box_Height - spaceBetweenX*2;
            CGSize  text_Size = [self.text kk_sizeWithFont:textFont maxWidth:width];
            if (text_Size.height>textH) {
                continue;
            } else {
                textSize = text_Size;
                boxHeight = box_Height;
                break;
            }
        }

        CGFloat Y = (button.frame.size.height-boxHeight)/2.0-KKWaitingView_OffsetY;
        //大黑色框
        UIView *bigBoxView = [[UIView alloc] initWithFrame:CGRectMake((button.frame.size.width-boxHeight)/2.0, Y, boxHeight, boxHeight)];
        bigBoxView.backgroundColor = [UIColor blackColor];
        bigBoxView.alpha = 0.7;
        [bigBoxView kk_setCornerRadius:5];
        [self addSubview:bigBoxView];
        UIView *boxView = [[UIView alloc] initWithFrame:bigBoxView.frame];
        boxView.backgroundColor = [UIColor clearColor];
        [self addSubview:boxView];

        spaceBetweenY = (boxView.frame.size.height - img_height - textSize.height)/3.0;
        UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activeView.frame = CGRectMake((boxView.frame.size.width-img_width)/2.0, spaceBetweenY, img_width, img_height);
        activeView.userInteractionEnabled = NO;
        [activeView startAnimating];
        [boxView addSubview:activeView];

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((boxHeight-textSize.width)/2.0, CGRectGetMaxY(activeView.frame)+spaceBetweenY, textSize.width, textSize.height)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = textColor;
        textLabel.font = textFont;
        textLabel.text = self.text;
        textLabel.numberOfLines = 0;
        [boxView addSubview:textLabel];
    }
    else {
        CGFloat img_width = 40;
        CGFloat img_height = 40;
        CGFloat spaceBetween = 15;
        CGFloat boxHeight = spaceBetween + img_height + spaceBetween;

        CGFloat Y = (button.frame.size.height-boxHeight)/2.0-KKWaitingView_OffsetY;
        //大黑色框
        UIView *bigBoxView = [[UIView alloc] initWithFrame:CGRectMake((button.frame.size.width-boxHeight)/2.0, Y, boxHeight, boxHeight)];
        bigBoxView.backgroundColor = [UIColor blackColor];
        bigBoxView.alpha = 0.7;
        [bigBoxView kk_setCornerRadius:5];
        [self addSubview:bigBoxView];
        UIView *boxView = [[UIView alloc] initWithFrame:bigBoxView.frame];
        boxView.backgroundColor = [UIColor clearColor];
        [self addSubview:boxView];

        UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activeView.frame = CGRectMake((boxView.frame.size.width-img_width)/2.0, spaceBetween, img_width, img_height);
        activeView.userInteractionEnabled = NO;
        [activeView startAnimating];
        [boxView addSubview:activeView];
    }
    
}

@end
