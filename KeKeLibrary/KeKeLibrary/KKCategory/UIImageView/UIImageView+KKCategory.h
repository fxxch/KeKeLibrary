//
//  UIImageView+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (KKCategory)

/**
 显示图片数据
 
 @param imageData imageData
 */
- (void)showImageData:(nullable NSData*)imageData;


/**
 显示图片数据
 
 @param imageData 图片数据
 @param rect 显示区域
 */
- (void)showImageData:(nullable NSData*)imageData
              inFrame:(CGRect)rect;

@end
