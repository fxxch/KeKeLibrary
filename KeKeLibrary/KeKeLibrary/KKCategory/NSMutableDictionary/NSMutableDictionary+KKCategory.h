//
//  NSMutableDictionary+KKCategory.h
//  KeKeLibrary
//
//  Created by liubo on 2018/5/15.
//  Copyright © 2018年 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (KKCategory)

#pragma mark ==================================================
#pragma mark == KKSafe
#pragma mark ==================================================
/**
 根据akey 移除 对应的 键值对
 
 @param aKey key
 */
- (void)removeObjectForKey_Safe:(id<NSCopying>)aKey;

/**
 将键值对 添加 到 NSMutableDictionary 内
 
 @param anObject 值
 @param aKey 键
 */
- (void)setObject_Safe:(id)anObject forKey:(id<NSCopying>)aKey;

@end
