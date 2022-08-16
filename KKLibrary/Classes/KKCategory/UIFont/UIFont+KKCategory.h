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
 某个字体的高度
 
 @param aFont 字体
 @return 高度
 */
+ (CGFloat)kk_heightForFont:(UIFont*)aFont;

/**
 某个字体的多行高度
 
 @param aFont 字体
 @return 高度
 */
+ (CGFloat)kk_heightForFont:(UIFont*)aFont numberOfLines:(NSInteger)numberOfLines;

@end
