//
//  KKCycleProgressView.m
//  CEDongLi
//
//  Created by liubo on 16/10/20.
//  Copyright © 2016年 KeKeStudio. All rights reserved.
//

#import "KKCycleProgressView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "KKCategory.h"
#import "KKLibraryDefine.h"

@interface KKCycleProgressView ()

@property (nonatomic, assign) CGFloat       progressValue;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, copy)   UIColor *trackMiddleColor_Real;

@property (nonatomic, assign) CGFloat       progressValueTemp;
@property (nonatomic, strong) NSTimer *myPlusTimer;
@property (nonatomic, strong) NSTimer *myReduceTimer;


@end

@implementation KKCycleProgressView

- (void)dealloc{
    if (self.myPlusTimer) {
        [self.myPlusTimer invalidate];
        self.myPlusTimer=nil;
    }
    if (self.myReduceTimer) {
        [self.myReduceTimer invalidate];
        self.myReduceTimer=nil;
    }
}

#pragma mark ========================================
#pragma mark == 初始化
#pragma mark ========================================
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder{
    self = [super initWithCoder:decoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    _outRadius = MIN(self.frame.size.width, self.frame.size.height)/2.0;
    _inRadius = MAX(MIN(self.frame.size.width, self.frame.size.height)/2.0 - 30.0f, 0);
    
    [self setBackgroundTrackColor:[UIColor colorWithRed:0.85f green:0.87f blue:0.89f alpha:1.00f]];
    [self setBackgroundTrackCenterColor:[UIColor clearColor]];
    
    _trackStartColor = [UIColor colorWithRed:0.38f green:0.76f blue:0.97f alpha:1.00f];
    _trackMiddleColor = [UIColor colorWithRed:0.38f green:0.76f blue:0.97f alpha:1.00f];
    _trackEndColor = [UIColor colorWithRed:0.38f green:0.76f blue:0.97f alpha:1.00f];

    _progressValue = 0.5;
    if (_progressLabel==nil) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [UIColor colorWithRed:0.38f green:0.76f blue:0.97f alpha:1.00f];
        _progressLabel.font = [UIFont boldSystemFontOfSize:24];
        _progressLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:_progressLabel];
    }
    _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progressValue*100];

    
    [self reload];
}

#pragma mark ========================================
#pragma mark == 设置属性
#pragma mark ========================================
- (void)setFrame:(CGRect)frame{
    if (frame.size.width != frame.size.height) {
        frame.size.height = frame.size.width;
    }
    
    [super setFrame:frame];
    
    _outRadius = MIN(self.frame.size.width, self.frame.size.height)/2.0;
    _inRadius = MAX(MIN(self.frame.size.width, self.frame.size.height)/2.0 - 30.0f, 0);
    
    [self reload];
}

- (void)setInRadius:(CGFloat)inRadius{
    if (_inRadius==inRadius) {
        return;
    }
    else{
        _inRadius = inRadius;
        [self reload];
    }
}

- (void)setOutRadius:(CGFloat)outRadius{
    if (_outRadius==outRadius) {
        return;
    }
    else{
        _outRadius = outRadius;
        [self reload];
    }
}

- (void)setBackgroundTrackColor:(UIColor *)backgroundTrackColor{
    _backgroundTrackColor = backgroundTrackColor;
    _backgroundLayer.strokeColor = _backgroundTrackColor.CGColor;//指定path的渲染颜色(轨迹颜色)
    [self setNeedsDisplay];
}

- (void)setBackgroundTrackCenterColor:(UIColor *)backgroundTrackCenterColor{
    _backgroundTrackCenterColor = backgroundTrackCenterColor;
    _backgroundLayer.fillColor = [_backgroundTrackCenterColor CGColor];//圆环中间的圆盘颜色
    [self setNeedsDisplay];
}

