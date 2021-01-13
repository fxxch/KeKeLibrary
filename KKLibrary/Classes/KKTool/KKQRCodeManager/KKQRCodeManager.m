//
//  KKQRCodeManager.m
//  BM
//
//  Created by sjyt on 2020/1/10.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKQRCodeManager.h"
#import "KKCategory.h"
#import "KKQRCodeScanViewController.h"

@interface KKQRCodeManager ()<KKQRCodeScanViewControllerDelagete>

@property (nonatomic , weak) UINavigationController *navigationController;
@property (nonatomic , weak) KKQRCodeScanViewController *scanner;
@property (nonatomic , assign) BOOL forPresent;
@property (nonatomic , weak) id<KKQRCodeScanDelegate> delegate;

@end

@implementation KKQRCodeManager

+ (KKQRCodeManager*_Nonnull)defaultManager{
    static KKQRCodeManager *KKQRCodeManager_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKQRCodeManager_default = [[self alloc] init];
    });
    return KKQRCodeManager_default;
}

- (void)showScannerWithDelegate:(id<KKQRCodeScanDelegate>_Nonnull)aDelegate
       fromNavigationController:(UINavigationController*_Nonnull)aNavigationController
                     forPresent:(BOOL)aForPresent{
    self.navigationController = aNavigationController;
    self.forPresent = aForPresent;
    self.delegate = aDelegate;
    
    KKQRCodeScanViewController *viewController = [[KKQRCodeScanViewController alloc] init];
    viewController.delegate = self;
    self.scanner = viewController;
    if (self.forPresent) {
        if ([UIDevice isSystemVersionBigerThan:@"13.0"]) {
            viewController.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [self.navigationController presentViewController:viewController animated:YES completion:^{
            
        }];
    }
    else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)startScan{
    [self.scanner startScan];
}

- (void)closeScanner{
    if (self.forPresent) {
        [self.scanner willPush];
        [self.scanner dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(KKQRCodeScan_ScannerDismissFinished)]) {
                [self.delegate KKQRCodeScan_ScannerDismissFinished];
            }
        }];
    } else {
        NSMutableArray *newArray = [NSMutableArray array];
        for (UIViewController *viewCon in self.navigationController.viewControllers) {
            if (viewCon != self.scanner) {
                [newArray addObject:viewCon];
            }
        }
        [self.scanner willPush];
        [self.navigationController setViewControllers:newArray animated:YES];
    }
    [self invalidate];
}

- (void)invalidate{
    self.delegate = nil;
    self.scanner = nil;
    self.navigationController = nil;
}

#pragma mark ==================================================
#pragma mark == KKQRCodeScanViewControllerDelagete
#pragma mark ==================================================
- (void)KKQRCodeScanViewController_FinishedWithQRCodeValue:(NSString*_Nonnull)aQRCodeValue{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKQRCodeScan_FinishedWithQRCodeValue:)]) {
        [self.delegate KKQRCodeScan_FinishedWithQRCodeValue:aQRCodeValue];
    }
}

- (void)KKQRCodeScanViewController_NavletfButtonClicked{
    if (self.forPresent) {
        [self.scanner dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(KKQRCodeScan_ScannerDismissFinished)]) {
                [self.delegate KKQRCodeScan_ScannerDismissFinished];
            }
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark ==================================================
#pragma mark == 生成二维码
#pragma mark ==================================================
+ (UIImage*_Nonnull)makeQRCodeWithString:(NSString*_Nonnull)aMessageString centerImage:(UIImage*_Nullable)aCenterImage{
    
    //创建名为"CIQRCodeGenerator"的CIFilter
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //将filter所有属性设置为默认值
    [filter setDefaults];
    
    //将所需尽心转为UTF8的数据，并设置给filter
    NSData *data = [aMessageString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    /*
     * L: 7%
     * M: 15%
     * Q: 25%
     * H: 30%
     */
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    //拿到二维码图片，此时的图片不是很清晰，需要二次加工
    CIImage *outPutImage = [filter outputImage];
    UIImage *hdimage = [KKQRCodeManager getHDImgWithCIImage:outPutImage size:CGSizeMake(KKApplicationWidth, KKApplicationWidth)];
    if (aCenterImage) {
        //给头像加一个白色圆边（如果没有这个需求直接忽略）
        UIImage *centerCircleImage = [KKQRCodeManager circleImageWithImage:aCenterImage borderWidth:50 borderColor:[UIColor whiteColor]];
        //合成图片
        UIImage *resultImage = [KKQRCodeManager syntheticImage:hdimage iconImage:centerCircleImage width:100 height:100];
        return resultImage;
    }
    else{
        return hdimage;
    }
}

/**
 调整二维码清晰度
 
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */
+ (UIImage*_Nonnull)getHDImgWithCIImage:(CIImage *_Nonnull)img size:(CGSize)size {
    
    //二维码的颜色
    UIColor *pointColor = [UIColor blackColor];
    //背景颜色
    UIColor *backgroundColor = [UIColor whiteColor];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage", img,
                             @"inputColor0", [CIColor colorWithCGColor:pointColor.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}



/**
 给图片加边框

 @param aImage 原始图片
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return 结果图片
 */
+ (UIImage*_Nonnull)circleImageWithImage:(UIImage *_Nonnull)aImage
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(UIColor *)borderColor{
    
    CGFloat imageWidth = aImage.size.width + 2 * borderWidth;
    CGFloat imageHeight = aImage.size.height + 2 * borderWidth;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), NO, 0.0);
    UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(borderWidth, borderWidth, aImage.size.width, aImage.size.height);

    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:80.0];
//    CGFloat radius = MIN(imageWidth, imageHeight) * 0.5;
//    CGPoint point = CGPointMake(imageWidth * 0.5, imageHeight * 0.5);
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point
//                                                              radius:radius
//                                                          startAngle:0
//                                                            endAngle:M_PI * 2
//                                                           clockwise:YES];
    bezierPath.lineWidth = borderWidth;
    bezierPath.lineCapStyle  = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineCapRound;
    [borderColor setStroke];
    [bezierPath stroke];
    [bezierPath addClip];
    [aImage drawInRect:rect];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return returnImage;
}

+ (UIImage*_Nonnull)syntheticImage:(UIImage*_Nonnull)aImage
                 iconImage:(UIImage*_Nullable)aIconImage
                     width:(CGFloat)width
                    height:(CGFloat)height{
    
    //开启图片上下文
    UIGraphicsBeginImageContext(aImage.size);
    //绘制背景图片
    [aImage drawInRect:CGRectMake(0, 0, aImage.size.width, aImage.size.height)];
    CGFloat x = (aImage.size.width - width) * 0.5;
    CGFloat y = (aImage.size.height - height) * 0.5;
    [aIconImage drawInRect:CGRectMake(x, y, width, height)];
    //取出绘制好的图片
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    //返回合成好的图片
    return returnImage;
}


#pragma mark ==================================================
#pragma mark == 主题
#pragma mark ==================================================
+ (UIImage*_Nullable)themeImageForName:(NSString*_Nullable)aImageName{
    UIImage *image = [NSBundle imageInBundle:@"KKQRCodeManager.bundle" imageName:aImageName];
    return image;
}


@end
