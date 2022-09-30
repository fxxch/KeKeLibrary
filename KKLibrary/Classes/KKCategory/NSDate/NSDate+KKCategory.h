//
//  NSDate+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KKDateFormatter01 @"yyyy-MM-dd HH:mm:ss"
#define KKDateFormatter02 @"yyyy-MM-dd HH:mm"
#define KKDateFormatter03 @"yyyy-MM-dd HH"
#define KKDateFormatter04 @"yyyy-MM-dd"
#define KKDateFormatter05 @"yyyy-MM"
#define KKDateFormatter06 @"MM-dd"
#define KKDateFormatter07 @"HH:mm"
#define KKDateFormatter08 [NSString stringWithFormat:@"yyyy%@MM%@",KKLocalization(@"年"),KKLocalization(@"月")]
#define KKDateFormatter09 [NSString stringWithFormat:@"MM%@dd%@",KKLocalization(@"月"),KKLocalization(@"日")]
#define KKDateFormatter10 [NSString stringWithFormat:@"yyyy%@MM%@dd%@",KKLocalization(@"年"),KKLocalization(@"月"),KKLocalization(@"日")]


@interface NSDate (KKCategory)

/**
 日
 
 @return 日
 */
- (NSUInteger)kk_day;

/**
 周（周一、周二、周三……）
 
 @return 周
 */
- (NSUInteger)kk_weekday;

/**
 月份
 
 @return 月份
 */
- (NSUInteger)kk_month;

/**
 年份
 
 @return 年份
 */
- (NSUInteger)kk_year;

/**
 计算某个月的总天数
 
 @return 天数
 */
- (NSUInteger)kk_numberOfDaysInMonth;

/**
 计算某个月的总周数
 
 @return 周数
 */
- (NSUInteger)kk_weeksOfMonth;

/**
 前一天
 
 @return 前一天
 */
- (nullable NSDate *)kk_previousDate;

/**
 后一天
 
 @return 后一天
 */
- (nullable NSDate *)kk_nextDate;

/**
 某周的第一天
 
 @return 某周的第一天
 */
- (nullable NSDate *)kk_firstDayOfWeek;

/**
 某周的最后一天
 
 @return 某周的最后一天
 */
- (nullable NSDate *)kk_lastDayOfWeek;

/**
 下一周的第一天
 
 @return 下一周的第一天
 */
- (nullable NSDate *)kk_firstDayOfNextWeek;

/**
 下一周的最后一天
 
 @return 下一周的最后一天
 */
- (nullable NSDate *)kk_lastDayOfNextWeek;

/**
 某月的第一天
 
 @return 某月的第一天
 */
- (nullable NSDate *)kk_firstDayOfMonth;

/**
 某月的最后一天
 
 @return 某月的最后一天
 */
- (nullable NSDate *)kk_lastDayOfMonth;


/**
 某个月的第一天是周几？
 
 @return 某个月的第一天是周几？
 */
- (NSUInteger)kk_weekdayOfFirstDayInMonth;

/**
 某个月的上个月的第一天？
 
 @return 某个月的上个月的第一天？
 */
- (nullable NSDate *)kk_firstDayOfPreviousMonth;

/**
 某个月的下个月的第一天？
 
 @return 某个月的下个月的第一天？
 */
- (nullable NSDate *)kk_firstDayOfNextMonth;


/**
 某个季度的第一天
 
 @return 某个季度的第一天
 */
- (nullable NSDate *)kk_firstDayOfQuarter;

/**
 某个季度的最后一天
 
 @return 某个季度的最后一天
 */
- (nullable NSDate *)kk_lastDayOfQuarter;

/**
 下个月的第一天
 
 @return 下个月的第一天
 */
- (nullable NSDate *)kk_theDayOfNextMonth;

/**
 下周的第一天
 
 @return 下周的第一天
 */
- (nullable NSDate *)kk_theDayOfNextWeek;

/**
 返回指定日期格式的字符串
 
 @param formatterString 日期格式
 @return 结果
 */
+ (nullable NSString*)kk_getStringWithFormatter:(nullable NSString*)formatterString;


/**
 将日期转换成日期字符串
 
 @param date 日期
 @param formatterString 需要转换成的日期格式
 @return 结果
 */
+ (nullable NSString*)kk_getStringFromDate:(nullable NSDate*)date
                             dateFormatter:(nullable NSString*)formatterString;


/**
 将日期字符串转换成日期
 
 @param string 日期字符串
 @param formatterString 日期字符串的格式
 @return 日期
 */
+ (nullable NSDate*)kk_getDateFromString:(nullable NSString*)string
                           dateFormatter:(nullable NSString*)formatterString;


/**
 判断日期1 是否比日期2 要早
 
 @param date01 日期1
 @param date02 日期2
 @return 结果
 
 */
+ (BOOL)kk_isDate:(nullable NSDate*)date01 earlierThanDate:(nullable NSDate*)date02;

