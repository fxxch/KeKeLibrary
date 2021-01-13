//
//  KKLog.h
//  BM
//
//  Created by liubo on 2019/12/29.
//  Copyright © 2019 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KKLogEmpty(obj) [KKLog KKLog_Empty:obj]
#define KKValidString(obj) [NSString stringWithFormat:@"%@",obj]


#define KKLogVerbose(obj) [KKLog KKLog_Verbose:obj]
#define KKLogVerboseFormat(format, ...) [KKLog KKLog_VerboseFormat:format,##__VA_ARGS__]

#define KKLogDebug(obj) [KKLog KKLog_Debug:obj]
#define KKLogDebugFormat(format, ...) [KKLog KKLog_DebugFormat:format,##__VA_ARGS__]

#define KKLogInfo(obj) [KKLog KKLog_Info:obj]
#define KKLogInfoFormat(format, ...) [KKLog KKLog_InfoFormat:format,##__VA_ARGS__]

#define KKLogWarning(obj) [KKLog KKLog_Warning:obj]
#define KKLogWarningFormat(format, ...) [KKLog KKLog_WarningFormat:format,##__VA_ARGS__]

#define KKLogError(obj) [KKLog KKLog_Error:obj]
#define KKLogErrorFormat(format, ...) [KKLog KKLog_ErrorFormat:format,##__VA_ARGS__]


@interface KKLog : NSObject

/* 占位符，不打印任何东西*/
+ (void)KKLog_Empty:(id _Nullable)aObject;

#pragma mark ==================================================
#pragma mark == Verbose 用于详细或经常出现的调试和诊断信息（会在Release下失效）
#pragma mark ==================================================
/// 用于详细或经常出现的调试和诊断信息（会在Release下失效）
+ (void)KKLog_Verbose:(id _Nullable)aObject;

+ (void)KKLog_VerboseFormat:(NSString* _Nullable)format,...;

#pragma mark ==================================================
#pragma mark == Debug 用于调试和诊断信息（会在Release下失效）
#pragma mark ==================================================
/// 用于调试和诊断信息（会在Release下失效）
+ (void)KKLog_Debug:(id _Nullable)aObject;

+ (void)KKLog_DebugFormat:(NSString* _Nullable)format,...;

#pragma mark ==================================================
#pragma mark == Info 值得关注的信息（会在Release下失效）
#pragma mark ==================================================
/// 值得关注的信息
+ (void)KKLog_Info:(id _Nullable)aObject;

+ (void)KKLog_InfoFormat:(NSString* _Nullable)format,...;

#pragma mark ==================================================
#pragma mark == Warning 可能会导致更严重的后果
#pragma mark ==================================================
/// 可能会导致更严重的后果
+ (void)KKLog_Warning:(id _Nullable)aObject;

+ (void)KKLog_WarningFormat:(NSString* _Nullable)format,...;

#pragma mark ==================================================
#pragma mark == Error 致命的错误
#pragma mark ==================================================
/// 致命的错误
+ (void)KKLog_Error:(id _Nullable)aObject;

+ (void)KKLog_ErrorFormat:(NSString* _Nullable)format,...;

@end
