//
//  UITableViewCell+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (KKCategory)

/**
 设置未选中时候的颜色
 
 @param color color
 */
- (void)setBackgroundViewColor:(nullable UIColor *)color;

/**
 设置未选中时候的图片
 
 @param image image
 */
- (void)setBackgroundViewImage:(nullable UIImage *)image;

/**
 设置选中时候的颜色
 
 @param color color
 */
- (void)setSelectedBackgroundViewColor:(nullable UIColor *)color;

/**
 设置选中时候的图片
 
 @param image image
 */
- (void)setSelectedBackgroundViewImage:(nullable UIImage *)image;

@end
