//
//  KKUserDefaultsManager.h
//  ChervonIot
//
//  Created by edward lannister on 2022/06/22.
//  Copyright © 2022 ts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUserDefaultsManager : NSObject

#pragma mark ==================================================
#pragma mark == Basic
#pragma mark ==================================================
+ (void)setObject:(id _Nullable)anObject forKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier;

+ (void)removeObjectForKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier;

+ (id _Nullable)objectForKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier;

+ (void)clearUserDefaultsWithIdentifier:(NSString*_Nullable)aIdentifier;


#pragma mark ==================================================
#pragma mark == More <Array>
#pragma mark ==================================================
+ (void)clearAllUserDefaults;

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
