//
//  UIButton+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonContentAlignment) {
    ButtonContentAlignmentLeft = 1,
    ButtonContentAlignmentCenter = 2,
    ButtonContentAlignmentRight = 3,
} ;

typedef NS_ENUM(NSInteger, ButtonContentLayoutModal) {
    ButtonContentLayoutModalVertical = 1,//垂直对齐
    ButtonContentLayoutModalHorizontal = 2,//水平对齐
} ;

typedef NS_ENUM(NSInteger, ButtonContentTitlePosition) {
    ButtonContentTitlePositionBefore = 1,//标题在图片的左边或者上边
    ButtonContentTitlePositionAfter = 2,//标题在图片的右边或者下边
} ;

@interface UIButton (KKCategory)

- (void)setBackgroundColor:(nullable UIColor *)backgroundColor
                  forState:(UIControlState)controlState;

- (void)setBackgroundImage:(nullable UIImage *)image
                  forState:(UIControlState)state
               contentMode:(UIViewContentMode)contentMode;

/**
 设置UIButton的图片和标题的对其方式
 contentAlignment //整体左、中、右对齐
 contentLayoutModal //图片与标题的布局方式，上下布局、左右并排布局
 contentTitlePosition //标题是否在图片的前面
 aSpace 图片与标题之间是否留间隙，间隙大小
 aEdgeInsets 整体靠左、靠右对其的时候，是否要紧靠边缘。当aEdgeInsets的left、right为0的时候就是紧靠边缘
 */
- (void)setButtonContentAlignment:(ButtonContentAlignment)contentAlignment
         ButtonContentLayoutModal:(ButtonContentLayoutModal)contentLayoutModal
       ButtonContentTitlePosition:(ButtonContentTitlePosition)contentTitlePosition
        SapceBetweenImageAndTitle:(CGFloat)aSpace
                       EdgeInsets:(UIEdgeInsets)aEdgeInsets;

@end
