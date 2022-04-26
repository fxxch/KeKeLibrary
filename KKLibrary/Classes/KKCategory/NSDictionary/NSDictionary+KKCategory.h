//
//  NSDictionary+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (KKCategory)

/**
 判断字典是否为空（nil、不是字典、字典包含元素0个 都视为空）
 
 @param dictionary 需要判断的字典
 @return 结果
 */
+ (BOOL)kk_isDictionaryNotEmpty:(nullable id)dictionary;

/**
 判断字典是否为空（nil、不是字典、字典包含元素0个 都视为空）
 
 @param dictionary 需要判断的字典
 @return 结果
 */
+ (BOOL)kk_isDictionaryEmpty:(nullable id)dictionary;


- (BOOL)kk_boolValueForKey:(nonnull id)aKey;

- (int)kk_intValueForKey:(nonnull id)aKey;

- (NSInteger)kk_integerValueForKey:(nonnull id)aKey;

- (float)kk_floatValueForKey:(nonnull id)aKey;

- (double)kk_doubleValueForKey:(nonnull id)aKey;

/**
 获取NSString对象
 
 @param aKey aKey
 @return 返回：可能是NSString对象 或者 nil
 */
- (nullable NSString *)kk_stringValueForKey:(nullable id)aKey;

/**
 获取NSString对象，不可能返回nil
 
 @param aKey aKey
 @return 返回：一定是一个NSString对象(NSString可能有值，可能为@“”)
 */
- (nonnull NSString*)kk_validStringForKey:(nullable id)aKey;

/**
 获取NSDictionary对象
 
 @param aKey aKey
 @return 返回：可能是NSDictionary对象 或者 nil
 */
- (nullable NSDictionary *)kk_dictionaryValueForKey:(nullable id)aKey;

/**
 获取NSDictionary对象
 
 @param aKey aKey
 @return 返回：一定是一个NSDictionary对象(NSDictionary里面可能有值，可能为空)
 */
- (nonnull NSDictionary*)kk_validDictionaryForKey:(nonnull id)aKey;

/**
 获取NSArray对象
 
 @param aKey aKey
 @return 返回：可能是NSArray对象 或者nil
 */
- (nullable NSArray *)kk_arrayValueForKey:(nullable id)aKey;

/**
 获取NSArray对象
 
 @param aKey aKey
 @return 返回：一定是一个NSArray对象(NSArray里面可能有值，可能为空)
 */
- (nonnull NSArray*)kk_validArrayForKey:(nullable id)aKey;

/**
 将字典转换成Json字符串
 
 @return Json字符串
 */
- (nullable NSString*)kk_translateToJSONString;

/**
 将JsonData转换成字典对象
 
 @return 字典对象
 */
+ (nullable NSDictionary*)kk_dictionaryFromJSONData:(nullable NSData*)aJsonData;

/**
 将JsonString转换成字典对象
 
 @return 字典对象
 */
+ (nullable NSDictionary*)kk_dictionaryFromJSONString:(nullable NSString*)aJsonString;

@end
