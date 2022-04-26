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

//产生>= from <=to 的随机数
+(NSInteger)kk_randomIntegerBetween:(int)from and:(int)to;

/*是否是整数*/
- (BOOL)kk_isInt;

/*是否是整数*/
- (BOOL)kk_isInteger;

/*是否是浮点数*/
- (BOOL)kk_isFloat;

/*是否是高精度浮点数*/
- (BOOL)kk_isDouble;

@end
