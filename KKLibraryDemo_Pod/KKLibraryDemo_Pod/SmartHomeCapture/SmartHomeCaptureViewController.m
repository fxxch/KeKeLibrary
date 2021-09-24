//
//  SmartHomeCaptureViewController.m
//  KKLibraryDemo_Pod
//
//  Created by liubo on 2021/7/13.
//

#import "SmartHomeCaptureViewController.h"
#import "SmartHomeCaptureView.h"
#import <KeKeLibrary/KeKeLibrary.h>

@interface SmartHomeCaptureViewController ()

@property (nonatomic , strong) SmartHomeCaptureView *videoView;
@property (nonatomic , strong) NSTimer *myTimer;

@end

@implementation SmartHomeCaptureViewController

- (void)dealloc
{
    if (self.myTimer) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"SmartHomeCapture";
    
    self.videoView = [[SmartHomeCaptureView alloc] initWithFrame:CGRectMake(15, 15+KKStatusBarAndNavBarHeight, KKScreenWidth-30, 160)];
    [self.view addSubview:self.videoView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.myTimer==nil) {
        KKWeakSelf(self);
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 block:^{
            [weakself myTimerRunLoop];
        } repeats:YES];
    }
}

- (void)myTimerRunLoop{

    UIImage *imageData = [self nomalSnapshotImage];

    for (NSInteger i=0; i<5; i++) {
        NSInteger randomX = [NSNumber randomIntegerBetween:0 and:self.videoView.frame.size.width];
        NSInteger randomY = [NSNumber randomIntegerBetween:0 and:self.videoView.frame.size.height];
        UIColor *color = [self getPixelColorAtLocation:CGPointMake(randomX, randomY) inImage:imageData];
        NSArray *RGB = [UIColor RGBAValue:color];
        float rValue = [[RGB objectAtIndex_Safe:0] floatValue]*255;
        float gValue = [[RGB objectAtIndex_Safe:1] floatValue]*255;
        float bValue = [[RGB objectAtIndex_Safe:2] floatValue]*255;
        NSLog(@"R:%d G:%d B:%d",(unsigned int)rValue,(unsigned int)gValue,(unsigned int)bValue);
    }
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point inImage:(UIImage*)aImage{
    UIColor* color = nil;
    CGImageRef inImage = aImage.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil; /* error */ }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            //NSLog(@"offset: %d", offset);
            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            //NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
            
        }
        
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
        {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
        }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
        {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
        }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
        {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

///**
// 截图
//
// @return UIImage
// */
//- (nullable UIImage *)snapshotWWW {
//
//    //2015-05-14 刘波
//    // 使用上下文截图,并使用指定的区域裁剪,模板代码
//    // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
//    UIGraphicsBeginImageContextWithOptions(self.videoView.bounds.size, YES, 0.0);
//    // 要裁剪的矩形范围
//    CGRect rect = self.videoView.bounds;
//    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
//
//    [self drawViewHierarchyInRect:rect afterScreenUpdates:YES];
//    // 从上下文中,取出UIImage
//    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
//
//    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
//    UIGraphicsEndImageContext();
//
//    // 添加截取好的图片到图片数组
//    if (snapshot) {
//        //self.lastVCScreenShotImg = snapshot;
//        return snapshot;
//    }
//    else{
//        return nil;
//    }
//}

#pragma mark ==================================================
#pragma mark == 截图
#pragma mark ==================================================
/**
 普通的截图
 该API仅可以在未使用layer和OpenGL渲染的视图上使用
 
 @return 截取的图片
 */
- (UIImage *)nomalSnapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.videoView.frame.size,NO,[UIScreen mainScreen].scale);
    [self.videoView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

/**
 针对有用过OpenGL渲染过的视图截图
 
 @return 截取的图片
 */
- (UIImage *)openglSnapshotImage
{
    CGSize size = self.videoView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
    CGRect rect =  self.videoView.frame;
    [self.videoView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

/**
 截图
 以UIView 的形式返回(_UIReplicantView)
 
 @return 截取出来的图片转换的视图
 */
- (UIView *)snapshotView
{
    UIView *snapView = [self.videoView snapshotViewAfterScreenUpdates:YES];
    return snapView;
}

@end
