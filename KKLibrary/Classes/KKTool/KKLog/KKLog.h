//
//  KKLog.h
//  BM
//
//  Created by liubo on 2019/12/29.
//  Copyright © 2019 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef const char * _Nullable KKLOG_FUCTION_NAME;

/**
 *  KKLogType
 */
typedef NS_ENUM(NSInteger,KKLogType) {
    
    KKLogType_Verbose = 0,//用于详细或经常出现的调试和诊断信息（会在Release下失效）
    
    KKLogType_Debug = 1,//用于调试和诊断信息（会在Release下失效）
    
    KKLogType_Info = 2,//值得关注的信息（会在Release下失效）

    KKLogType_Warning = 3,//可能会导致更严重的后果

    KKLogType_Error = 4//致命的错误
};

#define KKValidString(obj) ( (obj && [obj isKindOfClass:[NSString class]]) ? obj : @"" )

/*====================  Empty ====================*/
#define KKLogEmpty(obj)                                        \
        [KKLog kklogEmpty : obj                                \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__]


/*====================  Verbose ====================*/
#define KKLogVerbose(obj)                                      \
        [KKLog kklogPrint : KKLogType_Verbose                  \
                   object : obj                                \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__]

#define KKLogVerboseFormat(frmt, ...)                          \
        [KKLog kklogPrint : KKLogType_Verbose                  \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__                           \
                   format : (frmt), ##__VA_ARGS__]

/*====================  Debug ====================*/
#define KKLogDebug(obj)                                        \
        [KKLog kklogPrint : KKLogType_Debug                    \
                   object : obj                                \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__]

#define KKLogDebugFormat(frmt, ...)                            \
        [KKLog kklogPrint : KKLogType_Debug                    \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__                           \
                   format : (frmt), ##__VA_ARGS__]

/*====================  Info ====================*/
#define KKLogInfo(obj)                                         \
        [KKLog kklogPrint : KKLogType_Info                     \
                   object : obj                                \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__]

#define KKLogInfoFormat(frmt, ...)                             \
        [KKLog kklogPrint : KKLogType_Info                     \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__                           \
                   format : (frmt), ##__VA_ARGS__]

/*====================  Warning ====================*/
#define KKLogWarning(obj)                                      \
        [KKLog kklogPrint : KKLogType_Warning                  \
                   object : obj                                \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__]

#define KKLogWarningFormat(frmt, ...)                          \
        [KKLog kklogPrint : KKLogType_Warning                  \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__                           \
                   format : (frmt), ##__VA_ARGS__]


/*====================  Error ====================*/
#define KKLogError(obj)                                        \
        [KKLog kklogPrint : KKLogType_Error                    \
                   object : obj                                \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__]

#define KKLogErrorFormat(frmt, ...)                            \
        [KKLog kklogPrint : KKLogType_Error                    \
                  fuction : __PRETTY_FUNCTION__                \
                     line : __LINE__                           \
                   format : (frmt), ##__VA_ARGS__]


@interface KKLog : NSObject

/* 关闭/打开某种类型的日志，默认都是打开的*/
+ (void)kklogEnable:(BOOL)aEnable forType:(KKLogType)aType;

/* 占位符，不打印任何东西*/
+ (void)kklogEmpty:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;

+ (void)kklogPrint:(KKLogType)aType object:(id _Nullable)aObject fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line;

+ (void)kklogPrint:(KKLogType)aType fuction:(KKLOG_FUCTION_NAME)fuction line:(int)line format:(NSString *_Nullable)format, ...;

@end
