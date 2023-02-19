//
//  KKWindowMenuView.m
//  BM
//
//  Created by liubo on 2019/11/22.
//  Copyright © 2019 bm. All rights reserved.
//

#import "KKWindowMenuView.h"
#import "KKCategory.h"
#import "KKButton.h"
#import <objc/runtime.h>

#define KKWindowMenuItem_Height (36.0f)
#define KKWindowMenuItem_MinWidth (60.0f)
#define KKWindowMenuItem_ArrowHeight (10.0f)
#define KKWindowMenuItem_ArrowWidth (20.0f)


@interface KKWindowMenuView ()

@property (nonatomic,strong)UIButton *backgroundButton;
@property (nonatomic,strong)UIView *boxView;
@property (nonatomic,strong)UIView *arrowView;
@property (nonatomic,strong)UIScrollView *contentScrollView;
@property (nonatomic,weak)id<KKWindowMenuViewDelegate> delegate;
@property (nonatomic,strong)NSMutableArray *itemArray;

@end

@implementation KKWindowMenuView

+ (KKWindowMenuView*)showFromView:(UIView*)aView
                        withItems:(NSArray<KKWindowMenuItem*>*)aItemArray
                         delegate:(id<KKWindowMenuViewDelegate>)aDelegate{
    KKWindowMenuView *modalView = [[KKWindowMenuView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight)
                                   fromView:aView withItems:aItemArray delegate:aDelegate];
    UIWindow *window = [UIWindow kk_currentKeyWindow];
    [window addSubview:modalView];
    [modalView show];
    return modalView;
}

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (instancetype)initWithFrame:(CGRect)frame
                     fromView:(UIView*)aView
                       withItems:(NSArray<KKWindowMenuItem*>*)aItemArray
                        delegate:(id<KKWindowMenuViewDelegate>)aDelegate{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = aDelegate;
        
        self.itemArray = [[NSMutableArray alloc] init];
        [self.itemArray addObjectsFromArray:aItemArray];
        
//        for (UIWindow *subWindow in [[UIApplication sharedApplication] windows]) {
//            [subWindow endEditing:YES];
//        }

        //背景
        self.backgroundButton = [[UIButton alloc] initWithFrame:self.bounds];
        self.backgroundButton.backgroundColor = [UIColor clearColor];
        self.backgroundButton.exclusiveTouch = YES;
        [self.backgroundButton addTarget:self action:@selector(backgroundButtonClicked) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.backgroundButton];

        NSMutableArray *buttons = [NSMutableArray array];
        CGFloat maxWidth = 0;
        for (NSInteger i=0; i<[aItemArray count]; i++) {
            
            KKWindowMenuItem *item = [aItemArray objectAtIndex:i];
            
            NSString *title = item.title;
            CGFloat titleWidth = [title kk_sizeWithFont:[UIFont systemFontOfSize:14] maxWidth:CGFLOAT_MAX].width;
            CGFloat buttonWidth = MAX(KKWindowMenuItem_MinWidth, 15+titleWidth+15);
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, KKWindowMenuItem_Height)];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.tag = 9999+i;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button kk_setBackgroundColor:[UIColor kk_colorWithHexString:@"#262626"] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [buttons addObject:button];
            
            maxWidth = maxWidth + button.kk_width + 1;
            
            if (i==0) {
                if (i==[aItemArray count]-1) {
                    [button kk_setCornerRadius:10];
                }
                else{
                    [button kk_setCornerRadius:10 type:KKCornerRadiusType_LeftTop|KKCornerRadiusType_LeftBottom];
                }
            }
            else{
                if (i==[aItemArray count]-1) {
                    [button kk_setCornerRadius:10 type:KKCornerRadiusType_RightTop|KKCornerRadiusType_RightBottom];
                }
            }
        }
        
        
        CGRect windowFrame = [aView convertRect:aView.bounds toView:[UIWindow kk_currentKeyWindow]];
        CGFloat windowFrameCenterX = windowFrame.origin.x + windowFrame.size.width/2.0;
        CGFloat windowFrameBottomY = windowFrame.origin.y + windowFrame.size.height;
        CGFloat windowFrameTopY = windowFrame.origin.y;

        //底部显示
        if (KKStatusBarAndNavBarHeight+KKWindowMenuItem_Height+KKWindowMenuItem_ArrowHeight> windowFrame.origin.y) {

            //圆角矩形框
            self.boxView = [[UIView alloc] initWithFrame:CGRectMake(15, windowFrameBottomY+KKWindowMenuItem_ArrowHeight-5, KKApplicationWidth-30, KKWindowMenuItem_Height)];
            self.boxView.backgroundColor = [UIColor clearColor];
            [self.boxView kk_setCornerRadius:10];
            self.boxView.clipsToBounds = YES;
            [self addSubview:self.boxView];

            if (maxWidth>KKApplicationWidth-30) {
                self.boxView.frame = CGRectMake(15, windowFrameBottomY+KKWindowMenuItem_ArrowHeight-5, KKApplicationWidth-30, KKWindowMenuItem_Height);
            }
            else{
                self.boxView.frame = CGRectMake(KKApplicationWidth-15-maxWidth, windowFrameBottomY+KKWindowMenuItem_ArrowHeight-5, maxWidth, KKWindowMenuItem_Height);
                [self.boxView kk_setCenterX:windowFrame.origin.x+windowFrame.size.width/2.0];
                
                if (self.boxView.kk_right>KKApplicationWidth) {
                    [self.boxView kk_setRight:KKApplicationWidth-15];
                }
                else{
                    if (self.boxView.kk_left<0) {
                        [self.boxView kk_setLeft:15];
                    }
                }
            }

            //圆角矩形框上面放 ScrollView
            self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.boxView.bounds];
            self.contentScrollView.backgroundColor = [UIColor whiteColor];
            if (@available(iOS 11.0, *)) {
                self.contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }

            [self.boxView addSubview:self.contentScrollView];
            //ScrollView上面挨个摆放button
            CGFloat offsetX = 0;
            for (NSInteger i=0; i<[buttons count]; i++) {
                UIButton *button = [buttons kk_objectAtIndex_Safe:i];
                [button kk_setLeft:offsetX];
                [self.contentScrollView addSubview:button];
                offsetX = offsetX + button.kk_width;

                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 0, 1.0, button.kk_height)];
                line.backgroundColor = [UIColor whiteColor];
                [self.contentScrollView addSubview:line];
                
                offsetX = offsetX + 1;
            }
            self.contentScrollView.contentSize = CGSizeMake(offsetX, self.contentScrollView.kk_height);

            //黑色三角
            self.arrowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.boxView.frame.origin.y-KKWindowMenuItem_ArrowHeight, KKWindowMenuItem_ArrowWidth, KKWindowMenuItem_ArrowHeight)];
            self.arrowView.backgroundColor = [UIColor kk_colorWithHexString:@"#262626"];
            [self addSubview:self.arrowView];
            [self.arrowView kk_setMaskWithPath:[self KKWindowMenuItemArrow_upPath:self.arrowView.frame]];
            [self.arrowView kk_setCenterX:windowFrameCenterX];
            
            if (self.boxView.kk_right<self.arrowView.kk_right) {
                [self.boxView kk_setRight:self.arrowView.kk_right+15];
            }
            
        }
        //顶部显示
        else{
            //圆角矩形框
            self.boxView = [[UIView alloc] initWithFrame:CGRectMake(15, windowFrameTopY-KKWindowMenuItem_ArrowHeight-KKWindowMenuItem_Height+5, KKApplicationWidth-30, KKWindowMenuItem_Height)];
            self.boxView.backgroundColor = [UIColor clearColor];
            [self.boxView kk_setCornerRadius:10];
            self.boxView.clipsToBounds = YES;
            [self addSubview:self.boxView];

            if (maxWidth>KKApplicationWidth-30) {
                self.boxView.frame = CGRectMake(15, windowFrameTopY-KKWindowMenuItem_ArrowHeight-KKWindowMenuItem_Height+5, KKApplicationWidth-30, KKWindowMenuItem_Height);
            }
            else{
                self.boxView.frame = CGRectMake(15, windowFrameTopY-KKWindowMenuItem_ArrowHeight-KKWindowMenuItem_Height+5, maxWidth, KKWindowMenuItem_Height);
                [self.boxView kk_setCenterX:windowFrame.origin.x+windowFrame.size.width/2.0];
                
                if (self.boxView.kk_right>KKApplicationWidth) {
                    [self.boxView kk_setRight:KKApplicationWidth-15];
                }
                else{
                    if (self.boxView.kk_left<0) {
                        [self.boxView kk_setLeft:15];
                    }
                }
            }

            //圆角矩形框上面放 ScrollView
            self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.boxView.bounds];
            self.contentScrollView.backgroundColor = [UIColor whiteColor];
            [self.boxView addSubview:self.contentScrollView];
            if (@available(iOS 11.0, *)) {
                self.contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            //ScrollView上面挨个摆放button
            CGFloat offsetX = 0;
            for (NSInteger i=0; i<[buttons count]; i++) {
                UIButton *button = [buttons kk_objectAtIndex_Safe:i];
                [button kk_setLeft:offsetX];
                [self.contentScrollView addSubview:button];
                offsetX = offsetX + button.kk_width;

                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 0, 1.0, button.kk_height)];
                line.backgroundColor = [UIColor whiteColor];
                [self.contentScrollView addSubview:line];
                
                offsetX = offsetX + 1;
            }
            self.contentScrollView.contentSize = CGSizeMake(offsetX, self.contentScrollView.kk_height);
            
            //黑色三角
            self.arrowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.boxView.kk_bottom, KKWindowMenuItem_ArrowWidth, KKWindowMenuItem_ArrowHeight)];
            self.arrowView.backgroundColor = [UIColor kk_colorWithHexString:@"#262626"];
            [self addSubview:self.arrowView];
            [self.arrowView kk_setMaskWithPath:[self KKWindowMenuItemArrow_downPath:self.arrowView.frame]];
            [self.arrowView kk_setCenterX:windowFrameCenterX];
            
            if (self.boxView.kk_right<self.arrowView.kk_right) {
                [self.boxView kk_setRight:self.arrowView.kk_right+15];
            }
        }
        
        self.boxView.backgroundColor = [UIColor clearColor];
        self.contentScrollView.backgroundColor = [UIColor clearColor];
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        self.boxView.alpha = 0;
        self.arrowView.alpha = 0;
    }
    return self;
}


