//
//  KKFileCacheManagerDB.m
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKFileCacheManagerDB.h"
#import "KKCategory.h"
#import "KKLog.h"
#import "KKLibraryDBManager.h"

#define KKFileCacheManagerDB_ValidString(obj) ([KKFileCacheManagerDB validString:obj])

@implementation KKFileCacheManagerDB

+ (NSString*)validString:(NSString*)aString{
    if (aString && [aString isKindOfClass:[NSString class]]) {
        return aString;
    } else {
        return @"";
    }
}

#pragma mark ==================================================
#pragma mark == 接口方法
#pragma mark ==================================================
+ (NSArray*_Nonnull)allCacheDocumentInformation{
    NSString *selectSql = [NSString stringWithFormat:@" SELECT * FROM %@ "
                           ,TableName_KKFileCacheManager];

    __block NSMutableArray *arrary = [NSMutableArray array];

    FMDatabaseQueue *m_db = [KKLibraryDBManager defaultManager].db;
    [m_db inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery: selectSql];
        while ([rs next]) {
            NSDictionary *dictionary = [[KKLibraryDBManager defaultManager] dictionaryFromFMResultSet:rs];
            [arrary addObject_Safe:dictionary];
        }
        [rs close];
    }];

    return arrary;
}

+ (BOOL)saveFileCache_WithIdentifer:(NSString*_Nonnull)aIdentifier
                         remote_url:(NSString*_Nullable)aRemote_url
                    cache_directory:(NSString*_Nonnull)aCache_directory
                          extention:(NSString*_Nonnull)aExtention
                         local_path:(NSString*_Nonnull)aLocal_path
                         local_name:(NSString*_Nonnull)aLocal_name
                    local_full_name:(NSString*_Nonnull)aLocal_full_name
                       display_name:(NSString*_Nonnull)aDisplay_name
                  extra_information:(NSString*_Nullable)aExtra_information{

    NSString *identifer = KKFileCacheManagerDB_ValidString(aIdentifier);
    NSString *remote_url = KKFileCacheManagerDB_ValidString(aRemote_url);
    NSString *cache_directory = KKFileCacheManagerDB_ValidString(aCache_directory);
    NSString *extention = KKFileCacheManagerDB_ValidString(aExtention);
    NSString *local_path = KKFileCacheManagerDB_ValidString(aLocal_path);
    NSString *local_name = KKFileCacheManagerDB_ValidString(aLocal_name);
    NSString *local_full_name = KKFileCacheManagerDB_ValidString(aLocal_full_name);
    NSString *display_name = KKFileCacheManagerDB_ValidString(aDisplay_name);
    NSString *extra_information = KKFileCacheManagerDB_ValidString(aExtra_information);
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:identifer forKey:Table_KKFileCacheManager_identifier];
    [dictionary setObject:remote_url forKey:Table_KKFileCacheManager_url];
    [dictionary setObject:cache_directory forKey:Table_KKFileCacheManager_cache_directory];
    [dictionary setObject:extention forKey:Table_KKFileCacheManager_extention];
    [dictionary setObject:local_path forKey:Table_KKFileCacheManager_local_path];
    [dictionary setObject:local_name forKey:Table_KKFileCacheManager_local_name];
    [dictionary setObject:local_full_name forKey:Table_KKFileCacheManager_local_full_name];
    [dictionary setObject:display_name forKey:Table_KKFileCacheManager_display_name];
    [dictionary setObject:extra_information forKey:Table_KKFileCacheManager_extra_information];

    return [KKFileCacheManagerDB DBInsert_KKFileCache_Information:dictionary];
}

/**
 插入消息
 */
+ (BOOL)DBInsert_KKFileCache_Information:(NSDictionary*_Nullable)aInformation{
    if ([NSDictionary isDictionaryEmpty:aInformation]) {
        return NO;
    }

    //存在该条数据【删除】
    NSString *identifer  = [aInformation validStringForKey:Table_KKFileCacheManager_identifier   ];
    NSDictionary *oldInformation = [KKFileCacheManagerDB DBQuery_KKFileCache_WithIdentifer:identifer];
    if ([NSDictionary isDictionaryNotEmpty:oldInformation]) {
        [KKLibraryDBManager.defaultManager DBDelete_Table:TableName_KKFileCacheManager withValue:identifer forKey:Table_KKFileCacheManager_identifier];
    }

    BOOL result =  [KKLibraryDBManager.defaultManager insertInformation:aInformation toTable:TableName_KKFileCacheManager];

    KKLogInfoFormat(@"KKFileCacheManagerDB保存缓存图片:  %@",KKValidString(identifer));

    return  result;
}

/**
 查询消息
 */
+ (NSDictionary*_Nullable)DBQuery_KKFileCache_WithIdentifer:(NSString*_Nullable)aIdentifier{
    if ([NSString isStringEmpty:aIdentifier]) {
        return nil;
    }

    NSString *selectSql = [NSString stringWithFormat:@" SELECT * FROM %@ "
                           " where %@ = ?",TableName_KKFileCacheManager,Table_KKFileCacheManager_identifier];

    FMDatabaseQueue *m_db = KKLibraryDBManager.defaultManager.db;
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [m_db inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery: selectSql,aIdentifier];
        while ([rs next]) {
            NSDictionary *dictionary = [KKLibraryDBManager.defaultManager dictionaryFromFMResultSet:rs];
            [dic setValuesForKeysWithDictionary:dictionary];
        }
        [rs close];
    }];

    return dic;
}

/**
 查询消息【某个目录下】
 */
+ (NSArray*_Nullable)DBQuery_KKFileCache_WithCacheDirectory:(NSString*_Nullable)aCacheDirectory{
    if ([NSString isStringEmpty:aCacheDirectory]) {
        return nil;
    }

    NSString *selectSql = [NSString stringWithFormat:@" SELECT * FROM %@ "
                           " where %@ = ?",TableName_KKFileCacheManager,Table_KKFileCacheManager_cache_directory];

    FMDatabaseQueue *m_db = KKLibraryDBManager.defaultManager.db;
    __block NSMutableArray *array = [NSMutableArray array];
    [m_db inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery: selectSql,aCacheDirectory];
        while ([rs next]) {
            NSDictionary *dictionary = [KKLibraryDBManager.defaultManager dictionaryFromFMResultSet:rs];
            [array addObject_Safe:dictionary];
        }
        [rs close];
    }];

    return array;
}

/**
 删除消息
 */
+ (BOOL)DBDelete_KKFileCache_WithIdentifer:(NSString*_Nullable)aIdentifier{
    if ([NSString isStringEmpty:aIdentifier]) {
        return NO;
    }
    return [KKLibraryDBManager.defaultManager DBDelete_Table:TableName_KKFileCacheManager withValue:aIdentifier forKey:Table_KKFileCacheManager_identifier];
}


@end
