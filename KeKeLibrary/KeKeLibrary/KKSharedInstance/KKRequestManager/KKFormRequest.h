//
//  KKFormRequest.h
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KKFormRequestDelegate;

@class KKRequestSender;
@class KKRequestParam;

@interface KKFormRequest : NSObject

@property (nonatomic, copy) NSString        *identifier;
@property (nonatomic, strong) KKRequestParam  *requestParam;
@property (nonatomic, weak) KKRequestSender *requestSender;
@property (nonatomic, weak) id<KKFormRequestDelegate> delegate;


- (void)startRequest:(NSString *)aIdentifier
               param:(KKRequestParam *)param
       requestSender:(KKRequestSender*)aRequestSender;

- (void)setRequestIdentifier:(NSString *)aIdentifier
                       param:(KKRequestParam *)param
               requestSender:(KKRequestSender*)aRequestSender;

- (void)clearDelegatesAndCancel;

@end

@protocol KKFormRequestDelegate <NSObject>
@optional

- (void)requestFinished:(KKFormRequest *)request result:(id)responseObject;

- (void)requestFailed:(KKFormRequest *)request error:(NSError*)aError;

@end

