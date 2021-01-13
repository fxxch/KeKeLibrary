//
//  KKRefreshFooterAutoView.h
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKRefreshFooterAutoStateView.h"

@protocol KKRefreshFooterAutoViewDelegate;


@interface KKRefreshFooterAutoView : UIView

@property (nonatomic,strong)KKRefreshFooterAutoStateView *stateView;

/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setNoMoreData;

@end




#pragma mark ==================================================
#pragma mark == KKRefreshFooterAutoViewDelegate
#pragma mark ==================================================
@protocol KKRefreshFooterAutoViewDelegate <NSObject>

@required
//触发加载数据
- (void)KKRefreshFooterAutoView_BeginLoadMore:(KKRefreshFooterAutoView*)view;





@optional
/**
 自定义标题
 
 @param state 状态
 @return 文字
 */
- (NSString*)KKRefreshFooterAutoView_TextForState:(KKFAutoRefreshState)state;


/**
 根据不同状态，可以自定义View。
 
 @param aView KKRefreshFooterAutoView
 @param state 状态
 @return 返回自定义的View
 */
- (UIView*)KKRefreshFooterAutoView:(KKRefreshFooterAutoView*)aView
              customerViewForState:(KKFAutoRefreshState)state;

/**
 返回自定义View的高度(不实现该协议或返回0，则默认值是KKRefreshFooterAutoStateView_H高度)
 
 @param aView KKRefreshFooterAutoView
 @return 返回自定义的View的高度
 */
- (CGFloat)KKRefreshFooterAutoView_heightForCustomerView:(KKRefreshFooterAutoView*)aView;

@end





#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIScrollView (KKUIScrollViewFooterAExtension)

/*开启 加载更多*/
- (void)showRefreshFooterAutoWithDelegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate;

/*开启 加载更多 增加一点偏移量，相当于KKRefreshFooterAutoView的顶部不是与ScrollView的底部齐平，有一段间隙*/
- (void)showRefreshFooterAutoWithDelegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate
                                  offsetY:(CGFloat)offsetY;

/*关闭 加载更多*/
- (void)hideRefreshFooterAuto;

/*开始 加载更多*/
- (void)startRefreshFooterAuto;

/*停止 加载更多*/
- (void)stopRefreshFooterAuto;

/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setRefreshFooterAutoNoMoreData;

@property (nonatomic, strong, readonly) KKRefreshFooterAutoView *refreshFooterAuto;
@property (nonatomic, assign, readonly) BOOL haveFooterAuto;

@end









