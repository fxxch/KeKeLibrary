//
//  KKRequestParam.h
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define HTTPMethod_POST    @"POST"
#define HTTPMethod_GET     @"GET"

@class KKUploadDataObject;

@interface KKRequestParam : NSObject

@property (nonatomic, strong) NSMutableDictionary   *requestHeaderDic;//请求的头部
@property (nonatomic, strong) NSMutableDictionary   *postFilesPathDic;//发送的文件
@property (nonatomic, strong) NSMutableDictionary   *postParamDic;//请求的参数
@property (nonatomic, strong) NSMutableDictionary   *postDataDic;//请求的body数据
@property (nonatomic, strong) NSMutableData         *postData;//请求的body数据

@property (nonatomic, copy)   NSString              *urlString;//请求的URL
@property (nonatomic, copy)   NSString              *identifier;//网络请求标识符
@property (nonatomic, copy)   NSString              *method;//请求方式
@property (nonatomic, assign) NSTimeInterval        timeout;//超时设置
//是否需要进行参数加密（AESCrypt）
@property (nonatomic, copy) NSString              *encryptPassword;

- (NSString *)paramStringOfGet;
- (NSDictionary *)paramOfPost;

//添加头部信息
- (void)addRequestHeader:(NSString *)key withValue:(id)value;
//添加发送文件
- (void)addFile:(NSString *)filePath forKey:(NSString *)fileKey;
//添加请求参数
- (void)addParam:(NSString *)key withValue:(id)value;
- (void)addParams:(NSDictionary *)aParamsDictionary;
//请求的body数据
- (void)addPostData:(NSData *)data forKey:(NSString *)aKey;
//请求的body数据
- (void)addPostData:(NSData *)data;


@end
