//
//  KKLocalizationManager.m
//  BM
//
//  Created by liubo on 2019/12/28.
//  Copyright © 2019 bm. All rights reserved.
//

#import "KKLocalizationManager.h"
#import "stdarg.h"
#include <stdio.h>
#import "KKLog.h"

NSNotificationName const NotificationName_KKLocalizationDidChanged = @"NotificationName_KKLocalizationDidChanged";

#define kDefaultLanguage @"defaultLanguage"
#define kLocalizationFile @"localization.plist"

@interface KKLocalizationManager()

@end

@implementation KKLocalizationManager {
    NSBundle    *_bundle;
    NSString    *_currentLanguage;
}

- (void)dealloc {
    _bundle = nil;
}

+ (KKLocalizationManager *_Nonnull)shared{
    static KKLocalizationManager *KKLocalizationManager_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKLocalizationManager_default = [[self alloc] init];
    });
    return KKLocalizationManager_default;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        NSString *currentLanguage = [languages objectAtIndex:0];
        
        NSDictionary *language = [NSDictionary dictionaryWithObject:currentLanguage forKey:kDefaultLanguage];
        [defaults registerDefaults:language];
        [defaults synchronize];
        
        _currentLanguage = [defaults objectForKey:kDefaultLanguage];
        
        [self initLanguage];
    }
    return self;
}

- (void)initLanguage {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable"
                                                     ofType:@"strings"
                                                inDirectory:nil
                                            forLocalization:_currentLanguage];
    
    if (path == nil) {
        path = [[NSBundle mainBundle] pathForResource:@"InfoPlist"
                                               ofType:@"strings"
                                          inDirectory:nil
                                      forLocalization:_currentLanguage];
    }
    
    
    _bundle = [[NSBundle alloc] initWithPath:[path stringByDeletingLastPathComponent]];
    
    if (_bundle == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable"
                                                         ofType:@"strings"
                                                    inDirectory:nil
                                                forLocalization:@"en"];
        if (path == nil) {
            path = [[NSBundle mainBundle] pathForResource:@"InfoPlist"
                                                   ofType:@"strings"
                                              inDirectory:nil
                                          forLocalization:@"en"];
        }
        
        _bundle = [[NSBundle alloc] initWithPath:[path stringByDeletingLastPathComponent]];
    }
}

#pragma mark ==================================================
#pragma mark == Public Method
#pragma mark ==================================================
/* 可适配的的语言 */
- (NSArray *_Nullable)languages {
    if (_localizationList == nil) {
        _localizationList = [NSArray arrayWithContentsOfFile:[self localizationFilePath]];
    }
    return _localizationList;
}

/* 当前语言 */
- (NSString *_Nullable)currentLanguage {
    return _currentLanguage;
}

/* 更改语言 */
- (void)changeLocalization:(NSString *_Nullable)language {
    if (![_currentLanguage isEqualToString:language]) {
        _currentLanguage = language;
        
        [[NSUserDefaults standardUserDefaults] setObject:_currentLanguage forKey:kDefaultLanguage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self initLanguage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_KKLocalizationDidChanged object:nil];
    }
}

/* 获取国际化语言（不带参数） */
- (NSString *_Nullable)localStringWithKey:(NSString *_Nullable)key {
    return NSLocalizedStringFromTableInBundle(key, @"Localizable", _bundle, nil);
}

/* 获取国际化语言（带参数） */
- (NSString *_Nullable)localStringWithKeyAndParameter:(NSString *_Nullable)key, ...{
    
    NSString *format = NSLocalizedStringFromTableInBundle(key, @"Localizable", _bundle, nil);

    BOOL formatResult = YES;
    va_list argumentList;
    va_start(argumentList, key);
    formatResult = [self checkParameters:format andArgumentsList:argumentList];
    va_end(argumentList);

    if (formatResult) {
        NSString *returnString = nil;
        va_list args1;
        va_start(args1, key);
        returnString = [[NSString alloc] initWithFormat:format arguments:args1];
        va_end(args1);
        return returnString;
    }
    else {
        KKLogErrorFormat(@"❌ ERROR: %@ 参数错误",KKValidString(key));
        return nil;
    }
}

