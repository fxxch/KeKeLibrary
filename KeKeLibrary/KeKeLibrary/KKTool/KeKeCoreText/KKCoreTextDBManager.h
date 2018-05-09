//
//  KKCoreTextDBManager.h
//  CEDongLi
//
//  Created by liubo on 16/8/4.
//  Copyright © 2016年 KeKeStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KKCoreText_DBName @"KKCoreText.sqlite"

#define TableName_KKCoreText @"KKCoreText"
#pragma mark ==================================================
#pragma mark == KKCoreText
#pragma mark ==================================================
#define Table_KKCoreText_id                          @"id"                         //自增字段
#define Table_KKCoreText_core_text                   @"core_text"                  //原始字符串
#define Table_KKCoreText_clear_text                  @"clear_text"                 //清除格式之后的copy字符串
#define Table_KKCoreText_draw_text                   @"draw_text"                  //描绘的时候的字符串
#define Table_KKCoreText_items_dictionary_json       @"items_dictionary_json"      //
#define Table_KKCoreText_items_index_dictionary_json @"items_index_dictionary_json"//

#define TableName_IMText @"IMText"
#pragma mark ==================================================
#pragma mark == IMText
#pragma mark ==================================================
#define Table_IMText_id                          @"id"                         //自增字段
#define Table_IMText_core_text                   @"core_text"                  //原始字符串
#define Table_IMText_clear_text                  @"clear_text"                 //清除格式之后的copy字符串

#define TableName_KKCoreTextSize @"KKCoreTextSize"
#pragma mark ==================================================
#pragma mark == KKCoreTextSize
#pragma mark ==================================================
#define Table_KKCoreTextSize_id                          @"id"                         //自增字段
#define Table_KKCoreTextSize_core_text                   @"core_text"                  //原始字符串
#define Table_KKCoreTextSize_font_description            @"font_description"           //字体描述
#define Table_KKCoreTextSize_maxwidth                    @"maxwidth"                   //最大宽度
#define Table_KKCoreTextSize_row_separator_height        @"row_separator_height"       //行间距
#define Table_KKCoreTextSize_emotion_size                @"emotion_size"               //表情大小
#define Table_KKCoreTextSize_real_size                   @"real_size"                  //实际显示需要的大小（计算结果的大小）

@interface KKCoreTextDBManager : NSObject

+ (KKCoreTextDBManager *)defaultManager;

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

#pragma mark ==================================================
#pragma mark == 消息记录 KKCoreText
#pragma mark ==================================================
/**
 插入消息
 */
- (BOOL)DBInsert_KKCoreText_Information:(NSDictionary*)aInformation;

/**
 查询消息
 */
- (NSDictionary*)DBQuery_KKCoreText_WithCoreText:(NSString*)aCoreText;

#pragma mark ==================================================
#pragma mark == IMText
#pragma mark ==================================================
/**
 插入消息
 */
- (BOOL)DBInsert_IMText_Information:(NSDictionary*)aInformation;

/**
 查询消息
 */
- (NSDictionary*)DBQuery_IMText_WithIMText:(NSString*)aIMText;

#pragma mark ==================================================
#pragma mark == KKCoreTextSize
#pragma mark ==================================================
/**
 插入消息
 */
- (BOOL)DBInsert_KKCoreTextSize_Information:(NSDictionary*)aInformation;

/**
 查询消息
 */
- (NSDictionary*)DBQuery_KKCoreTextSize_WithInformation:(NSDictionary*)aInformation;

@end
