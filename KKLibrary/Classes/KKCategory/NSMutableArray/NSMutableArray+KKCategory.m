//
//  NSMutableArray+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSMutableArray+KKCategory.h"

@implementation NSMutableArray (KKCategory)

#pragma mark ==================================================
#pragma mark == KKSafe
#pragma mark ==================================================
/**
 安全存元素
 
 @param object 索引值
 */
- (void)kk_addObject_Safe:(id)object{
    if (object) {
        return [self addObject:object];
    }
}

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

/**
 NSMutableArray 插入 新值 到 索引index 指定位置
 
 @param anObject 新值
 @param index 索引 index
 */
- (void)kk_insertObject_Safe:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
        return;
    }

    if (index<0) {
        return;
    }

    if (!anObject){
        return;
    }
    
    [self insertObject:anObject atIndex:index];
}

/**
 在range范围内， 移除掉anObject
 
 @param anObject 移除的anObject
 @param range 范围
 */
- (void)kk_removeObject_Safe:(id)anObject inRange:(NSRange)range {
    if (range.location > self.count) {
        return;
    }
    
    if (range.length > self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
    if (!anObject){
        return;
    }
    
    
    return [self removeObject:anObject inRange:range];
}

/**
 NSMutableArray 移除 索引 index 对应的 值
 
 @param range 移除 范围
 */
- (void)kk_removeObjectsInRange_Safe:(NSRange)range {
    
    if (range.location > self.count) {
        return;
    }
    
    if (range.length > self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
    return [self removeObjectsInRange:range];
}


@end
