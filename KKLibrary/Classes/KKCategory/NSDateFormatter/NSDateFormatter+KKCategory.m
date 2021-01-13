//
//  NSDateFormatter+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSDateFormatter+KKCategory.h"

@implementation NSDateFormatter (KKCategory)

/**
 返回默认的NSDateFormatter
 
 @return 结果
 */
+ (nonnull NSDateFormatter*)defaultFormatter{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //    NSLocale *en_US_POSIX_Locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    //    [dateFormatter setLocale:en_US_POSIX_Locale];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    
    return dateFormatter;
}


@end
