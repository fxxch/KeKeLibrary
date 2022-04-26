//
//  UIView+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIView+KKCategory.h"
#import <objc/runtime.h>
#import "UIColor+KKCategory.h"
#import "KKView.h"
#import "CALayer+KKCategory.h"
#import "KKLibraryDefine.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

#define CAGradientLayerTag 2019093001

@implementation UIView (KKCategory)
@dynamic kk_tagInfo;
@dynamic kk_CornerRadius;
@dynamic kk_CornerRadiusType;

+ (UIView *)loadLineViewWithLineColor:(UIColor *)color andWidth:(CGFloat)width andHeight:(CGFloat)height{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    view.backgroundColor = color;
    
    return view;
}

#pragma mark ==================================================
#pragma mark == viewWillAppear、viewWillHidden
#pragma mark ==================================================
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL sys_SEL = @selector(setHidden:);
        SEL my_SEL = @selector(kk_setHidden:);
        
        Method sys_Method   = class_getInstanceMethod(self, sys_SEL);
        Method my_Method    = class_getInstanceMethod(self, my_SEL);

//        method_exchangeImplementations(sys_Method, my_Method);

        BOOL didAddMethod = class_addMethod([self class],
                                            sys_SEL,
                                            method_getImplementation(my_Method),
                                            method_getTypeEncoding(my_Method));

        if (didAddMethod) {
            class_replaceMethod([self class],
                                my_SEL,
                                method_getImplementation(sys_Method),
                                method_getTypeEncoding(sys_Method));
        }
        method_exchangeImplementations(sys_Method, my_Method);

        
        SEL sys_SEL_Frame = @selector(setFrame:);
        SEL my_SEL_Frame = @selector(kk_setFrame:);
        
        Method sys_Method_Frame   = class_getInstanceMethod(self, sys_SEL_Frame);
        Method my_Method_Frame    = class_getInstanceMethod(self, my_SEL_Frame);
        
//        method_exchangeImplementations(sys_Method, my_Method);
        
        BOOL didAddMethod_Frame = class_addMethod([self class],
                                                  sys_SEL_Frame,
                                                  method_getImplementation(my_Method_Frame),
                                                  method_getTypeEncoding(my_Method_Frame));
        
        if (didAddMethod_Frame) {
            class_replaceMethod([self class],
                                my_SEL_Frame,
                                method_getImplementation(sys_Method_Frame),
                                method_getTypeEncoding(sys_Method_Frame));
        }
        method_exchangeImplementations(sys_Method_Frame, my_Method_Frame);
    });
}

- (void)kk_setFrame:(CGRect)frame{
    [self kk_setFrame:frame];
    if (self.kk_CornerRadiusType!=KKCornerRadiusType_None) {
        //边框
        CAShapeLayer *layer =  (CAShapeLayer*)[self.layer kk_layerWithTag:2018111101];
        if (layer) {
            [self kk_setCornerRadius:self.kk_CornerRadius type:self.kk_CornerRadiusType borderColor:[UIColor colorWithCGColor:layer.strokeColor] borderWidth:layer.lineWidth];
        }
        else {
            [self kk_setCornerRadius:self.kk_CornerRadius type:self.kk_CornerRadiusType borderColor:[UIColor colorWithCGColor:self.layer.borderColor] borderWidth:layer.lineWidth];
        }
    }
}

- (void)kk_setHidden:(BOOL)hidden{
    BOOL oldValue = [self isHidden];
    if (hidden!=oldValue) {
        [self viewWillHidden:hidden];        
        [self kk_setHidden:hidden];
    }
    else{
        [self kk_setHidden:hidden];
    }
}

- (void)viewWillHidden:(BOOL)hidden{
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[KKView class]] &&
            subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewWillAppear:)]) {
            [subView viewWillAppear:animated];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[KKView class]] &&
            subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewDidAppear:)]) {
            [subView viewDidAppear:animated];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[KKView class]] &&
            subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewWillDisappear:)]) {
            [subView viewWillDisappear:animated];
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[KKView class]] &&
            subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewDidDisappear:)]) {
            [subView viewDidDisappear:animated];
        }
    }
}

