//
//  KKToastView.m
//  GouUseCore
//
//  Created by liubo on 2017/8/14.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKToastView.h"
#import "KKCategory.h"

#define KKToastView_Tag 20170815

@implementation KKToastView


+ (KKToastView*_Nullable)showInView:(UIView*_Nullable)aView
                               text:(NSString*_Nullable)aText
                              image:(UIImage*_Nullable)aImage
                          alignment:(KKToastViewAlignment)alignment{
    
    return [KKToastView showInView:aView
                              text:aText
                             image:aImage
                         alignment:alignment
                    hideAfterDelay:0];
}

+ (KKToastView*_Nullable)showInView:(UIView*_Nullable)aView
                               text:(NSString*_Nullable)aText
                              image:(UIImage*_Nullable)aImage
                          alignment:(KKToastViewAlignment)alignment
                     hideAfterDelay:(NSTimeInterval)delay{
    
    if (aView==nil) {
        return nil;
    }
    
    //移除旧的
    for (UIView *subView in [aView subviews]) {
        if ([subView isKindOfClass:[KKToastView class]]) {
            subView.alpha = 0;
            subView.userInteractionEnabled = NO;
        }
    }
    
    //添加新的
    KKToastView *subView = [[KKToastView alloc] initWithFrame:aView.bounds
                                                         text:aText
                                                        image:aImage
                                                    alignment:alignment
                                               hideAfterDelay:delay];
    subView.tag = KKToastView_Tag;
    [aView addSubview:subView];
    [aView bringSubviewToFront:subView];
    
    return subView;
}

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString*)aText
                        image:(UIImage*)aImage
                    alignment:(KKToastViewAlignment)alignment
               hideAfterDelay:(NSTimeInterval)delay{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //黑色背景
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        button.backgroundColor = [UIColor clearColor];
        [self addSubview:button];

        UIFont *textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        CGFloat fontHeight = [UIFont kk_heightForFont:textFont];
        UIColor *textColor = [UIColor whiteColor];
        CGFloat maxWidth_BalckBox = KKApplicationWidth-160;
        CGFloat maxWidth_Text = maxWidth_BalckBox-30;
        CGSize  textSize = [aText kk_sizeWithFont:textFont
                                          maxSize:CGSizeMake(maxWidth_Text, 5500)];
        

        CGFloat boxViewHeight = 0;
        CGFloat boxViewWidth = 0;
        if (aImage) {
            boxViewHeight = 15 + aImage.size.height + 10 + textSize.height + 15;
            boxViewWidth = MAX(textSize.width, aImage.size.width)+30;
        }
        else{
            boxViewHeight = 15 + textSize.height + 15;
            boxViewWidth = textSize.width+30;
        }
        
        
        CGFloat offsetY = 0;
        if (alignment==KKToastViewAlignment_Top) {
            offsetY = 40;
        }
        else if (alignment==KKToastViewAlignment_Center) {
            offsetY = (self.frame.size.height-boxViewHeight)/2.0-50;
        }
        else{
            offsetY = self.frame.size.height-85-boxViewHeight;
        }
        
        CGRect frame = CGRectMake((self.frame.size.width-boxViewWidth)/2.0,
                                  offsetY,
                                  boxViewWidth,
                                  boxViewHeight);
        
        //黑色框
        UIView *boxView = [[UIView alloc] initWithFrame:frame];
        boxView.backgroundColor = [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f];
        boxView.alpha = 0.75;
        [boxView kk_setCornerRadius:5.0f];
        [self addSubview:boxView];
        UIView *contentView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:contentView];
        
        if (aImage) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width-aImage.size.width)/2.0, 15, aImage.size.width, aImage.size.height)];
            imageView.image = aImage;
            [contentView addSubview:imageView];
        }
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, contentView.frame.size.height-15-textSize.height, textSize.width, textSize.height)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = textColor;
        textLabel.numberOfLines = 0;
        textLabel.font = textFont;
        textLabel.text = aText;
        [contentView addSubview:textLabel];
        
        if (delay<=0) {
            //两行
            if (textSize.height>fontHeight+1) {
                [self performSelector:@selector(hideAndRemoveSelf) withObject:nil afterDelay:2.5f];
            }
            else{
                [self performSelector:@selector(hideAndRemoveSelf) withObject:nil afterDelay:1.5f];
            }
        }
        else{
            [self performSelector:@selector(hideAndRemoveSelf) withObject:nil afterDelay:delay];
        }
    }
    return self;
}

- (void)hideAndRemoveSelf{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

@end

