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

@implementation UIView (KKCategory)
@dynamic tagInfo;

#pragma mark ==================================================
#pragma mark == viewWillAppear、viewWillHidden
#pragma mark ==================================================
+ (void)load{
    
    Method sys_Method = class_getInstanceMethod(self, @selector(setHidden:));
    Method my_Method = class_getInstanceMethod(self, @selector(kk_setHidden:));
    
    method_exchangeImplementations(sys_Method, my_Method);
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
//    NSLog(@"%@ %s",NSStringFromClass([self class]),__FUNCTION__);
    
}

- (void)viewWillAppear:(BOOL)animated{
//    NSLog(@"%@ %s",NSStringFromClass([self class]),__FUNCTION__);
    
    for (UIView *subView in [self subviews]) {
        if (subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewWillAppear:)]) {
            [subView viewWillAppear:animated];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
//    NSLog(@"%@ %s",NSStringFromClass([self class]),__FUNCTION__);
    
    for (UIView *subView in [self subviews]) {
        if (subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewDidAppear:)]) {
            [subView viewDidAppear:animated];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
//    NSLog(@"%@ %s",NSStringFromClass([self class]),__FUNCTION__);
    
    for (UIView *subView in [self subviews]) {
        if (subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewWillDisappear:)]) {
            [subView viewWillDisappear:animated];
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
//    NSLog(@"%@ %s",NSStringFromClass([self class]),__FUNCTION__);
    
    for (UIView *subView in [self subviews]) {
        if (subView.hidden==NO &&
            [subView respondsToSelector:@selector(viewDidDisappear:)]) {
            [subView viewDidDisappear:animated];
        }
    }
}


- (void)setTagInfo:(id)tagInfo{
    objc_setAssociatedObject(self, @"tagInfo", tagInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)tagInfo {
    return objc_getAssociatedObject(self, @"tagInfo");
}

#pragma mark ==================================================
#pragma mark == 普通设置
#pragma mark ==================================================
/**
 截图
 
 @return UIImage
 */
- (nullable UIImage *)snapshot {
    //2014-10-20 刘波
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //    if (UIGraphicsBeginImageContextWithOptions != NULL) {
    //        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    //    } else {
    //        UIGraphicsBeginImageContext(self.bounds.size);
    //    }
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)clearBackgroundColor {
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)removeAllSubviews{
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
}

- (void)setBackgroundImage:(nullable UIImage *)image {
    UIColor *color = [UIColor colorWithPatternImage:image];
    [self setBackgroundColor:color];
}

- (void)setIndex:(NSInteger)index {
    if (self.superview != nil) {
        [self.superview insertSubview:self atIndex:index];
    }
}

- (void)bringToFront {
    if (self.superview != nil) {
        [self.superview bringSubviewToFront:self];
    }
}

- (void)sendToBack {
    if (self.superview != nil) {
        [self.superview sendSubviewToBack:self];
    }
}

- (void)setBorderColor:(nullable UIColor *)color
                 width:(CGFloat)width {
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:color.CGColor];
}

- (void)setCornerRadius:(CGFloat)radius {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
}

- (void)setShadowColor:(nullable UIColor *)color
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

- (nullable UIViewController *)viewController {
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (nullable id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
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
- (id)initWithFrame:(CGRect)frame startHexColor:(nullable NSString*)startHexColor
        endHexColor:(nullable NSString*)endHexColor{
    
    self = [self initWithFrame:frame];
    if (self) {
        if (startHexColor && endHexColor) {
            CAGradientLayer *gLayer = [CAGradientLayer layer];
            gLayer.frame = self.bounds;
            gLayer.colors =     [NSArray arrayWithObjects:
                                 (id)[UIColor colorWithHexString:startHexColor].CGColor,
                                 (id)[UIColor colorWithHexString:endHexColor].CGColor, nil];
            [self.layer insertSublayer:gLayer atIndex:0];
        }
        else{
            self.backgroundColor = [UIColor darkGrayColor];
        }
    }
    return self;
}

- (void)setBackgroundColorFromColor:(nullable UIColor*)startUIColor
                            toColor:(nullable UIColor*)endUIColor
                          direction:(UIViewGradientColorDirection)direction{
    
    if (! (startUIColor && endUIColor)) {
        return;
    }
    
    if ([[self.layer sublayers] count]>0 &&  [[[self.layer sublayers] objectAtIndex:0] isKindOfClass:[CAGradientLayer class]]) {
        [[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
    }
    
    
    CAGradientLayer *gLayer = [CAGradientLayer layer];
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
    [gLayer setNeedsDisplay];
}

#pragma mark ==================================================
#pragma mark == 设置遮罩相关
#pragma mark ==================================================
@dynamic bezierPath;

- (void)setBezierPath:(UIBezierPath *)bezierPath{
    objc_setAssociatedObject(self, @"bezierPath", bezierPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIBezierPath *)bezierPath {
    return objc_getAssociatedObject(self, @"bezierPath");
}

- (void)setMaskWithPath:(nullable UIBezierPath*)path {
    [self setBezierPath:path];
    [self setMaskWithPath:path withBorderColor:nil borderWidth:0];
}

- (void)setMaskWithPath:(nullable UIBezierPath*)path withBorderColor:(nullable UIColor*)borderColor borderWidth:(float)borderWidth{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path CGPath];
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
    
    if (borderColor && borderWidth>0) {
        NSMutableArray *oldLayers = [NSMutableArray array];
        for (CALayer *layer in [self.layer sublayers]) {
            if ([layer isKindOfClass:[CAShapeLayer class]]) {
                [oldLayers addObject:layer];
            }
        }
        
        for (NSInteger i=0; i<[oldLayers count]; i++) {
            CALayer *layer = (CALayer*)[oldLayers objectAtIndex:i];
            [layer removeFromSuperlayer];
        }
        
        CAShapeLayer *maskBorderLayer = [[CAShapeLayer alloc] init];
        maskBorderLayer.path = [path CGPath];
        maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
        maskBorderLayer.strokeColor = [borderColor CGColor];
        maskBorderLayer.lineWidth = borderWidth;
        [self.layer addSublayer:maskBorderLayer];
    }
}

- (BOOL)containsPoint:(CGPoint)point{
    return [[self bezierPath] containsPoint:point];
}


#pragma mark ==================================================
#pragma mark == frame相关
#pragma mark ==================================================
- (CGPoint) topLeft{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGPoint) topRight{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomRight{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGFloat) width{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) height{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) left{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGFloat) top{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}



//=================frame相关=================

@end
