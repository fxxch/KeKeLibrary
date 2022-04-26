//
//  KKLibraryDBManager.m
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKLibraryDBManager.h"
#import "KKLog.h"
#import "KKCategory.h"

@implementation FMDatabase (Extention)

- (NSArray*)getTableColumnNames:(NSString*)tableName{

    FMResultSet *rs = [self getTableSchema:[tableName lowercaseString]];

    NSMutableArray *namesArray = [NSMutableArray array];
    //check if column is present in table schema
    while ([rs next]) {
        NSString *name = [rs stringForColumn:@"name"];
        if (name && [name length]>0) {
            [namesArray addObject:name];
        }
    }

    //If this is not done FMDatabase instance stays out of pool
    [rs close];

    return namesArray;
}

@end


@implementation KKLibraryDBManager
@synthesize db = m_db;

- (void)dealloc{
    [m_db close];
}

+ (KKLibraryDBManager *)defaultManager {
    static KKLibraryDBManager *KKLibraryDBManager_defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKLibraryDBManager_defaultManager = [[self alloc] init];
    });
    return KKLibraryDBManager_defaultManager;
}


#pragma mark ==================================================
#pragma mark == 实例化DB
#pragma mark ==================================================
- (id)init{
    if (self = [super init]) {
        [self openDB];
    }
    return self;
}

- (void)openDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:KKLibraryDBManager_DBName];

    //拷贝已经存在的（内置）数据库文件 到 document目录下
    NSFileManager* file = [NSFileManager defaultManager];
    if (![file fileExistsAtPath:dbPath]) {
        NSString* path = [[NSBundle kk_kkLibraryBundle] pathForResource:KKLibraryDBManager_DBName ofType:nil];
        NSError* error = nil;
        [file copyItemAtPath:path toPath:dbPath error:&error];
    }

    [self closeDB];

    m_db = [[FMDatabaseQueue alloc] initWithPath:dbPath] ;
    if (!m_db) {
        KKLogError(@"数据库拷贝失败");
    }
}

- (void)closeDB{
    [m_db close];
    m_db = nil;
}

#pragma mark ==================================================
#pragma mark == 公共方法
#pragma mark ==================================================
- (BOOL)DBQuery_Table:(NSString*)tableName isExistValue:(NSString*)aValue forKey:(NSString*)aKey{
    __block NSString *selectSql = [NSString stringWithFormat:@"SELECT count(1) FROM %@ where %@=? ",tableName,aKey];
    __block NSInteger count = 0;

    [m_db inDatabase:^(FMDatabase *db){
        count = [db intForQuery: selectSql,aValue];
    }];

    if (count>0) {
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)DBDelete_Table:(NSString*)tableName withValue:(NSString*)aValue forKey:(NSString*)aKey{
    __block NSString *selectSql = [NSString stringWithFormat:@"Delete FROM %@ where %@=? ",tableName,aKey];
    __block NSInteger count = 0;

    [m_db inDatabase:^(FMDatabase *db){
        count = [db intForQuery: selectSql,aValue];
    }];

    if (count>0) {
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)DBUpdate_Table:(NSString*)tableName withValue:(NSString*)aValue forKey:(NSString*)aKey{

    NSString *updateSql = [NSString stringWithFormat:@"Update %@ set %@=? ",tableName,aKey];
    __block BOOL result = NO;

    [m_db inDatabase:^(FMDatabase *db){

        result = [db executeUpdate:updateSql,aValue];

        if (!result) {
            KKLogErrorFormat(@"数据库操作失败：%s",__FUNCTION__);
        }
    }];

    return result;
}

- (void)setObject:(NSString*)aObject forKey:(NSString*)aKey intoDictionary:(NSMutableDictionary*)aDictionary{
    if (aKey && aDictionary) {
        if (aObject) {
            [aDictionary setObject:aObject forKey:aKey];
        }
        else{
            [aDictionary setObject:@"" forKey:aKey];
        }
    }
}

/**
 清空表
 */
- (BOOL)DBTruncate_Table:(NSString*)tableName{

    __block BOOL result = NO;
    //插入数据
    NSString *updateSql = [NSString stringWithFormat:@"Delete From %@",tableName];

    [m_db inDatabase:^(FMDatabase *db){

        result = [db executeUpdate:updateSql];

        if (!result) {
            KKLogErrorFormat(@"数据库操作失败：%s",__FUNCTION__);
        }
    }];

    return  result;
}

/**
 * 将数据库查询出来的数据，自动封装成Dictionary
 */
- (NSDictionary*)dictionaryFromFMResultSet:(FMResultSet*)rs{
    if (rs && rs.columnNameToIndexMap) {
        NSArray *columnNameArray = [rs.columnNameToIndexMap allKeys];
        if ([columnNameArray count]>0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSInteger i=0; i<[columnNameArray count]; i++) {
                NSString *columnName = [columnNameArray objectAtIndex:i];
                NSString *value = [rs stringForColumn:columnName];
                if (value && ![value isKindOfClass:[NSNull class]]) {
                    [dic setObject:value forKey:columnName];
                }
                else{
                    [dic setObject:@"" forKey:columnName];
                }
            }
            return dic;
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

/**
 * 将Dictionary插入到数据库对应的表中
 */
- (BOOL)insertInformation:(NSDictionary*)aInformation toTable:(NSString*)aTableName{

    __block BOOL result = NO;

    [m_db inDatabase:^(FMDatabase *db){

        NSMutableDictionary *ParameterDictionary = [NSMutableDictionary dictionary];

        NSArray *tableColumnNamesArray = [db getTableColumnNames:aTableName];

        if ([tableColumnNamesArray count]>0) {
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (",aTableName];
            NSString *insertSql_Values = [NSString stringWithFormat:@" VALUES ("];

            for (NSInteger i=0; i<[tableColumnNamesArray count]; i++) {
                NSString *columnName = [tableColumnNamesArray objectAtIndex:i];
                if (i==[tableColumnNamesArray count]-1) {
                    insertSql = [insertSql stringByAppendingFormat:@"%@)",columnName];
                    insertSql_Values = [insertSql_Values stringByAppendingFormat:@":%@)",columnName];
                }
                else{
                    insertSql = [insertSql stringByAppendingFormat:@"%@,",columnName];
                    insertSql_Values = [insertSql_Values stringByAppendingFormat:@":%@,",columnName];
                }

                NSObject *value = [aInformation objectForKey:columnName];
                if (value && [value isKindOfClass:[NSString class]]) {
                    [ParameterDictionary setObject:(NSString*)value forKey:columnName];
                }
                else if (value && [value isKindOfClass:[NSDictionary class]]){
                    [ParameterDictionary setObject:(NSString*)[(NSDictionary*)value kk_translateToJSONString] forKey:columnName];
                }
                else if (value && [value isKindOfClass:[NSArray class]]){
                    [ParameterDictionary setObject:(NSString*)[(NSArray*)value kk_translateToJSONString] forKey:columnName];
                }
                else if (value && [value isKindOfClass:[NSNumber class]]){
                    [ParameterDictionary setObject:[(NSNumber*)value stringValue] forKey:columnName];
                }
                else{
                    [ParameterDictionary setObject:[NSNull null] forKey:columnName];
                }
            }

            insertSql = [insertSql stringByAppendingString:insertSql_Values];

            result = [db executeUpdate:insertSql withParameterDictionary:ParameterDictionary];

            if (!result) {
                KKLogErrorFormat(@"数据库操作失败：%s",__FUNCTION__);
            }
        }
    }];

    return result;
}


@end
