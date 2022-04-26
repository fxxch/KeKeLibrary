//
//  UIFont+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (KKCategory)

/**
 某个字体所对应的单个汉字的尺寸大小
 
 @param aFont 字体
 @return 大小
 */
+ (CGSize)kk_sizeOfFont:(nonnull UIFont*)aFont;

/**
 某个字体大小所对应的单个汉字的尺寸大小
 
 @param aSize 字体大小
 @return 大小
 */
+ (CGSize)kk_systemFontSize:(CGFloat)aSize;

/**
 某个加粗字体大小所对应的单个汉字的尺寸大小
 
 @param aSize 字体大小
 @return 大小
 */
+ (CGSize)kk_boldSystemFontSize:(CGFloat)aSize;

/**
 某个字体的高度
 
 @param aFont 字体
 @return 高度
 */
+ (CGFloat)kk_heightForFont:(UIFont*_Nonnull)aFont;

/**
 某个字体的多行高度
 
 @param aFont 字体
 @return 高度
 */
+ (CGFloat)kk_heightForFont:(UIFont*_Nonnull)aFont numberOfLines:(NSInteger)numberOfLines;

@end
