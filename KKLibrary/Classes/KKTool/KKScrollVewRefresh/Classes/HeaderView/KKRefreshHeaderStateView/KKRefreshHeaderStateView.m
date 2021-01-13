//
//  KKRefreshHeaderStateView.m
//  YouJia
//
//  Created by liubo on 2018/7/19.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKRefreshHeaderStateView.h"
#import "NSString+KKCategory.h"
#import "UIFont+KKCategory.h"
#import "KKLocalizationManager.h"
#import "KKLibraryDefine.h"
#import "UIDevice+KKCategory.h"
#import "NSBundle+KKCategory.h"
#import "KKLog.h"

#define TEXT_COLOR  [UIColor colorWithRed:0.49f green:0.50f blue:0.49f alpha:1.00f]
#define TEXT_FONT   [UIFont systemFontOfSize:14]
#define FLIP_ANIMATION_DURATION 0.18f


@interface KKRefreshHeaderStateView ()

@property(nonatomic,assign)KKHPullRefreshState state;

@end



@implementation KKRefreshHeaderStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    CGSize size = [UIFont sizeOfFont:TEXT_FONT];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height-size.height)/2.0)];
    self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.statusLabel.font = TEXT_FONT;
    self.statusLabel.textColor = TEXT_COLOR;
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.statusLabel];
    
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 38.0f)/2.0, 38.0f, 38.0f)];
    UIImage *image = [NSBundle imageInBundle:@"KKScrollVewRefresh.bundle" imageName:@"blackArrow"];
    self.arrowImageView.image = image;
    [self addSubview:self.arrowImageView];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.frame = CGRectMake(0, (self.frame.size.height - 20.0f)/2.0, 20.0f, 20.0f);
    [self addSubview:self.activityView];
    
    [self reloadUIForState:KKHPullRefreshState_Normal];
}

#pragma mark ==================================================
#pragma mark == 自定义样式
#pragma mark ==================================================
- (void)setRefreshImageStyle:(KKHPullRefreshImageStyle)refreshImageStyle{
    _refreshImageStyle = refreshImageStyle;
    [self reload];
}

- (void)reload{
    if (_refreshImageStyle==KKHPullRefreshImageStyle_Default) {
        UIImage *image = [NSBundle imageInBundle:@"KKScrollVewRefresh.bundle" imageName:@"whiteArrow"];
        self.arrowImageView.image = image;
    }
    else if (_refreshImageStyle==KKHPullRefreshImageStyle_Black){
        UIImage *image = [NSBundle imageInBundle:@"KKScrollVewRefresh.bundle" imageName:@"blackArrow"];
        self.arrowImageView.image = image;
    }
    else if (_refreshImageStyle==KKHPullRefreshImageStyle_Blue){
        UIImage *image = [NSBundle imageInBundle:@"KKScrollVewRefresh.bundle" imageName:@"blueArrow"];
        self.arrowImageView.image = image;
    }
    else if (_refreshImageStyle==KKHPullRefreshImageStyle_Gray){
        UIImage *image = [NSBundle imageInBundle:@"KKScrollVewRefresh.bundle" imageName:@"grayArrow"];
        self.arrowImageView.image = image;
    }
    else if (_refreshImageStyle==KKHPullRefreshImageStyle_White){
        UIImage *image = [NSBundle imageInBundle:@"KKScrollVewRefresh.bundle" imageName:@"whiteArrow"];
        self.arrowImageView.image = image;
    }
    else{
        
    }

    [self reloadUIForState:_state];
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)reloadUIForState:(KKHPullRefreshState)state{
    
    NSString *text = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshHeaderStateView:textForState:)]) {
        text = [self.delegate KKRefreshHeaderStateView:self textForState:state];
    }
    
    switch (state) {
        case KKHPullRefreshState_Normal:{
            
            if ([NSString isStringEmpty:text]) {
                text = KKLibLocalizable_refresh_P;
                KKLogDebug(KKValidString(text));
            }
            CGSize textSize = [text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
            CGSize arrowSize = self.arrowImageView.image.size;

            //转圈
            [self.activityView stopAnimating];
            
            //箭头
            self.arrowImageView.hidden = NO;
            CGFloat arrowX = (self.frame.size.width-textSize.width-arrowSize.width)/2.0;
            CGFloat arrowY = (self.frame.size.height-arrowSize.height)/2.0;
            CGFloat arrowW = arrowSize.width;
            CGFloat arrowH = arrowSize.height;
            self.arrowImageView.frame = CGRectMake(arrowX,arrowY,arrowW,arrowH);

            //文字
            CGFloat textX = CGRectGetMaxX(self.arrowImageView.frame);
            CGFloat textY = (self.frame.size.height-textSize.height)/2.0;
            CGFloat textW = textSize.width;
            CGFloat textH = textSize.height;
            self.statusLabel.frame = CGRectMake(textX,textY,textW,textH);
            self.statusLabel.text = text;
            
            //动画
            CGAffineTransform endAngle2 = CGAffineTransformMakeRotation(0.0f*(M_PI/180.0f));
            [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
                self.arrowImageView.transform = endAngle2;
            } completion:^(BOOL finished) {
                
            }];
            
            break;
        }
        case KKHPullRefreshState_Pulling:{
            
            if ([UIDevice isSystemVersionBigerThan:@"10.0"]) {
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
                [feedBackGenertor prepare];
                [feedBackGenertor impactOccurred];
            }
            
            if ([NSString isStringEmpty:text]) {
                text = KKLibLocalizable_refresh_R;
            }
            CGSize textSize = [text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
            CGSize arrowSize = self.arrowImageView.image.size;
            
            //转圈
            [self.activityView stopAnimating];
            
            //箭头
            self.arrowImageView.hidden = NO;
            CGFloat arrowX = (self.frame.size.width-textSize.width-arrowSize.width)/2.0;
            CGFloat arrowY = (self.frame.size.height-arrowSize.height)/2.0;
            CGFloat arrowW = arrowSize.width;
            CGFloat arrowH = arrowSize.height;
            self.arrowImageView.frame = CGRectMake(arrowX,arrowY,arrowW,arrowH);
            
            //文字
            CGFloat textX = CGRectGetMaxX(self.arrowImageView.frame);
            CGFloat textY = (self.frame.size.height-textSize.height)/2.0;
            CGFloat textW = textSize.width;
            CGFloat textH = textSize.height;
            self.statusLabel.frame = CGRectMake(textX,textY,textW,textH);
            self.statusLabel.text = text;

            
            CGAffineTransform endAngle = CGAffineTransformMakeRotation(180.0f*(M_PI/180.0f));
            [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
                self.arrowImageView.transform = endAngle;
            } completion:^(BOOL finished) {
                
            }];
            break;
        }
        case KKHPullRefreshState_Loading:{

            if ([NSString isStringEmpty:text]) {
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

            //箭头
            self.arrowImageView.hidden = YES;
            
            //文字
            CGFloat textX = CGRectGetMaxX(self.activityView.frame)+5;
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
