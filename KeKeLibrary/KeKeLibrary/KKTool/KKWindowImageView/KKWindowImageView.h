//
//  KKWindowImageView.h
//  Social
//
//  Created by liubo on 13-4-19.
//  Copyright (c) 2013年 ibm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPageScrollView.h"
#import "KKWindowImageItem.h"
#import "UIButton+KKWebCache.h"
#import "UIImageView+KKWebCache.h"

#define KKWindowImageView_URL @"URLString"
#define KKWindowImageView_PlaceHolderImage @""

@interface KKWindowImageView : UIView<KKPageScrollViewDelegate,KKWindowImageItemDelegate>


/**
 展示一张远程图片

 @param imageURLString 图片的URL
 @param image 默认图片
 */
+ (void)showImageWithURLString:(NSString*)imageURLString placeholderImage:(UIImage*)image;


/**
 展示一张本地图片

 @param image 图片
 */
+ (void)showImage:(UIImage*)image;


/**
 展示一组远程图片
 @param aImageInformationArray 是一个Dictionary对象，必须包含以下键值对
        #define KKWindowImageView_URL @"URLString"
        #define KKWindowImageView_PlaceHolderImage @"PlaceHolderImage"
 @param index 默认选中哪一个
 */
+ (void)showImageWithURLStringArray:(NSArray*)aImageInformationArray
                      selectedIndex:(NSInteger)index;


/**
 动态展示一组远程图片

 @param aOriginViews 原始的所有View
 @param aImageURLStringArray 所有view的图片的URL数组
 @param aSelectedIndex 默认选中哪一个
 @return 返回一个实例
 */
+ (KKWindowImageView*)showFromViews:(NSArray*)aOriginViews
                imageURLStringArray:(NSArray*)aImageURLStringArray
                      selectedIndex:(NSInteger)aSelectedIndex;


@end
