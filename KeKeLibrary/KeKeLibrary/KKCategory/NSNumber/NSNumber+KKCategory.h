//
//  NSNumber+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNumber (KKCategory)

//产生>= from 小于to 的随机数
+(NSInteger)randomIntegerBetween:(int)from and:(int)to;

/*是否是整数*/
- (BOOL)isInt;

/*是否是整数*/
- (BOOL)isInteger;

/*是否是浮点数*/
- (BOOL)isFloat;

/*是否是高精度浮点数*/
- (BOOL)isDouble;

@end
