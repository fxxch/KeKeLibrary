//
//  NSArray+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSArray+KKCategory.h"
#import <objc/runtime.h>

@implementation NSArray (KKCategory)

#pragma mark ==================================================
#pragma mark == @dynamic & load
#pragma mark ==================================================
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            
        SEL sys_SEL = @selector(descriptionWithLocale:indent:);
        SEL my_SEL = @selector(cvn_descriptionWithLocale:indent:);
        
        Method sys_Method   = class_getInstanceMethod(self, sys_SEL);
        Method my_Method    = class_getInstanceMethod(self, my_SEL);
                
        BOOL didAddMethod = class_addMethod([self class],
                                                  sys_SEL,
                                                  method_getImplementation(my_Method),
                                                  method_getTypeEncoding(my_Method));
        
        if (didAddMethod) {
            class_replaceMethod([self class],
                                my_SEL,
                                method_getImplementation(sys_Method),
                                method_getTypeEncoding(sys_Method));
        }
        method_exchangeImplementations(sys_Method, my_Method);
    });
}

//解决NSLog对象的时候，中文输出unicode编码，不便查看的问题
- (NSString *)cvn_descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level{
    NSString *originString = [self cvn_descriptionWithLocale:locale indent:level];
    
    NSMutableString *convertedString = [originString mutableCopy];
    [convertedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:0 range:NSMakeRange(0, convertedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    
    return convertedString;
}

/**
 判断数组是否为空（nil、不是数组对象、数组对象包含的元素个数为空，均认为是空数组）
 
 @param array 需要判断的数组
 @return 结果
 */
+ (BOOL)kk_isArrayNotEmpty:(nullable id)array{
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
+ (BOOL)kk_isArrayEmpty:(nullable id)array{
    return ![NSArray kk_isArrayNotEmpty:array];
}

/**
 判断数组是否包含某个字符串元素
 
 @param aString 需要判断的字符串对象
 @return 结果
 */
- (BOOL)kk_containsStringValue:(nullable NSString*)aString{
    
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
- (nonnull NSString*)kk_translateToJSONString{
    
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
+ (nullable NSArray*)kk_arrayFromJSONData:(nullable NSData*)aJsonData{
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
+ (nullable NSArray*)kk_arrayFromJSONString:(nullable NSString*)aJsonString{
    
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
- (id)kk_objectAtIndex_Safe:(NSUInteger)index{
    if (index>=0 && index<[self count]) {
        return [self objectAtIndex:index];
    }
    else{
        return nil;
    }
}

@end
