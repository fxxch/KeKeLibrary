//
//  KKRefreshFooterDraggingView.m
//  KKLibrary
//
//  Created by liubo on 13-6-27.
//  Copyright (c) 2013年 KKLibrary. All rights reserved.
//

#import "KKRefreshFooterDraggingView.h"
#import "KKSharedInstance.h"
#import "KKCategory.h"
#import "KeKeLibraryDefine.h"

#define TEXT_COLOR  [UIColor colorWithRed:0.49f green:0.50f blue:0.49f alpha:1.00f]
#define TEXT_FONT   [UIFont systemFontOfSize:14]
#define FLIP_ANIMATION_DURATION 0.18f
#define EdgeInsets_Y 50.0f


@interface KKRefreshFooterDraggingView ()

- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate;

- (void)startLoadingMore;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView text:(NSString*)aText;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


@end

@implementation KKRefreshFooterDraggingView
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
    
    NSLog(@"KKRefreshFooterDraggingView dealloc");
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate{
    CGRect frame = scrollView.bounds;
    if(self = [super initWithFrame:CGRectMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height), scrollView.frame.size.width, scrollView.frame.size.height)]) {

        _delegate = aDelegate;
        delegateClass = object_getClass(_delegate);

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.statusLabel.font = [UIFont systemFontOfSize:14.0f];
        self.statusLabel.textColor = TEXT_COLOR;
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65.0f, 5, 15.0f, 40.0f)];
        NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
        UIImage *image = [UIImage imageWithContentsOfFile:filepath];
        self.arrowImageView.image = image;
//        self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        [self addSubview:self.arrowImageView];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.frame = CGRectMake(105.0f, 15.0f, 20.0f, 20.0f);
        [self addSubview:self.activityView];
        
        [self setState:KKFDraggingRefreshState_Normal];
        
        [scrollView addSubview:self];
//        [scrollView setValue:self forKey:@"refreshFooterDragging"];
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

- (void)setRefreshImageStyle:(KKFDraggingRefreshImageStyle)refreshImageStyle{
    _refreshImageStyle = refreshImageStyle;
    [self reload];
}


- (void)reload{
    
    if (self.refreshImageCustomer) {
        self.arrowImageView.image = self.refreshImageCustomer;
    }
    else{
        if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Default) {
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
//            self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Black){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blackArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
//            self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Blue){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blueArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
//            self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Gray){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/grayArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
//            self.arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_White){
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
- (void)startLoadingMore{
    if (_state == KKFDraggingRefreshState_Loading) {
        return;
    }
    UIView *v = self.superview;
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)v;
        if (!(_state == KKFDraggingRefreshState_Loading)) {
            
            if (scrollView.contentSize.height>scrollView.frame.size.height) {
                if (scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height-EdgeInsets_Y) {
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.2];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                                 0.0f,
                                                                 EdgeInsets_Y,
                                                                 0.0f)];
                    [UIView commitAnimations];
                    
                    [self setState:KKFDraggingRefreshState_Loading];

                    Class currentClass = object_getClass(_delegate);
                    if ((currentClass == delegateClass) &&
                        [_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                        [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                    }
                }
            }
            else{
                if (scrollView.contentOffset.y>EdgeInsets_Y) {
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.2];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                                 0.0f,
                                                                 scrollView.frame.size.height-scrollView.contentSize.height+EdgeInsets_Y,
                                                                 0.0f)];
                    [UIView commitAnimations];
                    
                    [self setState:KKFDraggingRefreshState_Loading];

                    Class currentClass = object_getClass(_delegate);
                    if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                        [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                    }
                }
            }
        }
        [scrollView setContentOffset:CGPointMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height)) animated:YES];
    }
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KKFDraggingRefreshState)aState{
	switch (aState) {
        case KKFDraggingRefreshState_Pulling:{
            if (self.statusTextForPulling) {
                self.statusLabel.text = self.statusTextForPulling;
            }
            else{
                self.statusLabel.text = KILocalization(@"释放加载...");
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
        case KKFDraggingRefreshState_Normal:{
            if (self.statusTextForNormal) {
                self.statusLabel.text = self.statusTextForNormal;
            }
            else{
                self.statusLabel.text = KILocalization(@"上拉加载更多...");
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
        case KKFDraggingRefreshState_Loading:{
            if (self.statusTextForLoading) {
                self.statusLabel.text = self.statusTextForLoading;
            }
            else{
                self.statusLabel.text = KILocalization(@"加载中...");
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
        self.activityView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width-5)/2.0,
                                         (EdgeInsets_Y-arrowImageSize.height)/2.0,
                                         arrowImageSize.width,
                                         arrowImageSize.height);
        self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.activityView.frame)+5,
                                        (EdgeInsets_Y-size01.height)/2.0,
                                        size01.width,
                                        size01.height);
    }
    else{
        self.statusLabel.font = TEXT_FONT;
        
        CGSize size01 = [self.statusLabel.text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
        
        CGSize arrowImageSize = self.arrowImageView.image.size;
        self.arrowImageView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width)/2.0,
                                           (EdgeInsets_Y-arrowImageSize.height)/2.0,
                                           arrowImageSize.width,
                                           arrowImageSize.height);
        self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.arrowImageView.frame),
                                        (EdgeInsets_Y-size01.height)/2.0,
                                        size01.width,
                                        size01.height);
    }
}

