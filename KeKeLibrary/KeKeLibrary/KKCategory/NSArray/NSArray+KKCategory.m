//
//  NSArray+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSArray+KKCategory.h"

@implementation NSArray (KKCategory)

/**
 判断数组是否为空（nil、不是数组对象、数组对象包含的元素个数为空，均认为是空数组）
 
 @param array 需要判断的数组
 @return 结果
 */
+ (BOOL)isArrayNotEmpty:(nullable id)array{
    if (array && [array isKindOfClass:[NSArray class]] && [array count]>0) {
        return YES;
    }
    else{
        return NO;
    }
}

/**
 判断数组是否为空（nil、不是数组对象、数组对象包含的元素个数为空，均认为是空数组）
 
 @param array 需要判断的数组
 @return 结果
 */
+ (BOOL)isArrayEmpty:(nullable id)array{
    return ![NSArray isArrayNotEmpty:array];
}

/**
 判断数组是否包含某个字符串元素
 
 @param aString 需要判断的字符串对象
 @return 结果
 */
- (BOOL)containsStringValue:(nullable NSString*)aString{
    
    BOOL contains = NO;
    
    for (int i = 0; i<[self count]; i++) {
        id indexString = [self objectAtIndex:i];
        
        if ([indexString isKindOfClass:[NSNumber class]]) {
            if ([aString integerValue] == [indexString integerValue]) {
                contains = YES;
                break;
            }
        }
        else if ([indexString isKindOfClass:[NSString class]]) {
            if ([indexString isEqualToString:aString]) {
                contains = YES;
                break;
            }
        }
        else{
            continue;
        }
    }
    
    return contains;
}

/**
 转换成json字符串
 
 @return 结果
 */
- (nonnull NSString*)translateToJSONString{
    
    //NSJSONWritingPrettyPrinted 方式，苹果会默认加上\n换行符，如果传0，就不会
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:0
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}

/**
 将JsonData转换成数组
 
 @param aJsonData aJsonData
 @return 结果
 */
+ (nullable NSArray*)arrayFromJSONData:(nullable NSData*)aJsonData{
    if (aJsonData && [aJsonData isKindOfClass:[NSData class]]) {
        NSError *error = nil;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:aJsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSArray class]]){
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
 将JsonString转换成数组
 
 @param aJsonString aJsonString
 @return 结果
 */
+ (nullable NSArray*)arrayFromJSONString:(nullable NSString*)aJsonString{
    
    if (aJsonString && [aJsonString isKindOfClass:[NSString class]]) {
        
        NSData *jsonData = [aJsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSArray class]]){
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

#pragma mark ==================================================
#pragma mark == KKSafe
#pragma mark ==================================================
/**
 安全取元素
 
 @param index 索引值
 @return 结果
 */
- (id)objectAtIndex_Safe:(NSUInteger)index{
    if (index<[self count]) {
        return [self objectAtIndex:index];
    }
    else{
        return nil;
    }
}

/**
 安全取元素
 
 @param index 索引值
 @return 结果
 */
- (id)objectAtIndexedSubscript_Safe:(NSUInteger)index{
    if (index<[self count]) {
        return [self objectAtIndexedSubscript:index];
    }
    else{
        return nil;
    }
}
@end
