//
//  UITextField+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (KKCategory)

/**
 设置占位符字体颜色
 
 @param color color
 */
- (void)setPlaceholderColor:(nullable UIColor *)color;

/**
 设置背景图片
 
 @param image image
 */
- (void)setBackgroundImage:(nullable UIImage *)image;

/**
 设置背景图片
 
 @param image image
 @param x 起始位置x
 @param y 起始位置y
 
 */
- (void)setBackgroundImage:(nullable UIImage *)image stretchWithX:(NSInteger)x stretchWithY:(NSInteger)y;

/**
 取消背景图片
 
 @param image image
 @param x 起始位置x
 @param y 起始位置y
 */
- (void)setDisabledBackgroundImage:(nullable UIImage *)image stretchWithX:(NSInteger)x stretchWithY:(NSInteger)y;

/**
 设置左边Label
 
 @param text 文字
 @param textColor 文字颜色
 @param width 宽度
 */
- (void)setLeftLabelTitle:(nullable NSString *)text textColor:(nullable UIColor *)textColor width:(CGFloat)width;

/**
 设置左边Label
 
 @param text 文字
 @param textColor 文字颜色
 @param font 文字字体
 @param width 宽度
 @param backgroundColor 背景颜色
 */
- (void)setLeftLabelTitle:(nullable NSString *)text
                textColor:(nullable UIColor *)textColor
                 textFont:(nullable UIFont *)font
                    width:(CGFloat)width
          backgroundColor:(nullable UIColor *)backgroundColor;

/**
 设置右边Label
 
 @param text 文字
 @param textColor 文字颜色
 @param font 文字字体
 @param width 宽度
 @param backgroundColor 背景颜色
 */
- (void)setRightLabelTitle:(nullable NSString *)text
                 textColor:(nullable UIColor *)textColor
                  textFont:(nullable UIFont *)font
                     width:(CGFloat)width
           backgroundColor:(nullable UIColor *)backgroundColor;

- (void)setMaxTextLenth:(int)length;

@end
