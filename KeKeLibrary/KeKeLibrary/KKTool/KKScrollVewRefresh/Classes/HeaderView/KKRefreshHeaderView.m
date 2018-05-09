//
//  KKRefreshHeaderView.m
//  KKLibrary
//
//  Created by liubo on 13-6-27.
//  Copyright (c) 2013年 KKLibrary. All rights reserved.
//

#import "KKRefreshHeaderView.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"

#define TEXT_COLOR  [UIColor colorWithRed:0.49f green:0.50f blue:0.49f alpha:1.00f]
#define TEXT_FONT   [UIFont systemFontOfSize:14]
#define FLIP_ANIMATION_DURATION 0.18f
#define EdgeInsets_Y 50.0f

@interface KKRefreshHeaderView ()

- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshHeaderViewDelegate>)aDelegate;

- (void)startRefresh;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView text:(NSString*)aText;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@implementation KKRefreshHeaderView
@synthesize delegate=_delegate;
@synthesize state = _state;
//@synthesize statusLabel = _statusLabel;
//@synthesize arrowImageView = _arrowImageView;
//@synthesize activityView = _activityView;
//
//@synthesize statusTextForPulling = _statusTextForPulling;
//@synthesize statusTextForNormal = _statusTextForNormal;
//@synthesize statusTextForLoading = _statusTextForLoading;
//@synthesize refreshImageCustomer = _refreshImageCustomer;
@synthesize refreshImageStyle = _refreshImageStyle;


- (void)dealloc{
    [self unobserveAllNotification];
    
    NSLog(@"KKRefreshHeaderView dealloc");
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshHeaderViewDelegate>)aDelegate{
    CGRect frame = scrollView.bounds;
    if(self = [super initWithFrame:CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height)]) {
        
        _delegate = aDelegate;
        delegateClass = object_getClass(_delegate);

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
                
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.statusLabel.font = TEXT_FONT;
        self.statusLabel.textColor = TEXT_COLOR;
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65.0f, frame.size.height - 50.0f, 15.0f, 40.0f)];
        NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
        UIImage *image = [UIImage imageWithContentsOfFile:filepath];
        self.arrowImageView.image = image;
//        self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        [self addSubview:self.arrowImageView];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.frame = CGRectMake(65.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        [self addSubview:self.activityView];
        
        [scrollView addSubview:self];
//        [scrollView setValue:self forKey:@"refreshHeader"];
        
        [self setState:KKHPullRefreshState_Normal];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 自定义
#pragma mark ==================================================
- (void)setRefreshImageCustomer:(UIImage *)refreshImageCustomer{
    _refreshImageCustomer = refreshImageCustomer;
    [self reload];
}

- (void)setStatusTextForLoading:(NSString *)statusTextForLoading{
    _statusTextForLoading = statusTextForLoading;
    [self reload];
}

- (void)setStatusTextForNormal:(NSString *)statusTextForNormal{
    _statusTextForNormal = statusTextForNormal;
    [self reload];
}

- (void)setStatusTextForPulling:(NSString *)statusTextForPulling{
    _statusTextForPulling = statusTextForPulling;
    [self reload];
}

- (void)setRefreshImageStyle:(KKHPullRefreshImageStyle)refreshImageStyle{
    _refreshImageStyle = refreshImageStyle;
    [self reload];
}

- (void)reload{
    if (_refreshImageCustomer) {
        self.arrowImageView.image = _refreshImageCustomer;
    }
    else{
        if (_refreshImageStyle==KKHPullRefreshImageStyle_Default) {
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
//            self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_Black){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blackArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
//            self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_Blue){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blueArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
//            self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_Gray){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/grayArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
//            self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_White){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
//            self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else{
            
        }
    }
    
    [self setState:_state];
}

