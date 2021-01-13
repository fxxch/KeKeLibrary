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
#include <mach/mach_time.h>
#import "KKLocalizationManager.h"
#import "KKLog.h"

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
 将日期字符串转换成日期
 
 @param aString 日期字符串 可以是时间戳或者是以下时间字符串中的一种
 #define KKDateFormatter01 @"yyyy-MM-dd HH:mm:ss"
 #define KKDateFormatter02 @"yyyy-MM-dd HH:mm"
 #define KKDateFormatter03 @"yyyy-MM-dd HH"
 #define KKDateFormatter04 @"yyyy-MM-dd"
 @return 日期
 */
+ (nullable NSDate *)dateFromString:(NSString*)aString
{
    if ([NSString isStringEmpty:aString]) {
        return nil;
    }
    
    //KKDateFormatter01 @"yyyy-MM-dd HH:mm:ss"
    if ([aString length]==[KKDateFormatter01 length]) {
        return [NSDate getDateFromString:aString dateFormatter:KKDateFormatter01];
    }
    //KKDateFormatter02 @"yyyy-MM-dd HH:mm"
    else if ([aString length]==[KKDateFormatter02 length]) {
        return [NSDate getDateFromString:aString dateFormatter:KKDateFormatter02];
    }
    //KKDateFormatter03 @"yyyy-MM-dd HH"
    else if ([aString length]==[KKDateFormatter03 length]) {
        if ([aString rangeOfString:@" "].length>0) {
            return [NSDate getDateFromString:aString dateFormatter:KKDateFormatter03];
        }
        //是一个十三位带毫秒的时间戳
        else{
            double timestamp = [aString doubleValue]/1000.0;
            return [NSDate dateWithTimeIntervalSince1970:timestamp];
        }
    }
    //KKDateFormatter04 @"yyyy-MM-dd"
    else if ([aString length]==[KKDateFormatter04 length]) {
        if ([aString rangeOfString:@"-"].length>0) {
            return [NSDate getDateFromString:aString dateFormatter:KKDateFormatter04];
        }
        //是一个十位的标准时间戳
        else{
            double timestamp = [aString doubleValue];
            return [NSDate dateWithTimeIntervalSince1970:timestamp];
        }
    }
    else{
        return nil;
    }
}

/* 代码调试的时候，执行的时间。返回格式 @"yyyy-MM-dd HH:mm:ss SSS" */
+ (NSString*_Nonnull)timeFormateStringForDebugCodeExecution{
//    NSString *time1 = [NSString stringWithFormat:@"%lld",mach_absolute_time()];
//    NSString *time2 =  [NSString stringWithFormat:@"%ld",(long)(CFAbsoluteTimeGetCurrent()*1000)];
    NSString *time3 = [NSDate getStringWithFormatter:@"yyyy-MM-dd HH:mm:ss SSS"];
    return time3?time3:@"";
}

/* 代码调试的时候，执行的时间。返回格式 @"HHmmssSSS" */
+ (NSString*_Nonnull)timestampStringForDebugCodeExecution{
//    NSString *time1 = [NSString stringWithFormat:@"%lld",mach_absolute_time()];
//    NSString *time2 =  [NSString stringWithFormat:@"%ld",(long)(CFAbsoluteTimeGetCurrent()*1000)];
    NSString *time3 = [NSDate getStringWithFormatter:@"HHmmssSSS"];
    return time3?time3:@"";
}


+ (NSString*_Nonnull)timeDurationFormatFullString:(NSTimeInterval)timeInterval{
    int HH = timeInterval/(60*60);
    int MM = (timeInterval - HH*(60*60))/60;
    int SS = timeInterval - HH*(60*60) - MM*60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",HH,MM,SS];
}

+ (NSString*_Nonnull)timeDurationFormatShortString:(NSTimeInterval)timeInterval{
    
    int HH = timeInterval/(60*60);
    int MM = (timeInterval - HH*(60*60))/60;
    int SS = timeInterval - HH*(60*60) - MM*60;
    if (HH>0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",HH,MM,SS];
    }
    else{
        return [NSString stringWithFormat:@"%02d:%02d",MM,SS];
    }
}

