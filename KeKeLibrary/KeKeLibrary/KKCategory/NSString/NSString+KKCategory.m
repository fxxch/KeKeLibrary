//
//  NSString+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSString+KKCategory.h"
#import <CommonCrypto/CommonDigest.h>
#import "AESCrypt.h"
#import "NSData+KKCategory.h"

@implementation NSString (KKCategory)

#pragma mark ==================================================
#pragma mark == 加密解密
#pragma mark ==================================================
- (nullable NSString *)md5 {
    if (!self) {
        return nil;
    }
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *outString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [outString appendFormat:@"%02x", result[i]];
    }
    return outString;
}

- (nullable NSString *)sha1 {
    if (!self) {
        return nil;
    }
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *outString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [outString appendFormat:@"%02x", digest[i]];
    }
    return outString;
}

- (nullable NSString *)base64Encoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64Encoded];
}

- (nullable NSString *)base64Decoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithData:[data base64Decoded] encoding:NSUTF8StringEncoding];
}

#pragma mark ==================================================
#pragma mark == URL处理
#pragma mark ==================================================
/**
 从GET请求的URL地址里面，解析参数的值
 
 @param aURL 需要判断的字符串
 @param paramName 参数名字
 
 @return 结果
 */
+ (nullable NSString *)getParamValueFromUrl:(nullable NSString*)aURL
                                  paramName:(nullable NSString *)paramName{
    if ([NSString isStringEmpty:aURL] ||
        [NSString isStringEmpty:paramName]) {
        return nil;
    }
    
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [aURL rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [aURL characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[aURL substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [aURL substringFromIndex:offset] :
            [aURL substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByRemovingPercentEncoding];
        }
    }
    return str;
}

- (nullable NSString *)URLEncodedString {
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //    NSString *encodedString = (NSString *)
    //    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
    //                                                              (CFStringRef)self,
    //                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
    //                                                              NULL,
    //                                                              kCFStringEncodingUTF8));
    //    return encodedString;
}

- (nullable NSString*)URLDecodedString {
    
    return [self stringByRemovingPercentEncoding];
    
    //    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
    //                                                                                                             (CFStringRef)self,
    //                                                                                                             CFSTR(""),
    //                                                                                                             kCFStringEncodingUTF8));
    //    return result;
}



#pragma mark ==================================================
#pragma mark == 日常判断
#pragma mark ==================================================
/**
 判断字符串是否为空（nil、不是字符串、去掉空格之后，长度为0 都视为空）
 
 @param string 需要判断的字符串
 @return 结果
 */
+ (BOOL)isStringNotEmpty:(nullable id)string{
    if (string && [string isKindOfClass:[NSString class]] && [[string trimLeftAndRightSpace] length]>0) {
        return YES;
    }
    else{
        return NO;
    }
}

/**
 判断字符串是否为空（nil、不是字符串、去掉空格之后，长度为0 都视为空）
 
 @param string 需要判断的字符串
 @return 结果
 */
+ (BOOL)isStringEmpty:(nullable id)string{
    return ![NSString isStringNotEmpty:string];
}


/**
 字符串的真实长度（汉字2 英文1）
 
 @return 长度
 */
- (int)realLenth{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}





/**
 判断字符串是不是URL
 
 @return 结果
 */
- (BOOL)isURL {
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", URL_EXPRESSION];
    return [urlTest evaluateWithObject:self];
}

/**
 去掉字符串里面的所有HTML标签
 
 @return 结果
 */
- (nullable NSString *)trimHTMLTag {
    
    NSString *html = [self stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"  "];
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        NSString *replaceString = [NSString stringWithFormat:@"%@>", text];
        if ([replaceString hasPrefix:@"<KK{"]) {
            continue;
        }
        else{
            html = [html stringByReplacingOccurrencesOfString:replaceString
                                                   withString:@""];
        }
    }
    return [html trimLeftAndRightSpace];
}


/**
 判断字符串是否是邮箱地址
 
 @return 结果
 */
- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 判断字符串是否是手机号码
 
 @return 结果
 */
