//
//  UIImageView+KKWebCache.h
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import "KKFileCacheManager.h"

@interface UIImageView (KKWebCache)

@property (nonatomic, copy, readonly) NSString *imageDataURLString;

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
              completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
              completed:(KKImageLoadCompletedBlock)completedBlock;


@end