#pragma mark ==================================================
#pragma mark == 会话列表时间格式
#pragma mark ==================================================
+ (NSString*_Nonnull)timeForConversationList:(NSTimeInterval)chatTime nowTimestamp:(NSTimeInterval)nowTimestamp {
    if (chatTime<1 || nowTimestamp<1) {
        return @"";
    }
    
    //会话时间
    NSDate *dateChat = [NSDate dateWithTimeIntervalSince1970:chatTime];
    NSString *yyyymmddChat = [NSDate getStringFromDate:dateChat dateFormatter:@"yyyy-MM-dd"];
    
    //当前时间(今天)
    NSDate *dateNow = [NSDate dateWithTimeIntervalSince1970:nowTimestamp];
    NSString *yyyymmddNow = [NSDate getStringFromDate:dateNow dateFormatter:@"yyyy-MM-dd"];
    if ([yyyymmddChat isEqualToString:yyyymmddNow]) {
        NSString *result = [NSDate getStringFromDate:dateChat dateFormatter:@"HH:mm"];
        return result?result : @"";
    }
    //昨天（1天前）
    NSDate *date01 = dateNow.previousDate;
    NSString *yyyymmdd01 = [NSDate getStringFromDate:date01 dateFormatter:@"yyyy-MM-dd"];
    if ([yyyymmddChat isEqualToString:yyyymmdd01]) {
        return  KKLocalization(@"一天前");
    }

    //前天（2天前）
    NSDate *date02 = date01.previousDate;
    NSString *yyyymmdd02 = [NSDate getStringFromDate:date02 dateFormatter:@"yyyy-MM-dd"];
    if ([yyyymmddChat isEqualToString:yyyymmdd02]) {
        return  KKLocalization(@"两天前");
    }

    //（3天前）
    NSDate *date03 = date02.previousDate;
    NSString *yyyymmdd03 = [NSDate getStringFromDate:date03 dateFormatter:@"yyyy-MM-dd"];
    if ([yyyymmddChat isEqualToString:yyyymmdd03]) {
        return  KKLocalization(@"三天前");
    }

    //（4天前）
    NSDate *date04 = date03.previousDate;
    NSString *yyyymmdd04 = [NSDate getStringFromDate:date04 dateFormatter:@"yyyy-MM-dd"];
    if ([yyyymmddChat isEqualToString:yyyymmdd04]) {
        return  KKLocalization(@"四天前");
    }

    //（5天前）
    NSDate *date05 = date04.previousDate;
    NSString *yyyymmdd05 = [NSDate getStringFromDate:date05 dateFormatter:@"yyyy-MM-dd"];
    if ([yyyymmddChat isEqualToString:yyyymmdd05]) {
        return  KKLocalization(@"五天前");
    }

    //（6天前）
    NSDate *date06 = date05.previousDate;
    NSString *yyyymmdd06 = [NSDate getStringFromDate:date06 dateFormatter:@"yyyy-MM-dd"];
    if ([yyyymmddChat isEqualToString:yyyymmdd06]) {
        return  KKLocalization(@"六天前");
    }

    //（7天前）
    NSDate *date07 = date06.previousDate;
    NSString *yyyymmdd07 = [NSDate getStringFromDate:date07 dateFormatter:@"yyyy-MM-dd"];
    if ([yyyymmddChat isEqualToString:yyyymmdd07]) {
        return  KKLocalization(@"七天前");
    }

    NSString *mm = [NSDate getStringFromDate:dateChat dateFormatter:@"MM"];
    NSString *dd = [NSDate getStringFromDate:dateChat dateFormatter:@"dd"];
    NSString *vMM = mm?mm : @"";
    NSString *vDD = dd?dd : @"";
    return KKLocalizationWithFormat(@"common.dateFormat.MMDD",vMM,vDD);
}



@end
