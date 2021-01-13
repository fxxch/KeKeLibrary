//
//  KKRefreshFooterTouchView.h
//  YouJia
//
//  Created by liubo on 2018/7/16.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKRefreshFooterTouchStateView.h"

@protocol KKRefreshFooterTouchViewDelegate;

@interface KKRefreshFooterTouchView : UIView

@property (nonatomic,strong)KKRefreshFooterTouchStateView *stateView;

/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setNoMoreData;

@end




#pragma mark ==================================================
#pragma mark == KKRefreshFooterTouchViewDelegate
#pragma mark ==================================================
@protocol KKRefreshFooterTouchViewDelegate <NSObject>

@required
//触发加载数据
- (void)KKRefreshFooterTouchView_BeginLoadMore:(KKRefreshFooterTouchView*)view;






@optional
/**
 自定义标题
 
 @param state 状态
 @return 文字
 */
- (NSString*)KKRefreshFooterTouchView_TextForState:(KKFTouchRefreshState)state;


/**
 根据不同状态，可以自定义View。
 
 @param aView KKRefreshFooterTouchView
 @param state 状态
 @return 返回自定义的View
 */
- (UIView*)KKRefreshFooterTouchView:(KKRefreshFooterTouchView*)aView
               customerViewForState:(KKFTouchRefreshState)state;

/**
 返回自定义View的高度(不实现该协议或返回0，则默认值是KKRefreshFooterTouchView_H高度)
 
 @param aView KKRefreshFooterTouchView
 @return 返回自定义的View的高度
 */
- (CGFloat)KKRefreshFooterTouchView_heightForCustomerView:(KKRefreshFooterTouchView*)aView;


@end





#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIScrollView (KKUIScrollViewFooterTouchExtension)

/*开启 加载更多*/
- (void)showRefreshFooterTouchWithDelegate:(id<KKRefreshFooterTouchViewDelegate>)aDelegate;

/*开启 加载更多 增加一点偏移量，相当于KKRefreshFooterTouchView的顶部不是与ScrollView的底部齐平，有一段间隙*/
- (void)showRefreshFooterTouchWithDelegate:(id<KKRefreshFooterTouchViewDelegate>)aDelegate
                                   offsetY:(CGFloat)offsetY;

/*关闭 加载更多*/
- (void)hideRefreshFooterTouch;

/*开始 加载更多*/
- (void)startRefreshFooterTouch;

/*停止 加载更多*/
- (void)stopRefreshFooterTouch;

/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setRefreshFooterTouchNoMoreData;

@property (nonatomic, strong, readonly) KKRefreshFooterTouchView *refreshFooterTouch;
@property (nonatomic, assign, readonly) BOOL haveFooterTouch;

@end
