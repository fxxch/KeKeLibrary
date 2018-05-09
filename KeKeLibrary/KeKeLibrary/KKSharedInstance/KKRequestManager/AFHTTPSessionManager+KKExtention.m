//
//  AFHTTPSessionManager+KKExtention.m
//  KKLibray
//
//  Created by liubo on 2018/4/26.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "AFHTTPSessionManager+KKExtention.h"
#import "KKRequestParam.h"
#import "KKCategory.h"

@implementation AFHTTPSessionManager (KKExtention)


- (NSURLSessionDataTask *)KK_POST:(NSString *)URLString
                   kkRequestParam:(KKRequestParam*)aKKParameters
                       parameters:(id)parameters
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    
    //_requestHeader
    if ([NSDictionary isDictionaryNotEmpty:aKKParameters.requestHeaderDic]) {
        NSArray *allKeys = [aKKParameters.requestHeaderDic allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [aKKParameters.requestHeaderDic objectForKey:key];
            
            [request setValue:value forHTTPHeaderField:key];
        }
    }
    
    //postData
    if (aKKParameters.postData) {
        
        NSMutableData *data = [NSMutableData data];
        [data appendData:request.HTTPBody];
        [data appendData:aKKParameters.postData];
        request.HTTPBody = data;
        
        unsigned long long lenth = [[request valueForHTTPHeaderField:@"Content-Length"] longLongValue];
        lenth = lenth + [aKKParameters.postData length];
        [request setValue:[NSString stringWithFormat:@"%llu", lenth] forHTTPHeaderField:@"Content-Length"];
    }
    
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

@end
