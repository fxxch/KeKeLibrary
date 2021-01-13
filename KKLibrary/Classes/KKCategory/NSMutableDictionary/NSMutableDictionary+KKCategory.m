//
//  NSMutableDictionary+KKCategory.m
//  KKLibrary
//
//  Created by liubo on 2018/5/15.
//  Copyright © 2018年 KKLibrary. All rights reserved.
//

#import "NSMutableDictionary+KKCategory.h"

@implementation NSMutableDictionary (KKCategory)

#pragma mark ==================================================
#pragma mark == KKSafe
#pragma mark ==================================================
/**
 根据akey 移除 对应的 键值对
 
 @param aKey key
 */
- (void)removeObjectForKey_Safe:(id<NSCopying>)aKey {
    if (!aKey) {
        return;
    }
    [self removeObjectForKey:aKey];
}

/**
 将键值对 添加 到 NSMutableDictionary 内
 
 @param anObject 值
 @param aKey 键
 */
- (void)setObject_Safe:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject) {
        return;
    }
    if (!aKey) {
        return;
    }
    return [self setObject:anObject forKey:aKey];
}

@end
