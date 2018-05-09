//
//  KKUserDefaultsManager.h
//  ProjectK
//
//  Created by liubo on 14-1-10.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KKUserDefaultsManager : NSObject

//+ (KKUserDefaultsManager *)defaultManager;

/**
 注册信息到NSUserDefaults（如果已经包含所存的值，就不保存了）
 1、anObject 需要保存的对象
 2、aKey 需要保存的对象——对应的key
 3、aIdentifier 标识符（根据需要自行分配，例如如果是缓存的数据指定给某个用户自己才能查看，那么这个值可以传这个用户的UserID
 */
+ (void)registerObject:(id)anObject forKey:(id)aKey identifier:(NSString*)aIdentifier;

/**
 保存信息到NSUserDefaults
 1、anObject 需要保存的对象
 2、aKey 需要保存的对象——对应的key
 3、aIdentifier 标识符（根据需要自行分配，例如如果是缓存的数据指定给某个用户自己才能查看，那么这个值可以传这个用户的UserID
 */
+ (void)setObject:(id)anObject forKey:(id)aKey identifier:(NSString*)aIdentifier;

/**
 从NSUserDefaults中移除信息
 1、aKey 移除保存的对象——对应的key
 2、aIdentifier 标识符（根据需要自行分配，例如如果是缓存的数据指定给某个用户自己才能查看，那么这个值可以传这个用户的UserID
 */
+ (void)removeObjectForKey:(NSString *)aKey identifier:(NSString*)aIdentifier;

/**
 读取NSUserDefaults的信息
 1、aKey 需要读取的对象——对应的key
 2、aIdentifier 标识符（根据需要自行分配，例如如果是缓存的数据指定给某个用户自己才能查看，那么这个值可以传这个用户的UserID
 */
+ (id)objectForKey:(id)aKey identifier:(NSString*)aIdentifier;

/**
 清除所有KKUserDefaultsManager数据
 1、aIdentifier 标识符（根据需要自行分配，例如如果是缓存的数据指定给某个用户自己才能查看，那么这个值可以传这个用户的UserID
 */
+ (void)clearKKUserDefaultsManagerWithIdentifier:(NSString*)aIdentifier;

/**
 清除所有NSUserDefaults数据
 */
+ (void)clearNSUserDefaults;

/**
 添加对象到数组，并且保存到NSUserDefaults
 1、anObject 需要保存的对象
 2、aKey 需要读取的对象——对应的key
 3、aIdentifier 标识符（根据需要自行分配，例如如果是缓存的数据指定给某个用户自己才能查看，那么这个值可以传这个用户的UserID
 */
+ (void)arrayAddObject:(id)anObject
                forKey:(id)aKey
            identifier:(NSString*)aIdentifier;

/**
 插入对象到数组，并且保存到NSUserDefaults
 1、anObject 需要保存的对象
 2、aIndex 需要插入的位置
 3、aKey 需要读取的对象——对应的key
 4、aIdentifier 标识符（根据需要自行分配，例如如果是缓存的数据指定给某个用户自己才能查看，那么这个值可以传这个用户的UserID
 */
+ (void)arrayInsertObject:(id)anObject
                  atIndex:(NSInteger)aIndex
                   forKey:(id)aKey
               identifier:(NSString*)aIdentifier;

/**
 移除对象从数组，并且保存
 1、aIndex 需要插入的位置
 2、aKey 需要读取的对象——对应的key
 3、aIdentifier 标识符（根据需要自行分配，例如如果是缓存的数据指定给某个用户自己才能查看，那么这个值可以传这个用户的UserID
 */
+ (void)arrayRemoveAtIndex:(NSInteger)aIndex
                    forKey:(id)aKey
                identifier:(NSString*)aIdentifier;

@end
