//
//  KKRefreshFooterDraggingView.h
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKRefreshFooterDraggingStateView.h"

@protocol KKRefreshFooterDraggingViewDelegate;


@interface KKRefreshFooterDraggingView : UIView

@property (nonatomic,strong)KKRefreshFooterDraggingStateView *stateView;

/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setNoMoreData;

@end




#pragma mark ==================================================
#pragma mark == KKRefreshFooterDraggingViewDelegate
#pragma mark ==================================================
@protocol KKRefreshFooterDraggingViewDelegate <NSObject>

@required
//触发加载数据
- (void)KKRefreshFooterDraggingView_BeginLoadMore:(KKRefreshFooterDraggingView*)view;





@optional
/**
 自定义标题
 
 @param state 状态
 @return 文字
 */
- (NSString*)KKRefreshFooterDraggingView_TextForState:(KKFDraggingRefreshState)state;

/**
 根据不同状态，可以自定义View。
 
 @param aView KKRefreshFooterDraggingView
 @param state 状态
 @return 返回自定义的View
 */
- (UIView*)KKRefreshFooterDraggingView:(KKRefreshFooterDraggingView*)aView
                  customerViewForState:(KKFDraggingRefreshState)state;

/**
 返回自定义View的高度(不实现该协议或返回0，则默认值是KKRefreshFooterDraggingStateView_H高度)
 
 @param aView KKRefreshFooterDraggingView
 @return 返回自定义的View的高度
 */
- (CGFloat)KKRefreshFooterDraggingView_heightForCustomerView:(KKRefreshFooterDraggingView*)aView;

@end





#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIScrollView (KKUIScrollViewFooterDExtension)

/*开启 加载更多*/
- (void)showRefreshFooterDraggingWithDelegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate;

/*开启 加载更多 增加一点偏移量，相当于KKRefreshFooterDraggingView的顶部不是与ScrollView的底部齐平，有一段间隙*/
- (void)showRefreshFooterDraggingWithDelegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate
                              offsetY:(CGFloat)offsetY;

/*关闭 加载更多*/
- (void)hideRefreshFooterDragging;

/*开始 加载更多*/
- (void)startRefreshFooterDragging;

/*停止 加载更多*/
- (void)stopRefreshFooterDragging;

/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setRefreshFooterDraggingNoMoreData;

@property (nonatomic, strong, readonly) KKRefreshFooterDraggingView *refreshFooterDragging;
@property (nonatomic, assign, readonly) BOOL haveFooterDragging;

@end















