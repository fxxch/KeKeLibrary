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

/**
 某个字体的高度
 
 @param aFont 字体
 @return 高度
 */
+ (CGFloat)heightForFont:(UIFont*)aFont{
    return [UIFont heightForFont:aFont numberOfLines:1];
}

/**
 某个字体的多行高度
 
 @param aFont 字体
 @return 高度
 */
+ (CGFloat)heightForFont:(UIFont*)aFont numberOfLines:(NSInteger)numberOfLines{
    
    
    NSInteger lineCount = MAX(numberOfLines, 1);

//    NSString *string = @"我";
//    for (NSInteger i=1; i<lineCount; i++) {
//        string = [string stringByAppendingString:@"\n我"];
//    }
//    CGFloat height = [string sizeWithFont:aFont maxWidth:1000].height;

    CGFloat height1 = ceilf(aFont.lineHeight*lineCount);
    
    return height1;
}


@end
