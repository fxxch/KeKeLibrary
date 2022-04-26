//
//  NSMutableData+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSMutableData+KKCategory.h"
#import "NSString+KKCategory.h"

#define NSMutableURLRequest_Boundary @"KKStudio"

@implementation NSMutableData (KKCategory)

/**
 当网络请求为POST方法上传文件的时候使用。参数拼接在body里面。
 其他情况，请不要用.可使用下面的：- (void) addPostKey:(NSString*)key value:(NSString*)value;
 
 @param key 参数key
 @param value 参数值
 */
- (void) kk_addPostKeyForFileUpload:(nullable NSString*)key value:(nullable NSString*)value{
    
    if (!value && ![value isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (!key && ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    //分界线 --
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",NSMutableURLRequest_Boundary];
    
    //添加分界线，换行
    NSString *spaceLine = [NSString stringWithFormat:@"%@\r\n",MPboundary];
    [self appendData:[spaceLine dataUsingEncoding:NSUTF8StringEncoding]];
    //添加字段名称，换行
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",key];
    [self appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
    //添加字段的值
    NSString *valueString = [NSString stringWithFormat:@"\r\n%@\r\n",value];
    
    [self appendData:[valueString dataUsingEncoding:NSUTF8StringEncoding]];
}


/**
 当网络请求为POST方法上传文件的时候使用。文件拼接在body里面。
 其他情况，请不要用
 
 @param data 参数的值
 @param key 参数的key
 */
- (void) kk_addPostDataForFileUpload:(nullable NSData*)data forKey:(nullable NSString*)key{
    if (!data && ![data isKindOfClass:[NSData class]]) {
        return;
    }
    
    if (!key && ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    //  设置头部
    NSData *leadingData = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"image.png\";\r\n Content-Type: image/png\r\n\r\n",NSMutableURLRequest_Boundary, key] dataUsingEncoding:NSUTF8StringEncoding];
    
    [self appendData:leadingData];
    
    //  数据
    [self appendData:[NSData dataWithData:data]];
    
    //  设置尾部
    NSData *trailingData = [[NSString stringWithFormat:@"\r\n--%@--\r\n", NSMutableURLRequest_Boundary] dataUsingEncoding:NSUTF8StringEncoding];
    [self appendData:trailingData];
}

/**
 当网络请求不是上传文件的时候使用。文件拼接在body里面。
 其他情况，请不要用。可使用上面的：- (void) addPostKeyForFileUpload:(NSString*)key value:(NSString*)value;
 */

/**
 当网络请求不是上传文件的时候使用。文件拼接在body里面。
 其他情况，请不要用。可使用上面的：- (void) addPostKeyForFileUpload:(NSString*)key value:(NSString*)value;
 
 @param key 参数的key
 @param value 参数的值
 */
- (void) kk_addPostKey:(nullable NSString*)key value:(nullable NSString*)value{
    if (!value && ![value isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (!key && ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSString *string = [[NSString alloc]initWithData:self encoding:NSUTF8StringEncoding];
    if ([string length]>0) {
        [self appendData:[[NSString stringWithFormat:@"&%@=%@",[key kk_KKURLEncodedString],[value kk_KKURLEncodedString]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else{
        [self appendData:[[NSString stringWithFormat:@"%@=%@",[key kk_KKURLEncodedString],[value kk_KKURLEncodedString]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

@end
