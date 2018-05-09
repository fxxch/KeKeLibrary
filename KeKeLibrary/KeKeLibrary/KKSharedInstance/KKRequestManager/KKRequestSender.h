//
//  KKRequestSender.h
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KKFormRequest.h"

#define NetWorkNoneCode 999

@class KKRequestParam;
@class KKFormRequest;

@interface KKRequestSender : NSObject

- (void)sendRequestWithParam:(KKRequestParam *)param
          requestIndentifier:(NSString*)indentifier;

/*子类可重写此方法*/
- (void)receivedRequestFinished:(KKFormRequest*)formRequest
                 httpInfomation:(NSDictionary*)httpInfomation
                  requestResult:(NSDictionary*)requestResult
                 responseString:(NSString*)aResponseString;

@end


#pragma mark -

@interface NSObject (KKRequest_NSObject)

/*注册成为监听器*/
- (void)observeKKRequestNotificaiton:(NSString *)identifier;

- (void)unobserveKKRequestNotificaiton:(NSString *)identifier;

/**
 每个NSObject 有网络请求的时候，就需要实现该方法【子类必须重写此方法】
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
              responseString:(NSString*)aResponseString;

@end