#pragma mark ==================================================
#pragma mark == Private Method
#pragma mark ==================================================
- (NSArray*_Nonnull)parametersInformat:(NSString *_Nullable)format{
    
    //format里面需要的参数个数
    NSMutableArray *parameters = [NSMutableArray array];

    NSUInteger length = [format length];
    unichar last = '\0';
    for (NSUInteger i = 0; i<length; ++i) {
        unichar current = [format characterAtIndex:i];
        if (last == '%') {
            switch (current) {
                case '@':{
                    [parameters addObject:@"%@"];
                    break;
                }
                case 'c':{
                    // warning: second argument to 'va_arg' is of promotable type 'char'; this va_arg has undefined behavior because arguments will be promoted to 'int'
                    [parameters addObject:@"%c"];
                    break;
                }
                case 's':{
                    [parameters addObject:@"%s"];
                    break;
                }
                case 'd':{
                    [parameters addObject:@"%d"];
                    break;
                }
                case 'D':{
                    [parameters addObject:@"%D"];
                    break;
                }
                case 'i':{
                    [parameters addObject:@"%i"];
                    break;
                }
                case 'u':{
                    [parameters addObject:@"%u"];
                    break;
                }
                case 'U':{
                    [parameters addObject:@"%U"];
                    break;
                }
                case 'h':{
                    i++;
                    if (i < length && [format characterAtIndex:i] == 'i') {
                        [parameters addObject:@"%h"];
                    }
                    else if (i < length && [format characterAtIndex:i] == 'u') {
                        [parameters addObject:@"%h"];
                    }
                    else {
                        i--;
                    }
                    break;
                }
                case 'q':{
                    i++;
                    if (i < length && [format characterAtIndex:i] == 'i') {
                        [parameters addObject:@"%q"];
                    }
                    else if (i < length && [format characterAtIndex:i] == 'u') {
                        [parameters addObject:@"%q"];
                    }
                    else {
                        i--;
                    }
                    break;
                }
                case 'f':{
                    [parameters addObject:@"%f"];
                    break;
                }
                case 'g':{
                    [parameters addObject:@"%g"];
                    break;
                }
                case 'l':
                    i++;
                    if (i < length) {
                        unichar next = [format characterAtIndex:i];
                        if (next == 'l') {
                            i++;
                            if (i < length && [format characterAtIndex:i] == 'd') {
                                //%lld
                                [parameters addObject:@"%l"];
                            }
                            else if (i < length && [format characterAtIndex:i] == 'u') {
                                [parameters addObject:@"%l"];
                            }
                            else {
                                i--;
                            }
                        }
                        else if (next == 'd') {
                            //%ld
                            [parameters addObject:@"%l"];
                        }
                        else if (next == 'u') {
                            //%lu
                            [parameters addObject:@"%l"];
                        }
                        else {
                            i--;
                        }
                    }
                    else {
                        i--;
                    }
                    break;
                default:
                    // something else that we can't interpret. just pass it on through like normal
                    break;
            }
        }
        else if (current == '%') {
            // percent sign; skip this character
        }
        else {
            
        }
        
        last = current;
    }
    
    return parameters;
}