- (void)setTrackStartColor:(UIColor *)trackStartColor{
    _trackStartColor = trackStartColor;
    
    if (_trackMiddleColor) {
        [self reload_GradientLayer];
        [self reload_GradientLayerMask];
    }
    else{
        CGFloat R=0;
        CGFloat G=0;
        CGFloat B=0;
        NSArray *colorArraryS = [UIColor RGBAValue:_trackStartColor];
        NSArray *colorArraryE = [UIColor RGBAValue:_trackEndColor];
        if ([colorArraryS count]>=3 && [colorArraryE count]>=3) {
            R = ([[colorArraryS objectAtIndex:0] floatValue] + [[colorArraryE objectAtIndex:0] floatValue])/2.0;
            G = ([[colorArraryS objectAtIndex:1] floatValue] + [[colorArraryE objectAtIndex:1] floatValue])/2.0;
            B = ([[colorArraryS objectAtIndex:2] floatValue] + [[colorArraryE objectAtIndex:2] floatValue])/2.0;
        }
        UIColor *color = [UIColor colorWithRed:R
                                         green:G
                                          blue:B
                                         alpha:1.0];
        _trackMiddleColor_Real = color;
        
        [self reload_GradientLayer];
        [self reload_GradientLayerMask];
    }
}

- (void)setTrackEndColor:(UIColor *)trackEndColor{
    _trackEndColor = trackEndColor;
    
    if (_trackMiddleColor) {
        [self reload_GradientLayer];
        [self reload_GradientLayerMask];
    }
    else{
        CGFloat R=0;
        CGFloat G=0;
        CGFloat B=0;
        NSArray *colorArraryS = [UIColor RGBAValue:_trackStartColor];
        NSArray *colorArraryE = [UIColor RGBAValue:_trackEndColor];
        if ([colorArraryS count]>=3 && [colorArraryE count]>=3) {
            R = ([[colorArraryS objectAtIndex:0] floatValue] + [[colorArraryE objectAtIndex:0] floatValue])/2.0;
            G = ([[colorArraryS objectAtIndex:1] floatValue] + [[colorArraryE objectAtIndex:1] floatValue])/2.0;
            B = ([[colorArraryS objectAtIndex:2] floatValue] + [[colorArraryE objectAtIndex:2] floatValue])/2.0;
        }
        UIColor *color = [UIColor colorWithRed:R
                                         green:G
                                          blue:B
                                         alpha:1.0];
        _trackMiddleColor_Real = color;
        
        [self reload_GradientLayer];
        [self reload_GradientLayerMask];
    }
}

- (void)setTrackMiddleColor:(UIColor *)trackMiddleColor{
    
    _trackMiddleColor = trackMiddleColor;
    
    _trackMiddleColor_Real = trackMiddleColor;
    
    [self reload_GradientLayer];
    [self reload_GradientLayerMask];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    if (_progressValue==progress) {
        return;
    }
    
    if (animated) {
        self.progressValueTemp = progress;
        
        if (self.progressValueTemp>self.progressValue) {
            
            NSInteger count = (NSInteger)((self.progressValueTemp-self.progressValue)/0.01);
            if (count<2) {
                _progressValue = progress;
                _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progressValue*100];
                self.progressValueTemp = _progressValue;
                
                [self reload];
            }
            else{
                if (self.myPlusTimer) {
                    [self.myPlusTimer invalidate];
                    self.myPlusTimer = nil;
                }
                
                KKWeakSelf(self);
                self.myPlusTimer = [NSTimer scheduledTimerWithTimeInterval:0.3/count block:^{
                    [weakself timerLoopPlus];
                } repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.myPlusTimer forMode:NSRunLoopCommonModes];

            }
        }
        else{
            NSInteger count = (NSInteger)((self.progressValue-self.progressValueTemp)/0.01);
            if (count<2) {
                _progressValue = progress;
                _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progressValue*100];
                self.progressValueTemp = _progressValue;
                [self reload];
            }
            else{
                if (self.myReduceTimer) {
                    [self.myReduceTimer invalidate];
                    self.myReduceTimer = nil;
                }

                KKWeakSelf(self);
                _myReduceTimer = [NSTimer scheduledTimerWithTimeInterval:0.3/count block:^{
                    [weakself timerLoopReduce];
                } repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_myReduceTimer forMode:NSRunLoopCommonModes];
            }
        }
    }
    else{
        _progressValue = progress;
        _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progressValue*100];
        self.progressValueTemp = _progressValue;

        [self reload];
    }
}

- (void)timerLoopPlus{
    _progressValue = _progressValue + 0.01;
    if (_progressValue>=self.progressValueTemp) {
        if (self.myPlusTimer) {
            [self.myPlusTimer invalidate];
            self.myPlusTimer=nil;
        }
        _progressValue = _progressValueTemp;
        _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progressValue*100];
        [self reload];
    }
    else{
        _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progressValue*100];
        [self reload];
    }
}

