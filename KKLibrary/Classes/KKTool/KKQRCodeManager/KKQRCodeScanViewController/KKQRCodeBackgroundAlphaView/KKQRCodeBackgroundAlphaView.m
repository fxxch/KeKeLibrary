//
//  KKQRCodeBackgroundAlphaView.m
//  BM
//
//  Created by sjyt on 2020/1/10.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKQRCodeBackgroundAlphaView.h"

@interface KKQRCodeBackgroundAlphaView ()

@property (nonatomic , assign) CGRect boxFrame;

@end

@implementation KKQRCodeBackgroundAlphaView

- (instancetype)initWithFrame:(CGRect)frame boxFrame:(CGRect)aFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.boxFrame = aFrame;
        self.backgroundColor = [UIColor clearColor];
        [self setOpaque:YES];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    /*绘制整个背景颜色*/
    UIColor *allBackgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [allBackgroundColor setFill];
    UIRectFill(rect);
    
    /*清除某个区域背景颜色*/
    //CGRect interSection = CGRectIntersection(rect, self.boxFrame); //取CGRect交集
    [UIColor.clearColor setFill];
    UIRectFill(self.boxFrame);
}

@end
