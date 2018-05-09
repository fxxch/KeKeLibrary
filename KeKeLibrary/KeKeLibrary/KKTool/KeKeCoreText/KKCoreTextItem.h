//
//  KKCoreTextItem.h
//  KKLibrary
//
//  Created by liubo on 13-5-11.
//  Copyright (c) 2013年 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KKCoreTextItemKey_type         @"type"
#define KKCoreTextItemKey_identifier   @"identifier"
#define KKCoreTextItemKey_url          @"url"
#define KKCoreTextItemKey_text         @"text"//如果是表情，就传表情图片路径
#define KKCoreTextItemKey_textColor    @"textColor"
#define KKCoreTextItemKey_emotionId    @"emotionId"


//#define KKCoreTextItemRegularExpression @"<KK.*?KK>"
#define KKCoreTextItemPrefix @"<KK{"  //开始标志
#define KKCoreTextItemSuffix @"}KK>"  //结束标志

#define KKCoreTextFixedText @"爩"     //占位符
#define KKCoreTextLinkText @"虋"     //网页链接 图标 占位符

/*
 龘靐齉齾龗麤鱻爩龖吁
 灪麣鸾鹂鲡驫饢籱癵爨
 滟厵麷鸜郁骊钃讟虋纞
 龞齽齼鼺黸麢鹳鹦鸙鸘
 */

typedef enum{
    KKCoreTextItemTypeNomal = 1,//普通文字
    KKCoreTextItemTypeLink = 2,//超链接
    KKCoreTextItemTypeHightLightColor = 3,//高亮文字
    KKCoreTextItemTypeEmotion = 4,//表情
    KKCoreTextItemTypeImage = 5,//图片
}KKCoreTextItemType;

@interface KKCoreTextItem : NSObject

@property(nonatomic,assign)KKCoreTextItemType type;
@property(nonatomic,copy)NSString *identifier;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *textColor;
@property(nonatomic,copy)NSString *emotionId;


- (id)initWithDictionary:(NSDictionary*)dictionary;
- (NSString*)toKKCoreTextString;
- (NSDictionary*)toDictionary;

@end

@interface NSString (KKCoreTextString)

- (NSArray *)URLList;

- (NSString*)stringByAppendingKKItem:(KKCoreTextItem *)item;

+ (NSString*)stringFromKKCoreTextString:(NSString*)kkCoreTextString;

//KKCoreTextString(服务器字符串) 转换成用户看见的字符串
+ (NSString*)stringFromKKCoreTextString:(NSString*)kkCoreTextString forDrawing:(BOOL)aForDrawing;

//KKCoreTextString(服务器字符串) 转换成用户看见的字符串 同时返回对应的节点数组
+ (NSString*)praseKKCortextString:(NSString*)kkCoreTextString items:(NSMutableArray*)outPutItemsArray forDrawing:(BOOL)aForDrawing;

/*KKCoreTextString(服务器字符串) 转换成用户看见的字符串 同时返回对应的节点数组
 aKKCoreTextString 输入的字符串
 aItemsArray 接收节点的数组
 aItemsDictionary 接收节点的字典，必然要 3-5：dic  key是3-5 说明从第三个字符开始，连续5个字符都属于这个节点 dic 里面是这个节点的信息
 aItemsIndexArray
 aForDrawing YES 表情和图片会被解析成一个特殊字符 NO 表情和图片被解析成text
 */
+ (NSString*)praseKKCortextString:(NSString*)aKKCoreTextString
                       itemsArray:(NSMutableArray*)aItemsArray
                  itemsDictionary:(NSMutableDictionary*)aItemsDictionary
             itemsIndexDictionary:(NSMutableDictionary*)aItemsIndexDictionary
                       forDrawing:(BOOL)aForDrawing;

+ (NSString*)string:(NSString*)originString insertItems:(NSArray*)kkCoreTextItems checkURL:(BOOL)shouldCheck;

+ (CGSize)KKCoreTextStringSizeWithFont:(UIFont*)font maxWidth:(CGFloat)maxWidth kkCoreTextString:(NSString*)kkCoreTextString;

+ (CGSize)KKCoreTextStringSizeWithFont:(UIFont*)font maxWidth:(CGFloat)maxWidth rowSeparatorHeight:(CGFloat)rowSeparatorHeight emotionSize:(CGSize)size kkCoreTextString:(NSString*)kkCoreTextString;

+ (BOOL)stringContainsEmoji:(NSString *)string;


@end

