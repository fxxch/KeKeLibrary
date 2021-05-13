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

@property (nonatomic , weak) UIView *cusView;

@end

@implementation KKWaitingView

+ (KKWaitingView*)showInView:(UIView*)aView
                    withType:(KKWaitingViewType)aType
             blackBackground:(BOOL)aBlackBackground
                        text:(NSString*)aText{

    [KKWaitingView hideForView:aView animation:NO];
    
    KKWaitingView *subView = [[KKWaitingView alloc] initWithFrame:aView.bounds
                                                             type:aType
                                                     customerView:nil
                                                  blackBackground:aBlackBackground
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

+ (KKWaitingView*)showInView:(UIView*)aView
                customerView:(UIView*)aCustomerView{

    [KKWaitingView hideForView:aView animation:NO];
    
    KKWaitingView *subView = [[KKWaitingView alloc] initWithFrame:aView.bounds
                                                             type:KKWaitingViewType_Customer
                                                     customerView:aCustomerView
                                                  blackBackground:NO
                                                             text:nil];
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
        [subView bringToFront];
        
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
                         type:(KKWaitingViewType)aType
                 customerView:(UIView*)aCustomerView
              blackBackground:(BOOL)aBlackBackground
                         text:(NSString*)aText{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = aType;
        self.text = aText;
        self.blackBackground = aBlackBackground;
        self.backgroundColor = [UIColor clearColor];
        self.cusView = aCustomerView;
        
        [[UIWindow currentKeyWindow] endEditing:YES];
        
        [self initUIWithCustomerView:aCustomerView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.superview) {
                
        self.frame = self.superview.bounds;
        
        BOOL cus = NO;
        for (UIView *subView in [self subviews]) {
            if (subView==self.cusView) {
                subView.frame = CGRectMake((self.frame.size.width-subView.frame.size.width)/2.0, (self.frame.size.height-subView.frame.size.height)/2.0-KKWaitingView_OffsetY, subView.frame.size.width, subView.frame.size.height);
                cus = YES;
                break;
            }
        }
        if (cus==NO) {
            [self removeAllSubviews];
            [self initUIWithCustomerView:self.cusView];
        }
        
        KKLogDebugFormat(@"layoutSubviews: %@",(NSStringFromCGRect(self.superview.frame)));
    }
}

- (void)initUIWithCustomerView:(UIView*)aCustomerView{

    if (aCustomerView) {
        aCustomerView.frame = CGRectMake((self.frame.size.width-aCustomerView.frame.size.width)/2.0, (self.frame.size.height-aCustomerView.frame.size.height)/2.0-KKWaitingView_OffsetY, aCustomerView.frame.size.width, aCustomerView.frame.size.height);
        [self addSubview:aCustomerView];
        return;
    }
    
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
        NSString *bundlePath = [[NSBundle kkLibraryBundle] bundlePath];
        NSString *filepath = nil;
        if ([bundlePath hasSuffix:@"/"]) {
            filepath = [NSString stringWithFormat:@"%@KKWaitingView.bundle/%@/%02ld_%@.png",bundlePath,imageType,(long)i,imageType];
        }
        else{
            filepath = [NSString stringWithFormat:@"%@/KKWaitingView.bundle/%@/%02ld_%@.png",bundlePath,imageType,(long)i,imageType];
        }
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
        CGFloat text_width = self.frame.size.width-160;

        UIColor *textColor = [UIColor whiteColor];
        UIFont *textFont = [UIFont systemFontOfSize:15];
        CGSize size = [self.text sizeWithFont:textFont maxSize:CGSizeMake(text_width, 1000)];
        if ([NSString isStringEmpty:self.text]) {
            size = CGSizeZero;
            spaceBetween = 0;
        }

        CGFloat Y = (self.frame.size.height-img_height-spaceBetween-size.height)/2.0-KKWaitingView_OffsetY;
        
        
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
        CGFloat bigBox_width = self.frame.size.width-160;
        CGFloat text_width = bigBox_width-30;
        
        UIColor *textColor = [UIColor whiteColor];
        UIFont  *textFont = [UIFont systemFontOfSize:15];
        CGSize  fontSize = [UIFont sizeOfFont:textFont];
        CGSize  textSize = [self.text sizeWithFont:textFont maxWidth:text_width];
        //文字长度超过一行
        if (textSize.height>fontSize.height+1) {
            bigBox_width = self.frame.size.width-160;
            text_width = bigBox_width-30;
        }
        //文字长度不超过一行
        else{
            bigBox_width = MAX(textSize.width + 30, 150);
            text_width = bigBox_width-30;
            textSize = CGSizeMake(bigBox_width-30, fontSize.height);
        }

        if ([NSString isStringEmpty:self.text]) {
            textSize = CGSizeZero;
            spaceBetween = 0;
        }
        KKLogEmpty([NSNumber numberWithFloat:text_width]);
        
        CGFloat bigBox_height = 0;
        if ([NSString isStringNotEmpty:self.text]) {
            bigBox_height = (25+img_height+spaceBetween+textSize.height+25);
        }
        else{
            bigBox_height = (25+img_height+25);
        }
        if (bigBox_height<bigBox_width) {
            bigBox_width = bigBox_height;
        }
        
        CGFloat Y = (button.frame.size.height-bigBox_height)/2.0-KKWaitingView_OffsetY;
        
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
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bigBoxView.frame)+15, Y, bigBoxView.frame.size.width-30, textSize.height)];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.textColor = textColor;
            textLabel.font = textFont;
            textLabel.text = self.text;
            textLabel.numberOfLines = 0;
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
