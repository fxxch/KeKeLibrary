//
//  KKCoreTextItem.m
//  KKLibrary
//
//  Created by liubo on 13-5-11.
//  Copyright (c) 2013年 KKLibrary. All rights reserved.
//

#import "KKCoreTextItem.h"
#import "KKCoreTextDBManager.h"
#import "NSDictionary+KKCategory.h"
#import "NSString+KKCategory.h"
#import "UIScreen+KKCategory.h"
#import "UIFont+KKCategory.h"

@implementation KKCoreTextItem

- (void)dealloc{
    self.url = nil;
    self.identifier = nil;
    self.text = nil;
    self.textColor = nil;
    self.emotionId = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    if (self) {
        NSString *a_type = [dictionary validStringForKey:KKCoreTextItemKey_type];
        NSString *a_identifier = [dictionary validStringForKey:KKCoreTextItemKey_identifier];
        NSString *a_text = [dictionary validStringForKey:KKCoreTextItemKey_text];
        NSString *a_textColor = [dictionary validStringForKey:KKCoreTextItemKey_textColor];
        NSString *a_expressionId = [dictionary validStringForKey:KKCoreTextItemKey_emotionId];
        NSString *a_url = [dictionary validStringForKey:KKCoreTextItemKey_url];
        
        if (a_type && ![a_type isEqualToString:@""]) {
            self.type = [a_type intValue];
        }
        else{
            self.type = KKCoreTextItemTypeNomal;
        }
        
        if ([NSString isStringNotEmpty:a_identifier]) {
            self.identifier = a_identifier;
        }
        else{
            self.identifier = @"";
        }
        
        if ([NSString isStringNotEmpty:a_text]) {
            self.text = a_text;
        }
        else{
            self.text = @"";
        }
        
        if ([NSString isStringNotEmpty:a_url]) {
            self.url = a_url;
        }
        else{
            self.url = @"";
        }
        
        if ([NSString isStringNotEmpty:a_textColor]) {
            self.textColor = a_textColor;
        }
        else{
            self.textColor = @"";
        }
        
        if ([NSString isStringNotEmpty:a_expressionId]) {
            self.emotionId = a_expressionId;
        }
        else{
            self.emotionId = @"";
        }
        
    }
    return self;
}

- (NSDictionary*)toDictionary{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:[NSString stringWithInteger:self.type] forKey:@"type"];

    if ([NSString isStringNotEmpty:self.identifier]) {
        [dictionary setObject:self.identifier forKey:@"identifier"];
    }
    if ([NSString isStringNotEmpty:self.url]) {
        [dictionary setObject:self.url forKey:@"url"];
    }
    if ([NSString isStringNotEmpty:self.text]) {
        [dictionary setObject:self.text forKey:@"text"];
    }
    if ([NSString isStringNotEmpty:self.textColor]) {
        [dictionary setObject:self.textColor forKey:@"textColor"];
    }
    if ([NSString isStringNotEmpty:self.emotionId]) {
        [dictionary setObject:self.emotionId forKey:@"emotionId"];
    }
    
    return dictionary;
}

- (NSString*)toKKCoreTextString{
    NSString *string = @"";
    string = [string stringByAppendingKKItem:self];
    return string;
}

@end


@implementation NSString (KKCoreTextString)

- (NSArray *)URLList {
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:URL_EXPRESSION
                                                                         options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                                           error:nil];
    NSArray *matches = [reg matchesInString:self
                                    options:NSMatchingReportProgress
                                      range:NSMakeRange(0, self.length)];
    
    NSMutableArray *URLs = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *result in matches) {
        [URLs addObject:[self substringWithRange:result.range]];
    }
    return URLs;
}

