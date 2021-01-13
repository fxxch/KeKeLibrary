//
//  KKRefreshFooterTouchView.m
//  YouJia
//
//  Created by liubo on 2018/7/16.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKRefreshFooterTouchView.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KKLibraryDefine.h"
#import "KKViewController.h"

@interface KKRefreshFooterTouchView (){
    __weak id _delegate;
    Class delegateClass;
}

@property(nonatomic,weak) id<KKRefreshFooterTouchViewDelegate> delegate;
@property(nonatomic,assign)KKFTouchRefreshState state;
@property(nonatomic,assign)CGFloat initOffsetY;
@property(nonatomic,assign)BOOL haveKVO;
@property(nonatomic,assign)CGFloat initEdgeInsetsBottom;

- (id)initWithScrollView:(UIScrollView*)scrollView
                delegate:(id<KKRefreshFooterTouchViewDelegate>)aDelegate
                 offsetY:(CGFloat)offsetY;

- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView;

- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView;;

- (void)startLoadingMore;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@implementation KKRefreshFooterTouchView


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
    
    [self revertEdgeInsetsBottom];
}

- (void)revertEdgeInsetsBottom{
    if (self.superview && [self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)self.superview;
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        edgeInsets.bottom = self.initEdgeInsetsBottom;
        [scrollView setContentInset:edgeInsets];
    }
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView
                delegate:(id<KKRefreshFooterTouchViewDelegate>)aDelegate
                 offsetY:(CGFloat)offsetY{
    
    CGFloat height = MAX(scrollView.contentSize.height, scrollView.frame.size.height);
    CGRect frame = CGRectMake(0,
                              height+offsetY,
                              scrollView.frame.size.width,
                              height);
    
    if(self = [super initWithFrame:frame]) {
        
        [self observeNotification:NotificationName_ViewControllerWillDealloc selector:@selector(Notification_ViewControllerWillDealloc:)];
        
        self.initOffsetY = offsetY;
        self.initEdgeInsetsBottom = scrollView.contentInset.bottom;

        _delegate = aDelegate;
        delegateClass = object_getClass(_delegate);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        
        self.stateView = [[KKRefreshFooterTouchStateView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [self bannerViewHeight])];
        [self addSubview:self.stateView];
        
        [scrollView addSubview:self];
        if ([UIDevice isSystemVersionBigerThan:@"11.0"] &&
            [scrollView isKindOfClass:[UITableView class]]) {
            UITableView *table = (UITableView*)scrollView;
            table.estimatedRowHeight = 0;
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
        }
        
        [self setState:KKFTouchRefreshState_Normal];
        
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        edgeInsets.bottom = self.initEdgeInsetsBottom+self.initOffsetY+[self bannerViewHeight];
        [scrollView setContentInset:edgeInsets];
        
        [self addKVO_ForScrollView:scrollView];

        // 单击的 Recognizer
        UITapGestureRecognizer* singleRecognizer  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        //点击的次数
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        //给self.view添加一个手势监测；
        [self addGestureRecognizer:singleRecognizer];
    }
    return self;
}

- (void)Notification_ViewControllerWillDealloc:(NSNotification*)notice{
    UIViewController *viewController = notice.object;
    if (viewController==self.viewController &&
        [self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)self.superview;
        [scrollView hideRefreshFooterTouch];
    }
}

- (void)SingleTap:(UITapGestureRecognizer*)singleRecognizer{
    if (_state==KKFTouchRefreshState_Normal) {
        
        [self setState:KKFTouchRefreshState_Loading];
        
        Class currentClass = object_getClass(_delegate);//添加了KVO currentClass变成了NSKVONotifying_Class
        if (([[currentClass description] containsString:[delegateClass description]]) && [_delegate respondsToSelector:@selector(KKRefreshFooterTouchView_BeginLoadMore:)]) {
            [_delegate KKRefreshFooterTouchView_BeginLoadMore:self];
        }
    }
}


#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KKFTouchRefreshState)aState{
    
    if (_state==KKFTouchRefreshState_NoMoreData) {
        return;
    }
    
    [self.stateView reloadUIForState:aState];
    _state = aState;
    
    for (UIView *subView in [self subviews]) {
        if (subView!=self.stateView) {
            [subView removeFromSuperview];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshFooterTouchView:customerViewForState:)]) {
        
        UIView *view = [self.delegate KKRefreshFooterTouchView:self customerViewForState:_state];
        if (view) {
            self.stateView.hidden = YES;
            
            view.frame =CGRectMake(0, 0, view.width, [self bannerViewHeight]);
            view.clipsToBounds = YES;
            [self addSubview:view];
        }
        else{
            self.stateView.hidden = NO;
        }
    }
    else{
        self.stateView.hidden = NO;
    }
    
}

- (CGFloat)bannerViewHeight{
    
    if (self.stateView.hidden == YES ||
        self.stateView == nil) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshFooterTouchView_heightForCustomerView:)]) {
            
            CGFloat height = [self.delegate KKRefreshFooterTouchView_heightForCustomerView:self];
            if (height>0) {
                return height;
            }
            else{
                return KKRefreshFooterTouchStateView_H;
            }
        }
        else{
            return KKRefreshFooterTouchStateView_H;
        }
    }
    else{
        return self.stateView.frame.size.height;
    }
}



#pragma mark ==================================================
#pragma mark == KKRefreshFooterTouchView 的私有方法
#pragma mark ==================================================
/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setNoMoreData{
    [self setState:KKFTouchRefreshState_NoMoreData];
}

