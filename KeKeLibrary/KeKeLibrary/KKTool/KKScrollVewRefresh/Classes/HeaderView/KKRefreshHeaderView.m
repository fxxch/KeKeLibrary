//
//  KKRefreshHeaderView.m
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KKRefreshHeaderView.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KeKeLibraryDefine.h"

#define TEXT_COLOR  [UIColor colorWithRed:0.49f green:0.50f blue:0.49f alpha:1.00f]
#define TEXT_FONT   [UIFont systemFontOfSize:14]
#define FLIP_ANIMATION_DURATION 0.18f
#define EdgeInsets_Y 50.0f

@interface KKRefreshHeaderView (){
    
    __weak id _delegate;
    Class delegateClass;
}

@property(nonatomic,weak) id <KKRefreshHeaderViewDelegate> delegate;
@property(nonatomic,assign)KKHPullRefreshState state;

- (id)initWithScrollView:(UIScrollView*)scrollView
                delegate:(id<KKRefreshHeaderViewDelegate>)aDelegate;

- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView;

- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView;;

- (void)startRefresh;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
                                                 text:(NSString*)aText;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@implementation KKRefreshHeaderView

- (void)dealloc{
    [self unobserveAllNotification];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];

    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;

    UIScrollView *oldSuperScrollView = (UIScrollView*)self.superview;
    
    // 旧的父控件移除监听
    [self removeKVO_ForScrollView:oldSuperScrollView];
    
    // 新的的父控件添加监听
    [self addKVO_ForScrollView:(UIScrollView*)newSuperview];
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
        [self addSubview:self.arrowImageView];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.frame = CGRectMake(65.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        [self addSubview:self.activityView];
        
        [scrollView addSubview:self];
        
        [self setState:KKHPullRefreshState_Normal];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=11 &&
            [scrollView isKindOfClass:[UITableView class]]) {
            UITableView *table = (UITableView*)scrollView;
            table.estimatedRowHeight = 0;
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
        }

        
        [self addKVO_ForScrollView:scrollView];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 自定义样式
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
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_Black){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blackArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_Blue){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blueArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_Gray){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/grayArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_White){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
        }
        else{
            
        }
    }
    
    [self setState:_state];
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
#pragma mark == 【KVO】
#pragma mark ==================================================
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"]){
        [self scrollViewContentOffsetChanged:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
}

- (void)scrollViewContentOffsetChanged:(CGPoint)contentOffset
{
    UIScrollView * scrollView = (UIScrollView *)self.superview;
    
    if (scrollView.contentOffset.y>=0) {
        return;
    }
    
    if (self.state == KKHPullRefreshState_Loading) {
        return;
    }
    
    if (scrollView.isDragging) {
        if ([scrollView contentOffset].y <= -EdgeInsets_Y){
            //将状态修改成 释放更新
            if (_state == KKHPullRefreshState_Normal) {
                [self setState:KKHPullRefreshState_Pulling];
            }
        }
        else if ([scrollView contentOffset].y > -EdgeInsets_Y && [scrollView contentOffset].y < 0.0f) {
            //将状态修改成 下拉刷新
            if (_state == KKHPullRefreshState_Pulling) {
                [self setState:KKHPullRefreshState_Normal];
            }
        }
        else{
            
        }
        
//        if ([scrollView contentInset].top != 0) {
//            [scrollView setContentInset:UIEdgeInsetsZero];
//        }
    }
    else{
        if (scrollView.contentOffset.y < - (EdgeInsets_Y+1)) {
            [self setState:KKHPullRefreshState_Loading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            [scrollView setContentInset:UIEdgeInsetsMake(60.0f, 0.0f, edgeInsets.bottom, 0.0f)];
            [UIView commitAnimations];
            Class currentClass = object_getClass(_delegate);//添加了KVO currentClass变成了NSKVONotifying_Class
            if (([[currentClass description] containsString:[delegateClass description]]) && [_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate refreshTableHeaderDidTriggerRefresh:self];
            }
        }
    }
}

#pragma mark ==================================================
#pragma mark == KKRefreshHeaderView 的私有方法
#pragma mark ==================================================
/* 以下两个方法已经废弃，无需再实现或者调用这两个方法了 */
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView{}
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView{}

/* 手动刷新 */
- (void)startRefresh{
    UIScrollView *scrollView = (UIScrollView*)(self.superview);
    [scrollView setContentOffset:CGPointMake(0, -EdgeInsets_Y-2) animated:YES];
}

/* 监听ScrollView的contentOffset值 */
- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView{
    if (aScrollView) {
        // 设置永远支持垂直弹簧效果
        aScrollView.alwaysBounceVertical = YES;
        [aScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

/* 取消监听ScrollView的contentOffset值 */
- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView{
    if (aScrollView) {
        [aScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

/* 加载完毕 */
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    [self refreshScrollViewDataSourceDidFinishedLoading:scrollView text:nil];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
                                                 text:(NSString*)aText{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:scrollView forKey:@"scrollView"];
    if (aText) {
        [dictionary setObject:aText forKey:@"text"];
    }
    
    [self performSelector:@selector(finished:) withObject:dictionary afterDelay:0.5];

}

- (void)finished:(NSDictionary*)dictionary{
    
    __block UIScrollView *scrollView = [dictionary objectForKey:@"scrollView"];
    __block NSString *text = [dictionary objectForKey:@"text"];
    
    KKWeakSelf(self);
    [UIView animateWithDuration:0.3 animations:^{
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, edgeInsets.bottom, 0.0f)];
    } completion:^(BOOL finished) {
        
        [weakself setState:KKHPullRefreshState_Normal];
        if (text) {
            weakself.statusLabel.text = text;
        }
        
    }];
}


@end

#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KKUIScrollViewHeaderExtension)
@dynamic refreshHeader;
@dynamic haveHeader;

- (void)setHaveHeader:(BOOL)haveHeader{
    objc_setAssociatedObject(self, @"haveHeader", [NSNumber numberWithBool:haveHeader], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)haveHeader{
    NSNumber *number = objc_getAssociatedObject(self, @"haveHeader");
    return [number boolValue];
}

- (void)setRefreshHeader:(KKRefreshHeaderView *)refreshHeader{
    objc_setAssociatedObject(self, @"refreshHeader", refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KKRefreshHeaderView *)refreshHeader{
    if (self.haveHeader) {
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
        //给Header设置样式
        headView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        headView.refreshImageStyle = KKHPullRefreshImageStyle_Black;
        //将Header与ScrollView动态绑定
        [self setRefreshHeader:headView];
        [self setHaveHeader:YES];;
    }
    
}

/*关闭 刷新数据*/
- (void)hideRefreshHeader{
    if (self.refreshHeader) {
        KKRefreshHeaderView *header = self.refreshHeader;
        objc_removeAssociatedObjects(self.refreshHeader);
        [header removeFromSuperview];
        [self setHaveHeader:NO];
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
























