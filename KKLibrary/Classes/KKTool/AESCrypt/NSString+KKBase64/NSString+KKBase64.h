//
//  NSString+KKBase64.h
//  KKLibrary
//
//  Created by 刘波 on 2020/12/17.
//  Copyright © 2020 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KKBase64)

+ (NSString *)kk_base64StringFromData:(NSData *)data length:(NSUInteger)length;

@end