- (NSString*)stringByAppendingKKItem:(KKCoreTextItem *)item{
    
    NSString *returnString = [self stringByAppendingString:KKCoreTextItemPrefix];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (item.type<KKCoreTextItemTypeNomal || item.type>KKCoreTextItemTypeImage) {
        [dictionary setObject:@"1" forKey:KKCoreTextItemKey_type];
    }
    else{
        [dictionary setObject:[NSString stringWithFormat:@"%ld",(long)item.type] forKey:KKCoreTextItemKey_type];
    }
    
    if ([NSString isStringNotEmpty:item.identifier]) {
        [dictionary setObject:item.identifier forKey:KKCoreTextItemKey_identifier];
    }
    
    if ([NSString isStringNotEmpty:item.url]) {
        [dictionary setObject:item.url forKey:KKCoreTextItemKey_url];
    }
    
    if ([NSString isStringNotEmpty:item.textColor] ) {
        [dictionary setObject:item.textColor forKey:KKCoreTextItemKey_textColor];
    }
    
    if ([NSString isStringNotEmpty:item.emotionId] ) {
        [dictionary setObject:item.emotionId forKey:KKCoreTextItemKey_emotionId];
    }
    if ([NSString isStringNotEmpty:item.text] ) {
        [dictionary setObject:item.text forKey:KKCoreTextItemKey_text];
    }
    
    
    NSString *jsonString = [dictionary translateToJSONString];
    
    returnString = [returnString stringByAppendingString:[jsonString substringWithRange:NSMakeRange(1, [jsonString length]-2)]];
    
    returnString = [returnString stringByAppendingString:KKCoreTextItemSuffix];
    
    return returnString;
}

+ (NSString*)stringFromKKCoreTextString:(NSString*)kkCoreTextString{
    return [NSString stringFromKKCoreTextString:kkCoreTextString forDrawing:NO];
}

+ (NSString*)stringFromKKCoreTextString:(NSString*)kkCoreTextString forDrawing:(BOOL)aForDrawing{
    return [NSString praseKKCortextString:kkCoreTextString items:nil forDrawing:aForDrawing];
}


//KKCoreTextString(服务器字符串) 转换成用户看见的字符串 同时返回对应的节点数组
+ (NSString*)praseKKCortextString:(NSString*)aKKCoreTextString items:(NSMutableArray*)outPutItemsArray forDrawing:(BOOL)aForDrawing{
    return [NSString praseKKCortextString:aKKCoreTextString itemsArray:outPutItemsArray itemsDictionary:nil itemsIndexDictionary:nil forDrawing:aForDrawing];
}

/*KKCoreTextString(服务器字符串) 转换成用户看见的字符串 同时返回对应的节点数组
 aKKCoreTextString 输入的字符串
 aItemsArray 接收节点的数组
 aItemsDictionary 接收节点的字典，必然要 3-5：dic  key是3-5 说明从第三个字符开始，连续5个字符都属于这个节点 dic 里面是这个节点的信息
 aItemsIndexDictionary 节点库，每个节点包含（start、end、information）
 
 */
+ (NSString*)praseKKCortextString:(NSString*)aKKCoreTextString
                       itemsArray:(NSMutableArray*)aItemsArray
                  itemsDictionary:(NSMutableDictionary*)aItemsDictionary
             itemsIndexDictionary:(NSMutableDictionary*)aItemsIndexDictionary
                       forDrawing:(BOOL)aForDrawing{
    return [NSString praseKKCortextString:aKKCoreTextString itemsArray:aItemsArray itemsDictionary:aItemsDictionary itemsIndexDictionary:aItemsIndexDictionary forDrawing:aForDrawing needSaveToDB:YES];
}

/*KKCoreTextString(服务器字符串) 转换成用户看见的字符串 同时返回对应的节点数组
 aKKCoreTextString 输入的字符串
 aItemsArray 接收节点的数组
 aItemsDictionary 接收节点的字典，必然要 3-5：dic  key是3-5 说明从第三个字符开始，连续5个字符都属于这个节点 dic 里面是这个节点的信息
 aItemsIndexDictionary 节点库，每个节点包含（start、end、information）
 
 */
