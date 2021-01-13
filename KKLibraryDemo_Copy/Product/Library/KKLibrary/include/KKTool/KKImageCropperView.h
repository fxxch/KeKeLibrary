//
//  KKImageCropperView.h
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKView.h"

/*宽、高比例*/
typedef enum {
    KKImageCropRatio1_1 = 1,
    KKImageCropRatio1_2,
    KKImageCropRatio2_1,
    KKImageCropRatio16_9,
    KKImageCropRatio16_10
} KKImageCropRatio;

@interface KKImageCropperView : UIView <UIScrollViewDelegate>

/*裁剪比例*/
@property (nonatomic, assign) KKImageCropRatio  cropRatio;

/*裁剪尺寸*/
@property (nonatomic, assign) CGSize            cropSize;

/*maskView的边距*/
@property (nonatomic, assign) UIEdgeInsets      padding;

/*需要裁剪的图片*/
@property (nonatomic, strong) UIImage           *image;

/*获取裁剪后的图片*/
- (UIImage *)croppedImage;


@end
