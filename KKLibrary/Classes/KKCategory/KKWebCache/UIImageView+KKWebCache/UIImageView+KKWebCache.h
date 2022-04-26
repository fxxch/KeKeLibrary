//
//  UIImageView+KKWebCache.h
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import "KKWebCache.h"

@interface UIImageView (KKWebCache)

@property (nonatomic, copy, readonly) NSString *kk_imageDataURLString;

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder;

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                 completed:(KKImageLoadCompletedBlock)completedBlock;


@end
