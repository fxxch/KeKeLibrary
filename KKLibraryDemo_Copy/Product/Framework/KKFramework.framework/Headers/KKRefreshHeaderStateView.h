//
//  KKRefreshHeaderStateView.h
//  YouJia
//
//  Created by liubo on 2018/7/19.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKView.h"
#import <QuartzCore/QuartzCore.h>

#define KKRefreshHeaderStateView_H 50.0f

typedef enum{
    KKHPullRefreshState_Pulling = 0,
    KKHPullRefreshState_Normal = 1,
    KKHPullRefreshState_Loading = 2,
} KKHPullRefreshState;

typedef enum{
    KKHPullRefreshImageStyle_Default = 0, //blackArrow.png
    KKHPullRefreshImageStyle_Black   = 1, //blackArrow.png
    KKHPullRefreshImageStyle_Blue    = 2, //blueArrow.png
    KKHPullRefreshImageStyle_Gray    = 3, //grayArrow.png
    KKHPullRefreshImageStyle_White   = 4, //whiteArrow.png
} KKHPullRefreshImageStyle;


@protocol KKRefreshHeaderStateViewDelegate;

@interface KKRefreshHeaderStateView : KKView

@property (nonatomic,strong)UILabel *statusLabel;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UIActivityIndicatorView *activityView;
@property (nonatomic,assign)KKHPullRefreshImageStyle refreshImageStyle;
@property (nonatomic , weak) id<KKRefreshHeaderStateViewDelegate> delegate;

- (void)reloadUIForState:(KKHPullRefreshState)state;

@end


#pragma mark ==================================================
#pragma mark == KKRefreshHeaderStateViewDelegate
#pragma mark ==================================================
@protocol KKRefreshHeaderStateViewDelegate <NSObject>
@optional

- (NSString*)KKRefreshHeaderStateView:(KKRefreshHeaderStateView*)aView
                         textForState:(KKHPullRefreshState)state;

@end

