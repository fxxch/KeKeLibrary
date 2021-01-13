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

#pragma mark ==================================================
#pragma mark == 基础方法
#pragma mark ==================================================
+ (BOOL)setObject:(id _Nullable)anObject forKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier;

+ (BOOL)removeObjectForKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier;

+ (id _Nullable)objectForKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier;

+ (BOOL)clearKKUserDefaultsManagerWithIdentifier:(NSString*_Nullable)aIdentifier;

#pragma mark ==================================================
#pragma mark == 扩展方法
#pragma mark ==================================================
+ (void)clearNSUserDefaults;

+ (void)arrayAddObject:(id _Nullable)anObject
                forKey:(NSString*_Nullable)aKey
            identifier:(NSString*_Nullable)aIdentifier;

+ (void)arrayInsertObject:(id _Nullable)anObject
                  atIndex:(NSInteger)aIndex
                   forKey:(NSString*_Nullable)aKey
               identifier:(NSString*_Nullable)aIdentifier;

+ (void)arrayRemoveAtIndex:(NSInteger)aIndex
                    forKey:(NSString*_Nullable)aKey
                identifier:(NSString*_Nullable)aIdentifier;

@end
