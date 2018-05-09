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


+ (KKToastView*)showInView:(UIView*)aView
                      text:(NSString*)aText
                 alignment:(KKToastViewAlignment)alignment{

    return [KKToastView showInView:aView
                              text:aText
                         alignment:alignment
                    hideAfterDelay:0];
}

+ (KKToastView*)showInView:(UIView*)aView
                      text:(NSString*)aText
                 alignment:(KKToastViewAlignment)alignment
            hideAfterDelay:(NSTimeInterval)delay{

    //移除旧的
    for (UIView *subView in [aView subviews]) {
        if ([subView isKindOfClass:[KKToastView class]]) {
//            [subView removeFromSuperview];
            subView.alpha = 0;
        }
    }
    
    //添加新的
    KKToastView *subView = [[KKToastView alloc] initWithFrame:aView.bounds
                                                         text:aText
                                                    alignment:alignment
                                               hideAfterDelay:delay];
    subView.tag = KKToastView_Tag;
    [aView addSubview:subView];
    [aView bringSubviewToFront:subView];
    
    return subView;
}

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString*)aText
                    alignment:(KKToastViewAlignment)alignment
               hideAfterDelay:(NSTimeInterval)delay{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //黑色背景
        UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
        button.backgroundColor = [UIColor clearColor];
//        [button addTarget:self action:@selector(backgroundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        UIFont *textFont = [UIFont systemFontOfSize:17];
        UIColor *textColor = [UIColor whiteColor];
        CGFloat maxWidth_Balck = 297;
        CGFloat maxWidth_Text = maxWidth_Balck-30;
        
        CGSize textSize = [aText sizeWithFont:textFont
                                      maxSize:CGSizeMake(maxWidth_Text, 55)];
        
        
        
        CGFloat Y = 0;
        if (alignment==KKToastViewAlignment_Top) {
            Y = 40;
        }
        else if (alignment==KKToastViewAlignment_Center) {
            Y = (self.frame.size.height-(10+textSize.height+10))/2.0;
        }
        else{
            Y = self.frame.size.height-85-(10+textSize.height+10);
        }
        
        
        CGSize fontsize = [UIFont sizeOfFont:textFont];
        
        //黑色框
        UIView *boxView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-textSize.width-30)/2.0, Y, textSize.width+30, textSize.height+20)];
        boxView.backgroundColor = [UIColor blackColor];
        [boxView setCornerRadius:(fontsize.height+20)/2.0];
        [self addSubview:boxView];
        
        Y = Y+10;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(boxView.frame)+15, Y, textSize.width, textSize.height)];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = textColor;
        textLabel.numberOfLines = 0;
        textLabel.font = textFont;
        textLabel.text = aText;
        [self addSubview:textLabel];
        
        if (delay<=0) {
            //两行
            if (textSize.height>fontsize.height+1) {
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

