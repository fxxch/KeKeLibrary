//
//  NSDate+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSDate+KKCategory.h"
#import "NSDateFormatter+KKCategory.h"
#import "NSString+KKCategory.h"

@implementation NSDate (KKCategory)

/**
 日
 
 @return 日
 */
- (NSUInteger)day {
    NSDateFormatter *dateFormatter = [NSDateFormatter defaultFormatter];
    [dateFormatter setDateFormat:@"d"];

    NSUInteger returnValue = [[dateFormatter stringFromDate:self] intValue];
    
    return returnValue;
}

/**
 周（周一、周二、周三……）
 
 @return 周
 */
- (NSUInteger)weekday {
    NSDateFormatter *dateFormatter = [NSDateFormatter defaultFormatter];
    [dateFormatter setDateFormat:@"c"];
    
    NSUInteger returnValue = [[dateFormatter stringFromDate:self] intValue];
    
    return returnValue;
}


/**
 月份
 
 @return 月份
 */
- (NSUInteger)month {
    NSDateFormatter *dateFormatter = [NSDateFormatter defaultFormatter];
    [dateFormatter setDateFormat:@"M"];
    
    NSUInteger returnValue = [[dateFormatter stringFromDate:self] intValue];
    
    return returnValue;
}

/**
 年份
 
 @return 年份
 */
- (NSUInteger)year {
    NSDateFormatter *dateFormatter = [NSDateFormatter defaultFormatter];
    [dateFormatter setDateFormat:@"y"];
    
    NSUInteger returnValue = [[dateFormatter stringFromDate:self] intValue];
    
    return returnValue;
}

/**
 计算某个月的总天数
 
 @return 天数
 */
- (NSUInteger)numberOfDaysInMonth {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:self].length;
#else
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                              inUnit:NSCalendarUnitMonth
                                             forDate:self].length;
#endif
    
}


/**
 计算某个月的总周数
 
 @return 周数
 */
- (NSUInteger)weeksOfMonth {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:self].length;
#else
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth
                                              inUnit:NSCalendarUnitMonth
                                             forDate:self].length;
#endif
    
}


/**
 前一天
 
 @return 前一天
 */
- (nullable NSDate *)previousDate {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setDay:-1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                         toDate:self
                                                        options:0];
}

/**
 后一天
 
 @return 后一天
 */
- (nullable NSDate *)nextDate {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setDay:1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                         toDate:self
                                                        options:0];
}


/**
 某周的第一天
 
 @return 某周的第一天
 */
- (nullable NSDate *)firstDayOfWeek {
    NSDate *date = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#else
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#endif
    
    
    if (ok) {
        return date;
    }
    return nil;
}

/**
 某周的最后一天
 
 @return 某周的最后一天
 */
- (nullable NSDate *)lastDayOfWeek {
    return [[self firstDayOfNextWeek] previousDate];
}

/**
 下一周的第一天
 
 @return 下一周的第一天
 */
- (nullable NSDate *)firstDayOfNextWeek {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    [dateComp setWeek:1];
#else
    [dateComp setWeekOfMonth:1];
#endif
    
    return [[[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                          toDate:self
                                                         options:0] firstDayOfWeek];
}

/**
 下一周的最后一天
 
 @return 下一周的最后一天
 */
- (nullable NSDate *)lastDayOfNextWeek {
    return [[self firstDayOfNextWeek] lastDayOfWeek];
}


/**
 某月的第一天
 
 @return 某月的第一天
 */
- (nullable NSDate *)firstDayOfMonth {
    NSDate *date = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#else
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#endif
    
    if (ok) {
        return date;
    }
    return nil;
}

/**
 某月的最后一天
 
 @return 某月的最后一天
 */
- (nullable NSDate *)lastDayOfMonth {
    NSDate *date = nil;
    date = [[self firstDayOfNextMonth] previousDate];
    return date;
}


/**
 某个月的第一天是周几？
 
 @return 某个月的第一天是周几？
 */
- (NSUInteger)weekdayOfFirstDayInMonth {
    return [[self firstDayOfMonth] weekday];
}

/**
 某个月的上个月的第一天？
 
 @return 某个月的上个月的第一天？
 */
- (nullable NSDate *)firstDayOfPreviousMonth {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setMonth:-1];
    return [[[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                          toDate:self
                                                         options:0] firstDayOfMonth];
}

/**
 某个月的下个月的第一天？
 
 @return 某个月的下个月的第一天？
 */
- (nullable NSDate *)firstDayOfNextMonth {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setMonth:1];
    return [[[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                          toDate:self
                                                         options:0] firstDayOfMonth];
}


/**
 某个季度的第一天
 
 @return 某个季度的第一天
 */
- (nullable NSDate *)firstDayOfQuarter {
    NSDate *date = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSQuarterCalendarUnit
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#else
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitQuarter
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#endif
    
    if (ok) {
        return date;
    }
    return nil;
}

/**
 某个季度的最后一天
 
 @return 某个季度的最后一天
 */
- (nullable NSDate *)lastDayOfQuarter {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setQuarter:1];
    return [[[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                          toDate:self
                                                         options:0] lastDayOfMonth];
}

/**
 下个月的第一天
 
 @return 下个月的第一天
 */
- (nullable NSDate *)theDayOfNextMonth{
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setMonth:1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                         toDate:self
                                                        options:0];
}

