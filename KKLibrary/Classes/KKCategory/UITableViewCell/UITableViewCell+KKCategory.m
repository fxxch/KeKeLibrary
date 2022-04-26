//
//  UITableViewCell+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UITableViewCell+KKCategory.h"

@implementation UITableViewCell (KKCategory)

/**
 设置未选中时候的颜色
 
 @param color color
 */
- (void)kk_setBackgroundViewColor:(nullable UIColor *)color {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    if (color == nil) {
        color = [UIColor whiteColor];
    }
    
    if (self.backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [backgroundView setOpaque:YES];
        [self setBackgroundView:backgroundView];
        backgroundView = nil;
    }
    [self.backgroundView setBackgroundColor:color];
}

/**
 设置未选中时候的图片
 
 @param image image
 */
- (void)kk_setBackgroundViewImage:(nullable UIImage *)image  {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    if (image == nil) {
        [self kk_setBackgroundViewColor:nil];
        return ;
    }
    
    if (![self.backgroundView isMemberOfClass:[UIImageView class]]) {
        [self.backgroundView removeFromSuperview];
    }
    
    UIImageView *imageView = (UIImageView *)[self backgroundView];
    
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self setBackgroundView:imageView];
    }
    
    [imageView setImage:image];
}

/**
 设置选中时候的颜色
 
 @param color color
 */
- (void)kk_setSelectedBackgroundViewColor:(nullable UIColor *)color {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    if (color == nil) {
        color = [UIColor whiteColor];
    }
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [selectedBackgroundView setOpaque:YES];
    [self setSelectedBackgroundView:selectedBackgroundView];
    selectedBackgroundView = nil;
    [self.selectedBackgroundView setBackgroundColor:color];
}

/**
 设置选中时候的图片
 
 @param image image
 */
- (void)kk_setSelectedBackgroundViewImage:(nullable UIImage *)image {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    if (image == nil) {
        [self kk_setSelectedBackgroundViewColor:nil];
        return ;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [imageView setImage:image];
    [self setSelectedBackgroundView:imageView];
    imageView = nil;
}

@end
