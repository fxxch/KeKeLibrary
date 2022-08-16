//
//  UIFont+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIFont+KKCategory.h"
#import "NSString+KKCategory.h"

@implementation UIFont (KKCategory)

/**
 某个字体的高度
 
 @param aFont 字体
 @return 高度
 */
+ (CGFloat)kk_heightForFont:(UIFont*)aFont{
    return [UIFont kk_heightForFont:aFont numberOfLines:1];
}

/**
 某个字体的多行高度
 
 @param aFont 字体
 @return 高度
 */
+ (CGFloat)kk_heightForFont:(UIFont*)aFont numberOfLines:(NSInteger)numberOfLines{
    NSInteger lineCount = MAX(numberOfLines, 1);
    CGFloat height = ceilf(aFont.lineHeight*lineCount);
    return height;
}


@end
