//
//  UIBezierPath+KKCategory.m
//  BM
//
//  Created by liubo on 2019/11/19.
//  Copyright © 2019 bm. All rights reserved.
//

#import "UIBezierPath+KKCategory.h"

@implementation UIBezierPath (KKCategory)

+ (UIBezierPath *)chatBoxRightShape:(CGRect)originalFrame{
    
    CGRect frame = originalFrame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat CornerRadius = 10;
    CGFloat arrowWidth = 10;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    //    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
    //    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    //左上角
    [bezierPath moveToPoint: CGPointMake(0, CornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.0*M_PI) endAngle:(1.5*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(CornerRadius, 0)];
    
    //右上角
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth-CornerRadius, 0)];
    [bezierPath addArcWithCenter:CGPointMake(width-arrowWidth-CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.5*M_PI) endAngle:(0*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth, CornerRadius)];
    
    //三角
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth, CornerRadius+CornerRadius)];
    
    [bezierPath addLineToPoint: CGPointMake(width-0.5, CornerRadius+CornerRadius+arrowWidth/2.0-0.5)];
    [bezierPath addLineToPoint: CGPointMake(width-0.5, CornerRadius+CornerRadius+arrowWidth/2.0+0.5)];

    //    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth/4.0, CornerRadius+arrowWidth+arrowWidth/4.0)];
    //    [bezierPath addArcWithCenter:CGPointMake(width-arrowWidth/2.0, CornerRadius+arrowWidth+arrowWidth/2.0) radius:arrowWidth/2.0/1.414 startAngle:(1.75*M_PI) endAngle:(0.25*M_PI) clockwise:YES];
    //    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth/4.0, CornerRadius+arrowWidth+arrowWidth*3/4.0)];
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth, CornerRadius+CornerRadius+arrowWidth)];
    
    //右下角
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth, height-CornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(width-CornerRadius-arrowWidth, height-CornerRadius) radius:CornerRadius startAngle:(0*M_PI) endAngle:(0.5*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(width-CornerRadius-arrowWidth, height)];
    
    //左下角
    [bezierPath addLineToPoint: CGPointMake(CornerRadius, height)];
    [bezierPath addArcWithCenter:CGPointMake(CornerRadius, height-CornerRadius) radius:CornerRadius startAngle:(0.5*M_PI) endAngle:(1.0*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(0, height-CornerRadius)];
    
    [bezierPath addLineToPoint: CGPointMake(0, CornerRadius)];
    
    [bezierPath closePath];
    
    return bezierPath;
    
}

+ (UIBezierPath *)chatBoxLeftShape:(CGRect)originalFrame{
    
    CGRect frame = originalFrame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat CornerRadius = 10;
    CGFloat arrowWidth = 10;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    //    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
    //    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    //左上角
    [bezierPath moveToPoint: CGPointMake(arrowWidth, CornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(arrowWidth+CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.0*M_PI) endAngle:(1.5*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(arrowWidth+CornerRadius, 0)];
    
    //右上角
    [bezierPath addLineToPoint: CGPointMake(width-CornerRadius, 0)];
    [bezierPath addArcWithCenter:CGPointMake(width-CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.5*M_PI) endAngle:(0*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(width, CornerRadius)];
    
    //右下角
    [bezierPath addLineToPoint: CGPointMake(width, height-CornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(width-CornerRadius, height-CornerRadius) radius:CornerRadius startAngle:(0*M_PI) endAngle:(0.5*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(width-CornerRadius, height)];
    
    //左下角
    [bezierPath addLineToPoint: CGPointMake(arrowWidth+CornerRadius, height)];
    [bezierPath addArcWithCenter:CGPointMake(arrowWidth+CornerRadius, height-CornerRadius) radius:CornerRadius startAngle:(0.5*M_PI) endAngle:(1.0*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(arrowWidth, height-CornerRadius)];
    
    //三角
    [bezierPath addLineToPoint: CGPointMake(arrowWidth, CornerRadius+CornerRadius+arrowWidth)];
    [bezierPath addLineToPoint: CGPointMake(0.5, CornerRadius+CornerRadius+arrowWidth/2.0+0.5)];
    [bezierPath addLineToPoint: CGPointMake(0.5, CornerRadius+CornerRadius+arrowWidth/2.0-0.5)];
    [bezierPath addLineToPoint: CGPointMake(arrowWidth, CornerRadius+CornerRadius)];
    
    [bezierPath addLineToPoint: CGPointMake(arrowWidth, CornerRadius)];
    
    [bezierPath closePath];
    
    return bezierPath;
    
}

@end
