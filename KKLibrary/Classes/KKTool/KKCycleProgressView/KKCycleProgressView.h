//
//  KKCycleProgressView.h
//  CEDongLi
//
//  Created by liubo on 16/10/20.
//  Copyright © 2016年 KeKeStudio. All rights reserved.
//

#import "KKView.h"

@interface KKCycleProgressView : KKView

@property (nonatomic, assign) CGFloat inRadius;//内半径
@property (nonatomic, assign) CGFloat outRadius;//外半径
@property (nonatomic, strong) UILabel *progressLabel;//进度
@property (nonatomic, copy) UIColor *backgroundTrackColor;
@property (nonatomic, copy) UIColor *backgroundTrackCenterColor;

@property (nonatomic, copy) UIColor *trackStartColor;
@property (nonatomic, copy) UIColor *trackMiddleColor;
@property (nonatomic, copy) UIColor *trackEndColor;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

- (CGFloat)progress;

@end