- (BOOL)isMobilePhoneNumber {
    NSString *cellPhoneRegex = @"^(((\\+86)?)|((86)?))1(3[0-9]|4[0-9]|5[0-9]|8[0-9]|7[0-9])[-]*\\d{4}[-]*\\d{4}$";
    NSPredicate *cellPhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cellPhoneRegex];
    return [cellPhoneTest evaluateWithObject:self];
}

/**
 判断字符串是否是座机号码
 
 @return 结果
 */
- (BOOL)isTelePhoneNumber {
    NSString *phoneRegex= @"((^0(10|2[0-9]|\\d{2,3})){0,1}-{0,1}(\\d{6,8}|\\d{6,8})$)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/**
 判断字符串是否含有中文字符
 
 @return 结果
 */
- (BOOL)isHaveChineseCharacter{
    for(NSInteger i = 0; i < [self length]; i++){
        int a = [self characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

/**
 判断字符串是否是邮政编码
 
 @return 结果
 */
- (BOOL)isPostCode {
    NSString *zipCodeRegex = @"[1-9]\\d{5}$";
    NSPredicate *zipCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipCodeRegex];
    return [zipCodeTest evaluateWithObject:self];
}

//- (BOOL)isHTMLTag {
//    NSString *htmlTagRegex = @"<(S*?)[^>]*>.*?|<.*? />";
//    NSPredicate *htmlTagText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", htmlTagRegex];
//    return [htmlTagText evaluateWithObject:self];
//}


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 宽度
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)sizeWithFont:(nullable UIFont *)font
              maxWidth:(CGFloat)width
         lineBreakMode:(NSLineBreakMode)lineBreakMode{
    
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 宽度
 @return 大小
 */
- (CGSize)sizeWithFont:(nullable UIFont *)font
              maxWidth:(CGFloat)width {
    
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param size 展示区域大小
 @return 大小
 */
- (CGSize)sizeWithFont:(nullable UIFont *)font
               maxSize:(CGSize)size {
    
    return [self sizeWithFont:font maxSize:size inset:UIEdgeInsetsMake(0, 0, 0, 0) lineBreakMode:NSLineBreakByWordWrapping];
}

/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param size 展示区域大小
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)sizeWithFont:(nullable UIFont *)font
               maxSize:(CGSize)size
         lineBreakMode:(NSLineBreakMode)lineBreakMode{
    
    return [self sizeWithFont:font maxSize:size inset:UIEdgeInsetsMake(0, 0, 0, 0) lineBreakMode:lineBreakMode];
}


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 展示区域宽度
 @param inset 缩进
 @return 大小
 */
- (CGSize)sizeWithFont:(nullable UIFont *)font
              maxWidth:(CGFloat)width
                 inset:(UIEdgeInsets)inset {
    
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX) inset:inset lineBreakMode:NSLineBreakByWordWrapping];
}


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param width 展示区域宽度
 @param inset 缩进
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)sizeWithFont:(nullable UIFont *)font
              maxWidth:(CGFloat)width
                 inset:(UIEdgeInsets)inset
         lineBreakMode:(NSLineBreakMode)lineBreakMode{
    
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX) inset:inset lineBreakMode:lineBreakMode];
}


/**
 计算字符串显示需要的尺寸大小
 
 @param font 字体大小
 @param size 展示区域
 @param inset 缩进
 @param lineBreakMode 换行方式
 @return 大小
 */
- (CGSize)sizeWithFont:(nullable UIFont *)font
               maxSize:(CGSize)size
                 inset:(UIEdgeInsets)inset
         lineBreakMode:(NSLineBreakMode)lineBreakMode{
    
    if (font == nil) {
        font = [UIFont systemFontOfSize:14.0f];
    }
    CGFloat width = size.width - inset.left - inset.right;
    CGFloat height = size.height - inset.top - inset.bottom;
    
    CGSize sizeReturn;
    
    NSStringDrawingOptions options =  NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = lineBreakMode;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary* Attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
    
    CGRect rect0 = [self boundingRectWithSize:CGSizeMake(width, height) options:options attributes:Attributes2 context:nil];
    sizeReturn = CGSizeMake(ceilf(rect0.size.width), ceilf(rect0.size.height));
    
    return sizeReturn;
}

/**
 去掉字符串首尾的空格
 
 @return 结果
 */
