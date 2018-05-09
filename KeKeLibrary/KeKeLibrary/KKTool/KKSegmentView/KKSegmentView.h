//
//  KKSegmentView.h
//  CEDongLi
//
//  Created by liubo on 16/1/1.
//  Copyright (c) 2016年 KeKeStudio. All rights reserved.
//

#import "KKView.h"

@class KKButton;

@protocol KKSegmentViewDelegate;

@interface KKSegmentView : KKView

/* 每个按钮的宽度，当值等于0的时候，每个按钮的宽度会根据屏幕宽度均等分 */
@property (nonatomic,assign,readonly)CGFloat widthPerSegment;

/* 背景 */
@property (nonatomic,strong)UIImageView *backgroundImageView;

/* 底部跟着滑动的 浮动条 */
@property (nonatomic,strong)UIView *sliderView;

/* 顶部分割线 */
@property (nonatomic,strong)UIView *headLineView;

/* 底部分割线 */
@property (nonatomic,strong)UIView *footLineView;

/* 左边遮罩 */
@property (nonatomic,strong)UIView *leftMaskView;

/* 右边遮罩 */
@property (nonatomic,strong)UIView *rightMaskView;

@property (nonatomic,assign)id<KKSegmentViewDelegate> delegate;

/* 当前选中的Button Index 如果等于NSNotFound 就表示一个都没选中*/
@property (nonatomic,assign)NSInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame segmentCount:(NSInteger)aCount;

- (instancetype)initWithFrame:(CGRect)frame segmentCount:(NSInteger)aCount widthPerSegment:(CGFloat)aWidthPerSegment;

- (void)deselect;

- (void)selectedIndex:(NSInteger)aIndex needRespondsDelegate:(BOOL)aNeedRespondsDelegate;

/* 隐藏每个按钮之间的分割线 默认是显示的*/
- (void)hideAllSeperatorLine;

- (NSArray<KKButton*> *)allButtons;

- (KKButton*)buttonAtIndex:(NSInteger)index;

@end

@protocol KKSegmentViewDelegate <NSObject>
@optional
/*
 被选中的Button再次被点击
 */
- (void)KKSegmentView:(KKSegmentView*)aSegementView selectedSameIndex:(NSInteger)aIndex;

/*
 选中了新的Button
 */
- (void)KKSegmentView:(KKSegmentView*)aSegementView selectedNewIndex:(NSInteger)aIndex;

@end



