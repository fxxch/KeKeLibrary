//
//  KKFormRequest.m
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKFormRequest.h"
#import "KKRequestParam.h"
#import "KKRequestManager.h"

#import "AFNetworking.h"
#import "AFHTTPSessionManager+KKExtention.h"
#import "KKCategory.h"
#import "AESCrypt.h"
#import "KeKeLibraryDefine.h"

typedef NS_ENUM(NSInteger,NetworkFrameworkType) {
    
    NetworkFrameworkType_AFNetworing=0,
    
    NetworkFrameworkType_ASIHttprequest=1,
};

@implementation KKFormRequest

#pragma mark ==================================================
#pragma mark == 外部接口
#pragma mark ==================================================
- (void)startRequest:(NSString *)aIdentifier
               param:(KKRequestParam *)param
       requestSender:(KKRequestSender *)aRequestSender{

    //调用AFNetworing框架
    [self startAFNRequest:aIdentifier param:param requestSender:aRequestSender];

    //调用ASIHttprequest框架
//    [self startASIRequest:aIdentifier param:param requestSender:aRequestSender];

}

- (void)setRequestIdentifier:(NSString *)aIdentifier
                       param:(KKRequestParam *)param
               requestSender:(KKRequestSender*)aRequestSender{
    self.requestSender = aRequestSender;
    self.identifier = aIdentifier;
    self.requestParam = param;
}

- (void)clearDelegatesAndCancel{
    
}

#pragma mark ==================================================
#pragma mark == 网络请求方式
#pragma mark ==================================================
/**
 调用AFNetworing框架

 @param aIdentifier 网络请求标识符
 @param param 网络请求参数
 @param aRequestSender 网络请求发送器
 */
