//
//  KKCoreTextDBManager.m
//  CEDongLi
//
//  Created by liubo on 16/8/4.
//  Copyright © 2016年 KeKeStudio. All rights reserved.
//

#import "KKCoreTextDBManager.h"
#import "KKCoreTextItem.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "KKCategory.h"

@interface FMDatabase (KKCoreTextDBManager_Extention)

- (NSArray*)getTableColumnNames:(NSString*)tableName;

@end

@implementation FMDatabase (KKCoreTextDBManager_Extention)

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

@interface KKCoreTextDBManager ()
{
    FMDatabaseQueue *m_db;
}

@property (nonatomic,strong) FMDatabaseQueue *db;

@end

@implementation KKCoreTextDBManager
@synthesize db = m_db;

- (void)dealloc{
    [m_db close];
}

+ (KKCoreTextDBManager *)defaultManager {
    static KKCoreTextDBManager *KKCoreTextDBManager_defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKCoreTextDBManager_defaultManager = [[self alloc] init];
    });
    return KKCoreTextDBManager_defaultManager;
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
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:KKCoreText_DBName];
    
    //拷贝已经存在的（内置）数据库文件 到 document目录下
    NSFileManager* file = [NSFileManager defaultManager];
    if (![file fileExistsAtPath:dbPath]) {
        NSString* path = [[NSBundle mainBundle] pathForResource:KKCoreText_DBName ofType:nil];
        NSError* error = nil;
        [file copyItemAtPath:path toPath:dbPath error:&error];
    }
    
    [self closeDB];
    
    m_db = [[FMDatabaseQueue alloc] initWithPath:dbPath] ;
    if (!m_db) {
#ifdef DEBUG
        NSLog(@"数据库拷贝失败");
#endif
    }
}

- (void)closeDB{
    [m_db close];
    m_db = nil;
}

- (void)saveKKCoreTextString:(NSString*)aString{
    // 为了防止界面卡住，可以异步执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSString praseKKCortextString:aString itemsArray:nil itemsDictionary:nil itemsIndexDictionary:nil forDrawing:YES];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //
        //        });
        
    });
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
#ifdef DEBUG
            NSLog(@"数据库操作失败：%s",__FUNCTION__);
#endif
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
#ifdef DEBUG
            NSLog(@"数据库操作失败：%s",__FUNCTION__);
#endif
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
                    [ParameterDictionary setObject:(NSString*)[(NSDictionary*)value translateToJSONString] forKey:columnName];
                }
                else if (value && [value isKindOfClass:[NSArray class]]){
                    [ParameterDictionary setObject:(NSString*)[(NSArray*)value translateToJSONString] forKey:columnName];
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
#ifdef DEBUG
                NSLog(@"数据库操作失败：%s",__FUNCTION__);
#endif
            }
        }
    }];
    
    return result;
}


#pragma mark ==================================================
#pragma mark == KKCoreText
#pragma mark ==================================================
/**
 插入消息
 */
- (BOOL)DBInsert_KKCoreText_Information:(NSDictionary*)aInformation{
    
    if ([NSMutableDictionary isDictionaryEmpty:aInformation]) {
        return NO;
    }
    
    NSString *core_text    = [aInformation validStringForKey:Table_KKCoreText_core_text   ];
    NSDictionary *oldInformation = [self DBQuery_KKCoreText_WithCoreText:core_text];
    
    __block BOOL result = NO;
    
    //存在该条数据【更新】
    if ([NSDictionary isDictionaryNotEmpty:oldInformation]) {
        NSString *core_text = [aInformation validStringForKey:Table_KKCoreText_core_text       ];
        NSString *clear_text = [aInformation validStringForKey:Table_KKCoreText_clear_text      ];
        NSString *draw_text = [aInformation validStringForKey:Table_KKCoreText_draw_text         ];
        NSString *items_dictionary_json  = [aInformation validStringForKey:Table_KKCoreText_items_dictionary_json ];
        NSString *items_index_dictionary_json = [oldInformation validStringForKey:Table_KKCoreText_items_index_dictionary_json];
        
        //更新数据
        NSString *updateSql = [NSString stringWithFormat:@"Update %@ set "
                               " clear_text                   = ?            ,"
                               " draw_text                    = ?            ,"
                               " items_dictionary_json        = ?            ,"
                               " items_index_dictionary_json  = ?             "
                               " where  "
                               " core_text = ? ",
                               TableName_KKCoreText];
        
        [m_db inDatabase:^(FMDatabase *db){
            result = [db executeUpdate:updateSql,
                      clear_text                  ,
                      draw_text                   ,
                      items_dictionary_json       ,
                      items_index_dictionary_json ,
                      core_text                   ];
            
            if (!result) {
#ifdef DEBUG
                NSLog(@"数据库操作失败：%s",__FUNCTION__);
#endif
            }
        }];
    }
    //不存在该条数据【新增】
    else{
        NSMutableDictionary *insertDictionary = [NSMutableDictionary dictionary];
        [insertDictionary setValuesForKeysWithDictionary:aInformation];
        /*插入数据 TableName_KKCoreText*/
        result = [self insertInformation:insertDictionary toTable:TableName_KKCoreText];
    }
    
    return  result;
}

