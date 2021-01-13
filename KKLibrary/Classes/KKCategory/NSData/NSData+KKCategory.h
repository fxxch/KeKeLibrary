//
//  NSData+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^KKImageConvertImageOneCompletedBlock)(NSData * _Nullable imageData,NSInteger index);
typedef void(^KKImageConvertImageAllCompletedBlock)(void);

@interface NSData (KKCategory)


- (nonnull NSString *)md5;

- (nonnull NSString *)base64Encoded;

- (nonnull NSData *)base64Decoded;

/**
 将图片压缩到指定大小 imageArray UIImage数组，imageDataSize 图片数据大小(单位KB)，比如100KB
 
 @param imageArray 需要转换的图片数组
 @param imageDataSize 需要压缩到图片数据大小(单位KB)，比如100KB
 @param completedOneBlock 处理完成一张的回调
 @param completedAllBlock 处理完成所有的回调
 */
+ (void)convertImage:(nullable NSArray*)imageArray
          toDataSize:(CGFloat)imageDataSize
        oneCompleted:(KKImageConvertImageOneCompletedBlock _Nullable )completedOneBlock
   allCompletedBlock:(KKImageConvertImageAllCompletedBlock _Nullable )completedAllBlock;

@end
