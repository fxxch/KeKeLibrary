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

- (void)setUnderLine:(nullable UIColor *)underLineColor
               range:(NSRange)range;

- (void)setUnderLine:(nullable UIColor *)underLineColor contentString:(nullable NSString *)contentString;

- (void)setCenterLine:(nullable UIColor *)centerLineColor
                range:(NSRange)range;

- (void)setCenterLine:(nullable UIColor *)centerLineColor contentString:(nullable NSString *)contentString;

#pragma mark ==================================================
#pragma mark ==创建UILabel
#pragma mark ==================================================
/**
 快速创建UILabel （行数默认一行，宽度默认屏幕宽度）
 
 @param textColor 字体颜色
 @param font 字体
 @param text 文字
 @return UILabel
 */
+ (nullable UILabel *)kk_initWithTextColor:(nullable UIColor *)textColor
                                      font:(UIFont*_Nullable)font
                                      text:(nullable NSString *)text;

/**
 快速创建UILabel （行数默认一行，宽度默认屏幕宽度）

 @param textColor 字体颜色
 @param font 字体
 @param text 文字
 @param maxWidth 最大宽度
 @return UILabel
 */
+ (nullable UILabel *)kk_initWithTextColor:(nullable UIColor *)textColor
                                      font:(UIFont*_Nullable)font
                                      text:(nullable NSString *)text
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
+ (instancetype _Nullable )kk_initWithTextColor:(nullable UIColor *)textColor
                                font:(nullable UIFont *)font
                                text:(nullable NSString *)text
                               lines:(NSInteger)lines
                            maxWidth:(CGFloat)maxWidth;


+ (UILabel *_Nullable)createNewlabelWithColor:(UIColor *_Nullable)color andFont:(UIFont *_Nullable)font andTextAlignment:(NSTextAlignment)textAlign;

+ (UILabel *_Nullable)createNewlabelWithColor:(UIColor *_Nullable)color andFont:(UIFont *_Nullable)font andTextAlignment:(NSTextAlignment)textAlign andLineNum:(NSInteger)lineNum;

@end
