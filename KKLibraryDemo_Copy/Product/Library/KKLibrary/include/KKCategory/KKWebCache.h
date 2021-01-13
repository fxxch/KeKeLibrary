//
//  KKWebCache.h
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKWebCacheDefine.h"

@interface KKWebCache : NSObject

/* 缓存图片 */
+ (NSData*)saveWebImage:(NSURL *)location response:(NSURLResponse *)response identifier:(NSString*)aIdentifier;

/* 下载图片 */
+ (void)downLoadImageWithURLString:(NSString*)aURLString
                         completed:(KKImageLoadCompletedBlock)completedBlock;

@end
