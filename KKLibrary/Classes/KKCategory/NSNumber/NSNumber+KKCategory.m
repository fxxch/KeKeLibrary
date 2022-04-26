//
//  NSNumber+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSNumber+KKCategory.h"

@implementation NSNumber (KKCategory)

//产生>= from <=to 的随机数
+(NSInteger)kk_randomIntegerBetween:(int)from and:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

/*是否是整数*/
- (BOOL)kk_isInt{
    if (strcmp([self objCType], @encode(int)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}


/*是否是整数*/
- (BOOL)kk_isInteger{
    if (strcmp([self objCType], @encode(long)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}

/*是否是浮点数*/
- (BOOL)kk_isFloat{
    if (strcmp([self objCType], @encode(float)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}

/*是否是高精度浮点数*/
- (BOOL)kk_isDouble{
    if (strcmp([self objCType], @encode(double)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}

@end
