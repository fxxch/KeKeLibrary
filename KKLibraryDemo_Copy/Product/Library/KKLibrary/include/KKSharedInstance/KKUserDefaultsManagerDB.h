//
//  KKUserDefaultsManagerDB.h
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TableName_KKUserDefaultsManager @"KKUserDefaultsManager"
#pragma mark ==================================================
#pragma mark == KKFileCacheManager
#pragma mark ==================================================
#define Table_KKUserDefaultsManager_id                      @"id" //自增字段
/* 标示符 用于区分用户 */
#define Table_KKUserDefaultsManager_user_identifier         @"user_identifier"
/* 主键 */
#define Table_KKUserDefaultsManager_key                     @"key"
/* 值  */
#define Table_KKUserDefaultsManager_value                   @"value"

@interface KKUserDefaultsManagerDB : NSObject

/**
 插入消息
 */
+ (BOOL)DBInsert_KKUserDefaults_WithUserIdentifier:(NSString*_Nullable)aUserIdentifier
                                               key:(NSString*_Nullable)aKey
                                             value:(NSString*_Nullable)aValue;

/**
 查询消息
 */
+ (NSString*_Nullable)DBQuery_KKUserDefaults_WithUserIdentifier:(NSString*_Nullable)aUserIdentifier
                                                            key:(NSString*_Nullable)aKey;

/**
 删除消息
 */
+ (BOOL)DBDelete_KKUserDefaults_WithUserIdentifier:(NSString*_Nullable)aUserIdentifier
                                               key:(NSString*_Nullable)aKey;

/**
 删除消息
 */
+ (BOOL)DBDelete_KKUserDefaults_WithUserIdentifier:(NSString*_Nullable)aUserIdentifier;

@end
