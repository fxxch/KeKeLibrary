//
//  KKLibraryDBManager.h
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <fmdb/FMDB.h>

@interface FMDatabase (KKExtention)

- (NSArray*)getTableColumnNames:(NSString*)tableName;

@end

#define KKLibraryDBManager_DBName @"KKLibraryDBManager.sqlite"

@interface KKLibraryDBManager : NSObject{
    FMDatabaseQueue *m_db;
}

@property (nonatomic,strong) FMDatabaseQueue *db;

+ (KKLibraryDBManager *)defaultManager;

- (void)openDB;

- (void)closeDB;

#pragma mark ==================================================
#pragma mark == 公共方法
#pragma mark ==================================================
- (BOOL)DBQuery_Table:(NSString*)tableName isExistValue:(NSString*)aValue forKey:(NSString*)aKey;

- (BOOL)DBDelete_Table:(NSString*)tableName withValue:(NSString*)aValue forKey:(NSString*)aKey;

- (BOOL)DBUpdate_Table:(NSString*)tableName withValue:(NSString*)aValue forKey:(NSString*)aKey;

- (void)setObject:(NSString*)aObject forKey:(NSString*)aKey intoDictionary:(NSMutableDictionary*)aDictionary;

/**
 清空表
 */
- (BOOL)DBTruncate_Table:(NSString*)tableName;

/**
 * 将数据库查询出来的数据，自动封装成Dictionary
 */
- (NSDictionary*)dictionaryFromFMResultSet:(FMResultSet*)rs;

/**
 * 将Dictionary插入到数据库对应的表中
 */
- (BOOL)insertInformation:(NSDictionary*)aInformation toTable:(NSString*)aTableName;


@end
