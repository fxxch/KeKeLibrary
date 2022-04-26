//
//  UIButton+KKWebCache.h
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKWebCache.h"

@interface UIButton (KKWebCache)

@property (nonatomic, copy, readonly) NSString *kk_imageDataURLString;

- (void)kk_showGIFSubView:(NSData*)data;




/*无状态*/
- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder;

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;

/*状态*/
- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  forState:(KKControlState)state;

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  forState:(KKControlState)state
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;

/*GCD块*/
- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                 completed:(KKImageLoadCompletedBlock)completedBlock;

/*GCD块+状态*/
- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  forState:(KKControlState)state
                 completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  forState:(KKControlState)state
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                 completed:(KKImageLoadCompletedBlock)completedBlock;



#pragma mark ==================================================
#pragma mark ==设置图片 setBackgroundImageWithURL
#pragma mark ==================================================
/*无状态*/
- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder;

- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                   showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;


/*状态*/
- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                            forState:(KKControlState)state;

- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                            forState:(KKControlState)state
                   showActivityStyle:(KKActivityIndicatorViewStyle)aStyle;

/*GCD块*/
- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                           completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                   showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                           completed:(KKImageLoadCompletedBlock)completedBlock;

/*GCD块+状态*/
- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                            forState:(KKControlState)state
                           completed:(KKImageLoadCompletedBlock)completedBlock;

- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                            forState:(KKControlState)state
                   showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                           completed:(KKImageLoadCompletedBlock)completedBlock;



@end