- (void)backgroundButtonClicked{
    [self hide];
}

- (void)buttonClicked:(UIButton*)aButton{
    
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(KKWindowMenuView:clickedIndex:item:)]) {

        NSInteger index = aButton.tag-9999;
        
        [self.delegate KKWindowMenuView:self
                           clickedIndex:index
                                   item:[self.itemArray objectAtIndex:index]];

    }

    [self hide];
}

- (void)show{
    
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(KKWindowMenuView_willShow:)]) {
        [self.delegate KKWindowMenuView_willShow:self];
    }

    [UIView animateWithDuration:0.25 animations:^{
        self.boxView.alpha = 1.0;
        self.arrowView.alpha = 1.0;
    }];
}

- (void)hide{
    
    if ((self.delegate) && [self.delegate respondsToSelector:@selector(KKWindowMenuView_willHide:)]) {
        [self.delegate KKWindowMenuView_willHide:self];
    }

    [self removeFromSuperview];
}

- (UIBezierPath *)KKWindowMenuItemArrow_upPath:(CGRect)originalFrame{
    
    CGRect frame = originalFrame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint: CGPointMake(0, height)];
    [bezierPath addLineToPoint: CGPointMake(width/2.0, 0)];
    [bezierPath addLineToPoint: CGPointMake(width, height)];
    [bezierPath addLineToPoint: CGPointMake(0, height)];
    [bezierPath closePath];
    
    return bezierPath;
    
}

- (UIBezierPath *)KKWindowMenuItemArrow_downPath:(CGRect)originalFrame{
    
    CGRect frame = originalFrame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint: CGPointMake(0, 0)];
    [bezierPath addLineToPoint: CGPointMake(width/2.0, height)];
    [bezierPath addLineToPoint: CGPointMake(width, 0)];
    [bezierPath addLineToPoint: CGPointMake(0, 0)];
    [bezierPath closePath];

    return bezierPath;
    
}


@end


