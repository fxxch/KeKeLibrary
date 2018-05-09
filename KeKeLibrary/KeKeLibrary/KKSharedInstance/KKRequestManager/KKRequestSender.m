//
//  KKRequestSender.m
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKRequestSender.h"
#import "KKRequestManager.h"
#import "KKFormRequest.h"

@implementation KKRequestSender

- (void)sendRequestWithParam:(KKRequestParam *)param
          requestIndentifier:(NSString*)indentifier{
    [KKRequestManager addRequestWithParam:param
                       requestIndentifier:indentifier
                            requestSender:self];
}

- (void)receivedRequestFinished:(KKFormRequest*)formRequest
                 httpInfomation:(NSDictionary*)httpInfomation
                  requestResult:(NSDictionary*)requestResult
                 responseString:(NSString*)aResponseString{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];

    [dictionary setObject:formRequest.identifier forKey:@"identifier"];
    
    if (requestResult) {
        [dictionary setObject:requestResult forKey:@"requestResult"];
    }
    
    if (httpInfomation) {
        [dictionary setObject:httpInfomation forKey:@"httpInfomation"];
    }
    
    if (aResponseString && [aResponseString length]>0) {
        [dictionary setObject:aResponseString forKey:@"responseString"];
    }
    
    [dictionary setObject:formRequest forKey:@"formRequest"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:formRequest.identifier
                                                        object:dictionary
                                                      userInfo:nil];
}

@end



////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSObject (KKRequest_NSObject)

- (void)observeKKRequestNotificaiton:(NSString *)identifier {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tRequestFinished:)
                                                 name:identifier
                                               object:nil];
}

- (void)tRequestFinished:(NSNotification *)noti {
    NSDictionary *noticeInfo = noti.object;
    NSString *identifier = [noticeInfo objectForKey:@"identifier"];
    NSMutableDictionary *requestResult = [noticeInfo objectForKey:@"requestResult"];
    NSDictionary *httpInfomation = [noticeInfo objectForKey:@"httpInfomation"];
    NSString *responseString = [noticeInfo objectForKey:@"responseString"];
    KKFormRequest *formRequest = [noticeInfo objectForKey:@"formRequest"];

    [self KKRequestDidFinished:formRequest
                 requestResult:requestResult
                httpInfomation:httpInfomation
             requestIdentifier:identifier
                responseString:responseString];
}

- (void)unobserveKKRequestNotificaiton:(NSString *)identifier {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:identifier object:nil];
}

/**
 每个NSObject 有网络请求的时候，就需要实现该方法
 @param aFormRequest 网络请求的实例
 @param aRequestResult 网络请求的结果【已经被解析成为字典了】
 @param aHttpInfomation 网络请求的http结果
 @param aRequestIdentifier 网络请求的标识符
 @param aResponseString 网络请求返回的原始数据
 */
- (void)KKRequestDidFinished:(KKFormRequest*)aFormRequest
               requestResult:(NSDictionary*)aRequestResult
              httpInfomation:(NSDictionary*)aHttpInfomation
           requestIdentifier:(NSString*)aRequestIdentifier
              responseString:(NSString*)aResponseString{
    
    
}




@end