- (void)timerLoopReduce{
    _progressValue = _progressValue - 0.01;
    if (_progressValue<=self.progressValueTemp) {
        if (self.myReduceTimer) {
            [self.myReduceTimer invalidate];
            self.myReduceTimer=nil;
        }
        _progressValue = _progressValueTemp;
        _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progressValue*100];
        [self reload];
    }
    else{
        _progressLabel.text = [NSString stringWithFormat:@"%.0f%%",_progressValue*100];
        [self reload];
    }
}


- (CGFloat)progress{
    return _progressValue;
}

#pragma mark ========================================
#pragma mark == 绘图
#pragma mark ========================================
/**
 * 刷新
 */
- (void)reload{
    
    [_backgroundLayer removeFromSuperlayer];
    [_gradientLayer removeFromSuperlayer];
    [_maskLayer removeFromSuperlayer];
    
    [self reload_BackgroundLayer];
    [self reload_GradientLayer];
    [self reload_GradientLayerMask];
    [self.layer setNeedsDisplay];
}

/**
 * 背景圆环
 */
- (void)reload_BackgroundLayer{
    
//    [_backgroundLayer removeFromSuperlayer];
//    _backgroundLayer = nil;
    
    CGFloat lineWidth = _outRadius-_inRadius;
    
    //圆环背景
    double startA = -M_PI_2;  //设置进度条起点位置
    double endA = -M_PI_2 + M_PI * 2;  //设置进度条终点位置
    _backgroundLayer = [[CAShapeLayer alloc] init];//创建一个track shape layer
    _backgroundLayer.frame = self.bounds;
    [self.layer addSublayer:_backgroundLayer];
    _backgroundLayer.fillColor = [_backgroundTrackCenterColor CGColor];//圆环中间的圆盘颜色
    _backgroundLayer.strokeColor = [_backgroundTrackColor CGColor];//指定path的渲染颜色(轨迹颜色)
    _backgroundLayer.opacity = 1.0; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
    _backgroundLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _backgroundLayer.lineWidth = lineWidth;//线的宽度(也即是内外半径之差)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:(self.frame.size.width-lineWidth)/2 startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _backgroundLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    _backgroundLayer.strokeStart = 0.0f;
    _backgroundLayer.strokeEnd = 1.0f;
}

/**
 * 颜色渐变层
 */
- (void)reload_GradientLayer{
    
//    [_gradientLayer removeFromSuperlayer];
//    _gradientLayer = nil;
    
    _gradientLayer = [[CAShapeLayer alloc] init];
    _gradientLayer.frame = self.bounds;
    _gradientLayer.fillColor = [[UIColor clearColor] CGColor];
    _gradientLayer.strokeColor = [[UIColor whiteColor] CGColor];//指定path的渲染颜色
    _gradientLayer.opacity = 1.0; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
    _gradientLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _gradientLayer.lineWidth = _outRadius;//线的宽度
    //    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:outRadius startAngle:-M_PI_2 endAngle:-M_PI_2+2*M_PI clockwise:YES];//上面说明过了用来构建圆形
    //    gradientLayer.path =[path2 CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    //    gradientLayer.strokeStart = 0.0f;
    //    gradientLayer.strokeEnd = 1.0f;
    
    //右侧渐变色
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
    //    rightLayer.locations = @[@0.3, @0.9, @1];
    rightLayer.colors =  [NSArray arrayWithObjects:
                          (id)(_trackStartColor).CGColor,
                          (id)(_trackMiddleColor).CGColor, nil];
    [_gradientLayer addSublayer:rightLayer];
    
    //左侧渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
    //    leftLayer.locations = @[@0.3, @0.9, @1];
    leftLayer.colors =  [NSArray arrayWithObjects:
                         (id)(_trackEndColor).CGColor,
                         (id)(_trackMiddleColor).CGColor, nil];
    [_gradientLayer addSublayer:leftLayer];
    
    //    [gradientLayer setMask:trackLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:_gradientLayer];
}

/**
 * 遮罩蒙版层
 */