-(nullable NSString*)trimLeftAndRightSpace{
    if (self) {
        NSString* trimed = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return trimed;
    }
    else {
        return nil;
    }
}

/**
 去掉字符串里面的所有空白（换行、制表符、中英文空格）
 
 @return 结果
 */
-(nullable NSString*)trimAllSpace{
    if (self) {
        NSString *string = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        //去掉英文空格
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        //去掉中文空格
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        //去掉其余空格
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        return string;
    }
    else {
        return nil;
    }
    
}

/**
 去掉字符串里面的所有数字
 
 @return 结果
 */
- (nullable NSString*)trimNumber{
    if (self) {
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+" options:0 error:NULL];
        NSString* resultString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
        return resultString;
    }
    else {
        return nil;
    }
}


/**
 从NSData里面转为字符串
 
 @param data data
 @return 字符串
 */
+ (nullable NSString*)stringWithData:(nullable NSData *)data{
    NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return s;
}


/**
 判定字符串 是否是整数
 
 @return 结果
 */
- (BOOL)isInteger{
    
    BOOL result = NO;
    
    if (self) {
        NSScanner* scan = [NSScanner scannerWithString:self];
        NSInteger val;
        result = [scan scanInteger:&val] && [scan isAtEnd];
    }
    
    if (result) {
        NSString *AA = [NSString stringWithFormat:@"%ld",(long)[self integerValue]];
        
        if ([AA isEqualToString:self]) {
            result = YES;
        }
        else{
            result = NO;
        }
    }
    
    return result;
}

/**
 判定字符串 是否是浮点数
 
 @return 结果
 */
- (BOOL)isFloat{
    
    NSString *clearString = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (![clearString isInteger]) {
        return NO;
    }
    else{
        NSRange stringRange = NSMakeRange(0, [self length]);
        NSRegularExpression* pointRegular = [NSRegularExpression regularExpressionWithPattern:@"[.]"
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:nil];
        NSArray *matches = [pointRegular matchesInString:self  options:NSMatchingReportCompletion range:stringRange];
        
        if ([matches count]==1) {
            return YES;
        }
        else{
            return NO;
        }
        //        for (NSTextCheckingResult *match in matches) {
        //            NSRange numberRange = [match range];
        //            [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
        //                                     value:(id)specialTextColor.CGColor
        //                                     range:numberRange];
        //        }
    }
}

/**
 将一个数字转换成中文的大写 (例如：123456 转换成： 拾贰万叁仟肆佰伍拾陆)
 
 @param aDigitalString 数字字符串
 @return 结果
 */
