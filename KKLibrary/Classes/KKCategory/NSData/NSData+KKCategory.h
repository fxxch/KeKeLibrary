//
//  NSData+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSData (KKCategory)

- (nonnull NSString *)kk_md5;

- (nonnull NSString *)kk_base64Encoded;

- (nonnull NSData *)kk_base64Decoded;

@end
