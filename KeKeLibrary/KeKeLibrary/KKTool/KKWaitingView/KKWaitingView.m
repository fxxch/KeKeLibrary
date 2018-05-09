//
//  KKWaitingView.m
//  GouUseCore
//
//  Created by liubo on 2017/8/9.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKWaitingView.h"
#import "KKCategory.h"
#import "KeKeLibraryDefine.h"
#import "KKSharedInstance.h"

#define KKWaitingView_Tag 20170809

@interface KKWaitingView ()

@property (nonatomic,assign)KKWaitingViewType type;
@property (nonatomic,strong)UILabel *textLabel;
@property (nonatomic,copy)NSString *text;
@property (nonatomic,assign)BOOL blackBackground;

@end

@implementation KKWaitingView

+ (KKWaitingView*)showInView:(UIView*)aView
                    withType:(KKWaitingViewType)aType
             blackBackground:(BOOL)aBlackBackground
                        text:(NSString*)aText{

    [KKWaitingView hideForView:aView animation:NO];
    
    KKWaitingView *subView = [[KKWaitingView alloc] initWithFrame:aView.bounds
                                                             type:aType
                                                  blackBackground:aBlackBackground
                                                             text:aText];
    subView.tag = KKWaitingView_Tag;
    [aView addSubview:subView];
    [aView bringSubviewToFront:subView];
    
    return subView;
}

+ (void)hideForView:(UIView*)aView{
    [KKWaitingView hideForView:aView animation:YES];
}

+ (void)hideForView:(UIView*)aView animation:(BOOL)animation{
    KKWaitingView *subView = (KKWaitingView*)[aView viewWithTag:KKWaitingView_Tag];
    if (subView) {
        [subView bringToFront];
        
        if (animation) {
            [UIView animateWithDuration:0.5 animations:^{
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
                         type:(KKWaitingViewType)aType
              blackBackground:(BOOL)aBlackBackground
                         text:(NSString*)aText{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = aType;
        self.text = aText;
        self.blackBackground = aBlackBackground;
        self.backgroundColor = [UIColor clearColor];
        
        [(UIWindow*)Window0 endEditing:YES];
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    NSMutableArray *animationImages = [NSMutableArray array];
    NSString *imageType = @"";
    
    if (self.type==KKWaitingViewType_White) {
        imageType = @"White";
    }
    else if (self.type==KKWaitingViewType_Gray){
        imageType = @"Gray";
    }
    else if (self.type==KKWaitingViewType_Green){
        imageType = @"Green";
    }
    else{
    
    }
    for (NSInteger i=1; i<=35; i++) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *filepath = [NSString stringWithFormat:@"%@/KKWaitingView.bundle/%@/%02ld_%@.png",bundlePath,imageType,(long)i,imageType];
        UIImage *image = [UIImage imageWithContentsOfFile:filepath];
        if (image) {
            [animationImages addObject:image];
        }
    }
    
    if (self.blackBackground) {
        
        //黑色背景
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.5;
        [self addSubview:button];
        
        //
        CGFloat img_width = 40;
        CGFloat img_height = 40;
        CGFloat spaceBetween = 25;
        CGFloat text_width = KKApplicationWidth-80;

        UIColor *textColor = [UIColor whiteColor];
        UIFont *textFont = [UIFont systemFontOfSize:15];
        CGSize size = [self.text sizeWithFont:textFont maxSize:CGSizeMake(text_width, 1000)];
        if ([NSString isStringEmpty:self.text]) {
            size = CGSizeZero;
            spaceBetween = 0;
        }

        CGFloat Y = (self.frame.size.height-img_height-spaceBetween-size.height)/2.0;
        
        
        //黑色框
        UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-img_width)/2.0, Y, img_width, img_height)];
        boxView.backgroundColor = [UIColor clearColor];
        boxView.alpha = 0.6;
        [self addSubview:boxView];

        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:boxView.frame];
        [self addSubview:iconImageView];
        iconImageView.tag = 20171024;
        iconImageView.userInteractionEnabled = NO;
        Y = Y + img_height;
        //开始旋转动画
        iconImageView.animationImages = animationImages;
        iconImageView.animationDuration = 2.0;
        [iconImageView startAnimating];
        
        if ([NSString isStringNotEmpty:self.text]) {
            Y = Y + spaceBetween;
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-text_width)/2.0, Y, text_width, size.height)];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.textColor = textColor;
            textLabel.numberOfLines = 0;
            textLabel.font = textFont;
            textLabel.text = self.text;
            [self addSubview:textLabel];
        }
    }
    else{
        //黑色背景
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        button.backgroundColor = [UIColor clearColor];
        button.alpha = 0.6;
        [self addSubview:button];
        
        //
        CGFloat img_width = 40;
        CGFloat img_height = 40;
        CGFloat spaceBetween = 25;
        CGFloat bigBox_width = 150;
        CGFloat text_width = 120;
        
        UIColor *textColor = [UIColor whiteColor];
        UIImage *iconImage = KKThemeImage(@"icon_NetWorkNotReachable");
        UIFont *textFont = [UIFont systemFontOfSize:15];
        CGSize size = [UIFont sizeOfFont:textFont];
        if ([NSString isStringEmpty:self.text]) {
            size = CGSizeZero;
            spaceBetween = 0;
        }
        
        
        CGFloat bigBox_height = 0;
        if ([NSString isStringNotEmpty:self.text]) {
            bigBox_height = (25+img_height+spaceBetween+size.height+25);
        }
        else{
            bigBox_height = (25+img_height+25);
        }
        
        CGFloat Y = (button.frame.size.height-bigBox_height)/2.0;
        
        //大黑色框
        UIView *bigBoxView = [[UIView alloc] initWithFrame:CGRectMake((button.frame.size.width-bigBox_width)/2.0, Y, bigBox_width, bigBox_height)];
        bigBoxView.backgroundColor = [UIColor blackColor];
        bigBoxView.alpha = 0.5;
        [bigBoxView setCornerRadius:5];
        [self addSubview:bigBoxView];
        Y = Y+25;

        //黑色框
        UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake((button.frame.size.width-img_width)/2.0, Y, img_width, img_height)];
        boxView.backgroundColor = [UIColor clearColor];
        boxView.alpha = 0.6;
        [self addSubview:boxView];

        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:boxView.frame];
        iconImageView.image = iconImage;
        iconImageView.tag = 20171024;
        [self addSubview:iconImageView];
        iconImageView.userInteractionEnabled = NO;
        Y = Y + img_height;
        //开始旋转动画
        iconImageView.animationImages = animationImages;
        iconImageView.animationDuration = 2.0;
        [iconImageView startAnimating];

        if ([NSString isStringNotEmpty:self.text]) {
            Y = Y+spaceBetween;
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bigBoxView.frame)+15, Y, text_width, size.height)];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.textColor = textColor;
            textLabel.font = textFont;
            textLabel.text = self.text;
            [self addSubview:textLabel];
        }
    }
}

- (void)startAnimating{
    
    UIImageView *imageView = [self viewWithTag:20171024];
    if (imageView && [imageView isKindOfClass:[UIImageView class]]) {
        [imageView startAnimating];
    }
}

- (void)stopAnimating{
    
    UIImageView *imageView = [self viewWithTag:20171024];
    if (imageView && [imageView isKindOfClass:[UIImageView class]]) {
        [imageView stopAnimating];
    }
}


@end
