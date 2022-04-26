//
//  NSString+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define URL_EXPRESSION_All [NSString kk_URL_RegularExpression_All]
#define URL_EXPRESSION_URL_Tail @"[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"
#define URL_EXPRESSION_URL_Protocol @"([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://|[wW]{3}.|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)"
#define URL_EXPRESSION_URL_IP  @"((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})(\\.((2(5[0-5]|[0-4]\\d))|[0-1]?\\d{1,2})){3})"

#define URL_EXPRESSION_Email  @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

/* 刘波 匹配http*/
//#define URL_EXPRESSION @"[hH][tT][tT][pP][sS]?://[a-zA-Z0-9+\\-*/`!@#$%^&()_~,.?<>:;\"\'\\[\\]\\{\\}_=|€£¥•‰]*"

/* 刘波 匹配http、www.*/
//#define URL_EXPRESSION @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

/* 刘波 匹配http、www.、sina.com */
//#define URL_EXPRESSION @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

/* 刘波 最佳匹配 */
//#define URL_EXPRESSION @"([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://|[wW]{3}.|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]"

/* 刘波 最佳匹配 多一个 sina.com格式匹配 */
#define URL_EXPRESSION_URL @"^(?=^.{3,255}$)(([hH][tT]{2}[pP][sS]?://)|([fF][tT][pP]://))?(www\\.)?[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(:\\d+)*([-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|])*$"
//#define URL_EXPRESSION_URL @"(([hH][tT]{2}[pP]://|[hH][tT]{2}[pP][sS]://|[wW]{3}.|[wW][aA][pP].|[fF][tT][pP].|[fF][iI][lL][eE].)[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|])|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z0-9]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
//#define URL_EXPRESSION_URL @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))"

/* 杨峰 */
//#define URL_EXPRESSION @"((https?|ftp|gopher|telnet|file|notes|ms-help):((//)|(\\\\))+[\\w\\d:#@%/;$()~_?\\+-=\\\\.&]*"

/* 新浪 */
//#define URL_EXPRESSION @"([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])"

@interface NSString (KKCategory)

#pragma mark ==================================================
#pragma mark == 加密解密
#pragma mark ==================================================
- (nullable NSString *)kk_md5;

- (nullable NSString *)kk_sha1;

- (nullable NSString *)kk_base64Encoded;

- (nullable NSString *)kk_base64Decoded;

#pragma mark ==================================================
#pragma mark == URL处理
#pragma mark ==================================================
/**
 从GET请求的URL地址里面，解析参数的值
 
 @param aURL 需要判断的字符串
 @param paramName 参数名字
 
 @return 结果
 */
+ (nullable NSString *)kk_getParamValueFromUrl:(nullable NSString*)aURL
                                     paramName:(nullable NSString *)paramName;

- (nullable NSString *)kk_KKURLEncodedString;

- (nullable NSString*)kk_KKURLDecodedString;

+ (nullable NSString*)kk_URL_RegularExpression_All;

- (NSArray *_Nonnull)kk_URLList;

#pragma mark ==================================================
#pragma mark == 日常判断
#pragma mark ==================================================
/**
 判断字符串是否为空（nil、不是字符串、去掉空格之后，长度为0 都视为空）
 
 @param string 需要判断的字符串
 @return 结果
 */
+ (BOOL)kk_isStringNotEmpty:(nullable id)string;

/**
 判断字符串是否为空（nil、不是字符串、去掉空格之后，长度为0 都视为空）
 
 @param string 需要判断的字符串
 @return 结果
 */
+ (BOOL)kk_isStringEmpty:(nullable id)string;

/** 判断字符串是不是一个本地文件路径格式
 @param string 需要判断的字符串
 @return 结果
 */
+ (BOOL)kk_isLocalFilePath:(nullable id)string;

/**
 字符串的真实长度（汉字2 英文1）
 
 @return 长度
 */
- (int)kk_realLenth;

/**
 判断字符串是不是URL
 
 @return 结果
 */
- (BOOL)kk_isURL;

/**
 去掉字符串里面的所有HTML标签
 
 @return 结果
 */
- (nullable NSString *)kk_trimHTMLTag;

/**
 隐藏手机号中间4位

 @return 。。。
 */
- (NSString *_Nonnull)kk_hiddenPhoneNum;

/**
 判断字符串是否是邮箱地址
 
 @return 结果
 */
- (BOOL)kk_isEmail;

/**
 判断字符串是否是手机号码
 
 @return 结果
 */
- (BOOL)kk_isMobilePhoneNumber;

/**
 判断字符串是否是座机号码
 
 @return 结果
 */
- (BOOL)kk_isTelePhoneNumber;

/**
 判断字符串是否含有中文字符
 
 @return 结果
 */
- (BOOL)kk_isHaveChineseCharacter;

/**
 判断字符串是否是邮政编码
 
 @return 结果
 */
- (BOOL)kk_isPostCode;

/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 宽度
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)kk_sizeWithFont:(nullable UIFont *)font
                 maxWidth:(CGFloat)width
            lineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 宽度
 @return 大小
 */
- (CGSize)kk_sizeWithFont:(nullable UIFont *)font
                 maxWidth:(CGFloat)width;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param size 展示区域大小
 @return 大小
 */
- (CGSize)kk_sizeWithFont:(nullable UIFont *)font
                  maxSize:(CGSize)size;