#pragma mark ==================================================
#pragma mark == 手动刷新
#pragma mark ==================================================
- (void)startRefresh{
    UIView *v = self.superview;
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scr = (UIScrollView*)v;
        if (!(_state == KKHPullRefreshState_Loading)) {
            
            [self setState:KKHPullRefreshState_Loading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scr.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            [UIView commitAnimations];

            Class currentClass = object_getClass(_delegate);
            if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate refreshTableHeaderDidTriggerRefresh:self];
            }
        }
        [scr setContentOffset:CGPointMake(0, -EdgeInsets_Y) animated:YES];
    }
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KKHPullRefreshState)aState{
    switch (aState) {
        case KKHPullRefreshState_Pulling:{
            if (self.statusTextForPulling) {
                self.statusLabel.text = self.statusTextForPulling;
            }
            else{
                self.statusLabel.text = KILocalization(@"释放更新");
            }
            [self.activityView stopAnimating];
            self.arrowImageView.hidden = NO;
            
            [self reloadSubviewsFrame];
            CGAffineTransform endAngle = CGAffineTransformMakeRotation(180.0f*(M_PI/180.0f));
            [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
                self.arrowImageView.transform = endAngle;
            } completion:^(BOOL finished) {
                
            }];
            break;
        }
        case KKHPullRefreshState_Normal:{
            if (self.statusTextForNormal) {
                self.statusLabel.text = self.statusTextForNormal;
            }
            else{
                self.statusLabel.text = KILocalization(@"下拉刷新");
            }
            
            [self.activityView stopAnimating];
            self.arrowImageView.hidden = NO;
            
            [self reloadSubviewsFrame];
            CGAffineTransform endAngle2 = CGAffineTransformMakeRotation(0.0f*(M_PI/180.0f));
            [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
                self.arrowImageView.transform = endAngle2;
            } completion:^(BOOL finished) {
                
            }];
            
            break;
        }
        case KKHPullRefreshState_Loading:{
            if (self.statusTextForLoading) {
                self.statusLabel.text = self.statusTextForLoading;
            }
            else{
                self.statusLabel.text = KILocalization(@"加载中…");
            }
            [self.activityView startAnimating];
            self.arrowImageView.hidden = YES;
            
            [self reloadSubviewsFrame];
            break;
        }
        default:
            break;
    }
    _state = aState;
}


- (void)reloadSubviewsFrame{
    
    if (self.arrowImageView.hidden) {
        self.statusLabel.font = TEXT_FONT;
        
        CGSize size01 = [self.statusLabel.text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
        
        CGSize arrowImageSize = self.activityView.frame.size;
        if (size01.height>arrowImageSize.height) {
            self.activityView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width-5)/2.0,
                                             self.frame.size.height-15-size01.height+(size01.height-arrowImageSize.height)/2.0,
                                             arrowImageSize.width,
                                             arrowImageSize.height);
            self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.activityView.frame)+5,
                                            self.frame.size.height-15-size01.height,
                                            size01.width,
                                            size01.height);
        }
        else{
            self.activityView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width-5)/2.0,
                                             self.frame.size.height-15-arrowImageSize.height,
                                             arrowImageSize.width,
                                             arrowImageSize.height);
            self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.activityView.frame)+5,
                                            self.frame.size.height-15-arrowImageSize.height+(arrowImageSize.height-size01.height)/2.0,
                                            size01.width,
                                            size01.height);
        }
    }
    else{
        self.statusLabel.font = TEXT_FONT;
        
        CGSize size01 = [self.statusLabel.text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
        
        CGSize arrowImageSize = self.arrowImageView.image.size;
        self.arrowImageView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width)/2.0,
                                         self.frame.size.height-15-arrowImageSize.height,
                                         arrowImageSize.width,
                                         arrowImageSize.height);
        self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.arrowImageView.frame),
                                        self.frame.size.height-15-arrowImageSize.width+(arrowImageSize.height-size01.height)/2.0,
                                        size01.width,
                                        size01.height);
    }
}