#pragma mark ==================================================
#pragma mark == 滚动
#pragma mark ==================================================
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y<0) {
        return;
    }
    
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, scrollView.frame.size.width, scrollView.frame.size.height);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,scrollView.frame.size.width, scrollView.contentSize.height);
    }
    
    if (scrollView.contentSize.height-scrollView.contentOffset.y>=scrollView.frame.size.height) {
        return;
    }
    
    if (scrollView.isDragging) {
        if (scrollView.contentSize.height>scrollView.frame.size.height) {
            if (_state == KKFDraggingRefreshState_Pulling
                && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height)
                && (scrollView.contentSize.height-scrollView.contentOffset.y>scrollView.frame.size.height-EdgeInsets_Y)) {
                
                [self setState:KKFDraggingRefreshState_Normal];
            }
            else if (_state == KKFDraggingRefreshState_Normal
                     && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height)
                     && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height-EdgeInsets_Y)) {
                
                [self setState:KKFDraggingRefreshState_Pulling];
            }
        }
        else{
            if (_state == KKFDraggingRefreshState_Pulling
                && (scrollView.contentOffset.y>0)
                && (scrollView.contentOffset.y<EdgeInsets_Y)) {
                
                [self setState:KKFDraggingRefreshState_Normal];
            }
            else if (_state == KKFDraggingRefreshState_Normal
                     && (scrollView.contentOffset.y>EdgeInsets_Y)) {
                
                [self setState:KKFDraggingRefreshState_Pulling];
            }
        }
	}
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height-scrollView.contentOffset.y>=scrollView.frame.size.height) {
        return;
    }
    
    if (_state != KKFDraggingRefreshState_Loading) {
        if (scrollView.contentSize.height>scrollView.frame.size.height) {
            if (scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height-EdgeInsets_Y) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                             0.0f,
                                                             EdgeInsets_Y,
                                                             0.0f)];
                [UIView commitAnimations];
                
                [self setState:KKFDraggingRefreshState_Loading];

                Class currentClass = object_getClass(_delegate);
                if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                    [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                }
            }
        }
        else{
            if (scrollView.contentOffset.y>EdgeInsets_Y) {
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                             0.0f,
                                                             scrollView.frame.size.height-scrollView.contentSize.height+EdgeInsets_Y,
                                                             0.0f)];
                [UIView commitAnimations];
                
                [self setState:KKFDraggingRefreshState_Loading];

                Class currentClass = object_getClass(_delegate);
                if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                    [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                }
            }
        }
        
    }
    
    //    [MediaController playMedia:@"playend" type:@"wav" loopsNum:0];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView text:(NSString*)aText{
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, scrollView.frame.size.width, scrollView.frame.size.height);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,scrollView.frame.size.width, scrollView.contentSize.height);
    }
    
    [self setState:KKFDraggingRefreshState_Normal];
    [self finished:scrollView];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, scrollView.frame.size.width, scrollView.frame.size.height);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,scrollView.frame.size.width, scrollView.contentSize.height);
    }
        
    [self setState:KKFDraggingRefreshState_Normal];
    [self finished:scrollView];
}

- (void)finished:(UIScrollView*)scrollView{
    
    [UIView animateWithDuration:0.3 animations:^{
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
    } completion:^(BOOL finished) {
        
    }];
}

@end


#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KKUIScrollViewFooterDExtension)
@dynamic refreshFooterDragging;
@dynamic haveFooterDragging;

- (void)setHaveFooter:(NSNumber *)haveFooterDragging{
    objc_setAssociatedObject(self, @"haveFooterDragging", haveFooterDragging, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)haveFooterDragging{
    return objc_getAssociatedObject(self, @"haveFooterDragging");
}

- (void)setRefreshFooterDragging:(KKRefreshFooterDraggingView *)refreshFooterDragging{
    objc_setAssociatedObject(self, @"refreshFooterDragging", refreshFooterDragging, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KKRefreshFooterDraggingView *)refreshFooterDragging{
    if ([objc_getAssociatedObject(self, @"haveFooterDragging") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshFooterDragging");
    }
    else{
        return nil;
    }
}

/*开启 加载更多*/
- (void)showRefreshFooterDraggingWithDelegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate{
    if (!self.refreshFooterDragging) {
        KKRefreshFooterDraggingView *footerView = [[KKRefreshFooterDraggingView alloc] initWithScrollView:self delegate:aDelegate];
        [self setRefreshFooterDragging:footerView];
        footerView.backgroundColor = [UIColor clearColor];
        footerView.statusLabel.textColor = [UIColor blackColor];
        footerView.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.haveFooter = [NSNumber numberWithBool:YES];
    }
}

/*关闭 加载更多*/
- (void)hideRefreshFooterDragging{
    if (self.refreshFooterDragging) {
        KKRefreshFooterDraggingView *footer = self.refreshFooterDragging;
        objc_removeAssociatedObjects(self.refreshFooterDragging);
        [footer removeFromSuperview];
        self.haveFooter = [NSNumber numberWithBool:NO];
    }
}

/*开始 加载更多*/
- (void)startRefreshFooterDragging{
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging startLoadingMore];
    }
}


/*停止 加载更多*/
- (void)stopRefreshFooterDragging:(NSString*)aText{
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging refreshScrollViewDataSourceDidFinishedLoading:self text:aText];
    }
}

- (void)stopRefreshFooterDragging{
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging refreshScrollViewDataSourceDidFinishedLoading:self];
    }
}



@end


