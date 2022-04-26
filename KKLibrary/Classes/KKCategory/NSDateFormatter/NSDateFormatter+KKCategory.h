//
//  NSDateFormatter+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDateFormatter (KKCategory)

/**
 返回默认的NSDateFormatter
 
 @return 结果
 */
+ (nonnull NSDateFormatter*)kk_defaultFormatter;

@end