#pragma mark ==================================================
#pragma mark == 滚动
#pragma mark ==================================================
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y>=0) {
        return;
    }
    
    if (_state == KKHPullRefreshState_Loading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(offset, 0.0f, edgeInsets.bottom, 0.0f)];
    }
    else if (scrollView.isDragging) {
        if (_state == KKHPullRefreshState_Pulling && scrollView.contentOffset.y > -EdgeInsets_Y && scrollView.contentOffset.y < 0.0f) {
            [self setState:KKHPullRefreshState_Normal];
        } else if (_state == KKHPullRefreshState_Normal && scrollView.contentOffset.y < -EdgeInsets_Y) {
            [self setState:KKHPullRefreshState_Pulling];
        }
        
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y>=0) {
        return;
    }
    
    if (_state == KKHPullRefreshState_Loading) {
        [self setState:KKHPullRefreshState_Loading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(60.0f, 0.0f, edgeInsets.bottom, 0.0f)];
        [UIView commitAnimations];
    }
    else{
        if (scrollView.contentOffset.y <= - EdgeInsets_Y && !(_state == KKHPullRefreshState_Loading)) {
            [self setState:KKHPullRefreshState_Loading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            [scrollView setContentInset:UIEdgeInsetsMake(60.0f, 0.0f, edgeInsets.bottom, 0.0f)];
            [UIView commitAnimations];

            Class currentClass = object_getClass(_delegate);
            if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate refreshTableHeaderDidTriggerRefresh:self];
            }
        }
    }
    //    [MediaController playMedia:@"playend" type:@"wav" loopsNum:0];
}


- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView text:(NSString*)aText{
    [self setState:KKHPullRefreshState_Normal];
    [self performSelector:@selector(finished:) withObject:scrollView afterDelay:0.5];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    [self setState:KKHPullRefreshState_Normal];
    [self performSelector:@selector(finished:) withObject:scrollView afterDelay:0.5];
}


- (void)finished:(UIScrollView*)scrollView{
//    NSLog(@"结束动画:%@",scrollView);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = scrollView.contentInset;
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, edgeInsets.bottom, 0.0f)];
    [UIView commitAnimations];
}


@end
#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KKUIScrollViewHeaderExtension)
@dynamic refreshHeader;
@dynamic haveHeader;

- (void)setHaveHeader:(NSNumber *)haveHeader{
    objc_setAssociatedObject(self, @"haveHeader", haveHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)haveHeader{
    return objc_getAssociatedObject(self, @"haveHeader");
}

- (void)setRefreshHeader:(KKRefreshHeaderView *)refreshHeader{
    objc_setAssociatedObject(self, @"refreshHeader", refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KKRefreshHeaderView *)refreshHeader{
    if ([objc_getAssociatedObject(self, @"haveHeader") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshHeader");
    }
    else{
        return nil;
    }
}

/*开启 刷新数据*/
- (void)showRefreshHeaderWithDelegate:(id<KKRefreshHeaderViewDelegate>)aDelegate{
    if (!self.refreshHeader) {
        KKRefreshHeaderView *headView = [[KKRefreshHeaderView alloc] initWithScrollView:self delegate:aDelegate];
        [self setRefreshHeader:headView];
        
        headView.backgroundColor = [UIColor clearColor];
        headView.statusLabel.textColor = [UIColor blackColor];
        headView.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.haveHeader = [NSNumber numberWithBool:YES];
    }
}

/*关闭 刷新数据*/
- (void)hideRefreshHeader{
    if (self.refreshHeader) {
        KKRefreshHeaderView *header = self.refreshHeader;
        objc_removeAssociatedObjects(self.refreshHeader);
        [header removeFromSuperview];
        self.haveHeader = [NSNumber numberWithBool:NO];
    }
}

/*开始 刷新数据*/
- (void)startRefreshHeader{
    if (self.refreshHeader) {
        [self.refreshHeader startRefresh];
    }
}

/*停止 刷新数据*/
- (void)stopRefreshHeader:(NSString*)aText{
    if (self.refreshHeader) {
        [self.refreshHeader refreshScrollViewDataSourceDidFinishedLoading:self text:aText];
    }
}

- (void)stopRefreshHeader{
    if (self.refreshHeader) {
        [self.refreshHeader refreshScrollViewDataSourceDidFinishedLoading:self];
    }
}


@end
