/**
 时间1 是否 > 时间2
 
 @param date01 时间1
 @param date02 时间2
 @return YES NO
 */
+ (BOOL)kk_isDate:(nullable NSDate*)date01 laterThanDate:(nullable NSDate*)date02;

/**
 将日期字符串转换成日期
 
 @param aString 日期字符串 可以是时间戳或者是以下时间字符串中的一种
 #define KKDateFormatter01 @"yyyy-MM-dd HH:mm:ss"
 #define KKDateFormatter02 @"yyyy-MM-dd HH:mm"
 #define KKDateFormatter03 @"yyyy-MM-dd HH"
 #define KKDateFormatter04 @"yyyy-MM-dd"
 @return 日期
 */
+ (nullable NSDate *)kk_dateFromString:(NSString*_Nullable)aString;

/* 代码调试的时候，执行的时间。返回格式 @"yyyy-MM-dd HH:mm:ss SSS" */
+ (NSString*_Nonnull)kk_timeFormateStringForDebugCodeExecution;

/* 代码调试的时候，执行的时间。返回格式 @"HHmmssSSS" */
+ (NSString*_Nonnull)kk_timestampStringForDebugCodeExecution;

+ (NSString*_Nonnull)kk_timeDurationFormatFullString:(NSTimeInterval)timeInterval;

+ (NSString*_Nonnull)kk_timeDurationFormatShortString:(NSTimeInterval)timeInterval;

+ (NSTimeInterval)kk_systemRuningSecondsSinceBoot;

@end



/*
 
 a: AM/PM (上午/下午)
 
 A: 0~86399999 (一天的第A微秒)
 
 c/cc: 1~7 (一周的第一天, 周天为1)
 
 ccc: Sun/Mon/Tue/Wed/Thu/Fri/Sat (星期几简写)
 
 cccc: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday (星期几全拼)
 
 d: 1~31 (月份的第几天, 带0)
 
 D: 1~366 (年份的第几天,带0)
 
 e: 1~7 (一周的第几天, 带0)
 
 E~EEE: Sun/Mon/Tue/Wed/Thu/Fri/Sat (星期几简写)
 
 EEEE: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday (星期几全拼)
 
 F: 1~5 (每月的第几周, 一周的第一天为周一)
 
 g: Julian Day Number (number of days since 4713 BC January 1) 未知
 
 G~GGG: BC/AD (Era Designator Abbreviated) 未知
 
 GGGG: Before Christ/Anno Domini 未知
 
 h: 1~12 (0 padded Hour (12hr)) 带0的时, 12小时制
 
 H: 0~23 (0 padded Hour (24hr))  带0的时, 24小时制
 
 k: 1~24 (0 padded Hour (24hr) 带0的时, 24小时制
 
 K: 0~11 (0 padded Hour (12hr)) 带0的时, 12小时制
 
 L/LL: 1~12 (0 padded Month)  第几月
 
 LLL: Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec 月份简写
 
 LLLL: January/February/March/April/May/June/July/August/September/October/November/December 月份全称
 
 m: 0~59 (0 padded Minute) 分钟
 
 M/MM: 1~12 (0 padded Month) 第几月
 
 MMM: Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
 
 MMMM: January/February/March/April/May/June/July/August/September/October/November/December
 
 q/qq: 1~4 (0 padded Quarter) 第几季度
 
 qqq: Q1/Q2/Q3/Q4 季度简写
 
 qqqq: 1st quarter/2nd quarter/3rd quarter/4th quarter 季度全拼
 
 Q/QQ: 1~4 (0 padded Quarter) 同小写
 
 QQQ: Q1/Q2/Q3/Q4 同小写
 
 QQQQ: 1st quarter/2nd quarter/3rd quarter/4th quarter 同小写
 
 s: 0~59 (0 padded Second) 秒数
 
 S: (rounded Sub-Second) 未知
 
 u: (0 padded Year) 未知
 
 v~vvv: (General GMT Timezone Abbreviation) 常规GMT时区的编写
 
 vvvv: (General GMT Timezone Name) 常规GMT时区的名称
 
 w: 1~53 (0 padded Week of Year, 1st day of week = Sunday, NB: 1st week of year starts from the last Sunday of last year) 一年的第几周, 一周的开始为周日,第一周从去年的最后一个周日起算
 
 W: 1~5 (0 padded Week of Month, 1st day of week = Sunday) 一个月的第几周
 
 y/yyyy: (Full Year) 完整的年份
 
 yy/yyy: (2 Digits Year)  2个数字的年份
 
 Y/YYYY: (Full Year, starting from the Sunday of the 1st week of year) 这个年份未知干嘛用的
 
 YY/YYY: (2 Digits Year, starting from the Sunday of the 1st week of year) 这个年份未知干嘛用的
 
 z~zzz: (Specific GMT Timezone Abbreviation) 指定GMT时区的编写
 
 zzzz: (Specific GMT Timezone Name) Z: +0000 (RFC 822 Timezone) 指定GMT时区的名称
 
 */