/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param size 展示区域大小
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)kk_sizeWithFont:(nullable UIFont *)font
                  maxSize:(CGSize)size
            lineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 展示区域宽度
 @param inset 缩进
 @return 大小
 */
- (CGSize)kk_sizeWithFont:(nullable UIFont *)font
                 maxWidth:(CGFloat)width
                    inset:(UIEdgeInsets)inset;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 展示区域宽度
 @param inset 缩进
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)kk_sizeWithFont:(nullable UIFont *)font
                 maxWidth:(CGFloat)width inset:(UIEdgeInsets)inset
            lineBreakMode:(NSLineBreakMode)lineBreakMode;


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param size 展示区域
 @param inset 缩进
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)kk_sizeWithFont:(nullable UIFont *)font
                  maxSize:(CGSize)size
                    inset:(UIEdgeInsets)inset
            lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 去掉字符串首尾的空格
 
 @return 结果
 */
-(nullable NSString*)kk_trimLeftAndRightSpace;

/**
 去掉字符串里面的所有空白（换行、制表符、中英文空格）
 
 @return 结果
 */
-(nullable NSString*)kk_trimAllSpace;

/**
 去掉字符串里面的所有数字
 
 @return 结果
 */
- (nullable NSString*)kk_trimNumber;


/**
 从NSData里面转为字符串
 
 @param data data
 @return 字符串
 */
+ (nullable NSString*)kk_stringWithData:(nullable NSData *)data;

/**
 判定字符串 是否是整数
 
 @return 结果
 */
- (BOOL)kk_isInteger;

/**
 判定字符串 是否是浮点数
 
 @return 结果
 */
- (BOOL)kk_isFloat;

/**
 判定字符串 是否是几位小数的浮点数
 
 @param aDigits 小数位数
 @return 结果
 */
- (BOOL)kk_isMathematicalNumbers_withDecimal:(NSInteger)aDigits;

/**
 将一个数字转换成中文的大写 (例如：123456 转换成： 拾贰万叁仟肆佰伍拾陆)
 
 @param aDigitalString 数字字符串
 @return 结果
 */
+ (nullable NSString*)kk_chineseUperTextFromDigitalString:(nullable NSString*)aDigitalString;

/**
 计算字符串所占用的字节数大小 编码方式：NSUTF8StringEncoding （一个汉字占3字节，一个英文占1字节）
 
 @param aString aString
 @return 结果
 */
+ (NSInteger)kk_sizeOfStringForNSUTF8StringEncoding:(nullable NSString*)aString;

/**
 截取字符串到制定字节大小    编码方式：NSUTF8StringEncoding
 
 @param size 需要截取的字节数
 @param string string
 @return 结果
 */
+ (nullable NSString*)kk_subStringForNSUTF8StringEncodingWithSize:(NSInteger)size string:(nullable NSString*)string;

/**
 计算字符串所占用的字节数大小 编码方式：NSUnicodeStringEncoding （一个汉字占2字节，一个英文占1字节）
 
 @param aString aString
 @return 结果
 */
+ (NSInteger)kk_sizeOfStringForNSUnicodeStringEncoding:(nullable NSString*)aString;

/**
 截取字符串到制定字节大小    编码方式：NSUnicodeStringEncoding
 
 @param size 需要截取的字节数
 @param string string
 @return 结果
 */
+ (nullable NSString*)kk_subStringForNSUnicodeStringEncodingWithSize:(NSInteger)size
                                                           string:(nullable NSString*)string;

+ (nonnull NSString*)kk_stringWithInteger:(NSInteger)intValue;

+ (nonnull NSString*)kk_stringWithFloat:(CGFloat)floatValue;

+ (nonnull NSString*)kk_stringWithDouble:(double)doubleValue;

+ (nonnull NSString*)kk_stringWithBool:(BOOL)boolValue;

#pragma mark ==================================================
#pragma mark == 随机字符串
#pragma mark ==================================================
/* 随机生成字符串(由大小写字母、数字组成) */
+ (NSString *_Nonnull)kk_randomString:(NSInteger)length;

/* 随机生成字符串(由大小写字母组成) */
+ (NSString *_Nonnull)kk_randomStringWithoutNumber:(NSInteger)length;

#pragma mark ==================================================
#pragma mark == KKSafe
#pragma mark ==================================================
/****************************************  substringFromIndex:  ***********************************/
/**
 从from位置截取字符串 对应 __NSCFConstantString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *_Nullable)kk_substringFromIndex_Safe:(NSUInteger)from;

/****************************************  substringFromIndex:  ***********************************/
/**
 从开始截取到to位置的字符串  对应  __NSCFConstantString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *_Nullable)kk_substringToIndex_Safe:(NSUInteger)to;

/*********************************** rangeOfString:options:range:locale:  ***************************/
/**
 搜索指定 字符串  对应  __NSCFConstantString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)kk_rangeOfString_Safe:(NSString *_Nullable)searchString
                         options:(NSStringCompareOptions)mask
                           range:(NSRange)rangeOfReceiverToSearch
                          locale:(nullable NSLocale *)locale;

/*********************************** substringWithRange:  ***************************/
/**
 截取指定范围的字符串  对应  __NSCFConstantString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *_Nullable)kk_substringWithRange_Safe:(NSRange)range;

#pragma mark ==================================================
#pragma mark == 文件路径相关
#pragma mark ==================================================
- (NSString*_Nullable)kk_fileNameWithOutExtention;

@end
