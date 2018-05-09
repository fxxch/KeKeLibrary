//
//  UIButton+KKWebCache.h
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKFileCacheManager.h"

@interface UIButton (KKWebCache)

@property (nonatomic, copy, readonly) NSString *imageDataURLString;

- (void)showGIFSubView:(NSData*)data;




/*无状态*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;

/*状态*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
               forState:(KKControlState)state;

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
               forState:(KKControlState)state
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;

/*GCD块*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
              completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
              completed:(KKImageLoadCompletedBlock)completedBlock;

/*GCD块+状态*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
               forState:(KKControlState)state
              completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
               forState:(KKControlState)state
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
              completed:(KKImageLoadCompletedBlock)completedBlock;



#pragma mark ==================================================
#pragma mark ==设置图片 setBackgroundImageWithURL
#pragma mark ==================================================
/*无状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder;

- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;


/*状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                         forState:(KKControlState)state;

- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                         forState:(KKControlState)state
                showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;

/*GCD块*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                        completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                        completed:(KKImageLoadCompletedBlock)completedBlock;

/*GCD块+状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                         forState:(KKControlState)state
                        completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                         forState:(KKControlState)state
                showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                        completed:(KKImageLoadCompletedBlock)completedBlock;



@end
