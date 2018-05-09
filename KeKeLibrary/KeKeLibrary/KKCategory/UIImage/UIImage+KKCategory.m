//
//  UIImage+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIImage+KKCategory.h"
#import "NSDateFormatter+KKCategory.h"
#import "NSString+KKCategory.h"

CGFloat KKDegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat KKRadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (KKCategory)

/**
 用颜色值来创建图片
 
 @param color 填充色
 @return UIImage
 */
- (nonnull UIImage *)imageWithColor:(nullable UIColor *)color{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 用颜色值来创建图片
 
 @param color 填充色
 @param size 图片大小
 @return UIImage
 */
+ (nonnull UIImage *)imageWithColor:(nonnull UIColor *)color
                               size:(CGSize)size{
    
    return [UIImage imageWithColor:color size:size radius:0];
}

/**
 用颜色值来创建图片
 
 @param color 填充色
 @param size 图片大小
 @param radius 圆角弧度
 @return UIImage
 */
+ (nonnull UIImage *)imageWithColor:(nonnull UIColor *)color
                               size:(CGSize)size
                             radius:(NSInteger)radius{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIView *view = [[UIView alloc]initWithFrame:rect];
    if (radius>0) {
        view.layer.cornerRadius = radius;
        view.layer.masksToBounds = YES;
    }
    view.backgroundColor = color;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, view.layer.contentsScale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 根据NSData判断是那种图片格式
 
 @param data 图片的data
 @return 格式字符串
 */
+ (nullable NSString *) contentTypeForImageData:(nullable NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x42:
            return @"image/bmp";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

/**
 根据NSData判断是那种图片格式
 
 @param data 图片的data
 @return 格式字符串
 */
+ (nullable NSString *) contentTypeExtensionForImageData:(nullable NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return UIImageExtensionType_JPG;
        case 0x89:
            return UIImageExtensionType_PNG;
        case 0x42:
            return UIImageExtensionType_BMP;
        case 0x47:
            return UIImageExtensionType_GIF;
        case 0x49:
        case 0x4D:
            return UIImageExtensionType_TIFF;
    }
    return @"";
}


/**
 翻转图片
 
 @param isHorizontal YES 水平翻转 NO 垂直翻转
 @return UIImage
 */
- (nullable UIImage *)flip:(BOOL)isHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    //2014-10-20 刘波
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    //    if (UIGraphicsBeginImageContextWithOptions != NULL) {
    //        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    //    } else {
    //        UIGraphicsBeginImageContext(rect.size);
    //    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    if (isHorizontal) {
        CGContextRotateCTM(ctx, M_PI);
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
    }
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 缩放到指定大小
 
 @param size 指定大小
 @return UIImage
 */
- (nullable UIImage *)resizeTo:(CGSize)size {
    return [self resizeToWidth:size.width height:size.height];
}


/**
 缩放到指定大小
 
 @param width 宽度
 @param height 高度
 @return UIImage
 */
- (nullable UIImage *)resizeToWidth:(CGFloat)width
                             height:(CGFloat)height {
    
    CGSize size = CGSizeMake(width, height);
    //2014-10-20 刘波
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //    if (UIGraphicsBeginImageContextWithOptions != NULL) {
    //        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //    } else {
    //        UIGraphicsBeginImageContext(size);
    //    }
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 缩放到指定大小
 
 @param width  宽度
 @return UIImage
 */
- (nullable UIImage *)scaleWithWidth:(CGFloat)width {
    CGSize imageSize = [self size];
    CGFloat scale = imageSize.width / width;
    CGFloat height = imageSize.height / scale;
    return [self resizeToWidth:width height:height];
}

/**
 缩放到指定大小
 
 @param height 高度
 @return UIImage
 */
- (nullable UIImage *)scaleWithHeight:(CGFloat)height {
    CGSize imageSize = [self size];
    CGFloat scale = imageSize.height / height;
    CGFloat width = imageSize.width / scale;
    return [self resizeToWidth:width height:height];
}


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
                              height:(CGFloat)height {
    
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

/**
 截图
 
 @param rect 需要截图区域
 @return UIImage
 */
- (nullable UIImage *)imageAtRect:(CGRect)rect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
}


/**
 自适应方向
 
 @return UIImage
 */
- (nullable UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (nullable UIImage *)decodedImage {
    CGImageRef imageRef = self.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 CGImageGetWidth(imageRef),
                                                 CGImageGetHeight(imageRef),
                                                 8,
                                                 // Just always return width * 4 will be enough
                                                 CGImageGetWidth(imageRef) * 4,
                                                 // System only supports RGB, set explicitly
                                                 colorSpace,
                                                 // Makes system don't need to do extra conversion when displayed.
                                                 // NOTE: here we remove the alpha channel for performance. Most of the time, images loaded
                                                 //       from the network are jpeg with no alpha channel. As a TODO, finding a way to detect
                                                 //       if alpha channel is necessary would be nice.
                                                 kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGRect rect = (CGRect){CGPointZero,{CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)}};
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *decompressedImage = [[UIImage alloc] initWithCGImage:decompressedImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

- (nullable UIImage *)decoded{
    CGImageRef imageRef = self.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    } else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    if (!context) return self;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef
                                                     scale:self.scale
                                               orientation:self.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}


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
                       point:(CGPoint)point {
    CGSize size = self.size;
    //2014-10-20 刘波
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //    if (UIGraphicsBeginImageContextWithOptions != NULL) {
    //        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //    } else {
    //        UIGraphicsBeginImageContext(size);
    //    }
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    if (textColor == nil) {
        textColor = [UIColor whiteColor];
    }
    
    [textColor setFill];
    
    if (font == nil) {
        font = [UIFont systemFontOfSize:14.0f];
    }
    
    NSDictionary* Attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, textColor,NSForegroundColorAttributeName, nil];
    [mark drawInRect:CGRectMake(point.x, point.y, self.size.width, self.size.height) withAttributes:Attributes2];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 添加日期
 
 @return UIImage
 */
- (nullable UIImage *)addCreateTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter defaultFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    CGSize size = [dateString sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] maxSize:CGSizeMake(self.size.width, CGFLOAT_MAX)];
    
    return [self addMark:dateString
               textColor:[UIColor blackColor]
                    font:[UIFont boldSystemFontOfSize:16.0f]
                   point:CGPointMake(self.size.width-size.width-10, self.size.height-size.height-10)];
    
}


/**
 等比缩放图片
 
 @param targetSize 目标大小
 @return UIImage
 */
- (nullable UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    

    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

/**
 图片旋转
 
 @param radians 需要旋转的角度
 @return UIImage
 */
- (nullable UIImage *)imageRotatedByRadians:(CGFloat)radians{
    return [self imageRotatedByDegrees:KKRadiansToDegrees(radians)];
}

/**
 图片旋转
 
 @param degrees 需要旋转的角度
 @return UIImage
 */
- (nullable UIImage *)imageRotatedByDegrees:(CGFloat)degrees{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(KKDegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, KKDegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

/**
 图片缩放
 
 @param scale 缩放的比例
 @return UIImage
 */
- (nullable UIImage*)convertImageToScale:(double)scale{
    CGSize newImageSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(newImageSize, 1.0, 1.0);
    //    UIGraphicsBeginImageContext(newImageSize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0,0, newImageSize.width, newImageSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

/**
 * 5.对图片进行滤镜处理
 */
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (nonnull UIImage *)filterWithOriginalImage:(nullable UIImage *)image
                                  filterName:(nullable NSString *)name{
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}


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
                                     radius:(NSInteger)radius{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter;
    if (name.length != 0) {
        filter = [CIFilter filterWithName:name];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        if (![name isEqualToString:@"CIMedianFilter"]) {
            [filter setValue:@(radius) forKey:@"inputRadius"];
        }
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return resultImage;
    }
    else{
        return nil;
    }
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (nullable UIImage*)createRoundedRectImage:(nullable UIImage*)image
                                       size:(CGSize)size
                                     radius:(NSInteger)radius
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

@end