+ (nullable NSString*)chineseUperTextFromDigitalString:(nullable NSString*)aDigitalString{
    
    if( ![aDigitalString isInteger] && ![aDigitalString isFloat]){
        return @"";
    }
    
    
    long long digital = [aDigitalString longLongValue];
    NSArray *uperArray = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    NSString *returnString = @"";
    
    long long digitalNumber = digital;
    //仟万亿
    long long danwei1 = 1000000000000000;
    NSInteger num1 = (NSInteger)(digitalNumber/danwei1);
    if (num1>0) {
        returnString = [returnString stringByAppendingFormat:@"%@仟",[uperArray objectAtIndex:num1]];
        long long temp = num1*danwei1;
        digitalNumber = digitalNumber - temp;
    }
    //佰万亿
    long long danwei2 = 100000000000000;
    NSInteger num2 = (NSInteger)(digitalNumber/danwei2);
    if (num2>0) {
        returnString = [returnString stringByAppendingFormat:@"%@佰",[uperArray objectAtIndex:num2]];
        long long temp = num2*danwei2;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 &&
            [returnString hasSuffix:@"零"]==NO) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //拾万亿
    long long danwei3 = 10000000000000;
    NSInteger num3 = (NSInteger)(digitalNumber/danwei3);
    if (num3>0) {
        returnString = [returnString stringByAppendingFormat:@"%@拾",[uperArray objectAtIndex:num3]];
        long long temp = num3*danwei3;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 &&
            [returnString hasSuffix:@"零"]==NO) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //万亿
    long long danwei4 = 1000000000000;
    NSInteger num4 = (NSInteger)(digitalNumber/danwei4);
    if (num4>0) {
        returnString = [returnString stringByAppendingFormat:@"%@万",[uperArray objectAtIndex:num4]];
        long long temp = num4*danwei4;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"万"];
        }
    }
    
    //仟亿
    long long danwei5 = 100000000000;
    NSInteger num5 = (NSInteger)(digitalNumber/danwei5);
    if (num5>0) {
        returnString = [returnString stringByAppendingFormat:@"%@仟",[uperArray objectAtIndex:num5]];
        long long temp = num5*danwei5;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 && ([returnString hasSuffix:@"零"]==NO)) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //佰亿
    long long danwei6 = 10000000000;
    NSInteger num6 = (NSInteger)(digitalNumber/danwei6);
    if (num6>0) {
        returnString = [returnString stringByAppendingFormat:@"%@佰",[uperArray objectAtIndex:num6]];
        long long temp = num6*danwei6;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 && ([returnString hasSuffix:@"零"]==NO)) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //拾亿
    long long danwei7 = 1000000000;
    NSInteger num7 = (NSInteger)(digitalNumber/danwei7);
    if (num7>0) {
        returnString = [returnString stringByAppendingFormat:@"%@拾",[uperArray objectAtIndex:num7]];
        long long temp = num7*danwei7;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 && ([returnString hasSuffix:@"零"]==NO)) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //亿
    long long danwei8 = 100000000;
    NSInteger num8 = (NSInteger)(digitalNumber/danwei8);
    if (num8>0) {
        returnString = [returnString stringByAppendingFormat:@"%@亿",[uperArray objectAtIndex:num8]];
        long long temp = num8*danwei8;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"亿"];
        }
    }
    
    //千万
    long long danwei9 = 10000000;
    NSInteger num9 = (NSInteger)(digitalNumber/danwei9);
    if (num9>0) {
        returnString = [returnString stringByAppendingFormat:@"%@仟",[uperArray objectAtIndex:num9]];
        long long temp = num9*danwei9;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 && ([returnString hasSuffix:@"零"]==NO)) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //佰万
    long long danwei10 = 1000000;
    NSInteger num10 = (NSInteger)(digitalNumber/danwei10);
    if (num10>0) {
        returnString = [returnString stringByAppendingFormat:@"%@佰",[uperArray objectAtIndex:num10]];
        long long temp = num10*danwei10;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 && ([returnString hasSuffix:@"零"]==NO)) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //拾万
    long long danwei11 = 100000;
    NSInteger num11 = (NSInteger)(digitalNumber/danwei11);
    if (num11>0) {
        returnString = [returnString stringByAppendingFormat:@"%@拾",[uperArray objectAtIndex:num11]];
        long long temp = num11*danwei11;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 && ([returnString hasSuffix:@"零"]==NO)) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //万
    long long danwei12 = 10000;
    NSInteger num12 = (NSInteger)(digitalNumber/danwei12);
    if (num12>0) {
        returnString = [returnString stringByAppendingFormat:@"%@万",[uperArray objectAtIndex:num12]];
        long long temp = num12*danwei12;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"万"];
        }
    }
    
    //仟
    long long danwei13 = 1000;
    NSInteger num13 = (NSInteger)(digitalNumber/danwei13);
    if (num13>0) {
        returnString = [returnString stringByAppendingFormat:@"%@仟",[uperArray objectAtIndex:num13]];
        long long temp = num13*danwei13;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 && ([returnString hasSuffix:@"零"]==NO)) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //佰
    long long danwei14 = 100;
    NSInteger num14 = (NSInteger)(digitalNumber/danwei14);
    if (num14>0) {
        returnString = [returnString stringByAppendingFormat:@"%@佰",[uperArray objectAtIndex:num14]];
        long long temp = num14*danwei14;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 && ([returnString hasSuffix:@"零"]==NO)) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //拾
    long long danwei15 = 10;
    NSInteger num15 = (NSInteger)(digitalNumber/danwei15);
    if (num15>0) {
        returnString = [returnString stringByAppendingFormat:@"%@拾",[uperArray objectAtIndex:num15]];
        long long temp = num15*danwei15;
        digitalNumber = digitalNumber - temp;
    }
    else{
        if ([returnString length]>0 && ([returnString hasSuffix:@"零"]==NO)) {
            returnString = [returnString stringByAppendingFormat:@"%@",@"零"];
        }
    }
    
    //个
    NSInteger num16 = (NSInteger)(digitalNumber/1);
    if (num16>0) {
        returnString = [returnString stringByAppendingFormat:@"%@元",[uperArray objectAtIndex:num16]];
        digitalNumber = digitalNumber - num16*1;
    }
    
    if ([aDigitalString isFloat]) {
        NSArray *temarr = [aDigitalString componentsSeparatedByString:@"."];
        if ([temarr count]>1) {
            //小数点后的数值字符串
            NSString *secondStr=[NSString stringWithFormat:@"%@",temarr[1]];
            //角
            NSInteger jiao = 0;
            //分
            NSInteger fen = 0;
            if ([secondStr length]>=2) {
                jiao = [[secondStr substringWithRange:NSMakeRange(0, 1)] integerValue];
                fen  = [[secondStr substringWithRange:NSMakeRange(1, 1)] integerValue];
                
                if (jiao==0 && fen==0) {
                    returnString = [returnString stringByAppendingFormat:@"%@",@"整"];
                }
                else{
                    returnString = [returnString stringByAppendingFormat:@"%@角",[uperArray objectAtIndex:jiao]];
                    returnString = [returnString stringByAppendingFormat:@"%@分",[uperArray objectAtIndex:fen]];
                    
                    returnString = [returnString stringByAppendingFormat:@"%@",@"整"];
                }
            }
            else if ([secondStr length]==1){
                jiao = [[secondStr substringWithRange:NSMakeRange(0, 1)] integerValue];
                returnString = [returnString stringByAppendingFormat:@"%@角",[uperArray objectAtIndex:jiao]];
                
                returnString = [returnString stringByAppendingFormat:@"%@分",[uperArray objectAtIndex:fen]];
                
                returnString = [returnString stringByAppendingFormat:@"%@",@"整"];
            }
            else{
                returnString = [returnString stringByAppendingFormat:@"%@",@"整"];
            }
        }
        else{
            returnString = [returnString stringByAppendingFormat:@"%@",@"整"];
        }
    }
    else if ([aDigitalString isInteger]){
        returnString = [returnString stringByAppendingFormat:@"%@",@"整"];
    }
    else{
        returnString = @"";
    }
    return returnString;
}

