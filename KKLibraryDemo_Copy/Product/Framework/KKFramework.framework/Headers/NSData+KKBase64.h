//
//  NSData+KKBase64.h
//  KKLibrary
//
//  Created by 刘波 on 2020/12/17.
//  Copyright © 2020 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (KKBase64)

+ (NSData *)kk_base64DataFromString:(NSString *)string;

@end
