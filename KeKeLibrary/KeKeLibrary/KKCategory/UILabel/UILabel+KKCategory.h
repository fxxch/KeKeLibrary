//
//  UILabel+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (KKCategory)

#pragma mark ==================================================
#pragma mark ==设置样式
#pragma mark ==================================================
- (void)setTextColor:(nullable UIColor *)textColor
               range:(NSRange)range;

- (void)setFont:(nullable UIFont *)font
          range:(NSRange)range;

- (void)setTextColor:(nullable UIColor *)textColor afterOccurenceOfString:(nullable NSString*)separator;

- (void)setFont:(nullable UIFont *)font afterOccurenceOfString:(nullable NSString*)separator;

- (void)setTextColor:(nullable UIColor *)textColor contentString:(nullable NSString *)string;

- (void)setFont:(nullable UIFont *)font contentString:(nullable NSString *)contentString;

#pragma mark ==================================================
#pragma mark ==创建UILabel
#pragma mark ==================================================
/**
 快速创建UILabel （行数默认一行，宽度默认屏幕宽度）
 
 @param textColor 字体颜色
 @param fontSize 字体大小加粗
 @param text 文字
 @return UILabel
 */
+ (nullable UILabel *)labelWithTextColor:(nullable UIColor *)textColor
                                fontSize:(NSInteger)fontSize
                                    text:(nullable NSString *)text;

/**
 快速创建UILabel （行数默认一行，宽度默认屏幕宽度）
 
 @param textColor 字体颜色
 @param fontSize 字体大小加粗
 @param text 文字
 @param maxWidth 最大宽度
 @return UILabel
 */
+ (nullable UILabel *)labelWithTextColor:(nullable UIColor *)textColor
                                fontSize:(NSInteger)fontSize
                                    text:(nullable NSString *)text
                                maxWidth:(CGFloat)maxWidth;
/**
 快速创建UILabel
 
 @param textColor 字体颜色
 @param fontSize 字体大小不加粗
 @param text 文字
 @param lines 行数
 @param maxWidth 最大宽度
 @return UILabel
 */
+ (nullable UILabel *)labelWithTextColor:(nullable UIColor *)textColor
                                fontSize:(NSInteger)fontSize
                                    text:(nullable NSString *)text
                                   lines:(NSInteger)lines
                                maxWidth:(CGFloat)maxWidth;

/**
 快速创建UILabel
 
 @param textColor 字体颜色
 @param fontSize 字体大小加粗
 @param text 文字
 @param lines 行数
 @param maxWidth 最大宽度
 @return UILabel
 */
+ (nullable UILabel *)labelWithTextColor:(nullable UIColor *)textColor
                            fontSizeBold:(NSInteger)fontSize
                                    text:(nullable NSString *)text
                                   lines:(NSInteger)lines
                                maxWidth:(CGFloat)maxWidth;

/**
 快速创建UILabel
 
 @param textColor 字体颜色
 @param font 字体
 @param text 文字
 @param lines 行数
 @param maxWidth 最大宽度
 @return UILabel
 */
+ (nullable UILabel *)labelWithTextColor:(nullable UIColor *)textColor
                                    font:(nullable UIFont *)font
                                    text:(nullable NSString *)text
                                   lines:(NSInteger)lines
                                maxWidth:(CGFloat)maxWidth;

@end
