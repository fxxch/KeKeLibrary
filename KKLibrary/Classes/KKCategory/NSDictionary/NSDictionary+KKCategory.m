//
//  NSDictionary+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSDictionary+KKCategory.h"
#import "NSArray+KKCategory.h"

@implementation NSDictionary (KKCategory)

/**
 判断字典是否为空（nil、不是字典、字典包含元素0个 都视为空）
 
 @param dictionary 需要判断的字典
 @return 结果
 */
+ (BOOL)isDictionaryNotEmpty:(nullable id)dictionary{
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]] && [dictionary count]>0) {
        return YES;
    }
    else{
        return NO;
    }
}

/**
 判断字典是否为空（nil、不是字典、字典包含元素0个 都视为空）
 
 @param dictionary 需要判断的字典
 @return 结果
 */
+ (BOOL)isDictionaryEmpty:(nullable id)dictionary{
    return ![NSDictionary isDictionaryNotEmpty:dictionary];
}


- (BOOL)boolValueForKey:(nonnull id)aKey {
    return [[self objectForKey:aKey] boolValue];
}

- (int)intValueForKey:(nonnull id)aKey {
    return [[self objectForKey:aKey] intValue];
}

- (NSInteger)integerValueForKey:(nonnull id)aKey {
    return [[self objectForKey:aKey] integerValue];
}

- (float)floatValueForKey:(nonnull id)aKey {
    return [[self objectForKey:aKey] floatValue];
}

- (double)doubleValueForKey:(nonnull id)aKey {
    return [[self objectForKey:aKey] doubleValue];
}

/**
 获取NSString对象
 
 @param aKey aKey
 @return 返回：可能是NSString对象 或者 nil
 */
- (nullable NSString *)stringValueForKey:(nullable id)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if ([value isKindOfClass:[NSString class]]) {
            return (NSString*)value;
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber*)value stringValue];
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

/**
 获取NSString对象，不可能返回nil
 
 @param aKey aKey
 @return 返回：一定是一个NSString对象(NSString可能有值，可能为@“”)
 */
- (nonnull NSString*)validStringForKey:(nullable id)aKey{
    
    if (aKey) {
        NSObject *object = [self objectForKey:aKey];
        if (object && ![object isKindOfClass:[NSNull class]]) {
            if ([object isKindOfClass:[NSNumber class]]) {
                return [(NSNumber*)object stringValue];
            }
            else if ([object isKindOfClass:[NSString class]]){
                return (NSString*)object;
            }
            else if ([object isKindOfClass:[NSDictionary class]]){
                return (NSString*)[(NSDictionary*)object translateToJSONString];
            }
            else if ([object isKindOfClass:[NSArray class]]){
                return (NSString*)[(NSArray*)object translateToJSONString];
            }
            else if ([object isKindOfClass:[NSURL class]]){
                return [(NSURL*)object absoluteString];
            }
            else{
                return [[NSString alloc] initWithFormat:@"%@", object];
            }
        }
        else{
            return @"";
        }
    }
    else{
        return @"";
    }
}

/**
 获取NSDictionary对象
 
 @param aKey aKey
 @return 返回：可能是NSDictionary对象 或者 nil
 */
- (nullable NSDictionary *)dictionaryValueForKey:(nullable id)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if ([value isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary*)value;
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

/**
 获取NSDictionary对象
 
 @param aKey aKey
 @return 返回：一定是一个NSDictionary对象(NSDictionary里面可能有值，可能为空)
 */
- (nonnull NSDictionary*)validDictionaryForKey:(nonnull id)aKey{
    if (aKey) {
        id value = [self objectForKey:aKey];
        if ([value isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary*)value;
        }
        else if ([value isKindOfClass:[NSString class]]){
            NSDictionary *returnDictionary  = [NSDictionary dictionaryFromJSONString:(NSString*)value];
            if ([NSDictionary isDictionaryNotEmpty:returnDictionary]) {
                return returnDictionary;
            }
            else{
                return [NSDictionary dictionary];
            }
        }
        else if ([value isKindOfClass:[NSData class]]){
            NSDictionary *returnDictionary  = [NSDictionary dictionaryFromJSONData:(NSData*)value];
            if ([NSDictionary isDictionaryNotEmpty:returnDictionary]) {
                return returnDictionary;
            }
            else{
                return [NSDictionary dictionary];
            }
        }
        else{
            return [NSDictionary dictionary];
        }
        
    }
    else{
        return [NSDictionary dictionary];
    }
}

/**
 获取NSArray对象
 
 @param aKey aKey
 @return 返回：可能是NSArray对象 或者nil
 */
- (nullable NSArray *)arrayValueForKey:(nullable id)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if ([value isKindOfClass:[NSArray class]]) {
            return (NSArray*)value;
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

/**
 获取NSArray对象
 
 @param aKey aKey
 @return 返回：一定是一个NSArray对象(NSArray里面可能有值，可能为空)
 */
- (nonnull NSArray*)validArrayForKey:(nullable id)aKey{
    if (aKey) {
        id value = [self objectForKey:aKey];
        if ([value isKindOfClass:[NSArray class]]) {
            return (NSArray*)value;
        }
        else if ([value isKindOfClass:[NSString class]]){
            NSArray *returnArray = [NSArray arrayFromJSONString:(NSString*)value];
            if ([NSArray isArrayNotEmpty:returnArray]) {
                return returnArray;
            }
            else{
                return [NSArray array];
            }
        }
        else if ([value isKindOfClass:[NSData class]]){
            NSArray *returnArray = [NSArray arrayFromJSONData:(NSData*)value];
            if ([NSArray isArrayNotEmpty:returnArray]) {
                return returnArray;
            }
            else{
                return [NSArray array];
            }
        }
        else{
            return [NSArray array];
        }
    }
    else{
        return [NSArray array];
    }
}

/**
 将字典转换成Json字符串
 
 @return Json字符串
 */
- (nullable NSString*)translateToJSONString{
    
    //NSJSONWritingPrettyPrinted 方式，苹果会默认加上\n换行符，如果传0，就不会
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}

/**
 将JsonData转换成字典对象
 
 @return 字典对象
 */
+ (nullable NSDictionary*)dictionaryFromJSONData:(nullable NSData*)aJsonData{
    if (aJsonData && [aJsonData isKindOfClass:[NSData class]]) {
        
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:aJsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSDictionary class]]){
            return jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    }
    else{
        // 解析错误
        return nil;
    }
}

/**
 将JsonString转换成字典对象
 
 @return 字典对象
 */
+ (nullable NSDictionary*)dictionaryFromJSONString:(nullable NSString*)aJsonString{
    
    if (aJsonString && [aJsonString isKindOfClass:[NSString class]]) {
        
        NSData *aJsonData = [aJsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:aJsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSDictionary class]]){
            return jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    }
    else{
        // 解析错误
        return nil;
    }
}

@end
