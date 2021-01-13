//
//  KKRefreshFooterDraggingStateView.h
//  YouJia
//
//  Created by liubo on 2018/7/20.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKView.h"
#import <QuartzCore/QuartzCore.h>

#define KKRefreshDraggingStateView_H 50.0f

typedef enum{
    KKFDraggingRefreshState_Pulling = 0,
    KKFDraggingRefreshState_Normal = 1,
    KKFDraggingRefreshState_Loading = 2,
    KKFDraggingRefreshState_NoMoreData = 3,
} KKFDraggingRefreshState;

typedef enum{
    KKFDraggingRefreshImageStyle_Default = 0,
    KKFDraggingRefreshImageStyle_Black = 1,
    KKFDraggingRefreshImageStyle_Blue = 2,
    KKFDraggingRefreshImageStyle_Gray = 3,
    KKFDraggingRefreshImageStyle_White = 4,
} KKFDraggingRefreshImageStyle;

@protocol KKRefreshFooterDraggingStateViewDelegate;

@interface KKRefreshFooterDraggingStateView : KKView

@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UIActivityIndicatorView *activityView;
@property (nonatomic,assign)KKFDraggingRefreshImageStyle refreshImageStyle;
@property (nonatomic , weak) id<KKRefreshFooterDraggingStateViewDelegate> delegate;

- (void)reloadUIForState:(KKFDraggingRefreshState)state;

@end

#pragma mark ==================================================
#pragma mark == KKRefreshFooterDraggingStateViewDelegate
#pragma mark ==================================================
@protocol KKRefreshFooterDraggingStateViewDelegate <NSObject>
@optional

- (NSString*)KKRefreshFooterDraggingStateView:(KKRefreshFooterDraggingStateView*)aView
                                 textForState:(KKFDraggingRefreshState)state;

@end

