//
//  NSMutableData+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableData (KKCategory)

/**
 当网络请求为POST方法上传文件的时候使用。参数拼接在body里面。
 其他情况，请不要用.可使用下面的：- (void) addPostKey:(NSString*)key value:(NSString*)value;
 
 @param key 参数key
 @param value 参数值
 */
- (void) kk_addPostKeyForFileUpload:(nullable NSString*)key value:(nullable NSString*)value;


/**
 当网络请求为POST方法上传文件的时候使用。文件拼接在body里面。
 其他情况，请不要用
 
 @param data 参数的值
 @param key 参数的key
 */
- (void) kk_addPostDataForFileUpload:(nullable NSData*)data forKey:(nullable NSString*)key;

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
- (void) kk_addPostKey:(nullable NSString*)key value:(nullable NSString*)value;

@end






