//
//  KKRefreshFooterDraggingView.h
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	KKFDraggingRefreshState_Pulling = 0,
	KKFDraggingRefreshState_Normal = 1,
	KKFDraggingRefreshState_Loading = 2,
} KKFDraggingRefreshState;

typedef enum{
    KKFDraggingRefreshImageStyle_Default = 0,
    KKFDraggingRefreshImageStyle_Black = 1,
    KKFDraggingRefreshImageStyle_Blue = 2,
    KKFDraggingRefreshImageStyle_Gray = 3,
    KKFDraggingRefreshImageStyle_White = 4,
} KKFDraggingRefreshImageStyle;

@protocol KKRefreshFooterDraggingViewDelegate;


@interface KKRefreshFooterDraggingView : UIView

@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UIActivityIndicatorView *activityView;

/*用于外部自定义样式*/
@property (nonatomic,copy)NSString *statusTextForPulling;//松开即可刷新...
@property (nonatomic,copy)NSString *statusTextForNormal;//下拉可以刷新...
@property (nonatomic,copy)NSString *statusTextForLoading;//更新中...
@property (nonatomic,copy)UIImage  *refreshImageCustomer;
@property (nonatomic,assign)KKFDraggingRefreshImageStyle refreshImageStyle;

/* 以下两个方法已经废弃，无需再实现或者调用这两个方法了 */
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end




#pragma mark ==================================================
#pragma mark == KKRefreshFooterDraggingViewDelegate
#pragma mark ==================================================
@protocol KKRefreshFooterDraggingViewDelegate <NSObject>

@optional

//触发刷新加载数据
- (void)refreshTableFooterDraggingViewDidTriggerRefresh:(KKRefreshFooterDraggingView*)view;

@end





#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIScrollView (KKUIScrollViewFooterDExtension)

/*开启 加载更多*/
- (void)showRefreshFooterDraggingWithDelegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate;

/*关闭 加载更多*/
- (void)hideRefreshFooterDragging;

/*开始 加载更多*/
- (void)startRefreshFooterDragging;

/*停止 加载更多*/
- (void)stopRefreshFooterDragging:(NSString*)aText;
- (void)stopRefreshFooterDragging;

@property (nonatomic, strong, readonly) KKRefreshFooterDraggingView *refreshFooterDragging;
@property (nonatomic, assign, readonly) BOOL haveFooterDragging;

@end