/**
 查询消息
 */
- (NSDictionary*)DBQuery_KKCoreText_WithCoreText:(NSString*)aCoreText{
    
    NSString *selectSql = [NSString stringWithFormat:@" SELECT * FROM %@ "
                           " where core_text = ?",TableName_KKCoreText];
    
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [m_db inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery: selectSql,aCoreText];
        while ([rs next]) {
            NSDictionary *dictionary = [self dictionaryFromFMResultSet:rs];
            [dic setValuesForKeysWithDictionary:dictionary];
        }
        [rs close];
    }];
    
    return dic;
}

#pragma mark ==================================================
#pragma mark == IMText
#pragma mark ==================================================
/**
 插入消息
 */
- (BOOL)DBInsert_IMText_Information:(NSDictionary*)aInformation{
    
    NSString *clear_text    = [aInformation validStringForKey:Table_IMText_clear_text   ];
    NSDictionary *oldInformation = [self DBQuery_IMText_WithIMText:clear_text];
    
    __block BOOL result = NO;
    
    //存在该条数据【更新】
    if ([NSDictionary isDictionaryNotEmpty:oldInformation]) {
        return YES;
    }
    //不存在该条数据【新增】
    else{
        NSMutableDictionary *insertDictionary = [NSMutableDictionary dictionary];
        [insertDictionary setValuesForKeysWithDictionary:aInformation];
        /*插入数据 TableName_IMText*/
        result = [self insertInformation:insertDictionary toTable:TableName_IMText];
    }
    
    return  result;
}

/**
 查询消息
 */
- (NSDictionary*)DBQuery_IMText_WithIMText:(NSString*)aIMText{
    
    NSString *selectSql = [NSString stringWithFormat:@" SELECT * FROM %@ "
                           " where clear_text = ?",TableName_IMText];
    
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [m_db inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery: selectSql,aIMText];
        while ([rs next]) {
            NSDictionary *dictionary = [self dictionaryFromFMResultSet:rs];
            [dic setValuesForKeysWithDictionary:dictionary];
        }
        [rs close];
    }];
    
    return dic;
}


#pragma mark ==================================================
#pragma mark == KKCoreTextSize
#pragma mark ==================================================
/**
 插入消息
 */
- (BOOL)DBInsert_KKCoreTextSize_Information:(NSDictionary*)aInformation{
    
    NSDictionary *oldInformation = [self DBQuery_KKCoreTextSize_WithInformation:aInformation];
    
    __block BOOL result = NO;
    
    //存在该条数据【更新】
    if ([NSDictionary isDictionaryNotEmpty:oldInformation]) {
        return YES;
    }
    //不存在该条数据【新增】
    else{
        NSMutableDictionary *insertDictionary = [NSMutableDictionary dictionary];
        [insertDictionary setValuesForKeysWithDictionary:aInformation];
        /*插入数据 TableName_KKCoreTextSize*/
        result = [self insertInformation:insertDictionary toTable:TableName_KKCoreTextSize];
    }
    
    return  result;
}

/**
 查询消息
 */
- (NSDictionary*)DBQuery_KKCoreTextSize_WithInformation:(NSDictionary*)aInformation{
    
    NSString *core_text
    = [aInformation validStringForKey:Table_KKCoreTextSize_core_text   ];
    NSString *font_description
    = [aInformation validStringForKey:Table_KKCoreTextSize_font_description];
    NSString *maxwidth
    = [aInformation validStringForKey:Table_KKCoreTextSize_maxwidth   ];
    NSString *row_separator_height
    = [aInformation validStringForKey:Table_KKCoreTextSize_row_separator_height   ];
    NSString *emotion_size
    = [aInformation validStringForKey:Table_KKCoreTextSize_emotion_size   ];
    
    NSString *selectSql = [NSString stringWithFormat:@" SELECT * FROM %@ "
                           " where core_text = ? "
                           " and   font_description = ? "
                           " and   maxwidth = ? "
                           " and   row_separator_height = ? "
                           " and   emotion_size = ? "
                           ,TableName_KKCoreTextSize];
    
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [m_db inDatabase:^(FMDatabase *db){
        FMResultSet *rs = [db executeQuery: selectSql,
                           core_text,
                           font_description,
                           maxwidth,
                           row_separator_height,
                           emotion_size];
        while ([rs next]) {
            NSDictionary *dictionary = [self dictionaryFromFMResultSet:rs];
            [dic setValuesForKeysWithDictionary:dictionary];
        }
        [rs close];
    }];
    
    return dic;
}

#pragma mark ==================================================
#pragma mark == 其他方法
#pragma mark ==================================================


@end
