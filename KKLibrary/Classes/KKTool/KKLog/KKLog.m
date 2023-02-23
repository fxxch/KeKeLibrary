//
//  KKLog.m
//  BM
//
//  Created by liubo on 2019/12/29.
//  Copyright © 2019 bm. All rights reserved.
//

#import "KKLog.h"

//#define KKLog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

static BOOL kkLogVerboseEnable = YES;
static BOOL kkLogDebugEnable = YES;
static BOOL kkLogInfoEnable = YES;
static BOOL kkLogWarningEnable = YES;
static BOOL kkLogErrorEnable = YES;

@implementation KKLog

/* 占位符，不打印任何东西*/
+ (void)kklogEmpty:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;{
    
}

+ (void)kklogEnable:(BOOL)aEnable forType:(KKLogType)aType{
    switch (aType) {
        case KKLogType_Verbose:{
            kkLogVerboseEnable = aEnable;
            break;
        }
        case KKLogType_Debug:{
            kkLogDebugEnable = aEnable;
            break;
        }
        case KKLogType_Info:{
            kkLogInfoEnable = aEnable;
            break;
        }
        case KKLogType_Warning:{
            kkLogWarningEnable = aEnable;
            break;
        }
        case KKLogType_Error:{
            kkLogErrorEnable = aEnable;
            break;
        }
        default:
            break;
    }
}

+ (void)kklogPrint:(KKLogType)aType object:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line{
    switch (aType) {
        case KKLogType_Verbose:{//用于详细或经常出现的调试和诊断信息（会在Release下失效）
        #ifdef DEBUG
            if (kkLogVerboseEnable) {
                NSLog(@"🔈VERBOSE: %s %d %@",fuction,line,aObject);
            }
        #endif
            break;
        }
        case KKLogType_Debug:{//用于调试和诊断信息（会在Release下失效）
        #ifdef DEBUG
            if (kkLogDebugEnable) {
                NSLog(@"💚 DEBUG: %s %d %@",fuction,line,aObject);
            }
        #endif
            break;
        }
        case KKLogType_Info:{//值得关注的信息（会在Release下失效）
        #ifdef DEBUG
            if (kkLogInfoEnable) {
                NSLog(@"👀INFO: %s %d %@",fuction,line,aObject);
            }
        #endif
            break;
        }
        case KKLogType_Warning:{//可能会导致更严重的后果
            if (kkLogWarningEnable) {
                NSLog(@"⚠️ WARNING: %s %d %@",fuction,line,aObject);
            }
            break;
        }
        case KKLogType_Error:{//致命的错误
            if (kkLogErrorEnable) {
                NSLog(@"❌ ERROR: %s %d %@",fuction,line,aObject);
            }
            break;
        }
        default:
            break;
    }

    
}

+ (void)kklogPrint:(KKLogType)aType fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...{
    switch (aType) {
        case KKLogType_Verbose:{//用于详细或经常出现的调试和诊断信息（会在Release下失效）
        #ifdef DEBUG
            if (kkLogVerboseEnable) {
                NSString *returnString = nil;
                va_list args1;
                va_start(args1, format);
                returnString = [[NSString alloc] initWithFormat:format arguments:args1];
                va_end(args1);
                if (returnString) {
                    NSLog(@"🔈VERBOSE: %s %d %@",fuction,line,returnString);
                }
            }
        #endif
            break;
        }
        case KKLogType_Debug:{//用于调试和诊断信息（会在Release下失效）
        #ifdef DEBUG
            if (kkLogDebugEnable) {
                NSString *returnString = nil;
                va_list args1;
                va_start(args1, format);
                returnString = [[NSString alloc] initWithFormat:format arguments:args1];
                va_end(args1);
                if (returnString) {
                    NSLog(@"💚DEBUG: %s %d %@",fuction,line,returnString);
                }
            }
        #endif
            break;
        }
        case KKLogType_Info:{//值得关注的信息（会在Release下失效）
        #ifdef DEBUG
            if (kkLogInfoEnable) {
                NSString *returnString = nil;
                va_list args1;
                va_start(args1, format);
                returnString = [[NSString alloc] initWithFormat:format arguments:args1];
                va_end(args1);
                if (returnString) {
                    NSLog(@"👀 INFO: %s %d %@",fuction,line,returnString);
                }
            }
        #endif
            break;
        }
        case KKLogType_Warning:{//可能会导致更严重的后果
            if (kkLogWarningEnable) {
                NSString *returnString = nil;
                va_list args1;
                va_start(args1, format);
                returnString = [[NSString alloc] initWithFormat:format arguments:args1];
                va_end(args1);
                if (returnString) {
                    NSLog(@"⚠️ WARNING: %s %d %@",fuction,line,returnString);
                }
            }
            break;
        }
        case KKLogType_Error:{//致命的错误
            if (kkLogErrorEnable) {
                NSString *returnString = nil;
                va_list args1;
                va_start(args1, format);
                returnString = [[NSString alloc] initWithFormat:format arguments:args1];
                va_end(args1);
                if (returnString) {
                    NSLog(@"❌ ERROR: %s %d %@",fuction,line,returnString);
                }
            }
            break;
        }
        default:
            break;
    }
}

@end
