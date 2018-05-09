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
 某个字体所对应的单个汉字的尺寸大小
 
 @param aFont 字体
 @return 大小
 */
+ (CGSize)sizeOfFont:(nonnull UIFont*)aFont{
    NSString *string = @"我";
    return [string sizeWithFont:aFont maxWidth:1000];
}

/**
 某个字体大小所对应的单个汉字的尺寸大小
 
 @param aSize 字体大小
 @return 大小
 */
+ (CGSize)systemFontSize:(CGFloat)aSize{
    NSString *string = @"我";
    return [string sizeWithFont:[UIFont systemFontOfSize:aSize] maxWidth:1000];
}

/**
 某个加粗字体大小所对应的单个汉字的尺寸大小
 
 @param aSize 字体大小
 @return 大小
 */
+ (CGSize)boldSystemFontSize:(CGFloat)aSize{
    NSString *string = @"我";
    return [string sizeWithFont:[UIFont boldSystemFontOfSize:aSize] maxWidth:1000];
}

@end
