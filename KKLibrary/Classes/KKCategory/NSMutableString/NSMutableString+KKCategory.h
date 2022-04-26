//
//  NSMutableString+KKCategory.h
//  KKLibrary
//
//  Created by liubo on 2018/5/15.
//  Copyright © 2018年 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (KKCategory)

#pragma mark ==================================================
#pragma mark == KKSafe
#pragma mark ==================================================
/****************************************  substringFromIndex:  ***********************************/
/**
 从from位置截取字符串 对应 __NSCFString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *_Nullable)kk_substringFromIndex_Safe:(NSUInteger)from;


/****************************************  substringFromIndex:  ***********************************/
/**
 从开始截取到to位置的字符串  对应  __NSCFString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *_Nullable)kk_substringToIndex_Safe:(NSUInteger)to;

/*********************************** rangeOfString:options:range:locale:  ***************************/
/**
 搜索指定 字符串  对应  __NSCFString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)kk_rangeOfString_Safe:(NSString *_Nullable)searchString
                         options:(NSStringCompareOptions)mask
                           range:(NSRange)rangeOfReceiverToSearch
                          locale:(nullable NSLocale *)locale;


/*********************************** substringWithRange:  ***************************/
/**
 截取指定范围的字符串  对应  __NSCFString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *_Nullable)kk_substringWithRange_Safe:(NSRange)range;

/*********************************** safeMutable_appendString:  ***************************/
/**
 追加字符串 对应  __NSCFString
 
 @param aString 追加的字符串
 */
- (void)kk_appendString_Safe:(NSString *_Nullable)aString;

@end
