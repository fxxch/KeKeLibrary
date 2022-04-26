//
//  UIColor+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KKCategory)


/**
 将UIColor转换成十六进制的颜色值
 
 @param color 颜色
 @return 结果
 */
+ (nonnull NSString *)kk_hexStringFromColor:(nullable UIColor *)color;

/**
 将十六进制的颜色值转换成UIColor
 
 @param hexString 十六进制颜色
 @return 结果
 */
+ (nonnull UIColor *)kk_colorWithHexString:(nonnull NSString *)hexString;


/**
 将十六进制的颜色值转换成UIColor

 @param hexString 十六进制颜色
 @param alphaValue 透明度
 @return 结果
 */
+ (nonnull UIColor *)kk_colorWithHexString:(nonnull NSString *)hexString alpha:(CGFloat)alphaValue;

/**
 从UIColor里面获取RGB值
 
 @param color color
 @return 结果
 */
+ (nonnull NSArray *)kk_RGBAValue:(nonnull UIColor*)color;

/**
 通过RGBA值创建color
 
 @param rValue rValue（0-255）
 @param gValue gValue（0-255）
 @param bValue bValue（0-255）
 @param alpha alpha（0-1）
 @return return 结果
 */
+ (nonnull UIColor *)kk_colorWithR:(CGFloat)rValue
                                 G:(CGFloat)gValue
                                 B:(CGFloat)bValue
                             alpha:(CGFloat)alpha;

/**
 随机生成颜色
 @return 结果
 */
+ (nonnull UIColor *)kk_RandomColorRGB;

/**
 随机生成颜色
 @return 结果
 */
+ (nonnull UIColor *)kk_RandomColorRGBA;

@end
