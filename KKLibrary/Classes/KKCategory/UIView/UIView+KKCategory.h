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
typedef NS_ENUM(NSInteger,KKUIViewGradientColorDirection) {
    
    KKUIViewGradientColorDirection_TopBottom = 0,/* 从上到下 */
    
    KKUIViewGradientColorDirection_BottomTop = 1,/* 从下到上 */
    
    KKUIViewGradientColorDirection_LeftRight = 2,/* 从左到右 */

    KKUIViewGradientColorDirection_RightLeft = 3,/* 从右到左 */

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


@property (nonatomic,strong) id _Nullable kk_tagInfo;
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
#pragma mark == 截图
#pragma mark ==================================================
/**
 截图
 
 @return UIImage
 */
- (nullable UIImage *)kk_snapshot;

/**
 ①普通的截图
 该API仅可以在未使用layer和OpenGL渲染的视图上使用
 这种是最最普通的截图，针对一般的视图上添加视图的情况，基本都可以使用。
 @return 截取的图片
 */
- (nullable UIImage *)kk_snapshotImage_normal;

/**
 ②针对有用过OpenGL渲染过的视图截图
 如果一些视图是用OpenGL渲染出来的，那么使用上面①的方式就无法截图到OpenGL渲染的部分，这时候就要用到改进后的截图方案②
 @return 截取的图片
 */
- (nullable UIImage *)kk_snapshotImage_opengl;

/**
 截图
 ③以UIView 的形式返回(_UIReplicantView)
 有一些特殊的Layer（比如：AVCaptureVideoPreviewLayer 和 AVSampleBufferDisplayLayer） 添加到某个View 上后，使用上面的几种方式都无法截取到Layer上的内容，这个时候可以使用系统的一个API，但是该API只能返回一个UIView，返回的UIView 可以修改frame 等参数
 遗留问题：
 通过方式三截取的UIView，无法转换为UIImage，我试过将返回的截图View写入位图再转换成UIImage，但是返回的UIImage 要么为空，要么没有内容。如果有人知道解决方案请告知我。
 @return 截取出来的图片转换的视图
 */
- (nullable UIView *)kk_snapshotImage_view;

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
- (nullable UIImage *)kk_snapshotImage_fromOpenGLStreamView;

#pragma mark ==================================================
#pragma mark == 普通设置
#pragma mark ==================================================
- (void)kk_clearBackgroundColor;

- (void)kk_removeAllSubviews;

- (void)kk_setBackgroundImage:(nullable UIImage *)image;

- (void)kk_setIndex:(NSInteger)index;

- (void)kk_bringToFront;

- (void)kk_sendToBack;

- (nullable UIViewController *)kk_viewController;

/**
 创建一个渐变色的View
 
 @param frame frame
 @param startHexColor 开始颜色
 @param endHexColor 结束颜色
 @return 结果
 */
- (nullable id)initWithFrame:(CGRect)frame startHexColor:(nullable NSString*)startHexColor endHexColor:(nullable NSString*)endHexColor;

- (void)kk_setBackgroundColorFromColor:(nullable UIColor*)startUIColor
                               toColor:(nullable UIColor*)endUIColor
                             direction:(KKUIViewGradientColorDirection)direction;

#pragma mark ==================================================
#pragma mark == 设置遮罩相关
#pragma mark ==================================================
@property (nonatomic,strong) UIBezierPath * _Nullable kk_bezierPath;

- (void)kk_setMaskWithPath:(nullable UIBezierPath*)path;

- (void)kk_setMaskWithPath:(nullable UIBezierPath*)path
               borderColor:(nullable UIColor*)borderColor
               borderWidth:(float)borderWidth;

- (BOOL)kk_containsPoint:(CGPoint)point;

#pragma mark ==================================================
#pragma mark == 设置圆角（计算UIBezierPath+边框颜色+边框粗细）、设置遮罩
#pragma mark ==================================================
- (void)kk_setCornerRadius:(CGFloat)radius;

- (void)kk_setCornerRadius:(CGFloat)radius
                      type:(KKCornerRadiusType)aType;

#pragma mark ==================================================
#pragma mark == 设置边框（①如果有另外UIBezierPath、设置遮罩，②否则就设置默认）
#pragma mark ==================================================
- (void)kk_setBorderColor:(nullable UIColor *)color width:(CGFloat)width;

#pragma mark ==================================================
#pragma mark == 设置阴影
#pragma mark ==================================================
- (void)kk_setShadowColor:(nullable UIColor *)color
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
- (void)kk_setDottedLineWithStrokeColor:(UIColor *_Nullable)strokeColor
                              lineWidth:(CGFloat)lineWidth
                        lineDashPattern:(NSArray<NSNumber *> *_Nullable)lineDashPattern;

#pragma mark ==================================================
#pragma mark == frame相关
#pragma mark ==================================================
- (CGPoint)kk_topLeft;

- (CGPoint)kk_topRight;

- (CGPoint)kk_bottomLeft;

- (CGPoint)kk_bottomRight;

- (CGFloat)kk_width;

- (void)kk_setWidth:(CGFloat)newwidth;

- (CGFloat)kk_height;

- (void)kk_setHeight:(CGFloat)newheight;

- (CGFloat)kk_left;

- (void)kk_setLeft:(CGFloat)newleft;

- (CGFloat)kk_right;

- (void)kk_setRight:(CGFloat)newright;

- (CGFloat)kk_top;

- (void)kk_setTop:(CGFloat)newtop;

- (CGFloat)kk_bottom;

- (void)kk_setBottom:(CGFloat)newbottom;

- (CGFloat)kk_centerX;

- (void)kk_setCenterX:(CGFloat)centerX;

- (CGFloat)kk_centerY;

- (void)kk_setCenterY:(CGFloat)centerY;

#pragma mark ==================================================
#pragma mark == 缩放动画
#pragma mark ==================================================
- (void)kk_showZoomAnimation;

@end
