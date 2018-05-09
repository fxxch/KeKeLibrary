//
//  AFHTTPSessionManager+KKExtention.h
//  KKLibray
//
//  Created by liubo on 2018/4/26.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class KKRequestParam;

@interface AFHTTPSessionManager (KKExtention)

- (NSURLSessionDataTask *)KK_POST:(NSString *)URLString
                   kkRequestParam:(KKRequestParam*)aKKParameters
                       parameters:(id)parameters
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
