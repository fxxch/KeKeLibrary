//
//  KKLog.h
//  BM
//
//  Created by liubo on 2019/12/29.
//  Copyright © 2019 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef const char * _Nullable KKLOG_FUCTION_NAME;

#define KKValidString(obj) ([NSString stringWithFormat:@"%@",obj])

/*====================  Empty ====================*/
#define KKLogEmpty(obj)                                         \
        [KKLog KKLog_Empty : obj                                \
                   fuction : __PRETTY_FUNCTION__                \
                      line : __LINE__]


/*====================  Verbose ====================*/
#define KKLogVerbose(obj)                                       \
        [KKLog KKLog_Verbose : obj                              \
                     fuction : __PRETTY_FUNCTION__              \
                        line : __LINE__]

#define KKLogVerboseFormat(frmt, ...)                           \
        [KKLog KKLog_Verbose_fuction : __PRETTY_FUNCTION__      \
                                line : __LINE__                 \
                              format : (frmt), ##__VA_ARGS__]

/*====================  Debug ====================*/
#define KKLogDebug(obj)                                         \
        [KKLog KKLog_Debug : obj                                \
                   fuction : __PRETTY_FUNCTION__                \
                      line : __LINE__]

#define KKLogDebugFormat(frmt, ...)                             \
        [KKLog KKLog_Debug_fuction : __PRETTY_FUNCTION__        \
                              line : __LINE__                   \
                            format : (frmt), ##__VA_ARGS__]

/*====================  Info ====================*/
#define KKLogInfo(obj)                                          \
        [KKLog KKLog_Info : obj                                 \
                  fuction : __PRETTY_FUNCTION__                 \
                     line : __LINE__];

#define KKLogInfoFormat(frmt, ...)                              \
        [KKLog KKLog_Info_fuction : __PRETTY_FUNCTION__         \
                             line : __LINE__                    \
                           format : (frmt), ##__VA_ARGS__]

/*====================  Warning ====================*/
#define KKLogWarning(obj)                                       \
        [KKLog KKLog_Warning : obj                              \
                     fuction : __PRETTY_FUNCTION__              \
                        line : __LINE__]

#define KKLogWarningFormat(frmt, ...)                           \
        [KKLog KKLog_Warning_fuction : __PRETTY_FUNCTION__      \
                                line : __LINE__                 \
                              format : (frmt), ##__VA_ARGS__]

/*====================  Error ====================*/
#define KKLogError(obj)                                         \
        [KKLog KKLog_Error : obj                                \
                   fuction : __PRETTY_FUNCTION__                \
                      line : __LINE__]

#define KKLogErrorFormat(frmt, ...)                             \
        [KKLog KKLog_Error_fuction : __PRETTY_FUNCTION__        \
                              line : __LINE__                   \
                            format : (frmt), ##__VA_ARGS__]

@interface KKLog : NSObject

/* 占位符，不打印任何东西*/
+ (void)KKLog_Empty:(id _Nullable)aObject
            fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;

#pragma mark ==================================================
#pragma mark == Verbose 用于详细或经常出现的调试和诊断信息（会在Release下失效）
#pragma mark ==================================================
/// 用于详细或经常出现的调试和诊断信息（会在Release下失效）
+ (void)KKLog_Verbose:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;

+ (void)KKLog_Verbose_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...;

#pragma mark ==================================================
#pragma mark == Debug 用于调试和诊断信息（会在Release下失效）
#pragma mark ==================================================
/// 用于调试和诊断信息（会在Release下失效）
+ (void)KKLog_Debug:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;

+ (void)KKLog_Debug_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...;

#pragma mark ==================================================
#pragma mark == Info 值得关注的信息（会在Release下失效）
#pragma mark ==================================================
/// 值得关注的信息
+ (void)KKLog_Info:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;

+ (void)KKLog_Info_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...;

#pragma mark ==================================================
#pragma mark == Warning 可能会导致更严重的后果
#pragma mark ==================================================
/// 可能会导致更严重的后果
+ (void)KKLog_Warning:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;

+ (void)KKLog_Warning_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...;

#pragma mark ==================================================
#pragma mark == Error 致命的错误
#pragma mark ==================================================
/// 致命的错误
+ (void)KKLog_Error:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;

+ (void)KKLog_Error_fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...;

@end