+ (NSString*)praseKKCortextString:(NSString*)aKKCoreTextString
                       itemsArray:(NSMutableArray*)aItemsArray
                  itemsDictionary:(NSMutableDictionary*)aItemsDictionary
             itemsIndexDictionary:(NSMutableDictionary*)aItemsIndexDictionary
                       forDrawing:(BOOL)aForDrawing
                     needSaveToDB:(BOOL)aNeedSaveToDB{
    
    if (!aKKCoreTextString) {
        return nil;
    }
    
    NSDictionary *dbInformation = [[KKCoreTextDBManager defaultManager] DBQuery_KKCoreText_WithCoreText:aKKCoreTextString];
    if ([NSDictionary isDictionaryNotEmpty:dbInformation]) {
//        NSString *core_text = [dbInformation validStringForKey:Table_KKCoreText_core_text       ];
        NSString *clear_text = [dbInformation validStringForKey:Table_KKCoreText_clear_text      ];
        NSString *draw_text = [dbInformation validStringForKey:Table_KKCoreText_draw_text         ];
        NSString *items_dictionary_json  = [dbInformation validStringForKey:Table_KKCoreText_items_dictionary_json ];
        NSString *items_index_dictionary_json = [dbInformation validStringForKey:Table_KKCoreText_items_index_dictionary_json];
        
        NSDictionary *items_dictionary = [NSDictionary dictionaryFromJSONString:items_dictionary_json];
        [aItemsDictionary removeAllObjects];
        if ([NSDictionary isDictionaryNotEmpty:items_dictionary]) {
            [aItemsDictionary setValuesForKeysWithDictionary:items_dictionary];
        }
        
        NSDictionary *items_index_dictionary = [NSDictionary dictionaryFromJSONString:items_index_dictionary_json];
        [aItemsIndexDictionary removeAllObjects];
        if ([NSDictionary isDictionaryNotEmpty:items_index_dictionary]) {
            [aItemsIndexDictionary setValuesForKeysWithDictionary:items_index_dictionary];
        }
        
        
        if (aItemsArray) {
            NSArray *items = [items_dictionary allValues];
            
            NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
            for (int i=0; i<[items count]; i++) {
                NSDictionary *itemDictionary = (NSDictionary*)[items objectAtIndex:i];
                KKCoreTextItem *item = [[KKCoreTextItem alloc] initWithDictionary:itemDictionary];
                if ([NSString isStringNotEmpty:item.text]) {
                    [itemDic setObject:item forKey:item.text];
                }
            }
            
            [aItemsArray addObjectsFromArray:[itemDic allValues]];
        }
        
        if (aForDrawing) {
            return draw_text;
        }
        else{
            return clear_text;
        }
    }
    else{
        NSMutableDictionary *bItemsDictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *bItemsIndexDictionary = [NSMutableDictionary dictionary];
        
        NSString *tempString = [NSString stringWithString:aKKCoreTextString];
        
        //方法二
        NSScanner *scanner = [NSScanner scannerWithString:tempString];
        NSString *kkString = nil;
        while (![scanner isAtEnd]) {
            [scanner scanUpToString:KKCoreTextItemPrefix intoString:NULL];
            [scanner scanUpToString:KKCoreTextItemSuffix intoString:&kkString];
            
            if (kkString) {
                NSString *fullKKString = [kkString stringByAppendingString:KKCoreTextItemSuffix];
                
                NSString *dicString = [fullKKString substringFromIndex:3];
                dicString = [dicString substringToIndex:[dicString length]-3];
                
                NSDictionary *dictionary = [NSDictionary dictionaryFromJSONString:dicString];
                
                if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
                    
                    NSString *type = [dictionary validStringForKey:KKCoreTextItemKey_type];
                    NSInteger textLenth = 0;
                    NSRange range = [tempString rangeOfString:fullKKString];
                    if (range.length>0) {
                        if ([type integerValue]==KKCoreTextItemTypeEmotion || [type integerValue]==KKCoreTextItemTypeImage) {
                            
                            NSString *key = [NSString stringWithFormat:@"%d-%d",(int)(range.location),1];
                            [bItemsDictionary setObject:dictionary forKey:key];
                            NSArray *arr = [key componentsSeparatedByString:@"-"];
                            NSInteger start = [[arr objectAtIndex:0] integerValue];
                            NSInteger lenth = [[arr objectAtIndex:1] integerValue];
                            for (NSInteger j=start; j<start+lenth; j++) {
                                
                                NSMutableDictionary *indexDic = [NSMutableDictionary dictionary];
                                [indexDic setObject:[NSString stringWithInteger:start] forKey:@"start"];
                                [indexDic setObject:[NSString stringWithInteger:start+lenth-1] forKey:@"end"];
                                [indexDic setObject:dictionary forKey:@"information"];
                                
                                [bItemsIndexDictionary setObject:indexDic forKey:[NSString stringWithInteger:j]];
                            }
                            
                            if (aForDrawing) {
                                tempString = [tempString stringByReplacingOccurrencesOfString:fullKKString
                                                                                   withString:KKCoreTextFixedText
                                                                                      options:NSCaseInsensitiveSearch
                                                                                        range:range];
                            }
                            else{
                                NSString *text = [dictionary validStringForKey:KKCoreTextItemKey_text];
                                
                                tempString = [tempString stringByReplacingOccurrencesOfString:fullKKString
                                                                                   withString:text
                                                                                      options:NSCaseInsensitiveSearch
                                                                                        range:range];
                            }
                        }
                        else if ([type integerValue]==KKCoreTextItemTypeLink) {
                            
//                            同事圈那边特殊处理
//                            NSString *text = [dictionary validStringForKey:KKCoreTextItemKey_text];
//                            if ([text isEqualToString:@"网页链接"]) {
//
//                                KKCoreTextItem *item = [[KKCoreTextItem alloc] init];
//                                item.type = KKCoreTextItemTypeImage;
//                                item.text = KKCoreTextLinkText;
//                                item.url = KKThemeImagePath(@"FriendChat_UrlIcon1");
//                                NSDictionary *newInformation = [NSMutableDictionary dictionary];
//                                [newInformation setValuesForKeysWithDictionary:[item toDictionary]];
//
//                                NSString *key = [NSString stringWithFormat:@"%d-%d",(int)(range.location),1];
//                                [bItemsDictionary setObject:newInformation forKey:key];
//                                NSArray *arr = [key componentsSeparatedByString:@"-"];
//                                NSInteger start = [[arr objectAtIndex:0] integerValue];
//                                NSInteger lenth = [[arr objectAtIndex:1] integerValue];
//                                for (NSInteger j=start; j<start+lenth; j++) {
//
//                                    NSMutableDictionary *indexDic = [NSMutableDictionary dictionary];
//                                    [indexDic setObject:[NSString stringWithInteger:start] forKey:@"start"];
//                                    [indexDic setObject:[NSString stringWithInteger:start+lenth-1] forKey:@"end"];
//                                    [indexDic setObject:newInformation forKey:@"information"];
//
//                                    [bItemsIndexDictionary setObject:indexDic forKey:[NSString stringWithInteger:j]];
//                                }
//
//
//                                NSString *key1 = [NSString stringWithFormat:@"%d-%d",(int)(range.location)+1,(int)[text length]];
//                                [bItemsDictionary setObject:dictionary forKey:key1];
//                                NSArray *arr1 = [key1 componentsSeparatedByString:@"-"];
//                                NSInteger start1 = [[arr1 objectAtIndex:0] integerValue];
//                                NSInteger lenth1 = [[arr1 objectAtIndex:1] integerValue];
//                                for (NSInteger j=start1; j<start1+lenth1; j++) {
//
//                                    NSMutableDictionary *indexDic = [NSMutableDictionary dictionary];
//                                    [indexDic setObject:[NSString stringWithInteger:start1] forKey:@"start"];
//                                    [indexDic setObject:[NSString stringWithInteger:start1+lenth1-1] forKey:@"end"];
//                                    [indexDic setObject:dictionary forKey:@"information"];
//
//                                    [bItemsIndexDictionary setObject:indexDic forKey:[NSString stringWithInteger:j]];
//                                }
//
//                                NSString *newText = [NSString stringWithFormat:@"%@%@",KKCoreTextLinkText,text];
//
//                                tempString = [tempString stringByReplacingOccurrencesOfString:fullKKString
//                                                                                   withString:newText
//                                                                                      options:NSCaseInsensitiveSearch
//                                                                                        range:range];
//                            }
//                            else{
//                                NSString *key = [NSString stringWithFormat:@"%d-%d",(int)(range.location),(int)[text length]];
//                                [bItemsDictionary setObject:dictionary forKey:key];
//                                NSArray *arr = [key componentsSeparatedByString:@"-"];
//                                NSInteger start = [[arr objectAtIndex:0] integerValue];
//                                NSInteger lenth = [[arr objectAtIndex:1] integerValue];
//                                for (NSInteger j=start; j<start+lenth; j++) {
//
//                                    NSMutableDictionary *indexDic = [NSMutableDictionary dictionary];
//                                    [indexDic setObject:[NSString stringWithInteger:start] forKey:@"start"];
//                                    [indexDic setObject:[NSString stringWithInteger:start+lenth-1] forKey:@"end"];
//                                    [indexDic setObject:dictionary forKey:@"information"];
//
//                                    [bItemsIndexDictionary setObject:indexDic forKey:[NSString stringWithInteger:j]];
//                                }
//
//                                tempString = [tempString stringByReplacingOccurrencesOfString:fullKKString
//                                                                                   withString:text
//                                                                                      options:NSCaseInsensitiveSearch
//                                                                                        range:range];
//                            }
                            
                            NSString *text = [dictionary validStringForKey:KKCoreTextItemKey_text];
                            NSString *key = [NSString stringWithFormat:@"%d-%d",(int)(range.location),(int)[text length]];
                            [bItemsDictionary setObject:dictionary forKey:key];
                            NSArray *arr = [key componentsSeparatedByString:@"-"];
                            NSInteger start = [[arr objectAtIndex:0] integerValue];
                            NSInteger lenth = [[arr objectAtIndex:1] integerValue];
                            for (NSInteger j=start; j<start+lenth; j++) {
                                
                                NSMutableDictionary *indexDic = [NSMutableDictionary dictionary];
                                [indexDic setObject:[NSString stringWithInteger:start] forKey:@"start"];
                                [indexDic setObject:[NSString stringWithInteger:start+lenth-1] forKey:@"end"];
                                [indexDic setObject:dictionary forKey:@"information"];
                                
                                [bItemsIndexDictionary setObject:indexDic forKey:[NSString stringWithInteger:j]];
                            }
                            
                            tempString = [tempString stringByReplacingOccurrencesOfString:fullKKString
                                                                               withString:text
                                                                                  options:NSCaseInsensitiveSearch
                                                                                    range:range];

                            
                        }
                        else if ([type integerValue]==KKCoreTextItemTypeHightLightColor) {
                            
                            NSString *text = [dictionary validStringForKey:KKCoreTextItemKey_text];
                            
                            NSString *key = [NSString stringWithFormat:@"%d-%d",(int)(range.location),(int)[text length]];
                            [bItemsDictionary setObject:dictionary forKey:key];
                            NSArray *arr = [key componentsSeparatedByString:@"-"];
                            NSInteger start = [[arr objectAtIndex:0] integerValue];
                            NSInteger lenth = [[arr objectAtIndex:1] integerValue];
                            for (NSInteger j=start; j<start+lenth; j++) {
                                
                                NSMutableDictionary *indexDic = [NSMutableDictionary dictionary];
                                [indexDic setObject:[NSString stringWithInteger:start] forKey:@"start"];
                                [indexDic setObject:[NSString stringWithInteger:start+lenth-1] forKey:@"end"];
                                [indexDic setObject:dictionary forKey:@"information"];
                                
                                [bItemsIndexDictionary setObject:indexDic forKey:[NSString stringWithInteger:j]];
                            }
                            
                            tempString = [tempString stringByReplacingOccurrencesOfString:fullKKString
                                                                               withString:text
                                                                                  options:NSCaseInsensitiveSearch
                                                                                    range:range];
                        }
                        else{
                            NSString *text = [dictionary validStringForKey:KKCoreTextItemKey_text];
                            
                            if (text && [text length]>0) {
                                textLenth = [text length];
                            }
                            
                            NSString *key = [NSString stringWithFormat:@"%d-%ld",(int)(scanner.scanLocation-kkString.length),(long)textLenth];
                            [bItemsDictionary setObject:dictionary forKey:key];
                            NSArray *arr = [key componentsSeparatedByString:@"-"];
                            NSInteger start = [[arr objectAtIndex:0] integerValue];
                            NSInteger lenth = [[arr objectAtIndex:1] integerValue];
                            for (NSInteger j=start; j<start+lenth; j++) {
                                NSMutableDictionary *indexDic = [NSMutableDictionary dictionary];
                                [indexDic setObject:[NSString stringWithInteger:start] forKey:@"start"];
                                [indexDic setObject:[NSString stringWithInteger:start+lenth-1] forKey:@"end"];
                                [indexDic setObject:dictionary forKey:@"information"];
                                
                                [bItemsIndexDictionary setObject:indexDic forKey:[NSString stringWithInteger:j]];
                            }
                            
                            tempString = [tempString stringByReplacingOccurrencesOfString:fullKKString
                                                                               withString:text
                                                                                  options:NSCaseInsensitiveSearch
                                                                                    range:range];
                        }
                    }
                }
            }
            
            kkString = nil;
        }
        
        [aItemsArray removeAllObjects];
        [aItemsDictionary removeAllObjects];
        [aItemsIndexDictionary removeAllObjects];
        
        [aItemsDictionary setValuesForKeysWithDictionary:bItemsDictionary];
        [aItemsIndexDictionary setValuesForKeysWithDictionary:bItemsIndexDictionary];
        
        
        if (aNeedSaveToDB) {
            __block NSMutableDictionary *coreTextDbInfo = [[NSMutableDictionary alloc] init];
            [coreTextDbInfo setObject:aKKCoreTextString forKey:Table_KKCoreText_core_text];
            NSString *items_dictionary_json = [aItemsDictionary translateToJSONString];
            NSString *items_index_dictionary_json = [aItemsIndexDictionary translateToJSONString];
            [coreTextDbInfo setObject:items_dictionary_json?items_dictionary_json:@"" forKey:Table_KKCoreText_items_dictionary_json];
            [coreTextDbInfo setObject:items_index_dictionary_json?items_index_dictionary_json:@"" forKey:Table_KKCoreText_items_index_dictionary_json];
            if (aForDrawing) {
                [coreTextDbInfo setObject:tempString forKey:Table_KKCoreText_draw_text];
                
                // 为了防止界面卡住，可以异步执行
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSString *clear_text = [self praseKKCortextString:aKKCoreTextString itemsArray:nil itemsDictionary:nil itemsIndexDictionary:nil forDrawing:NO needSaveToDB:NO];
                    [coreTextDbInfo setObject:clear_text forKey:Table_KKCoreText_clear_text];
                    [[KKCoreTextDBManager defaultManager] DBInsert_KKCoreText_Information:coreTextDbInfo];
                    
//#warning Compute KKCoreTextSize For IMMessage
                    NSInteger iconLeftSpace = 10;//头像左边间隙
                    NSInteger iconWidth = 38;//头像大小
                    NSInteger iconRightSpace = 10;//头像右边边间隙
                    NSInteger arrowWidth = 8;//三角形宽度
                    NSInteger messageBoxLeftSpace = 10;//文字框左边内间距
                    NSInteger messageBoxRightSpace = 10;//文字框右边内间距
                    CGFloat textWidth_Max = KKApplicationWidth-(iconLeftSpace+iconWidth+iconRightSpace)*2-arrowWidth-messageBoxLeftSpace-messageBoxRightSpace;
                    CGFloat fontWidth = [UIFont sizeOfFont:[UIFont systemFontOfSize:17]].width;
                    NSInteger maxTextCount = textWidth_Max/fontWidth;
                    CGFloat textMaxWidth = maxTextCount * fontWidth;

                    [NSString KKCoreTextStringSizeWithFont:[UIFont systemFontOfSize:17] maxWidth:textMaxWidth kkCoreTextString:aKKCoreTextString];
                });
                
            }
            else{
                [coreTextDbInfo setObject:tempString forKey:Table_KKCoreText_clear_text];
                // 为了防止界面卡住，可以异步执行
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSString *draw_text = [self praseKKCortextString:aKKCoreTextString itemsArray:nil itemsDictionary:nil itemsIndexDictionary:nil forDrawing:YES needSaveToDB:NO];
                    [coreTextDbInfo setObject:draw_text forKey:Table_KKCoreText_draw_text];
                    [[KKCoreTextDBManager defaultManager] DBInsert_KKCoreText_Information:coreTextDbInfo];
                    
//#warning Compute KKCoreTextSize For IMMessage
                    NSInteger iconLeftSpace = 10;//头像左边间隙
                    NSInteger iconWidth = 38;//头像大小
                    NSInteger iconRightSpace = 10;//头像右边边间隙
                    NSInteger arrowWidth = 8;//三角形宽度
                    NSInteger messageBoxLeftSpace = 10;//文字框左边内间距
                    NSInteger messageBoxRightSpace = 10;//文字框右边内间距
                    CGFloat textWidth_Max = KKApplicationWidth-(iconLeftSpace+iconWidth+iconRightSpace)*2-arrowWidth-messageBoxLeftSpace-messageBoxRightSpace;
                    CGFloat fontWidth = [UIFont sizeOfFont:[UIFont systemFontOfSize:17]].width;
                    NSInteger maxTextCount = textWidth_Max/fontWidth;
                    CGFloat textMaxWidth = maxTextCount * fontWidth;
                    
                    [NSString KKCoreTextStringSizeWithFont:[UIFont systemFontOfSize:17] maxWidth:textMaxWidth kkCoreTextString:aKKCoreTextString];

                    //            dispatch_async(dispatch_get_main_queue(), ^{
                    //                
                    //            });
                    
                });
            }
        }
        
        
        if (aItemsArray) {
            NSArray *items = [aItemsDictionary allValues];
            
            NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
            for (int i=0; i<[items count]; i++) {
                NSDictionary *itemDictionary = (NSDictionary*)[items objectAtIndex:i];
                KKCoreTextItem *item = [[KKCoreTextItem alloc] initWithDictionary:itemDictionary];
                if ([NSString isStringNotEmpty:item.text]) {
                    [itemDic setObject:item forKey:item.text];
                }
            }
            
            [aItemsArray addObjectsFromArray:[itemDic allValues]];
        }
        
        return tempString;
    }
}