/* 手动加载更多 */
- (void)startLoadingMore{
    
    [self SingleTap:nil];

    UIScrollView *scrollView = (UIScrollView*)(self.superview);
    
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height+[self bannerViewHeight]+self.initOffsetY+2) animated:YES];
    }
    else{
        [scrollView setContentOffset:CGPointMake(0, [self bannerViewHeight]+self.initOffsetY+2) animated:YES];
    }
}

/* 监听ScrollView的contentOffset值 */
- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView{
    if (aScrollView) {
        
        if (self.haveKVO==NO) {
            self.haveKVO = YES;
            
            // 设置永远支持垂直弹簧效果
            aScrollView.alwaysBounceVertical = YES;
            
            NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
            
            [aScrollView addObserver:self
                          forKeyPath:@"contentOffset"
                             options:options
                             context:nil];
            
            [aScrollView addObserver:self
                          forKeyPath:@"contentSize"
                             options:options
                             context:nil];
        }
    }
}

/* 取消监听ScrollView的contentOffset值 */
- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView{
    if (aScrollView) {
        if (self.haveKVO==YES) {
            self.haveKVO = NO;
            [aScrollView removeObserver:self forKeyPath:@"contentOffset"];
            [aScrollView removeObserver:self forKeyPath:@"contentSize"];
        }
    }
}

/* 加载完毕 */
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    
    CGFloat height = MAX(scrollView.contentSize.height, scrollView.frame.size.height);
    self.frame = CGRectMake(0,
                            height+self.initOffsetY,
                            scrollView.frame.size.width,
                            height);
    
    [self setState:KKFTouchRefreshState_Normal];
}

#pragma mark ==================================================
#pragma mark == 【KVO】
#pragma mark ==================================================
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"]){
        [self scrollViewContentOffsetChanged:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"contentSize"]){
        [self scrollViewContentSizeChanged:[[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue]];
    }
    else{
        
    }
}

- (void)scrollViewContentOffsetChanged:(CGPoint)contentOffset{
    
}

- (void)scrollViewContentSizeChanged:(CGSize)contentSize{
    
    UIScrollView * scrollView = (UIScrollView *)self.superview;
    
    CGRect rect = self.frame;
    rect.origin.y = MAX(scrollView.frame.size.height, scrollView.contentSize.height)+self.initOffsetY;
    rect.size.height = MAX(scrollView.frame.size.height, scrollView.contentSize.height);
    self.frame = rect;
}

#pragma mark ==================================================
#pragma mark == KKRefreshFooterTouchStateViewDelegate
#pragma mark ==================================================
- (NSString*)KKRefreshFooterTouchStateView:(KKRefreshFooterTouchStateView*)aView
                              textForState:(KKFTouchRefreshState)state{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshFooterTouchView_TextForState:)]) {
        return [self.delegate KKRefreshFooterTouchView_TextForState:state];
    }
    else{
        return nil;
    }
}

@end

#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KKUIScrollViewFooterTouchExtension)
@dynamic refreshFooterTouch;
@dynamic haveFooterTouch;

- (void)setHaveFooterTouch:(BOOL)haveFooterTouch{
    objc_setAssociatedObject(self, @"haveFooterTouch", [NSNumber numberWithBool:haveFooterTouch], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)haveFooterTouch{
    NSNumber *number = objc_getAssociatedObject(self, @"haveFooterTouch");
    return [number boolValue];
}

- (void)setRefreshFooterTouch:(KKRefreshFooterTouchView *)refreshFooterTouch{
    objc_setAssociatedObject(self, @"refreshFooterTouch", refreshFooterTouch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KKRefreshFooterTouchView *)refreshFooterTouch{
    if ([objc_getAssociatedObject(self, @"haveFooterTouch") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshFooterTouch");
    }
    else{
        return nil;
    }
}

/*开启 加载更多*/
- (void)showRefreshFooterTouchWithDelegate:(id<KKRefreshFooterTouchViewDelegate>)aDelegate{
    [self showRefreshFooterTouchWithDelegate:aDelegate offsetY:0];
}

/*开启 加载更多 增加一点偏移量，相当于KKRefreshFooterTouchView的顶部不是与ScrollView的底部齐平，有一段间隙*/
- (void)showRefreshFooterTouchWithDelegate:(id<KKRefreshFooterTouchViewDelegate>)aDelegate
                                  offsetY:(CGFloat)offsetY{
    
    [self hideRefreshFooterTouch];
    if (!self.refreshFooterTouch) {
        KKRefreshFooterTouchView *footerView = [[KKRefreshFooterTouchView alloc] initWithScrollView:self delegate:aDelegate offsetY:offsetY];
        [self setRefreshFooterTouch:footerView];
        [self setHaveFooterTouch:YES];
        
        footerView.backgroundColor = [UIColor clearColor];
        footerView.stateView.statusLabel.font = [UIFont systemFontOfSize:11];
        footerView.stateView.statusLabel.textColor = [UIColor grayColor];
    }
}


/*关闭 加载更多*/
- (void)hideRefreshFooterTouch{
    if (self.refreshFooterTouch) {
        KKRefreshFooterTouchView *footer = self.refreshFooterTouch;
        objc_removeAssociatedObjects(self.refreshFooterTouch);
        [footer removeFromSuperview];
        [self setHaveFooterTouch:NO];
    }
    
}

/*开始 加载更多*/
- (void)startRefreshFooterTouch{
    if (self.refreshFooterTouch) {
        [self.refreshFooterTouch startLoadingMore];
    }
}


/*停止 加载更多*/
- (void)stopRefreshFooterTouch{
    if (self.refreshFooterTouch) {
        [self.refreshFooterTouch refreshScrollViewDataSourceDidFinishedLoading:self];
    }
}

/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setRefreshFooterTouchNoMoreData{
    if (self.refreshFooterTouch) {
        [self.refreshFooterTouch setNoMoreData];
    }
}

@end



