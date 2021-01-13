//
//  KKRefreshFooterAutoStateView.m
//  YouJia
//
//  Created by liubo on 2018/7/20.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKRefreshFooterAutoStateView.h"
#import "NSString+KKCategory.h"
#import "UIFont+KKCategory.h"
#import "KKLocalizationManager.h"
#import "KKLibraryDefine.h"

#define RefreshFooterAuto_TEXT_COLOR  [UIColor colorWithRed:0.49f green:0.50f blue:0.49f alpha:1.00f]
#define RefreshFooterAuto_TEXT_FONT   [UIFont systemFontOfSize:14]
#define RefreshFooterAuto_FLIP_ANIMATION_DURATION 0.18f

@interface KKRefreshFooterAutoStateView ()

@property(nonatomic,assign)KKFAutoRefreshState state;

@end

@implementation KKRefreshFooterAutoStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    CGSize size = [UIFont sizeOfFont:RefreshFooterAuto_TEXT_FONT];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height-size.height)/2.0)];
    self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.statusLabel.font = RefreshFooterAuto_TEXT_FONT;
    self.statusLabel.textColor = RefreshFooterAuto_TEXT_COLOR;
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.statusLabel];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.frame = CGRectMake(0, (self.frame.size.height - 20.0f)/2.0, 20.0f, 20.0f);
    [self addSubview:self.activityView];
    
    [self reloadUIForState:KKFAutoRefreshState_Normal];
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)reloadUIForState:(KKFAutoRefreshState)state{
    
    NSString *text = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshFooterAutoStateView:textForState:)]) {
        text = [self.delegate KKRefreshFooterAutoStateView:self textForState:state];
    }

    switch (state) {
        case KKFAutoRefreshState_Normal:{
            
            if (text==nil) {
                text = KKLibLocalizable_refresh_LoadMore;
            }
            CGSize textSize = [text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
            
            //转圈
            [self.activityView stopAnimating];
            
            //文字
            CGFloat textX = (self.frame.size.width-textSize.width)/2.0;
            CGFloat textY = (self.frame.size.height-textSize.height)/2.0;
            CGFloat textW = textSize.width;
            CGFloat textH = textSize.height;
            self.statusLabel.frame = CGRectMake(textX,textY,textW,textH);
            self.statusLabel.text = text;

            break;
        }
        case KKFAutoRefreshState_Loading:{
            
            if (text==nil) {
                text = KKLibLocalizable_refresh_Loading;
            }
            CGSize textSize = [text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
            CGSize arrowSize = self.activityView.frame.size;
            
            //转圈
            [self.activityView startAnimating];
            CGFloat activityX = (self.frame.size.width-textSize.width-arrowSize.width-5)/2.0;
            CGFloat activityY = (self.frame.size.height-textSize.height)/2.0;
            CGFloat activityW = arrowSize.width;
            CGFloat activityH = arrowSize.height;
            self.activityView.frame = CGRectMake(activityX,activityY,activityW,activityH);
            
            //文字
            CGFloat textX = CGRectGetMaxX(self.activityView.frame)+5;
            CGFloat textY = (self.frame.size.height-textSize.height)/2.0;
            CGFloat textW = textSize.width;
            CGFloat textH = textSize.height;
            self.statusLabel.frame = CGRectMake(textX,textY,textW,textH);
            self.statusLabel.text = text;
            break;
        }
        case KKFAutoRefreshState_NoMoreData:{
            
            if (text==nil) {
                text = KKLibLocalizable_refresh_NoMore;
            }
            CGSize textSize = [text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
            
            //转圈
            [self.activityView stopAnimating];
            
            //文字
            CGFloat textX = (self.frame.size.width-textSize.width)/2.0;
            CGFloat textY = (self.frame.size.height-textSize.height)/2.0;
            CGFloat textW = textSize.width;
            CGFloat textH = textSize.height;
            self.statusLabel.frame = CGRectMake(textX,textY,textW,textH);
            self.statusLabel.text = text;
            
            break;
        }
        default:
            break;
    }
    
    _state = state;
}


@end

