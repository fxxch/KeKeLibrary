//
//  KKFileCacheManagerDB.h
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TableName_KKFileCacheManager @"KKFileCacheManager"
#pragma mark ==================================================
#pragma mark == KKFileCacheManager
#pragma mark ==================================================
#define Table_KKFileCacheManager_id                          @"id" //自增字段
/* 文件标示符（一般是文件的远程URL字符串）*/
#define Table_KKFileCacheManager_identifier                  @"identifier"
/* 文件远程URL*/
#define Table_KKFileCacheManager_url                         @"remote_url"
/* 所处的文件夹类型Web_Image、Album_Image…… */
#define Table_KKFileCacheManager_cache_directory             @"cache_directory"
/* 文件扩展名（PNG、MP4、pdf…………）*/
#define Table_KKFileCacheManager_extention                   @"extention"
/* 文件本地路径*/
#define Table_KKFileCacheManager_local_path                  @"local_path"
/* 本地文件名(20141212_094434_123999) */
#define Table_KKFileCacheManager_local_name                  @"local_name"
/* 本地文件名(20141212_094434_123999.png) */
#define Table_KKFileCacheManager_local_full_name             @"local_full_name"
/* 远程文件名/显示的文件名(国庆出游.png) */
#define Table_KKFileCacheManager_display_name                @"display_name"//
/* 文件信息（扩展字段）*/
#define Table_KKFileCacheManager_extra_information           @"extra_information"



NS_ASSUME_NONNULL_BEGIN

@interface KKFileCacheManagerDB : NSObject

#pragma mark ==================================================
#pragma mark == 接口方法
#pragma mark ==================================================
+ (NSArray*_Nonnull)allCacheDocumentInformation;

+ (BOOL)saveFileCache_WithIdentifer:(NSString*_Nonnull)aIdentifier
                         remote_url:(NSString*_Nullable)aRemote_url
                    cache_directory:(NSString*_Nonnull)aCache_directory
                          extention:(NSString*_Nonnull)aExtention
                         local_path:(NSString*_Nonnull)aLocal_path
                         local_name:(NSString*_Nonnull)aLocal_name
                    local_full_name:(NSString*_Nonnull)aLocal_full_name
                       display_name:(NSString*_Nonnull)aDisplay_name
                  extra_information:(NSString*_Nullable)aExtra_information;

/**
 插入消息
 */
+ (BOOL)DBInsert_KKFileCache_Information:(NSDictionary*_Nullable)aInformation;

/**
 查询消息
 */
+ (NSDictionary*_Nullable)DBQuery_KKFileCache_WithIdentifer:(NSString*_Nullable)aIdentifier;

/**
 查询消息【某个目录下】
 */
+ (NSArray*_Nullable)DBQuery_KKFileCache_WithCacheDirectory:(NSString*_Nullable)aCacheDirectory;

/**
 删除消息
 */
+ (BOOL)DBDelete_KKFileCache_WithIdentifer:(NSString*_Nullable)aIdentifier;

@end

NS_ASSUME_NONNULL_END
