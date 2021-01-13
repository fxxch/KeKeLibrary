//
//  KKRefreshFooterTouchStateView.h
//  YouJia
//
//  Created by liubo on 2018/7/21.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKView.h"
#import <QuartzCore/QuartzCore.h>

#define KKRefreshFooterTouchStateView_H 50.0f

typedef enum{
    KKFTouchRefreshState_Normal = 1,
    KKFTouchRefreshState_Loading = 2,
    KKFTouchRefreshState_NoMoreData = 3,
} KKFTouchRefreshState;

@protocol KKRefreshFooterTouchStateViewDelegate;

@interface KKRefreshFooterTouchStateView : KKView

@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UIActivityIndicatorView *activityView;
@property (nonatomic , weak) id<KKRefreshFooterTouchStateViewDelegate> delegate;

- (void)reloadUIForState:(KKFTouchRefreshState)state;


@end

#pragma mark ==================================================
#pragma mark == KKRefreshFooterTouchStateViewDelegate
#pragma mark ==================================================
@protocol KKRefreshFooterTouchStateViewDelegate <NSObject>
@optional

- (NSString*)KKRefreshFooterTouchStateView:(KKRefreshFooterTouchStateView*)aView
                              textForState:(KKFTouchRefreshState)state;

@end
