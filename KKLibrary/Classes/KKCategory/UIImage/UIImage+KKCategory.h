//
//  UIImage+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIImageExtensionType_PNG  @"png"
#define UIImageExtensionType_BMP  @"bmp"
#define UIImageExtensionType_JPG  @"jpeg"
#define UIImageExtensionType_GIF  @"gif"
#define UIImageExtensionType_TIFF @"tiff"


@interface UIImage (KKCategory)

/**
 用颜色值来创建图片
 
 @param color 填充色
 @param size 图片大小
 @return UIImage
 */
+ (nonnull UIImage *)kk_imageWithColor:(nonnull UIColor *)color
                                  size:(CGSize)size;

/**
 用颜色值来创建图片
 
 @param color 填充色
 @param size 图片大小
 @param radius 圆角弧度
 @return UIImage
 */
+ (nonnull UIImage *)kk_imageWithColor:(nonnull UIColor *)color
                                  size:(CGSize)size
                                radius:(NSInteger)radius;

/**
 根据NSData判断是那种图片格式
 
 @param data 图片的data
 @return 格式字符串
 */
+ (nullable NSString *)kk_contentTypeForImageData:(nullable NSData *)data;

/**
 根据NSData判断是那种图片格式
 
 @param data 图片的data
 @return 格式字符串
 */
+ (nullable NSString *)kk_contentTypeExtensionForImageData:(nullable NSData *)data;

/**
 翻转图片
 
 @param isHorizontal YES 水平翻转 NO 垂直翻转
 @return UIImage
 */
- (nullable UIImage *)kk_flip:(BOOL)isHorizontal;

/**
 缩放到指定大小
 
 @param size 指定大小
 @return UIImage
 */
- (nullable UIImage *)kk_resizeTo:(CGSize)size;

/**
 缩放到指定大小
 
 @param width 宽度
 @param height 高度
 @return UIImage
 */
- (nullable UIImage *)kk_resizeToWidth:(CGFloat)width height:(CGFloat)height;

/**
 缩放到指定大小
 
 @param width  宽度
 @return UIImage
 */
- (nullable UIImage *)kk_scaleWithWidth:(CGFloat)width;

/**
 缩放到指定大小
 
 @param height 高度
 @return UIImage
 */
- (nullable UIImage *)kk_scaleWithHeight:(CGFloat)height;


/**
 截图
 
 @param x 需要截图区域的x
 @param y 需要截图区域的y
 @param width 需要截图区域的width
 @param height 需要截图区域的height
 @return UIImage
 */
- (nullable UIImage *)kk_cropImageWithX:(CGFloat)x
                                      y:(CGFloat)y
                                  width:(CGFloat)width
                                 height:(CGFloat)height;

/**
 截图
 
 @param rect 需要截图区域
 @return UIImage
 */
- (nullable UIImage *)kk_imageAtRect:(CGRect)rect;

/**
 自适应方向
 
 @return UIImage
 */
- (nullable UIImage *)kk_fixOrientation;

- (nullable UIImage *)kk_decodedImage;

- (nullable UIImage *)kk_decoded;

/**
 图片加水印
 
 @param mark 水印文字
 @param textColor 水印文字颜色
 @param font 水印文字字体
 @param point 水印文字起始坐标
 @return UIImage
 */
- (nonnull UIImage *)kk_addMark:(nullable NSString *)mark
                      textColor:(nullable UIColor *)textColor
                           font:(nullable UIFont *)font
                          point:(CGPoint)point;

/**
 添加日期
 
 @return UIImage
 */
- (nullable UIImage *)kk_addCreateTime;

/**
 等比缩放图片
 
 @param targetSize 目标大小
 @return UIImage
 */
- (nullable UIImage *)kk_imageByScalingProportionallyToSize:(CGSize)targetSize;

/**
 图片旋转
 
 @param radians 需要旋转的角度
 @return UIImage
 */
- (nullable UIImage *)kk_imageRotatedByRadians:(CGFloat)radians;

/**
 图片旋转
 
 @param degrees 需要旋转的角度
 @return UIImage
 */
- (nullable UIImage *)kk_imageRotatedByDegrees:(CGFloat)degrees;

/**
 图片缩放
 
 @param scale 缩放的比例
 @return UIImage
 */
- (nullable UIImage*)kk_convertImageToScale:(double)scale;

/**
 * 5.对图片进行滤镜处理
 */
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (nonnull UIImage *)kk_filterWithOriginalImage:(nullable UIImage *)image
                                  filterName:(nullable NSString *)name;

/**
 * 6.对图片进行模糊处理
 */
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (nullable UIImage *)kk_blurWithOriginalImage:(nullable UIImage *)image
                                   blurName:(nullable NSString *)name
                                     radius:(NSInteger)radius;

+ (nullable UIImage*)kk_createRoundedRectImage:(nullable UIImage*)image
                                       size:(CGSize)size
                                     radius:(NSInteger)radius;

- (UIImage *_Nonnull)kk_imageTransWithColor:(UIColor *_Nonnull)color;


#pragma mark ==================================================
#pragma mark == ImageConvert
#pragma mark ==================================================
typedef void(^KKImageConvertImageOneCompletedBlock)(NSData * _Nullable imageData,NSInteger index);
typedef void(^KKImageConvertImageAllCompletedBlock)(void);

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
