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


///**
// 用颜色值来创建图片
// 
// @param color 填充色
// @return UIImage
// */
//- (nonnull UIImage *)imageWithColor:(nullable UIColor *)color;

/**
 用颜色值来创建图片
 
 @param color 填充色
 @param size 图片大小
 @return UIImage
 */
+ (nonnull UIImage *)imageWithColor:(nonnull UIColor *)color
                               size:(CGSize)size;

/**
 用颜色值来创建图片
 
 @param color 填充色
 @param size 图片大小
 @param radius 圆角弧度
 @return UIImage
 */
+ (nonnull UIImage *)imageWithColor:(nonnull UIColor *)color
                               size:(CGSize)size
                             radius:(NSInteger)radius;

/**
 根据NSData判断是那种图片格式
 
 @param data 图片的data
 @return 格式字符串
 */
+ (nullable NSString *) contentTypeForImageData:(nullable NSData *)data;

/**
 根据NSData判断是那种图片格式
 
 @param data 图片的data
 @return 格式字符串
 */
+ (nullable NSString *) contentTypeExtensionForImageData:(nullable NSData *)data;

/**
 翻转图片
 
 @param isHorizontal YES 水平翻转 NO 垂直翻转
 @return UIImage
 */
- (nullable UIImage *)flip:(BOOL)isHorizontal;

/**
 缩放到指定大小
 
 @param size 指定大小
 @return UIImage
 */
- (nullable UIImage *)resizeTo:(CGSize)size;

/**
 缩放到指定大小
 
 @param width 宽度
 @param height 高度
 @return UIImage
 */
- (nullable UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

/**
 缩放到指定大小
 
 @param width  宽度
 @return UIImage
 */
- (nullable UIImage *)scaleWithWidth:(CGFloat)width;

/**
 缩放到指定大小
 
 @param height 高度
 @return UIImage
 */
- (nullable UIImage *)scaleWithHeight:(CGFloat)height;


/**
 截图
 
 @param x 需要截图区域的x
 @param y 需要截图区域的y
 @param width 需要截图区域的width
 @param height 需要截图区域的height
 @return UIImage
 */
- (nullable UIImage *)cropImageWithX:(CGFloat)x
                                   y:(CGFloat)y
                               width:(CGFloat)width
                              height:(CGFloat)height;

/**
 截图
 
 @param rect 需要截图区域
 @return UIImage
 */
- (nullable UIImage *)imageAtRect:(CGRect)rect;

/**
 自适应方向
 
 @return UIImage
 */
- (nullable UIImage *)fixOrientation;

- (nullable UIImage *)decodedImage;

- (nullable UIImage *)decoded;

/**
 图片加水印
 
 @param mark 水印文字
 @param textColor 水印文字颜色
 @param font 水印文字字体
 @param point 水印文字起始坐标
 @return UIImage
 */
- (nonnull UIImage *)addMark:(nullable NSString *)mark
                   textColor:(nullable UIColor *)textColor
                        font:(nullable UIFont *)font
                       point:(CGPoint)point;

/**
 添加日期
 
 @return UIImage
 */
- (nullable UIImage *)addCreateTime;

/**
 等比缩放图片
 
 @param targetSize 目标大小
 @return UIImage
 */
- (nullable UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;

/**
 图片旋转
 
 @param radians 需要旋转的角度
 @return UIImage
 */
- (nullable UIImage *)imageRotatedByRadians:(CGFloat)radians;

/**
 图片旋转
 
 @param degrees 需要旋转的角度
 @return UIImage
 */
- (nullable UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 图片缩放
 
 @param scale 缩放的比例
 @return UIImage
 */
- (nullable UIImage*)convertImageToScale:(double)scale;

/**
 * 5.对图片进行滤镜处理
 */
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (nonnull UIImage *)filterWithOriginalImage:(nullable UIImage *)image
                                  filterName:(nullable NSString *)name;

/**
 * 6.对图片进行模糊处理
 */
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (nullable UIImage *)blurWithOriginalImage:(nullable UIImage *)image
                                   blurName:(nullable NSString *)name
                                     radius:(NSInteger)radius;

+ (nullable UIImage*)createRoundedRectImage:(nullable UIImage*)image
                                       size:(CGSize)size
                                     radius:(NSInteger)radius;

- (UIImage *_Nonnull)imageTransWithColor:(UIColor *_Nonnull)color;
@end
