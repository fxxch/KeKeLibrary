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

/* 当前选中的Button Index 如果等于NSNotFound 就表示一个都没选中*/
@property (nonatomic,assign,readonly)NSInteger selectedIndex;

@property (nonatomic,assign)CGSize sliderSize;

@property (nonatomic,assign)id<KKSegmentViewDelegate> delegate;

@property (nonatomic,assign) CGFloat leftMagin;

/* 背景 默认底色无色*/
@property (nonatomic,strong)UIImageView *backgroundImageView;

/* 顶部分割线 默认隐藏*/
@property (nonatomic,strong)UIView *headLineView;

/* 底部分割线 默认隐藏*/
@property (nonatomic,strong)UIView *footLineView;

/* 底部跟着滑动的 浮动条 默认隐藏*/
@property (nonatomic,strong)UIView *sliderView;

/* 左边遮罩 默认隐藏*/
@property (nonatomic,strong)UIView *leftMaskView;

/* 右边遮罩 默认隐藏*/
@property (nonatomic,strong)UIView *rightMaskView;

- (void)selectedIndex:(NSInteger)aIndex needRespondsDelegate:(BOOL)aNeedRespondsDelegate;

- (void)deselected_needRespondsDelegate:(BOOL)aNeedRespondsDelegate;

- (void)reloadData;

- (KKButton*)buttonAtIndex:(NSInteger)aIndex;



@end

@protocol KKSegmentViewDelegate <NSObject>
@required
/**
 有多少个按钮
 */
- (NSInteger)KKSegmentView_NumberOfButtons:(KKSegmentView*)aSegmentView;


- (KKButton*)KKSegmentView:(KKSegmentView*)aSegmentView
            buttonForIndex:(NSInteger)aIndex;


@optional
/*
 被选中的Button再次被点击
 */
- (void)KKSegmentView:(KKSegmentView*)aSegementView
    selectedSameIndex:(NSInteger)aIndex;

/*
 选中了新的Button
 */
- (void)KKSegmentView:(KKSegmentView*)aSegementView
    willDeselectIndex:(NSInteger)aOldIndex
   willSelectNewIndex:(NSInteger)aNewIndex;

@end