- (void)startAFNRequest:(NSString *)aIdentifier
                  param:(KKRequestParam *)param
          requestSender:(KKRequestSender *)aRequestSender{
    
    self.requestSender = aRequestSender;
    self.identifier = aIdentifier;
    self.requestParam = param;
        
#ifdef DEBUG
    if (KKFormRequest_IsOpenLog) {
        NSLog(@"网络接口【%@】: %@",[self.requestParam method],self.requestParam.urlString);
    }
    
    if (self.requestParam.postParamDic) {
        if (KKFormRequest_IsOpenLog) {
            NSLog(@"网络POST参数: %@",self.requestParam.postParamDic);
        }
    }
    if (self.requestParam.postFilesPathDic) {
        if (KKFormRequest_IsOpenLog) {
            NSLog(@"网络POST文件: %@",self.requestParam.postFilesPathDic);
        }
    }
    if (self.requestParam.requestHeaderDic) {
        if (KKFormRequest_IsOpenLog) {
            NSLog(@"网络requestHeader: %@",self.requestParam.requestHeaderDic);
        }
    }
#endif

    //AFN3.0+基于封住HTPPSession的句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //最大请求并发任务数
//    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json"
//                     forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8"
//                     forHTTPHeaderField:@"Content-Type"];
    
    // 设置接收的Content-Type
//    NSSet *Content_Type = [[NSSet alloc] initWithObjects:
//                           @"application/xml",
//                           @"text/xml",
//                           @"text/html",
//                           @"application/json",
//                           @"text/plain",
//                           @"text/json",
//                           @"text/javascript",
//                           @"multipart/form-data",
//                           nil];
//    manager.responseSerializer.acceptableContentTypes = Content_Type;
    
    //_requestHeader
    if ([NSDictionary isDictionaryNotEmpty:self.requestParam.requestHeaderDic]) {
        NSArray *allKeys = [self.requestParam.requestHeaderDic allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [self.requestParam.requestHeaderDic objectForKey:key];
            
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }

    
    
    //POST请求
    if ([[self.requestParam.method uppercaseString] isEqualToString:@"POST"]) {
        
        //加密
        NSMutableDictionary *postParamDic = [NSMutableDictionary dictionary];
        if ([NSString isStringNotEmpty:self.requestParam.encryptPassword]) {
            NSDictionary *dictionary = [self.requestParam paramOfPost];
            NSString *newString = [AESCrypt encrypt:[dictionary translateToJSONString]
                                           password:self.requestParam.encryptPassword];
            [postParamDic setObject:@"ios" forKey:@"app"];
            [postParamDic setObject:newString forKey:@"info"];
        }
        //不加密
        else{
            NSDictionary *dictionary = [self.requestParam paramOfPost];
            [postParamDic setValuesForKeysWithDictionary:dictionary];
        }

        
        if ([NSDictionary isDictionaryNotEmpty:self.requestParam.postFilesPathDic] ||
            [NSDictionary isDictionaryNotEmpty:self.requestParam.postDataDic] ||
            self.requestParam.postData) {
                //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
            KKWeakSelf(self);
            [manager KK_POST:self.requestParam.urlString
              kkRequestParam:self.requestParam
               parameters:postParamDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                   
                       //发送文件
                   if ([NSDictionary isDictionaryNotEmpty:weakself.requestParam.postFilesPathDic]) {
                       NSArray *allKeys = [weakself.requestParam.postFilesPathDic allKeys];
                       for (NSInteger i=0; i<[allKeys count]; i++) {
                           NSString *key = [allKeys objectAtIndex:i];
                           NSString *filePath = [weakself.requestParam.postFilesPathDic objectForKey:key];
                           NSError *error;
                           [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:key error:&error];
                           if (error) {
                               NSLog(@"%@",error);
                           }
                       }
                   }
                   
                   if ([NSDictionary isDictionaryNotEmpty:weakself.requestParam.postDataDic]) {
                       NSArray *allKeys = [weakself.requestParam.postDataDic allKeys];
                       for (NSInteger i=0; i<[allKeys count]; i++) {
                           NSString *key = [allKeys objectAtIndex:i];
                           NSData *data = [weakself.requestParam.postDataDic objectForKey:key];
                           [formData appendPartWithFormData:data name:key];
                       }
                   }
                   
               } progress:^(NSProgress * _Nonnull uploadProgress) {
                   
                   //上传进度
                   // @property int64_t totalUnitCount;     需要下载文件的总大小
                   // @property int64_t completedUnitCount; 当前已经下载的大小
                   //
                   // 给Progress添加监听 KVO
                   //            NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                   // 回到主队列刷新UI,用户自定义的进度条
                   //            dispatch_async(dispatch_get_main_queue(), ^{
                   //                self.progressView.progress = 1.0 *
                   //                uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
                   //            });
                   
               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                       //主线
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       NSString *string = nil;
                       if ([responseObject isKindOfClass:[NSDictionary class]]) {
                           string = [(NSDictionary*)responseObject translateToJSONString];
                       }
                       else if ([responseObject isKindOfClass:[NSString class]]){
                           string = (NSString*)responseObject;
                       }
                       else if ([responseObject isKindOfClass:[NSData class]]){
                           string = [NSString stringWithData:(NSData *)responseObject];
                       }
                       else{
                           
                       }
                       
                       if (weakself.delegate &&
                           [weakself.delegate respondsToSelector:@selector(requestFinished:result:)]) {
                           [weakself.delegate requestFinished:self result:string];
                       }
                       
                   });
                   
                   
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                       //主线
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if (weakself.delegate &&
                           [weakself.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                           [weakself.delegate requestFailed:self error:error];
                       }
                       
                   });
               }];
        }
        else{
                //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
            KKWeakSelf(self);
            [manager POST:self.requestParam.urlString
               parameters:postParamDic progress:^(NSProgress * _Nonnull uploadProgress) {
                   
                       //上传进度
                       // @property int64_t totalUnitCount;     需要下载文件的总大小
                       // @property int64_t completedUnitCount; 当前已经下载的大小
                       //
                       // 给Progress添加监听 KVO
                       //            NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                       // 回到主队列刷新UI,用户自定义的进度条
                       //            dispatch_async(dispatch_get_main_queue(), ^{
                       //                self.progressView.progress = 1.0 *
                       //                uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
                       //            });

               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                       //主线
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       NSString *string = nil;
                       if ([responseObject isKindOfClass:[NSDictionary class]]) {
                           string = [(NSDictionary*)responseObject translateToJSONString];
                       }
                       else if ([responseObject isKindOfClass:[NSString class]]){
                           string = (NSString*)responseObject;
                       }
                       else if ([responseObject isKindOfClass:[NSData class]]){
                           string = [NSString stringWithData:(NSData *)responseObject];
                       }
                       else{
                           
                       }
                       
                       if (weakself.delegate &&
                           [weakself.delegate respondsToSelector:@selector(requestFinished:result:)]) {
                           [weakself.delegate requestFinished:self result:string];
                       }
                       
                   });

               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   
                       //主线
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       if (weakself.delegate &&
                           [weakself.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                           [weakself.delegate requestFailed:self error:error];
                       }
                       
                   });

               } ];
        }
        
        
    }
    //GET请求
    else if ([[self.requestParam.method uppercaseString] isEqualToString:@"GET"]){
        
        NSString *urlString = _requestParam.urlString;
        if (KKFormRequest_IsOpenLog) {
            NSLog(@"GET原始的URL: %@",urlString);
        }
        urlString = [NSString stringWithFormat:@"%@%@", urlString, [self.requestParam paramStringOfGet]];
#ifdef DEBUG
        if (KKFormRequest_IsOpenLog) {
            NSLog(@"GET请求的URL: %@",urlString);
        }
#endif
        KKWeakSelf(self);
        [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //主线
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *string = nil;
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    string = [(NSDictionary*)responseObject translateToJSONString];
                }
                else if ([responseObject isKindOfClass:[NSString class]]){
                    string = (NSString*)responseObject;
                }
                else if ([responseObject isKindOfClass:[NSData class]]){
                    string = [NSString stringWithData:(NSData *)responseObject];
                }
                else{
                    
                }
                
                if (weakself.delegate &&
                    [weakself.delegate respondsToSelector:@selector(requestFinished:result:)]) {
                    [weakself.delegate requestFinished:self result:string];
                }

            });

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //主线
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakself.delegate &&
                    [weakself.delegate respondsToSelector:@selector(requestFailed:error:)]) {
                    [weakself.delegate requestFailed:self error:error];
                }
                
            });

        }];
    }
    else{
        
    }
}

@end
