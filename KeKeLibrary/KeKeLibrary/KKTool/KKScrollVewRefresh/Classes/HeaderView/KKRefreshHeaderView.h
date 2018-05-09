//
//  KKRefreshHeaderView.h
//  KKLibrary
//
//  Created by liubo on 13-6-27.
//  Copyright (c) 2013年 KKLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
    KKHPullRefreshState_Pulling = 0,
    KKHPullRefreshState_Normal = 1,
    KKHPullRefreshState_Loading = 2,
} KKHPullRefreshState;

typedef enum{
    KKHPullRefreshImageStyle_Default = 0, //whiteArrow.png
    KKHPullRefreshImageStyle_Black   = 1, //blackArrow.png
    KKHPullRefreshImageStyle_Blue    = 2, //blueArrow.png
    KKHPullRefreshImageStyle_Gray    = 3, //grayArrow.png
    KKHPullRefreshImageStyle_White   = 4, //whiteArrow.png
} KKHPullRefreshImageStyle;

@protocol KKRefreshHeaderViewDelegate;

@interface KKRefreshHeaderView : UIView{
    
    __weak id _delegate;
    Class delegateClass;

    KKHPullRefreshState _state;
//    UILabel *_statusLabel;
//    UIImageView *_arrowImageView;
//    UIActivityIndicatorView *_activityView;
    
//    NSString *_statusTextForPulling;
//    NSString *_statusTextForNormal;
//    NSString *_statusTextForLoading;
//    UIImage  *_refreshImageCustomer;
    KKHPullRefreshImageStyle _refreshImageStyle;
}

@property(nonatomic,weak) id <KKRefreshHeaderViewDelegate> delegate;

@property (nonatomic,assign)KKHPullRefreshState state;
@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UIActivityIndicatorView *activityView;

/*用于外部自定义样式*/
@property (nonatomic,copy)NSString *statusTextForPulling;//松开即可刷新...
@property (nonatomic,copy)NSString *statusTextForNormal;//下拉可以刷新...
@property (nonatomic,copy)NSString *statusTextForLoading;//更新中...
@property (nonatomic,copy)UIImage  *refreshImageCustomer;
@property (nonatomic,assign)KKHPullRefreshImageStyle refreshImageStyle;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end


#pragma mark ==================================================
#pragma mark == KKRefreshHeaderViewDelegate
#pragma mark ==================================================
@protocol KKRefreshHeaderViewDelegate <NSObject>

@optional

//触发刷新加载数据
- (void)refreshTableHeaderDidTriggerRefresh:(KKRefreshHeaderView*)view;

@end







#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>

@interface UIScrollView (KKUIScrollViewHeaderExtension)

/*开启 刷新数据*/
- (void)showRefreshHeaderWithDelegate:(id<KKRefreshHeaderViewDelegate>)aDelegate;

/*关闭 刷新数据*/
- (void)hideRefreshHeader;

/*开始 刷新数据*/
- (void)startRefreshHeader;

/*停止 刷新数据*/
- (void)stopRefreshHeader:(NSString*)aText;
- (void)stopRefreshHeader;


@property (nonatomic, strong, readonly) KKRefreshHeaderView *refreshHeader;
@property (nonatomic, copy, readonly) NSNumber *haveHeader;

@end


