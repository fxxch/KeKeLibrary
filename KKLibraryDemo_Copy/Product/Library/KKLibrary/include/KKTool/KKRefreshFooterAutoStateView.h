//
//  KKRefreshFooterAutoStateView.h
//  YouJia
//
//  Created by liubo on 2018/7/20.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKView.h"
#import <QuartzCore/QuartzCore.h>

#define KKRefreshFooterAutoStateView_H 50.0f

@protocol KKRefreshFooterAutoStateViewDelegate;

typedef enum{
    KKFAutoRefreshState_Normal = 1,
    KKFAutoRefreshState_Loading = 2,
    KKFAutoRefreshState_NoMoreData = 3,
} KKFAutoRefreshState;

@interface KKRefreshFooterAutoStateView : KKView

@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UIActivityIndicatorView *activityView;
@property (nonatomic , weak) id<KKRefreshFooterAutoStateViewDelegate> delegate;

- (void)reloadUIForState:(KKFAutoRefreshState)state;

@end

#pragma mark ==================================================
#pragma mark == KKRefreshFooterAutoStateViewDelegate
#pragma mark ==================================================
@protocol KKRefreshFooterAutoStateViewDelegate <NSObject>
@optional

- (NSString*)KKRefreshFooterAutoStateView:(KKRefreshFooterAutoStateView*)aView
                             textForState:(KKFAutoRefreshState)state;

@end
