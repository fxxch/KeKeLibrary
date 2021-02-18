//
//  KKLog.m
//  BM
//
//  Created by liubo on 2019/12/29.
//  Copyright © 2019 bm. All rights reserved.
//

#import "KKLog.h"

//#define KKLog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

@implementation KKLog

/* 占位符，不打印任何东西*/
+ (void)KKLog_Empty:(id _Nullable)aObject
            fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;
{
    
}

#pragma mark ==================================================
#pragma mark == Verbose 用于详细或经常出现的调试和诊断信息（会在Release下失效）
#pragma mark ==================================================
/// 用于详细或经常出现的调试和诊断信息（会在Release下失效）
+ (void)KKLog_Verbose:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line{
#ifdef DEBUG
    NSLog(@"🔈VERBOSE: %s %d %@",fuction,line,aObject);
#endif
}

+ (void)KKLog_Verbose_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...{
#ifdef DEBUG
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"🔈VERBOSE: %s %d %@",fuction,line,returnString);
    }
#endif
}

#pragma mark ==================================================
#pragma mark == Debug 用于调试和诊断信息（会在Release下失效）
#pragma mark ==================================================
/// 用于调试和诊断信息（会在Release下失效）
+ (void)KKLog_Debug:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line{
#ifdef DEBUG
    NSLog(@"💚 DEBUG: %s %d %@",fuction,line,aObject);
#endif
}

+ (void)KKLog_Debug_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...{
#ifdef DEBUG
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"💚DEBUG: %s %d %@",fuction,line,returnString);
    }
#endif
}

#pragma mark ==================================================
#pragma mark == Info 值得关注的信息（会在Release下失效）
#pragma mark ==================================================
/// 值得关注的信息
+ (void)KKLog_Info:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line{
#ifdef DEBUG
    NSLog(@"👀INFO: %s %d %@",fuction,line,aObject);
#endif
}

+ (void)KKLog_Info_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...{
#ifdef DEBUG
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"👀 INFO: %s %d %@",fuction,line,returnString);
    }
#endif
}

#pragma mark ==================================================
#pragma mark == Warning 可能会导致更严重的后果
#pragma mark ==================================================
/// 可能会导致更严重的后果
+ (void)KKLog_Warning:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line{
    NSLog(@"⚠️ WARNING: %s %d %@",fuction,line,aObject);
}

+ (void)KKLog_Warning_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...{
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"⚠️ WARNING: %s %d %@",fuction,line,returnString);
    }
}

#pragma mark ==================================================
#pragma mark == Error 致命的错误
#pragma mark ==================================================
/// 致命的错误
+ (void)KKLog_Error:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line{
    NSLog(@"❌ ERROR: %s %d %@",fuction,line,aObject);
}

+ (void)KKLog_Error_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...{
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"❌ ERROR: %s %d %@",fuction,line,returnString);
    }
}

@end