+ (NSString*)string:(NSString*)originString insertItems:(NSArray*)kkCoreTextItems checkURL:(BOOL)shouldCheck{
    
    if (!originString) {
        return originString;
    }
    
    
    NSMutableArray *coreTextItems = [NSMutableArray arrayWithArray:kkCoreTextItems];
    
    if (shouldCheck) {
        NSArray *URLList = [originString URLList];
        if (URLList && [URLList count]>0) {
            for (int i=0; i<[URLList count]; i++) {
                NSString *url = [URLList objectAtIndex:i];
                KKCoreTextItem *item05 = [[KKCoreTextItem alloc]init];
                item05.type = KKCoreTextItemTypeLink;
                item05.identifier = @"";
                item05.url = url;
                item05.text = url;
                [coreTextItems addObject:item05];
            }
        }
    }
    
    NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
    for (int i=0; i<[coreTextItems count]; i++) {
        KKCoreTextItem *itemi = (KKCoreTextItem*)[coreTextItems objectAtIndex:i];
        [itemDic setObject:itemi forKey:itemi.text];
    }
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:[itemDic allValues]];
    
    
    NSString *returnString = [NSString stringWithString:originString];
    
    for (int i=0; i<[items count]; i++) {
        NSObject *obj = [items objectAtIndex:i];
        if ([obj isKindOfClass:[KKCoreTextItem class]]) {
            KKCoreTextItem *item = (KKCoreTextItem*)obj;
            NSString *string = @"";
            string = [string stringByAppendingKKItem:item];
            returnString = [returnString stringByReplacingOccurrencesOfString:item.text withString:string];
        }
    }
    return returnString;
}

