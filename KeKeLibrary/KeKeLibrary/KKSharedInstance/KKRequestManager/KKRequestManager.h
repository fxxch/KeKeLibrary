//
//  KKRequestManager.h
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define httpResultURLKey     @"resultURL"
#define httpResultCodeKey    @"resultCode"
#define httpResultMessageKey @"resultMessage"
#define httpCodeKey          @"code"
#define httpMessageKey       @"message"

#define NetworkRequestFailed     @"999996" //网络请求失败
#define httpResultEmptyCode      @"999997" //网络请求返回数据为空
#define httpResultParseErrorCode @"999998" //网络请求返回数据无法解析
#define NetworkNotReachableCode  @"999999" //没有网络连接

#define KKFormRequest_IsOpenLog 1

@class KKRequestParam;
@class KKRequestSender;

@interface KKRequestManager : NSObject

@property(nonatomic,strong)NSMutableArray *requestList;

+ (KKRequestManager*)defaultManager;

+ (void)addRequestWithParam:(KKRequestParam *)param
         requestIndentifier:(NSString*)indentifier
              requestSender:(KKRequestSender*)requestSender;

- (void)cancelRequest:(NSString*)indentifier;

@end