/**
 计算字符串所占用的字节数大小 编码方式：NSUTF8StringEncoding （一个汉字占3字节，一个英文占1字节）
 
 @param aString aString
 @return 结果
 */
+ (NSInteger)sizeOfStringForNSUTF8StringEncoding:(nullable NSString*)aString{
    NSInteger result = 0;
    const char *tchar=[aString UTF8String];
    if (NULL == tchar) {
        return result;
    }
    result = strlen(tchar);
    return result;
}

/**
 截取字符串到制定字节大小    编码方式：NSUTF8StringEncoding
 
 @param size 需要截取的字节数
 @param string string
 @return 结果
 */
+ (nullable NSString*)subStringForNSUTF8StringEncodingWithSize:(NSInteger)size
                                                        string:(nullable NSString*)string{
    
    NSString *tempString = [NSString stringWithString:string];
    
    NSInteger tempStringSize = [NSString sizeOfStringForNSUTF8StringEncoding:tempString];
    if (tempStringSize <= size) {
        return tempString;
    }
    
    if (size>tempStringSize/2) {
        NSInteger index = [tempString length];
        while (1) {
            if ([NSString sizeOfStringForNSUTF8StringEncoding:tempString]<=size) {
                break;
            }
            else{
                index = index -1;
                tempString = [string substringWithRange:NSMakeRange(0, index)];
            }
        }
    }
    else{
        NSInteger index = 1;
        while (1) {
            tempString = [string substringWithRange:NSMakeRange(0, index)];
            if ([NSString sizeOfStringForNSUTF8StringEncoding:tempString]<size) {
                index = index + 1;
            }
            else{
                break;
            }
        }
    }
    
    return tempString;
}

/**
 计算字符串所占用的字节数大小 编码方式：NSUnicodeStringEncoding （一个汉字占2字节，一个英文占1字节）
 
 @param aString aString
 @return 结果
 */
