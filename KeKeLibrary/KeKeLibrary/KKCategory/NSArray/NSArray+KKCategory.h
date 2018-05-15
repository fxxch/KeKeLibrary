//
//  NSArray+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (KKCategory)


/**
 判断数组是否为空（nil、不是数组对象、数组对象包含的元素个数为空，均认为是空数组）
 
 @param array 需要判断的数组
 @return 结果
 */
+ (BOOL)isArrayNotEmpty:(nullable id)array;

/**
 判断数组是否为空（nil、不是数组对象、数组对象包含的元素个数为空，均认为是空数组）
 
 @param array 需要判断的数组
 @return 结果
 */
+ (BOOL)isArrayEmpty:(nullable id)array;

/**
 判断数组是否包含某个字符串元素
 
 @param aString 需要判断的字符串对象
 @return 结果
 */
- (BOOL)containsStringValue:(nullable NSString*)aString;

/**
 转换成json字符串
 
 @return 结果
 */
- (nonnull NSString*)translateToJSONString;
/**
 将JsonData转换成数组
 
 @param aJsonData aJsonData
 @return 结果
 */
+ (nullable NSArray*)arrayFromJSONData:(nullable NSData*)aJsonData;

/**
 将JsonString转换成数组
 
 @param aJsonString aJsonString
 @return 结果
 */
+ (nullable NSArray*)arrayFromJSONString:(nullable NSString*)aJsonString;

#pragma mark ==================================================
#pragma mark == KKSafe
#pragma mark ==================================================
/**
 安全取元素
 
 @param index 索引值
 @return 结果
 */
- (id)objectAtIndex_Safe:(NSUInteger)index;

/**
 安全取元素
 
 @param index 索引值
 @return 结果
 */
- (id)objectAtIndexedSubscript_Safe:(NSUInteger)index;

@end