- (void)setKk_tagInfo:(id)kk_tagInfo{
    objc_setAssociatedObject(self, @"kk_tagInfo", kk_tagInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)kk_tagInfo {
    return objc_getAssociatedObject(self, @"kk_tagInfo");
}

- (void)setKk_CornerRadiusType:(KKCornerRadiusType)kk_CornerRadiusType{
    objc_setAssociatedObject(self, @"kk_CornerRadiusType", [NSNumber numberWithInteger:kk_CornerRadiusType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KKCornerRadiusType)kk_CornerRadiusType{
    NSNumber *kk_CornerRadiusType = objc_getAssociatedObject(self, @"kk_CornerRadiusType");
    return [kk_CornerRadiusType integerValue];
}

- (void)setKk_CornerRadius:(CGFloat)kk_CornerRadius{
    objc_setAssociatedObject(self, @"kk_CornerRadius", [NSNumber numberWithFloat:kk_CornerRadius], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)kk_CornerRadius{
    NSNumber *kk_CornerRadius = objc_getAssociatedObject(self, @"kk_CornerRadius");
    return [kk_CornerRadius integerValue];
}

#pragma mark ==================================================
#pragma mark == 截图
#pragma mark ==================================================
/**
 截图
 
 @return UIImage
 */
- (nullable UIImage *)kk_snapshot {

    UIImage *image_normal = [self kk_snapshotImage_normal];
    if (image_normal && [image_normal isKindOfClass:[UIImage class]]) {
        return image_normal;
    }
    else{
        UIImage *image_opengl = [self kk_snapshotImage_opengl];
        if (image_opengl && [image_opengl isKindOfClass:[UIImage class]]) {
            return image_opengl;
        }
        else{
            return nil;
        }
    }
}

/**
 ①普通的截图
 该API仅可以在未使用layer和OpenGL渲染的视图上使用
 这种是最最普通的截图，针对一般的视图上添加视图的情况，基本都可以使用。
 @return 截取的图片
 */
- (UIImage *)kk_snapshotImage_normal
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

/**
 ②针对有用过OpenGL渲染过的视图截图
 如果一些视图是用OpenGL渲染出来的，那么使用上面①的方式就无法截图到OpenGL渲染的部分，这时候就要用到改进后的截图方案②
 @return 截取的图片
 */
- (UIImage *)kk_snapshotImage_opengl
{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
    CGRect rect =  self.bounds;
    [self drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

/**
 截图
 ③以UIView 的形式返回(_UIReplicantView)
 有一些特殊的Layer（比如：AVCaptureVideoPreviewLayer 和 AVSampleBufferDisplayLayer） 添加到某个View 上后，使用上面的几种方式都无法截取到Layer上的内容，这个时候可以使用系统的一个API，但是该API只能返回一个UIView，返回的UIView 可以修改frame 等参数
 遗留问题：
 通过方式三截取的UIView，无法转换为UIImage，我试过将返回的截图View写入位图再转换成UIImage，但是返回的UIImage 要么为空，要么没有内容。如果有人知道解决方案请告知我。
 @return 截取出来的图片转换的视图
 */
- (UIView *)kk_snapshotImage_view
{
    UIView *snapView = [self snapshotViewAfterScreenUpdates:YES];
    return snapView;
}

#pragma mark ==================================================
#pragma mark == 从一个视频流的画面截图（视频流是openGL渲染的，无法常规截图）
#pragma mark ==================================================
/**
 使用OpenGL截图 获取一个view的截图,注意,只能截取能看的见的部分
 #import <OpenGLES/ES2/gl.h>
 #import <OpenGLES/ES2/glext.h>
 #import <GLKit/GLKit.h>
 @return image
 */
- (nullable UIImage *)kk_snapshotImage_fromOpenGLStreamView{
    int width = self.kk_width;//352; //视频宽度*3
    int height = self.kk_height;//288;//视频宽度*3
    
    NSInteger myDataLength = width * height * 4;
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width* 4; x++) {
            buffer2[(int)((height-1 - y) * width * 4 + x)] = buffer[(int)(y * 4 * width + x)];
        }
    }
    free(buffer);
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    //    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGBitmapInfo bitmapInfo = (CGBitmapInfo)kCGImageAlphaNoneSkipLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width , height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
    return myImage;
}

#pragma mark ==================================================
#pragma mark == 普通设置
#pragma mark ==================================================
- (void)kk_clearBackgroundColor {
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)kk_removeAllSubviews{
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
}

- (void)kk_setBackgroundImage:(nullable UIImage *)image {
    UIColor *color = [UIColor colorWithPatternImage:image];
    [self setBackgroundColor:color];
}

- (void)kk_setIndex:(NSInteger)index {
    if (self.superview != nil) {
        [self.superview insertSubview:self atIndex:index];
    }
}

- (void)kk_bringToFront {
    if (self.superview != nil) {
        [self.superview bringSubviewToFront:self];
    }
}

- (void)kk_sendToBack {
    if (self.superview != nil) {
        [self.superview sendSubviewToBack:self];
    }
}

- (nullable UIViewController *)kk_viewController {
    return (UIViewController *)[self kk_traverseResponderChainForUIViewController];
}

- (nullable id)kk_traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder kk_traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}


/**
 创建一个渐变色的View
 
 @param frame frame
 @param startHexColor 开始颜色
 @param endHexColor 结束颜色
 @return 结果
 */
- (id)initWithFrame:(CGRect)frame
      startHexColor:(nullable NSString*)startHexColor
        endHexColor:(nullable NSString*)endHexColor{
    
    self = [self initWithFrame:frame];
    if (self) {
        if (startHexColor && endHexColor) {
            CAGradientLayer *gLayer = [CAGradientLayer layer];
            gLayer.kk_tag = CAGradientLayerTag;
            gLayer.frame = self.bounds;
            gLayer.colors =     [NSArray arrayWithObjects:
                                 (id)[UIColor kk_colorWithHexString:startHexColor].CGColor,
                                 (id)[UIColor kk_colorWithHexString:endHexColor].CGColor, nil];
            
            [self.layer insertSublayer:gLayer atIndex:0];

        }
        else{
            self.backgroundColor = [UIColor darkGrayColor];
        }
    }
    return self;
}

- (void)kk_setBackgroundColorFromColor:(nullable UIColor*)startUIColor
                               toColor:(nullable UIColor*)endUIColor
                             direction:(UIViewGradientColorDirection)direction{
    
    if (! (startUIColor && endUIColor)) {
        return;
    }
    
    CALayer *layer = [self.layer kk_layerWithTag:CAGradientLayerTag];
    [layer removeFromSuperlayer];
    
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.kk_tag = CAGradientLayerTag;
    gLayer.colors =     [NSArray arrayWithObjects:
                         (id)startUIColor.CGColor,
                         (id)endUIColor.CGColor, nil];
    
    if (direction==UIViewGradientColorDirection_TopBottom) {
        gLayer.frame = self.bounds;
    }
    else if (direction==UIViewGradientColorDirection_BottomTop){
        gLayer.frame = self.bounds;
        [gLayer setValue:[NSNumber numberWithDouble:M_PI] forKeyPath:@"transform.rotation.z"];
    }
    else if (direction==UIViewGradientColorDirection_LeftRight){
        gLayer.frame = CGRectMake(-(self.frame.size.height/2.0-self.frame.size.width/2.0), self.frame.size.height/2.0-self.frame.size.width/2.0, self.bounds.size.height, self.bounds.size.width);
        [gLayer setValue:[NSNumber numberWithDouble:-M_PI/2] forKeyPath:@"transform.rotation.z"];
    }
    else if (direction==UIViewGradientColorDirection_RightLeft){
        gLayer.frame = CGRectMake(-(self.frame.size.height/2.0-self.frame.size.width/2.0), self.frame.size.height/2.0-self.frame.size.width/2.0, self.bounds.size.height, self.bounds.size.width);
        [gLayer setValue:[NSNumber numberWithDouble:M_PI/2] forKeyPath:@"transform.rotation.z"];
    }
    else{
        gLayer.frame = self.bounds;
        [gLayer setValue:[NSNumber numberWithDouble:M_PI/2] forKeyPath:@"transform.rotation.z"];
    }
    
    [self.layer insertSublayer:gLayer atIndex:0];
    [gLayer setNeedsLayout];
    [gLayer setNeedsDisplay];
}

#pragma mark ==================================================
#pragma mark == 设置遮罩相关UIBezierPath
#pragma mark ==================================================
@dynamic kk_bezierPath;

- (void)setKk_bezierPath:(UIBezierPath *)kk_bezierPath{
    objc_setAssociatedObject(self, @"kk_bezierPath", kk_bezierPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIBezierPath *)kk_bezierPath {
    return objc_getAssociatedObject(self, @"kk_bezierPath");
}

- (void)kk_setMaskWithPath:(nullable UIBezierPath*)path {
    [self kk_setMaskWithPath:path borderColor:[UIColor colorWithCGColor:self.layer.borderColor] borderWidth:self.layer.borderWidth];
}

- (void)kk_setMaskWithPath:(nullable UIBezierPath*)path
               borderColor:(nullable UIColor*)borderColor
               borderWidth:(float)borderWidth{
    
    self.kk_bezierPath = path;
    
    //路径
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path CGPath];
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
    
    //边框
    if (borderColor && borderWidth>0) {

        CALayer *layer =  [self.layer kk_layerWithTag:2018111101];
        [layer removeFromSuperlayer];

        CAShapeLayer *maskBorderLayer = [[CAShapeLayer alloc] init];
        maskBorderLayer.kk_tag = 2018111101;
        maskBorderLayer.path = [path CGPath];
        maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
        maskBorderLayer.strokeColor = [borderColor CGColor];
        maskBorderLayer.lineWidth = borderWidth;
        [self.layer addSublayer:maskBorderLayer];
    }
}

- (BOOL)kk_containsPoint:(CGPoint)point{
    if (self.kk_bezierPath) {
        return [[self kk_bezierPath] containsPoint:point];
    }
    else{
        return [self kk_containsPoint:point];
    }
}

#pragma mark ==================================================
#pragma mark == 设置圆角（计算UIBezierPath+边框颜色+边框粗细）、设置遮罩
#pragma mark ==================================================
/*
 这个实现方法里maskToBounds会触发离屏渲染(offscreen rendering)，GPU在当前屏幕缓冲区外新开辟一个渲染缓冲区进行工作，也就是离屏渲染，这会给我们带来额外的性能损耗，如果这样的圆角操作达到一定数量，会触发缓冲区的频繁合并和上下文的的频繁切换，性能的代价会宏观地表现在用户体验上<掉帧>不建议使用.
 */
- (void)kk_setCornerRadius:(CGFloat)radius {
    //只需要设置layer层的两个属性
    //设置圆角
    self.layer.cornerRadius = radius;
    //将多余的部分切掉
    self.layer.masksToBounds = YES;
    //    [self setCornerRadius:radius type:KKCornerRadiusType_All];
}

- (void)kk_setCornerRadius:(CGFloat)radius
                      type:(KKCornerRadiusType)aType{
    //边框
    CAShapeLayer *layer =  (CAShapeLayer*)[self.layer kk_layerWithTag:2018111101];
    if (layer) {
        [self kk_setCornerRadius:radius type:aType borderColor:[UIColor colorWithCGColor:layer.strokeColor] borderWidth:layer.lineWidth];
    }
    else{
        CGFloat borderWidth = self.layer.borderWidth;
        if (borderWidth>0.2) {
            NSString *borderColor = [UIColor kk_hexStringFromColor:[UIColor colorWithCGColor:self.layer.borderColor]];
            [self kk_setBorderColor:nil width:0];
            [self kk_setCornerRadius:radius type:aType borderColor:[UIColor colorWithCGColor:self.layer.borderColor] borderWidth:self.layer.borderWidth];
            [self kk_setBorderColor:[UIColor kk_colorWithHexString:borderColor] width:borderWidth];
        }
        else{
            [self kk_setCornerRadius:radius type:aType borderColor:[UIColor colorWithCGColor:self.layer.borderColor] borderWidth:self.layer.borderWidth];
        }
    }
}

- (void)kk_setCornerRadius:(CGFloat)radius
                      type:(KKCornerRadiusType)aType
               borderColor:(nullable UIColor*)borderColor
               borderWidth:(float)borderWidth{

    KKCornerRadiusType inType = aType;
    if (inType==KKCornerRadiusType_All) {
        inType = KKCornerRadiusType_LeftTop |
        KKCornerRadiusType_RightTop |
        KKCornerRadiusType_RightBottom |
        KKCornerRadiusType_LeftBottom;
    }
    self.kk_CornerRadiusType = inType;
    self.kk_CornerRadius = radius;
    
    CGRect frame = self.bounds;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat CornerRadius = radius;

    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
//    bezierPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:(UIRectCorner) cornerRadii:<#(CGSize)#>];
        
    //    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
    //    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
    if (inType==KKCornerRadiusType_None) {

        [bezierPath moveToPoint: CGPointMake(0, 0)];
        [bezierPath addLineToPoint: CGPointMake(width, 0)];
        [bezierPath addLineToPoint: CGPointMake(width, height)];
        [bezierPath addLineToPoint: CGPointMake(0, height)];
        [bezierPath addLineToPoint: CGPointMake(0, 0)];
        [bezierPath closePath];
    }
    else{
        //左上角
        if ((inType & KKCornerRadiusType_LeftTop) == KKCornerRadiusType_LeftTop) {
            [bezierPath moveToPoint: CGPointMake(0, CornerRadius)];
            [bezierPath addArcWithCenter:CGPointMake(CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.0*M_PI) endAngle:(1.5*M_PI) clockwise:YES];
            [bezierPath addLineToPoint: CGPointMake(CornerRadius, 0)];
        }
        else{
            [bezierPath moveToPoint: CGPointMake(0, CornerRadius)];
            [bezierPath addLineToPoint: CGPointMake(0, 0)];
            [bezierPath addLineToPoint: CGPointMake(CornerRadius, 0)];
        }
        
        //右上角
        if ((inType & KKCornerRadiusType_RightTop) == KKCornerRadiusType_RightTop) {
            [bezierPath addLineToPoint: CGPointMake(width-CornerRadius, 0)];
            [bezierPath addArcWithCenter:CGPointMake(width-CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.5*M_PI) endAngle:(0*M_PI) clockwise:YES];
            [bezierPath addLineToPoint: CGPointMake(width, CornerRadius)];
        }
        else{
            [bezierPath addLineToPoint: CGPointMake(width-CornerRadius, 0)];
            [bezierPath addLineToPoint: CGPointMake(width, 0)];
            [bezierPath addLineToPoint: CGPointMake(width, CornerRadius)];
        }
        
        //右下角
        if ((inType & KKCornerRadiusType_RightBottom) == KKCornerRadiusType_RightBottom) {
            [bezierPath addLineToPoint: CGPointMake(width, height-CornerRadius)];
            [bezierPath addArcWithCenter:CGPointMake(width-CornerRadius, height-CornerRadius) radius:CornerRadius startAngle:(0*M_PI) endAngle:(0.5*M_PI) clockwise:YES];
            [bezierPath addLineToPoint: CGPointMake(width-CornerRadius, height)];
        }
        else{
            [bezierPath addLineToPoint: CGPointMake(width, height-CornerRadius)];
            [bezierPath addLineToPoint: CGPointMake(width, height)];
            [bezierPath addLineToPoint: CGPointMake(width-CornerRadius, height)];
        }
        
        //左下角
        if ((inType & KKCornerRadiusType_LeftBottom) == KKCornerRadiusType_LeftBottom) {
            [bezierPath addLineToPoint: CGPointMake(CornerRadius, height)];
            [bezierPath addArcWithCenter:CGPointMake(CornerRadius, height-CornerRadius) radius:CornerRadius startAngle:(0.5*M_PI) endAngle:(1.0*M_PI) clockwise:YES];
            [bezierPath addLineToPoint: CGPointMake(0, height-CornerRadius)];
        }
        else{
            [bezierPath addLineToPoint: CGPointMake(CornerRadius, height)];
            [bezierPath addLineToPoint: CGPointMake(0, height)];
            [bezierPath addLineToPoint: CGPointMake(0, height-CornerRadius)];
        }
        
        //结束
        [bezierPath addLineToPoint: CGPointMake(0, CornerRadius)];
        
        [bezierPath closePath];
    }
    
    [self kk_setMaskWithPath:bezierPath borderColor:borderColor borderWidth:borderWidth];
}


#pragma mark ==================================================
#pragma mark == 设置边框（①如果有另外UIBezierPath、设置遮罩，②否则就设置默认）
#pragma mark ==================================================
- (void)kk_setBorderColor:(nullable UIColor *)color
                    width:(CGFloat)width {
    if (self.kk_bezierPath) {
        [self kk_setMaskWithPath:self.kk_bezierPath borderColor:color borderWidth:width];
    }
    else{
        [self.layer setBorderWidth:width];
        [self.layer setBorderColor:color.CGColor];
    }
}

#pragma mark ==================================================
#pragma mark == 设置阴影
#pragma mark ==================================================
- (void)kk_setShadowColor:(nullable UIColor *)color
                  opacity:(CGFloat)opacity
                   offset:(CGSize)offset
               blurRadius:(CGFloat)blurRadius
               shadowPath:(nullable CGPathRef)shadowPath{
    
    /*通过设置1.2.3步导航阴影就可以出现,如果对阴影有特别的需要,可再设置4.5这两个步骤.*/
    
    //1.设置阴影颜色
    [self.layer setShadowColor:color.CGColor];
    //2.设置阴影颜色的透明度
    [self.layer setShadowOpacity:opacity];
    //3.设置阴影偏移范围
    [self.layer setShadowOffset:offset];
    //4.设置阴影半径
    [self.layer setShadowRadius:blurRadius];
    //5.设置阴影路径
    if (shadowPath) {
        self.layer.shadowPath = shadowPath;
        //        aView.layer.shadowPath = [UIBezierPath bezierPathWithRect:aView.bounds].CGPath;
    }
    self.clipsToBounds = NO;
}

#pragma mark ==================================================
#pragma mark == 设置虚线
#pragma mark ==================================================
/**
 设置虚线
 
 @param strokeColor 虚线的颜色
 @param lineWidth 虚线的宽度
 @param lineDashPattern 虚线的间隔
 */
- (void)kk_setDottedLineWithStrokeColor:(UIColor *)strokeColor
                              lineWidth:(CGFloat)lineWidth
                        lineDashPattern:(NSArray<NSNumber *> *)lineDashPattern{
    
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = strokeColor.CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = lineWidth;
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = lineDashPattern;//@[@4, @2];
    
    [self.layer addSublayer:border];
}

#pragma mark ==================================================
#pragma mark == frame相关
#pragma mark ==================================================
- (CGPoint)kk_topLeft{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGPoint)kk_topRight{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGPoint)kk_bottomLeft{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)kk_bottomRight{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGFloat)kk_width{
    return self.frame.size.width;
}

- (void)kk_setWidth: (CGFloat) newwidth{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat)kk_height{
    return self.frame.size.height;
}

- (void)kk_setHeight: (CGFloat) newheight{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat)kk_left{
    return self.frame.origin.x;
}

- (void)kk_setLeft: (CGFloat) newleft{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)kk_right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)kk_setRight: (CGFloat) newright{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGFloat)kk_top{
    return self.frame.origin.y;
}

- (void)kk_setTop: (CGFloat) newtop{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat)kk_bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)kk_setBottom: (CGFloat) newbottom{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)kk_centerX{
    return self.center.x;
}

- (void)kk_setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)kk_centerY{
    return self.center.y;
}

- (void)kk_setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

#pragma mark ==================================================
#pragma mark == 缩放动画
#pragma mark ==================================================
- (void)kk_showZoomAnimation{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];

    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85, 0.85, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    [self.layer addAnimation:animation forKey:nil];
}

@end