+ (CGSize)KKCoreTextStringSizeWithFont:(UIFont*)font  maxWidth:(CGFloat)maxWidth kkCoreTextString:(NSString*)kkCoreTextString{
    return [NSString KKCoreTextStringSizeWithFont:font maxWidth:maxWidth rowSeparatorHeight:0 emotionSize:CGSizeZero kkCoreTextString:kkCoreTextString];
}

+ (CGSize)KKCoreTextStringSizeWithFont:(UIFont*)font maxWidth:(CGFloat)maxWidth rowSeparatorHeight:(CGFloat)rowSeparatorHeight emotionSize:(CGSize)size kkCoreTextString:(NSString*)kkCoreTextString{
    
    NSString *fontDescription = [font description];
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"<UICTFont.*?>"
                                                                           options:0
                                                                             error:&error];
    NSString* result = [regex stringByReplacingMatchesInString:fontDescription
                                                       options:0
                                                         range:NSMakeRange(0,fontDescription.length)
                                                  withTemplate:@""];

    NSMutableDictionary *sizeInformation = [NSMutableDictionary dictionary];
    [sizeInformation setObject:result?result:@"" forKey:Table_KKCoreTextSize_font_description];
    [sizeInformation setObject:kkCoreTextString?kkCoreTextString:@"" forKey:Table_KKCoreTextSize_core_text];

    NSString *maxWidthString  = [NSString stringWithFormat:@"%ld",(long)(floorf(maxWidth))];
    [sizeInformation setObject:maxWidthString?maxWidthString:@"" forKey:Table_KKCoreTextSize_maxwidth];

    NSString *rowSeparatorHeightString  = [NSString stringWithFormat:@"%ld",(long)(ceilf(rowSeparatorHeight))];
    [sizeInformation setObject:rowSeparatorHeightString?rowSeparatorHeightString:@"" forKey:Table_KKCoreTextSize_row_separator_height];

    NSString *emotionSizeString = NSStringFromCGSize(size);
    [sizeInformation setObject:emotionSizeString?emotionSizeString:@"" forKey:Table_KKCoreTextSize_emotion_size];

    NSDictionary *dbInformation = [[KKCoreTextDBManager defaultManager] DBQuery_KKCoreTextSize_WithInformation:sizeInformation];
    if ([NSDictionary isDictionaryNotEmpty:dbInformation]) {
        NSString *realSizeString = [dbInformation validStringForKey:Table_KKCoreTextSize_real_size];
        CGSize size = CGSizeFromString(realSizeString);
        return size;
    }
    else{
        NSMutableDictionary *itemsDictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *_itemsIndexDictionary = [NSMutableDictionary dictionary];//所有的item index
        NSString *kkString = [NSString stringWithString:kkCoreTextString?kkCoreTextString:@""];
        
        NSString *_clearText = [NSString praseKKCortextString:kkString itemsArray:nil itemsDictionary:itemsDictionary itemsIndexDictionary:_itemsIndexDictionary forDrawing:YES];
        
        
        CGFloat upX=0;
        CGFloat upY=0;
        CGFloat returnWidth = 0;
        NSString *stringWO = @"我";
        CGSize fontSize = [stringWO sizeWithFont:font maxSize:CGSizeMake(300, 300)];
        
        for (int i=0; i<[_clearText length]; ) {
            
            NSDictionary *pointInfo = [_itemsIndexDictionary objectForKey:[NSString stringWithInteger:i]];
            //是节点
            if (pointInfo) {
                NSDictionary *itemInformation = [pointInfo objectForKey:@"information"];
                NSInteger itemType = [[itemInformation validStringForKey:KKCoreTextItemKey_type] integerValue];
                //表情
                if (itemType==KKCoreTextItemTypeEmotion) {
                    if (maxWidth - upX < fontSize.height){
                        upY = upY + fontSize.height + rowSeparatorHeight;
                        upX = 0;
                    }
                    upX = upX+fontSize.height;
                }
                //图片
                else if (itemType==KKCoreTextItemTypeImage) {
                    if (maxWidth - upX < fontSize.height){
                        upY = upY + fontSize.height + rowSeparatorHeight;
                        upX = 0;
                    }
                    
                    upX = upX+fontSize.height;
                }
                //超链接
                else if (itemType==KKCoreTextItemTypeLink){
                    NSString *text = [_clearText substringWithRange:NSMakeRange(i,1)];
                    CGSize textSize = [text sizeWithFont:font maxWidth:100];
                    
                    if (maxWidth - upX < textSize.width){
                        upY = upY + MAX(fontSize.height, textSize.height) + rowSeparatorHeight;
                        upX = 0;
                    }
                    upX = upX+textSize.width;
                }
                //高亮文字
                else if (itemType==KKCoreTextItemTypeHightLightColor){
                    NSString *text = [_clearText substringWithRange:NSMakeRange(i,1)];
                    CGSize textSize = [text sizeWithFont:font maxWidth:100];
                    
                    if (maxWidth - upX < textSize.width){
                        upY = upY + MAX(fontSize.height, textSize.height) + rowSeparatorHeight;
                        upX = 0;
                    }
                    upX = upX+textSize.width;
                }
                else{}
                
                returnWidth = MAX(upX, returnWidth);
                
                i = i + 1;
            }
            //普通文字
            else{
                NSRange range = [_clearText rangeOfComposedCharacterSequenceAtIndex:i];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_clearText];
                NSString *text = [[attrString attributedSubstringFromRange:range] string];
                
                if ([text isEqualToString:@""]) {
                    text = [_clearText substringWithRange:NSMakeRange(i,1)];
                }
                
                if ([text isEqualToString:@"\n"]){
                    CGSize textSize = [UIFont sizeOfFont:font];
                    upY = upY + MAX(fontSize.height, textSize.height) + rowSeparatorHeight;
                    upX = 0;
                }
                else{
                    CGSize textSize = [text sizeWithFont:font maxWidth:100];
                    
                    if (maxWidth - upX < textSize.width){
                        upY = upY + MAX(fontSize.height, textSize.height) + rowSeparatorHeight;
                        upX = 0;
                    }
                    
                    upX = upX+textSize.width;
                    
                    returnWidth = MAX(upX, returnWidth);
                }
                
                i = i + (int)[text length];
            }
        }
        
        CGSize resultSize = CGSizeMake(returnWidth+1, upY + fontSize.height + rowSeparatorHeight);
        [sizeInformation setObject:NSStringFromCGSize(resultSize) forKey:Table_KKCoreTextSize_real_size];
        [[KKCoreTextDBManager defaultManager] DBInsert_KKCoreTextSize_Information:sizeInformation];
        return resultSize;
    }
}


//判断是否是系统表情

+ (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     
     {
         
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff)
             
         {
             
             if (substring.length > 1)
                 
             {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                     
                 {
                     
                     returnValue = YES;
                     
                 }
                 
             }
             
         }
         
         else if (substring.length > 1)
             
         {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
         }
         
         else
             
         {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
             else if (0x2B05 <= hs && hs <= 0x2b07)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
             else if (0x2934 <= hs && hs <= 0x2935)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
             else if (0x3297 <= hs && hs <= 0x3299)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
                 
             {
                 
                 returnValue = YES;
                 
             }
             
         }
         
     }];
    
    return returnValue;
    
}


@end