- (BOOL)checkParameters:(NSString *_Nullable)format
       andArgumentsList:(va_list)args{
    
    BOOL formatSuccess = YES;
    //format里面需要的参数个数
    NSMutableArray *parameters = [NSMutableArray array];
    //key后面携带的参数列表
    NSMutableArray *arguments = [NSMutableArray array];

    NSUInteger length = [format length];
    unichar last = '\0';
    for (NSUInteger i = 0; i<length && formatSuccess==YES; ++i) {
        id arg = nil;
        unichar current = [format characterAtIndex:i];
        if (last == '%') {
            switch (current) {
                case '@':{
                    [parameters addObject:@"%@"];
                    arg = va_arg(args, id);
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 'c':{
                    // warning: second argument to 'va_arg' is of promotable type 'char'; this va_arg has undefined behavior because arguments will be promoted to 'int'
                    [parameters addObject:@"%c"];
                    arg = [NSString stringWithFormat:@"%c", va_arg(args, int)];
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 's':{
                    [parameters addObject:@"%s"];
                    arg = [NSString stringWithUTF8String:va_arg(args, char*)];
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 'd':{
                    [parameters addObject:@"%d"];
                    arg = [NSNumber numberWithInt:va_arg(args, int)];
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 'D':{
                    [parameters addObject:@"%D"];
                    arg = [NSNumber numberWithInt:va_arg(args, int)];
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 'i':{
                    [parameters addObject:@"%i"];
                    arg = [NSNumber numberWithInt:va_arg(args, int)];
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 'u':{
                    [parameters addObject:@"%u"];
                    arg = [NSNumber numberWithUnsignedInt:va_arg(args, unsigned int)];
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 'U':{
                    [parameters addObject:@"%U"];
                    arg = [NSNumber numberWithUnsignedInt:va_arg(args, unsigned int)];
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 'h':{
                    i++;
                    if (i < length && [format characterAtIndex:i] == 'i') {
                        //  warning: second argument to 'va_arg' is of promotable type 'short'; this va_arg has undefined behavior because arguments will be promoted to 'int'
                        arg = [NSNumber numberWithUnsignedInt:va_arg(args, unsigned int)];
                        [parameters addObject:@"%h"];
                        if (arg != nil) [arguments addObject:arg];
                        else formatSuccess = NO;
                    }
                    else if (i < length && [format characterAtIndex:i] == 'u') {
                        // warning: second argument to 'va_arg' is of promotable type 'unsigned short'; this va_arg has undefined behavior because arguments will be promoted to 'int'
                        arg = [NSNumber numberWithUnsignedShort:(unsigned short)(va_arg(args, uint))];
                        [parameters addObject:@"%h"];
                        if (arg != nil) [arguments addObject:arg];
                        else formatSuccess = NO;
                    }
                    else {
                        i--;
                    }
                    break;
                }
                case 'q':{
                    i++;
                    if (i < length && [format characterAtIndex:i] == 'i') {
                        arg = [NSNumber numberWithLongLong:va_arg(args, long long)];
                        [parameters addObject:@"%q"];
                        if (arg != nil) [arguments addObject:arg];
                        else formatSuccess = NO;
                    }
                    else if (i < length && [format characterAtIndex:i] == 'u') {
                        arg = [NSNumber numberWithUnsignedLongLong:va_arg(args, unsigned long long)];
                        [parameters addObject:@"%q"];
                        if (arg != nil) [arguments addObject:arg];
                        else formatSuccess = NO;
                    }
                    else {
                        i--;
                    }
                    break;
                }
                case 'f':{
                    arg = [NSNumber numberWithDouble:va_arg(args, double)];
                    [parameters addObject:@"%f"];
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 'g':{
                    // warning: second argument to 'va_arg' is of promotable type 'float'; this va_arg has undefined behavior because arguments will be promoted to 'double'
                    arg = [NSNumber numberWithFloat:(float)(va_arg(args, double))];
                    [parameters addObject:@"%g"];
                    if (arg != nil) [arguments addObject:arg];
                    else formatSuccess = NO;
                    break;
                }
                case 'l':
                    i++;
                    if (i < length) {
                        unichar next = [format characterAtIndex:i];
                        if (next == 'l') {
                            i++;
                            if (i < length && [format characterAtIndex:i] == 'd') {
                                //%lld
                                arg = [NSNumber numberWithLongLong:va_arg(args, long long)];
                                [parameters addObject:@"%l"];
                                if (arg != nil) [arguments addObject:arg];
                                else formatSuccess = NO;
                            }
                            else if (i < length && [format characterAtIndex:i] == 'u') {
                                //%llu
                                arg = [NSNumber numberWithUnsignedLongLong:va_arg(args, unsigned long long)];
                                [parameters addObject:@"%l"];
                                if (arg != nil) [arguments addObject:arg];
                                else formatSuccess = NO;
                            }
                            else {
                                i--;
                            }
                        }
                        else if (next == 'd') {
                            //%ld
                            arg = [NSNumber numberWithLong:va_arg(args, long)];
                            [parameters addObject:@"%l"];
                            if (arg != nil) [arguments addObject:arg];
                            else formatSuccess = NO;
                        }
                        else if (next == 'u') {
                            //%lu
                            arg = [NSNumber numberWithUnsignedLong:va_arg(args, unsigned long)];
                            [parameters addObject:@"%l"];
                            if (arg != nil) [arguments addObject:arg];
                            else formatSuccess = NO;
                        }
                        else {
                            i--;
                        }
                    }
                    else {
                        i--;
                    }
                    break;
                default:
                    // something else that we can't interpret. just pass it on through like normal
                    break;
            }
        }
        else if (current == '%') {
            // percent sign; skip this character
        }
        else {
            
        }
        
        last = current;
    }
    
//    NSLog(@"%@",parameters);
//    NSLog(@"%@",arguments);
    
    return formatSuccess;
    
}

- (NSString *_Nullable)localizationFilePath {
    return [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath], kLocalizationFile];
}

@end
