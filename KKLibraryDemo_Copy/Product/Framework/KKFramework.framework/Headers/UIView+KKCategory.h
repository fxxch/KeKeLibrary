//
//  UIView+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KKCategory)

/**
 *  渐进色的方向
 */
typedef NS_ENUM(NSInteger,UIViewGradientColorDirection) {
    
    UIViewGradientColorDirection_TopBottom = 0,/* 从上到下 */
    
    UIViewGradientColorDirection_BottomTop = 1,/* 从下到上 */
    
    UIViewGradientColorDirection_LeftRight = 2,/* 从左到右 */

    UIViewGradientColorDirection_RightLeft = 3,/* 从右到左 */

};

/**
 *  圆角的位置
 */
typedef NS_OPTIONS(NSUInteger, KKCornerRadiusType) {
    KKCornerRadiusType_None          =  0,//左上角
    KKCornerRadiusType_LeftTop       = 1 << 0,//左上角
    KKCornerRadiusType_RightTop      = 1 << 1,//右上角
    KKCornerRadiusType_RightBottom   = 1 << 2,//右下角
    KKCornerRadiusType_LeftBottom    = 1 << 3,//左下角
    KKCornerRadiusType_All           = 1 << 4,//全部
};


@property (nonatomic,strong) id _Nullable tagInfo;
@property (nonatomic,assign) KKCornerRadiusType kk_CornerRadiusType;
@property (nonatomic,assign) CGFloat kk_CornerRadius;

+ (UIView *_Nullable)loadLineViewWithLineColor:(UIColor *_Nullable)color andWidth:(CGFloat)width andHeight:(CGFloat)height;

#pragma mark ==================================================
#pragma mark == viewWillAppear、viewWillHidden
#pragma mark ==================================================
- (void)viewWillHidden:(BOOL)hidden;

- (void)viewWillAppear:(BOOL)animated;

- (void)viewDidAppear:(BOOL)animated;

- (void)viewWillDisappear:(BOOL)animated;

- (void)viewDidDisappear:(BOOL)animated;

#pragma mark ==================================================
#pragma mark == 普通设置
#pragma mark ==================================================
/**
 截图
 
 @return UIImage
 */
- (nullable UIImage *)snapshot;

- (void)clearBackgroundColor;

- (void)removeAllSubviews;

- (void)setBackgroundImage:(nullable UIImage *)image;

- (void)setIndex:(NSInteger)index;

- (void)bringToFront;

- (void)sendToBack;

- (nullable UIViewController *)viewController;

/**
 创建一个渐变色的View
 
 @param frame frame
 @param startHexColor 开始颜色
 @param endHexColor 结束颜色
 @return 结果
 */
- (nullable id)initWithFrame:(CGRect)frame startHexColor:(nullable NSString*)startHexColor endHexColor:(nullable NSString*)endHexColor;

- (void)setBackgroundColorFromColor:(nullable UIColor*)startUIColor
                            toColor:(nullable UIColor*)endUIColor
                          direction:(UIViewGradientColorDirection)direction;

#pragma mark ==================================================
#pragma mark == 设置遮罩相关
#pragma mark ==================================================
@property (nonatomic,strong) UIBezierPath * _Nullable bezierPath;

- (void)setMaskWithPath:(nullable UIBezierPath*)path;

- (void)setMaskWithPath:(nullable UIBezierPath*)path
            borderColor:(nullable UIColor*)borderColor
            borderWidth:(float)borderWidth;

- (BOOL)containsPoint:(CGPoint)point;

#pragma mark ==================================================
#pragma mark == 设置圆角（计算UIBezierPath+边框颜色+边框粗细）、设置遮罩
#pragma mark ==================================================
- (void)setCornerRadius:(CGFloat)radius;

- (void)setCornerRadius:(CGFloat)radius
                   type:(KKCornerRadiusType)aType;

#pragma mark ==================================================
#pragma mark == 设置边框（①如果有另外UIBezierPath、设置遮罩，②否则就设置默认）
#pragma mark ==================================================
- (void)setBorderColor:(nullable UIColor *)color width:(CGFloat)width;

#pragma mark ==================================================
#pragma mark == 设置阴影
#pragma mark ==================================================
- (void)setShadowColor:(nullable UIColor *)color
               opacity:(CGFloat)opacity
                offset:(CGSize)offset
            blurRadius:(CGFloat)blurRadius
            shadowPath:(nullable CGPathRef)shadowPath;

#pragma mark ==================================================
#pragma mark == 设置虚线
#pragma mark ==================================================
/**
 设置虚线

 @param strokeColor 虚线的颜色
 @param lineWidth 虚线的宽度
 @param lineDashPattern 虚线的间隔
 */
- (void)setDottedLineWithStrokeColor:(UIColor *_Nullable)strokeColor
                           lineWidth:(CGFloat)lineWidth
                     lineDashPattern:(NSArray<NSNumber *> *_Nullable)lineDashPattern;

#pragma mark ==================================================
#pragma mark == frame相关
#pragma mark ==================================================
- (CGPoint)topLeft;

- (CGPoint)topRight;

- (CGPoint)bottomLeft;

- (CGPoint)bottomRight;

- (CGFloat)width;

- (void)setWidth:(CGFloat)newwidth;

- (CGFloat)height;

- (void)setHeight:(CGFloat)newheight;

- (CGFloat)left;

- (void)setLeft:(CGFloat)newleft;

- (CGFloat)right;

- (void)setRight:(CGFloat)newright;

- (CGFloat)top;

- (void)setTop:(CGFloat)newtop;

- (CGFloat)bottom;

- (void)setBottom:(CGFloat)newbottom;

- (CGFloat)centerX;

- (void)setCenterX:(CGFloat)centerX;

- (CGFloat)centerY;

- (void)setCenterY:(CGFloat)centerY;

#pragma mark ==================================================
#pragma mark == 缩放动画
#pragma mark ==================================================
- (void)showZoomAnimation;

@end
