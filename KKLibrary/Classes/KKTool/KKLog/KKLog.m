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
+ (void)KKLog_Empty:(id _Nullable)aObject{
    
}

#pragma mark ==================================================
#pragma mark == Verbose 用于详细或经常出现的调试和诊断信息（会在Release下失效）
#pragma mark ==================================================
/// 用于详细或经常出现的调试和诊断信息（会在Release下失效）
+ (void)KKLog_Verbose:(id _Nullable)aObject{
#ifdef DEBUG
    NSLog(@"🔈VERBOSE: %s %d %@",__FUNCTION__,__LINE__,aObject);
#endif
}

+ (void)KKLog_VerboseFormat:(NSString*_Nullable)format,...{
#ifdef DEBUG
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"🔈VERBOSE: %s %d %@",__FUNCTION__,__LINE__,returnString);
    }
#endif
}

#pragma mark ==================================================
#pragma mark == Debug 用于调试和诊断信息（会在Release下失效）
#pragma mark ==================================================
/// 用于调试和诊断信息（会在Release下失效）
+ (void)KKLog_Debug:(id _Nullable)aObject{
#ifdef DEBUG
    NSLog(@"💚 DEBUG: %s %d %@",__FUNCTION__,__LINE__,aObject);
#endif
}

+ (void)KKLog_DebugFormat:(NSString* _Nullable)format,...{
#ifdef DEBUG
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"💚DEBUG: %s %d %@",__FUNCTION__,__LINE__,returnString);
    }
#endif
}

#pragma mark ==================================================
#pragma mark == Info 值得关注的信息（会在Release下失效）
#pragma mark ==================================================
/// 值得关注的信息
+ (void)KKLog_Info:(id _Nullable)aObject{
    #ifdef DEBUG
    NSLog(@"👀INFO: %s %d %@",__FUNCTION__,__LINE__,aObject);
    #endif
}

+ (void)KKLog_InfoFormat:(NSString* _Nullable)format,...{
#ifdef DEBUG
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"👀 INFO: %s %d %@",__FUNCTION__,__LINE__,returnString);
    }
#endif
}

#pragma mark ==================================================
#pragma mark == Warning 可能会导致更严重的后果
#pragma mark ==================================================
/// 可能会导致更严重的后果
+ (void)KKLog_Warning:(id _Nullable)aObject{
    NSLog(@"⚠️ WARNING: %s %d %@",__FUNCTION__,__LINE__,aObject);
}

+ (void)KKLog_WarningFormat:(NSString* _Nullable)format,...{
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"⚠️ WARNING: %s %d %@",__FUNCTION__,__LINE__,returnString);
    }
}

#pragma mark ==================================================
#pragma mark == Error 致命的错误
#pragma mark ==================================================
/// 致命的错误
+ (void)KKLog_Error:(id _Nullable)aObject{
    NSLog(@"❌ ERROR: %s %d %@",__FUNCTION__,__LINE__,aObject);
}

+ (void)KKLog_ErrorFormat:(NSString*_Nullable)format,...{
    NSString *returnString = nil;
    va_list args1;
    va_start(args1, format);
    returnString = [[NSString alloc] initWithFormat:format arguments:args1];
    va_end(args1);
    if (returnString) {
        NSLog(@"❌ ERROR: %s %d %@",__FUNCTION__,__LINE__,returnString);
    }
}

@end