/**
 下周的第一天
 
 @return 下周的第一天
 */
- (nullable NSDate *)theDayOfNextWeek{
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setWeekday:7];
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                         toDate:self
                                                        options:0];
}

/**
 返回指定日期格式的字符串
 
 @param formatterString 日期格式
 @return 结果
 */
+ (nullable NSString*)getStringWithFormatter:(nullable NSString*)formatterString{
    if ([NSString isStringEmpty:formatterString]) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter defaultFormatter];
    [dateFormatter setDateFormat:formatterString];
    NSString *nowDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return nowDateString;
}



/**
 将日期转换成日期字符串
 
 @param date 日期
 @param formatterString 需要转换成的日期格式
 @return 结果
 */
+ (nullable NSString*)getStringFromDate:(nullable NSDate*)date
                          dateFormatter:(nullable NSString*)formatterString{
    
    if ([NSString isStringEmpty:formatterString]) {
        return nil;
    }
    
    if (date==nil || (![date isKindOfClass:[NSDate class]])) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter defaultFormatter];
    [dateFormatter setDateFormat:formatterString];
    NSString *returnString = [dateFormatter stringFromDate:date];
    
    return returnString;
}


/**
 将日期字符串转换成日期
 
 @param string 日期字符串
 @param formatterString 日期字符串的格式
 @return 日期
 */
+ (nullable NSDate*)getDateFromString:(nullable NSString*)string dateFormatter:(nullable NSString*)formatterString{
    
    if ([NSString isStringEmpty:formatterString]) {
        return nil;
    }
    
    if ([NSString isStringEmpty:string]) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter defaultFormatter];
    [dateFormatter setDateFormat:formatterString];
    NSDate *oldDate = [dateFormatter dateFromString:string];
    
    return oldDate;
}

/**
 判断日期1 是否比日期2 要早
 
 @param date01 日期1
 @param date02 日期2
 @return 结果
 
 */
+ (BOOL)isDate:(nullable NSDate*)date01 earlierThanDate:(nullable NSDate*)date02{
    
    if (date01==nil || (![date01 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    if (date02==nil || (![date02 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    NSTimeInterval before = [date01 timeIntervalSince1970]*1;
    
    NSTimeInterval after = [date02 timeIntervalSince1970]*1;
    
    
    NSTimeInterval cha = after - before;
    
    
    if (cha>0) {
        return YES;
    }
    else {
        return NO;
    }
}

/**
 时间1 是否 > 时间2
 
 @param date01 时间1
 @param date02 时间2
 @return YES NO
 */
+ (BOOL)isDate:(nullable NSDate*)date01 laterThanDate:(nullable NSDate*)date02{
    
    if (date01==nil || (![date01 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    if (date02==nil || (![date02 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    NSTimeInterval before = [date01 timeIntervalSince1970]*1;
    
    NSTimeInterval after = [date02 timeIntervalSince1970]*1;
    
    
    NSTimeInterval cha = before - after;
    
    
    if (cha>0) {
        return YES;
    }
    else {
        return NO;
    }
}

/**
 根据时间戳返回日期字符串
 
 @param aTimestamp 时间戳字符串
 @param formatterString 需要返回的日期字符串格式
 @return 结果
 */
+ (nullable NSString *)getStringFromTimestamp:(NSString*)aTimestamp
                                    formatter:(nullable NSString*)formatterString
{
    if ([NSString isStringEmpty:aTimestamp]) {
        return nil;
    }
    
    
    //1970
    double timestamp = 0;
    if ([aTimestamp length]<=10) {
        timestamp = [aTimestamp doubleValue];
    }
    else{
        NSString *beishu = @"1";
        for (int i=0; i<[aTimestamp length]-10; i++) {
            beishu = [beishu stringByAppendingString:@"0"];
        }
        timestamp = [aTimestamp doubleValue]/([beishu integerValue]);
    }
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    return  [NSDate getStringFromDate:date dateFormatter:formatterString];
}

@end
