//
//  UIView+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KKCategory)

typedef enum{
    UIViewGradientColorDirection_TopBottom = 1,//从上到下
    UIViewGradientColorDirection_BottomTop = 2,//从下到上
    UIViewGradientColorDirection_LeftRight = 3,//从左到右
    UIViewGradientColorDirection_RightLeft = 4,//从右到左
}UIViewGradientColorDirection;

@property (nonatomic,strong) id _Nullable tagInfo;


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

- (void)setBorderColor:(nullable UIColor *)color width:(CGFloat)width;

- (void)setCornerRadius:(CGFloat)radius;

- (void)setShadowColor:(nullable UIColor *)color
               opacity:(CGFloat)opacity
                offset:(CGSize)offset
            blurRadius:(CGFloat)blurRadius
            shadowPath:(nullable CGPathRef)shadowPath;

- (nullable UIViewController *)viewController;

/**
 创建一个渐变色的View
 
 @param frame frame
 @param startHexColor 开始颜色
 @param endHexColor 结束颜色
 @return 结果
 */
- (nullable id)initWithFrame:(CGRect)frame startHexColor:(nullable NSString*)startHexColor endHexColor:(nullable NSString*)endHexColor;

- (void)setBackgroundColorFromColor:(nullable UIColor*)startUIColor toColor:(nullable UIColor*)endUIColor direction:(UIViewGradientColorDirection)direction;

#pragma mark ==================================================
#pragma mark == 设置遮罩相关
#pragma mark ==================================================
@property (nonatomic,strong) UIBezierPath * _Nullable bezierPath;

- (void)setMaskWithPath:(nullable UIBezierPath*)path;

- (void)setMaskWithPath:(nullable UIBezierPath*)path withBorderColor:(nullable UIColor*)borderColor borderWidth:(float)borderWidth;

- (BOOL)containsPoint:(CGPoint)point;

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

@end
