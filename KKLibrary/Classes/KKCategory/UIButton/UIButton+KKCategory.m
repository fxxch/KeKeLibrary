//
//  UIButton+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIButton+KKCategory.h"
#import "UIImage+KKCategory.h"
#import "NSString+KKCategory.h"
#import "UIView+KKCategory.h"

@implementation UIButton (KKCategory)

- (void)setBackgroundColor:(nullable UIColor *)backgroundColor
                  forState:(UIControlState)controlState{
    
    UIImage *image = [UIImage imageWithColor:backgroundColor size:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    [self setBackgroundImage:image forState:controlState];
}

- (void)setBackgroundImage:(nullable UIImage *)image
                  forState:(UIControlState)state
               contentMode:(UIViewContentMode)contentMode{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.contentMode = contentMode;
    imageView.image = image;
    UIImage *newImage = [imageView snapshot];
    [self setBackgroundImage:newImage forState:state];
}

- (void)setButtonContentAlignment:(ButtonContentAlignment)contentAlignment
         ButtonContentLayoutModal:(ButtonContentLayoutModal)contentLayoutModal
       ButtonContentTitlePosition:(ButtonContentTitlePosition)contentTitlePosition
        SapceBetweenImageAndTitle:(CGFloat)aSpace
                       EdgeInsets:(UIEdgeInsets)aEdgeInsets{
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;
    
    NSString *aTitle = self.titleLabel.text;
    
    CGSize titleSize = [aTitle sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(self.frame.size.width, 1000)];
    
    CGSize aImageSize = self.imageView.frame.size;
    if (!self.imageView.image) {
        aImageSize = CGSizeZero;
    }
    
    
    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointZero;
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointZero;
    
    
    //垂直对齐
    if (contentLayoutModal==ButtonContentLayoutModalVertical) {
        if (contentAlignment==ButtonContentAlignmentLeft) {
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height+aSpace+aImageSize.height);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height/2.0);
                
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height+aSpace+titleSize.height/2.0);
            }
            else{
                
            }
        }
        else if (contentAlignment==ButtonContentAlignmentCenter){
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height+aSpace+aImageSize.height);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height/2.0);
                
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height+aSpace+titleSize.height/2.0);
            }
            else{
                
            }
        }
        else if (contentAlignment==ButtonContentAlignmentRight){
            
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height+aSpace+aImageSize.height);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height/2.0);
                
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height+aSpace+titleSize.height/2.0);
            }
            else{
                
            }
        }
        else{
            
        }
    }
    //水平对齐
    else if (contentLayoutModal==ButtonContentLayoutModalHorizontal){
        if (contentAlignment==ButtonContentAlignmentLeft) {
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+titleSize.width/2.0, self.frame.size.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(aEdgeInsets.left+titleSize.width+aImageSize.width/2.0+aSpace, self.frame.size.height/2.0);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+titleSize.width/2.0+aImageSize.width+aSpace, self.frame.size.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(aEdgeInsets.left+aImageSize.width/2.0, self.frame.size.height/2.0);
            }
            else{
                
            }
        }
        else if (contentAlignment==ButtonContentAlignmentCenter){
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                CGFloat endTitleLabelCenter_X = MAX((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+titleSize.width/2.0, titleSize.width/2.0+5);
                endTitleLabelCenter = CGPointMake(endTitleLabelCenter_X, self.frame.size.height/2.0);
                // 找出imageView最终的center
                CGFloat endImageViewCenter_X = MIN((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+titleSize.width+aSpace+aImageSize.width/2.0, self.frame.size.width-aImageSize.width/2.0);
                endImageViewCenter = CGPointMake(endImageViewCenter_X, self.frame.size.height/2.0);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+aImageSize.width/2.0, self.frame.size.height/2.0);
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(endImageViewCenter.x+(aImageSize.width)/2.0+aSpace+titleSize.width/2.0, self.frame.size.height/2.0);
            }
            else{
                
            }
        }
        else if (contentAlignment==ButtonContentAlignmentRight){
            
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(self.frame.size.width-titleSize.width/2.0-aImageSize.width-aEdgeInsets.right-aSpace, self.frame.size.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-aImageSize.width/2.0, self.frame.size.height/2.0);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(self.frame.size.width-aImageSize.width/2.0-titleSize.width-aEdgeInsets.right-aSpace, self.frame.size.height/2.0);
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-titleSize.width/2.0, self.frame.size.height/2.0);
            }
            else{
                
            }
        }
        else{
            
        }
    }
    else{
        
    }
    
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y+self.titleEdgeInsets.top;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x+self.titleEdgeInsets.left;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y+self.imageEdgeInsets.top;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x+self.imageEdgeInsets.left;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
}

+ (UIButton*)kk_initWithFrame:(CGRect)aFrame
                        title:(NSString*)aTitle
                    titleFont:(UIFont*)aFont
                   titleColor:(UIColor*)aTitleColor
              backgroundColor:(UIColor*)aBackgroundColor{
    
    UIButton *button = [[UIButton alloc] initWithFrame:aFrame];
    if (aBackgroundColor) {
        [button setBackgroundColor:aBackgroundColor forState:UIControlStateNormal];
    }
    [button setTitle:aTitle forState:UIControlStateNormal];
    button.titleLabel.font = aFont;
    [button setTitleColor:aTitleColor forState:UIControlStateNormal];
    return button;
}

@end
