//
//  KKRefreshHeaderView.h
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKRefreshHeaderStateView.h"

@protocol KKRefreshHeaderViewDelegate;

@interface KKRefreshHeaderView : UIView

@property (nonatomic,strong)KKRefreshHeaderStateView *stateView;

@end


#pragma mark ==================================================
#pragma mark == KKRefreshHeaderViewDelegate
#pragma mark ==================================================
@protocol KKRefreshHeaderViewDelegate <NSObject>

@optional

//触发刷新加载数据
- (void)KKRefreshHeaderView_BeginRefresh:(KKRefreshHeaderView*)view;

/**
 自定义标题

 @param state 状态
 @return 文字
 */
- (NSString*)KKRefreshHeaderView_TextForState:(KKHPullRefreshState)state;


/**
 根据不同状态，可以自定义View。

 @param aView KKRefreshHeaderView
 @param state 状态
 @return 返回自定义的View
 */
- (UIView*)KKRefreshHeaderView:(KKRefreshHeaderView*)aView
          customerViewForState:(KKHPullRefreshState)state;

/**
 返回自定义View的高度(不实现该协议或返回0，则默认值是KKRefreshHeaderStateView_H高度)
 
 @param aView KKRefreshHeaderView
 @return 返回自定义的View的高度
 */
- (CGFloat)KKRefreshHeaderView_heightForCustomerView:(KKRefreshHeaderView*)aView;



@end







#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>

@interface UIScrollView (KKUIScrollViewHeaderExtension)

/*开启 刷新数据*/
- (void)showRefreshHeaderWithDelegate:(id<KKRefreshHeaderViewDelegate>)aDelegate;

/*开启 刷新数据 增加一点偏移量，相当于RefreshHeaderView的底部不是与ScrollView的顶部齐平，有一段间隙*/
- (void)showRefreshHeaderWithDelegate:(id<KKRefreshHeaderViewDelegate>)aDelegate
                              offsetY:(CGFloat)offsetY;

/*关闭 刷新数据*/
- (void)hideRefreshHeader;

/*开始 刷新数据*/
- (void)startRefreshHeader;

/*停止 刷新数据*/
- (void)stopRefreshHeader;


@property (nonatomic, strong, readonly) KKRefreshHeaderView *refreshHeader;
@property (nonatomic, assign, readonly) BOOL haveHeader;

@end