- (void)reload_GradientLayerMask{
    
    if (_progressValue==0) {
        _gradientLayer.hidden = YES;
        return;
    }
    else{
        _gradientLayer.hidden = NO;
    }
    
//    [_maskLayer removeFromSuperlayer];
//    _maskLayer = nil;
    
    //第一象限（二维坐标右上角为第一象限）
    if (0<_progressValue && _progressValue<=0.25) {
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        //    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
        //    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
        
        //外半径起始点
        [bezierPath moveToPoint: CGPointMake(self.frame.size.width/2.0, 0)];
        
        //内半径起始点
        [bezierPath addLineToPoint: CGPointMake(self.frame.size.width/2.0, _outRadius-_inRadius)];
        
        //内圆弧
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = (-M_PI_2 + M_PI*2*_progressValue);
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:_inRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        //内半径终止点
        CGFloat x1 = _outRadius + _inRadius*cos(fabs(endAngle));
        CGFloat y1 = _outRadius - _inRadius*sin(fabs(endAngle));
        [bezierPath addLineToPoint: CGPointMake(x1, y1)];
        
        
        //外半径终止点
        CGFloat x2 = _outRadius + _outRadius*cos(fabs(endAngle));
        CGFloat y2 = _outRadius - _outRadius*sin(fabs(endAngle));
        [bezierPath addLineToPoint: CGPointMake(x2, y2)];
        
        //        //外圆弧
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:_outRadius startAngle:endAngle endAngle:startAngle clockwise:NO];
        
        //结束点
        [bezierPath addLineToPoint: CGPointMake(self.frame.size.width/2.0, 0)];
        
        [bezierPath closePath];
        
        _maskLayer = [[CAShapeLayer alloc] init];
        _maskLayer.path = [bezierPath CGPath];
        _maskLayer.fillColor = [[UIColor whiteColor] CGColor];
        _maskLayer.frame = _gradientLayer.bounds;
        [_gradientLayer setMask:_maskLayer];
        
        //        CAShapeLayer *maskBorderLayer = [[CAShapeLayer alloc] init];
        //        maskBorderLayer.path = [bezierPath CGPath];
        //        maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
        //        maskBorderLayer.strokeColor = [[UIColor redColor] CGColor];
        //        maskBorderLayer.lineWidth = 5.0;
        //        [gradientLayer addSublayer:maskBorderLayer];
        //        [maskBorderLayer release];
    }
    //第二象限
    else if (0.25<_progressValue && _progressValue<=0.5){
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        //    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
        //    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
        
        //外半径起始点
        [bezierPath moveToPoint: CGPointMake(self.frame.size.width/2.0, 0)];
        
        //内半径起始点
        [bezierPath addLineToPoint: CGPointMake(self.frame.size.width/2.0, _outRadius-_inRadius)];
        
        //内圆弧
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = (-M_PI_2 + M_PI*2*_progressValue);
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:_inRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        //内半径终止点
        CGFloat x1 = _outRadius + _inRadius*cos(endAngle);
        CGFloat y1 = _outRadius + _inRadius*sin(endAngle);
        [bezierPath addLineToPoint: CGPointMake(x1, y1)];
        
        
        //外半径终止点
        CGFloat x2 = _outRadius + _outRadius*cos(endAngle);
        CGFloat y2 = _outRadius + _outRadius*sin(endAngle);
        [bezierPath addLineToPoint: CGPointMake(x2, y2)];
        
        //外圆弧
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:_outRadius startAngle:endAngle endAngle:startAngle clockwise:NO];
        
        //结束点
        [bezierPath moveToPoint: CGPointMake(self.frame.size.width/2.0, 0)];
        
        [bezierPath closePath];
        
        _maskLayer = [[CAShapeLayer alloc] init];
        _maskLayer.path = [bezierPath CGPath];
        _maskLayer.fillColor = [[UIColor whiteColor] CGColor];
        _maskLayer.frame = _gradientLayer.bounds;
        [_gradientLayer setMask:_maskLayer];
        
        //        CAShapeLayer *maskBorderLayer = [[CAShapeLayer alloc] init];
        //        maskBorderLayer.path = [bezierPath CGPath];
        //        maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
        //        maskBorderLayer.strokeColor = [[UIColor redColor] CGColor];
        //        maskBorderLayer.lineWidth = 5.0;
        //        [gradientLayer addSublayer:maskBorderLayer];
        //        [maskBorderLayer release];
    }
    //第三象限
    else if (0.5<_progressValue && _progressValue<=0.75){
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        //    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
        //    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
        
        //外半径起始点
        [bezierPath moveToPoint: CGPointMake(self.frame.size.width/2.0, 0)];
        
        //内半径起始点
        [bezierPath addLineToPoint: CGPointMake(self.frame.size.width/2.0, _outRadius-_inRadius)];
        
        //内圆弧
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = (-M_PI_2 + M_PI*2*_progressValue);
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:_inRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        //内半径终止点
        CGFloat x1 = _outRadius - _inRadius*sin(endAngle-M_PI_2);
        CGFloat y1 = _outRadius + _inRadius*cos(endAngle-M_PI_2);
        [bezierPath addLineToPoint: CGPointMake(x1, y1)];
        
        
        //外半径终止点
        CGFloat x2 = _outRadius - _outRadius*sin(endAngle-M_PI_2);
        CGFloat y2 = _outRadius + _outRadius*cos(endAngle-M_PI_2);
        [bezierPath addLineToPoint: CGPointMake(x2, y2)];
        
        //外圆弧
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:_outRadius startAngle:endAngle endAngle:startAngle clockwise:NO];
        
        //结束点
        [bezierPath moveToPoint: CGPointMake(self.frame.size.width/2.0, 0)];
        
        [bezierPath closePath];
        
        _maskLayer = [[CAShapeLayer alloc] init];
        _maskLayer.path = [bezierPath CGPath];
        _maskLayer.fillColor = [[UIColor whiteColor] CGColor];
        _maskLayer.frame = _gradientLayer.bounds;
        [_gradientLayer setMask:_maskLayer];
        
        //        CAShapeLayer *maskBorderLayer = [[CAShapeLayer alloc] init];
        //        maskBorderLayer.path = [bezierPath CGPath];
        //        maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
        //        maskBorderLayer.strokeColor = [[UIColor redColor] CGColor];
        //        maskBorderLayer.lineWidth = 5.0;
        //        [gradientLayer addSublayer:maskBorderLayer];
        //        [maskBorderLayer release];
    }
    //第四象限
    else{
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        //    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
        //    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
        
        //外半径起始点
        [bezierPath moveToPoint: CGPointMake(self.frame.size.width/2.0, 0)];
        
        //内半径起始点
        [bezierPath addLineToPoint: CGPointMake(self.frame.size.width/2.0, _outRadius-_inRadius)];
        
        //内圆弧
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = (-M_PI_2 + M_PI*2*_progressValue);
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:_inRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        //内半径终止点
        CGFloat x1 = _outRadius - _inRadius*cos(endAngle-M_PI);
        CGFloat y1 = _outRadius - _inRadius*sin(endAngle-M_PI);
        [bezierPath addLineToPoint: CGPointMake(x1, y1)];
        
        
        //外半径终止点
        CGFloat x2 = _outRadius - _outRadius*cos(endAngle-M_PI);
        CGFloat y2 = _outRadius - _outRadius*sin(endAngle-M_PI);
        [bezierPath addLineToPoint: CGPointMake(x2, y2)];
        
        //外圆弧
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0) radius:_outRadius startAngle:endAngle endAngle:startAngle clockwise:NO];
        
        //结束点
        [bezierPath moveToPoint: CGPointMake(self.frame.size.width/2.0, 0)];
        
        [bezierPath closePath];
        
        _maskLayer = [[CAShapeLayer alloc] init];
        _maskLayer.path = [bezierPath CGPath];
        _maskLayer.fillColor = [[UIColor whiteColor] CGColor];
        _maskLayer.frame = _gradientLayer.bounds;
        [_gradientLayer setMask:_maskLayer];
        
        //        CAShapeLayer *maskBorderLayer = [[CAShapeLayer alloc] init];
        //        maskBorderLayer.path = [bezierPath CGPath];
        //        maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
        //        maskBorderLayer.strokeColor = [[UIColor redColor] CGColor];
        //        maskBorderLayer.lineWidth = 5.0;
        //        [gradientLayer addSublayer:maskBorderLayer];
        //        [maskBorderLayer release];
    }
    
}



@end