+ (NSInteger)sizeOfStringForNSUnicodeStringEncoding:(nullable NSString*)aString{
    int strlength = 0;
    char* p = (char*)[aString cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[aString lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

/**
 截取字符串到制定字节大小    编码方式：NSUnicodeStringEncoding
 
 @param size 需要截取的字节数
 @param string string
 @return 结果
 */
+ (nullable NSString*)subStringForNSUnicodeStringEncodingWithSize:(NSInteger)size
                                                           string:(nullable NSString*)string{
    
    NSString *tempString = [NSString stringWithString:string];
    
    NSInteger tempStringSize = [NSString sizeOfStringForNSUnicodeStringEncoding:tempString];
    if (tempStringSize <= size) {
        return tempString;
    }
    
    if (size>tempStringSize/2) {
        NSInteger index = [tempString length];
        while (1) {
            if ([NSString sizeOfStringForNSUnicodeStringEncoding:tempString]<=size) {
                break;
            }
            else{
                index = index -1;
                tempString = [string substringWithRange:NSMakeRange(0, index)];
            }
        }
    }
    else{
        NSInteger index = 1;
        while (1) {
            tempString = [string substringWithRange:NSMakeRange(0, index)];
            if ([NSString sizeOfStringForNSUnicodeStringEncoding:tempString]<size) {
                index = index + 1;
            }
            else{
                break;
            }
        }
    }
    
    return tempString;
}

+ (nonnull NSString*)stringWithInteger:(NSInteger)intValue{
    return [NSString stringWithFormat:@"%ld",(long)intValue];
}

+ (nonnull NSString*)stringWithFloat:(CGFloat)floatValue{
    return [NSString stringWithFormat:@"%f",floatValue];
}

+ (nonnull NSString*)stringWithDouble:(double)doubleValue{
    return [NSString stringWithFormat:@"%lf",doubleValue];
}

+ (nonnull NSString*)stringWithBool:(BOOL)boolValue{
    return [NSString stringWithFormat:@"%ld",(long)boolValue];
}

#pragma mark ==================================================
#pragma mark == KKSafe
#pragma mark ==================================================
/****************************************  substringFromIndex:  ***********************************/
/**
 从from位置截取字符串 对应 __NSCFConstantString
 
 @param from 截取起始位置
 @return 截取的子字符串
 */
- (NSString *)substringFromIndex_Safe:(NSUInteger)from {
    if (from > self.length ) {
        return nil;
    }
    return [self substringFromIndex:from];
}


/****************************************  substringFromIndex:  ***********************************/
/**
 从开始截取到to位置的字符串  对应  __NSCFConstantString
 
 @param to 截取终点位置
 @return 返回截取的字符串
 */
- (NSString *)substringToIndex_Safe:(NSUInteger)to {
    if (to > self.length ) {
        return nil;
    }
    return [self substringToIndex:to];
}

/*********************************** rangeOfString:options:range:locale:  ***************************/
/**
 搜索指定 字符串  对应  __NSCFConstantString
 
 @param searchString 指定 字符串
 @param mask 比较模式
 @param rangeOfReceiverToSearch 搜索 范围
 @param locale 本地化
 @return 返回搜索到的字符串 范围
 */
- (NSRange)rangeOfString_Safe:(NSString *)searchString
                      options:(NSStringCompareOptions)mask
                        range:(NSRange)rangeOfReceiverToSearch
                       locale:(nullable NSLocale *)locale {
    if (!searchString) {
        searchString = self;
    }
    
    if (rangeOfReceiverToSearch.location > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if (rangeOfReceiverToSearch.length > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        rangeOfReceiverToSearch = NSMakeRange(0, self.length);
    }
    
    
    return [self rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}

/*********************************** substringWithRange:  ***************************/
/**
 截取指定范围的字符串  对应  __NSCFConstantString
 
 @param range 指定的范围
 @return 返回截取的字符串
 */
- (NSString *)substringWithRange_Safe:(NSRange)range {
    if (range.location > self.length) {
        return nil;
    }
    
    if (range.length > self.length) {
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    return [self substringWithRange:range];
}


@end
