//
//  NSMutableArray+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableArray (KKCategory)

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

/**
 NSMutableArray 插入 新值 到 索引index 指定位置
 
 @param anObject 新值
 @param index 索引 index
 */
- (void)insertObject_Safe:(id)anObject atIndex:(NSUInteger)index;

/**
 在range范围内， 移除掉anObject
 
 @param anObject 移除的anObject
 @param range 范围
 */
- (void)removeObject_Safe:(id)anObject inRange:(NSRange)range;

/**
 NSMutableArray 移除 索引 index 对应的 值
 
 @param range 移除 范围
 */
- (void)removeObjectsInRange_Safe:(NSRange)range;

@end
