//
//  KKUserDefaultsManagerDB.m
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKUserDefaultsManagerDB.h"
#import "KKCategory.h"
#import "KKLibraryDBManager.h"

@implementation KKUserDefaultsManagerDB

/**
 插入消息
 */
+ (BOOL)DBInsert_KKUserDefaults_WithUserIdentifier:(NSString*_Nullable)aUserIdentifier
                                               key:(NSString*_Nullable)aKey
                                               value:(NSString*_Nullable)aValue{
    if ([NSString kk_isStringEmpty:aKey] ||
        [NSString kk_isStringEmpty:aValue] ) {
        return NO;
    }

    [KKUserDefaultsManagerDB DBDelete_KKUserDefaults_WithUserIdentifier:aUserIdentifier
                                                                    key:aKey];

    NSMutableDictionary *aInformation = [NSMutableDictionary dictionary];
    if ([NSString kk_isStringNotEmpty:aUserIdentifier]) {
        [aInformation setObject:aUserIdentifier forKey:Table_KKUserDefaultsManager_user_identifier];
    } else {
        [aInformation setObject:@"" forKey:Table_KKUserDefaultsManager_user_identifier];
    }
    [aInformation setObject:aKey forKey:Table_KKUserDefaultsManager_key];
    [aInformation setObject:aValue forKey:Table_KKUserDefaultsManager_value];

    BOOL result =  [KKLibraryDBManager.defaultManager insertInformation:aInformation
                                                                toTable:TableName_KKUserDefaultsManager];

    return  result;
}

/**
 查询消息
 */
+ (NSString*_Nullable)DBQuery_KKUserDefaults_WithUserIdentifier:(NSString*_Nullable)aUserIdentifier
                                                            key:(NSString*_Nullable)aKey{
    if ([NSString kk_isStringEmpty:aKey]) {
        return nil;
    }

    if ([NSString kk_isStringNotEmpty:aUserIdentifier]) {
        NSString *selectSql = [NSString stringWithFormat:@" SELECT * FROM %@ "
                               " where %@ = ? and %@ = ?",TableName_KKUserDefaultsManager,Table_KKUserDefaultsManager_user_identifier,Table_KKUserDefaultsManager_key];

        FMDatabaseQueue *m_db = KKLibraryDBManager.defaultManager.db;
        __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [m_db inDatabase:^(FMDatabase *db){
            FMResultSet *rs = [db executeQuery: selectSql,aUserIdentifier,aKey];
            while ([rs next]) {
                NSDictionary *dictionary = [KKLibraryDBManager.defaultManager dictionaryFromFMResultSet:rs];
                [dic setValuesForKeysWithDictionary:dictionary];
            }
            [rs close];
        }];

        return [dic kk_validStringForKey:Table_KKUserDefaultsManager_value];
    } else {
        NSString *selectSql = [NSString stringWithFormat:@" SELECT * FROM %@ "
                               " where %@ = ?",TableName_KKUserDefaultsManager,Table_KKUserDefaultsManager_key];

        FMDatabaseQueue *m_db = KKLibraryDBManager.defaultManager.db;
        __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [m_db inDatabase:^(FMDatabase *db){
            FMResultSet *rs = [db executeQuery: selectSql,aKey];
            while ([rs next]) {
                NSDictionary *dictionary = [KKLibraryDBManager.defaultManager dictionaryFromFMResultSet:rs];
                [dic setValuesForKeysWithDictionary:dictionary];
            }
            [rs close];
        }];

        return [dic kk_validStringForKey:Table_KKUserDefaultsManager_value];
    }
}

/**
 删除消息
 */
+ (BOOL)DBDelete_KKUserDefaults_WithUserIdentifier:(NSString*_Nullable)aUserIdentifier
                                               key:(NSString*_Nullable)aKey{
    if ([NSString kk_isStringEmpty:aKey]) {
        return NO;
    }

    if ([NSString kk_isStringNotEmpty:aUserIdentifier]) {
        __block BOOL result = NO;

        NSString *deleteSql = [NSString stringWithFormat:@"Delete From %@ "
                               " where  "
                               " %@ = ? and %@ = ? ",
                               TableName_KKUserDefaultsManager,
                               Table_KKUserDefaultsManager_user_identifier,
                               Table_KKUserDefaultsManager_key];

        FMDatabaseQueue *m_db = KKLibraryDBManager.defaultManager.db;
        [m_db inDatabase:^(FMDatabase *db){

            result = [db executeUpdate:deleteSql,aUserIdentifier,aKey];

            if (!result) {
#ifdef DEBUG
                NSLog(@"数据库操作失败：%s",__FUNCTION__);
#endif
            }
        }];

        return result;

    } else {
        __block BOOL result = NO;

        NSString *deleteSql = [NSString stringWithFormat:@"Delete From %@ "
                               " where  "
                               " %@ = ?",
                               TableName_KKUserDefaultsManager,
                               Table_KKUserDefaultsManager_key];

        FMDatabaseQueue *m_db = KKLibraryDBManager.defaultManager.db;
        [m_db inDatabase:^(FMDatabase *db){

            result = [db executeUpdate:deleteSql,aKey];

            if (!result) {
#ifdef DEBUG
                NSLog(@"数据库操作失败：%s",__FUNCTION__);
#endif
            }
        }];

        return result;
    }
}

/**
 删除消息
 */
+ (BOOL)DBDelete_KKUserDefaults_WithUserIdentifier:(NSString*_Nullable)aUserIdentifier{
    if ([NSString kk_isStringEmpty:aUserIdentifier]) {
        return NO;
    }

    __block BOOL result = NO;

    NSString *deleteSql = [NSString stringWithFormat:@"Delete From %@ "
                           " where  "
                           " %@ = ?",
                           TableName_KKUserDefaultsManager,
                           Table_KKUserDefaultsManager_user_identifier];

    FMDatabaseQueue *m_db = KKLibraryDBManager.defaultManager.db;
    [m_db inDatabase:^(FMDatabase *db){

        result = [db executeUpdate:deleteSql,aUserIdentifier];

        if (!result) {
#ifdef DEBUG
            NSLog(@"数据库操作失败：%s",__FUNCTION__);
#endif
        }
    }];

    return result;
}

@end
