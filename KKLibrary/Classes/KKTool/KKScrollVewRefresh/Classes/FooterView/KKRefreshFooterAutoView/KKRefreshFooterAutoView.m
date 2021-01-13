//
//  KKRefreshFooterAutoView.m
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KKRefreshFooterAutoView.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KKLibraryDefine.h"
#import "KKViewController.h"

@interface KKRefreshFooterAutoView (){
    __weak id _delegate;
    Class delegateClass;
}

@property(nonatomic,weak) id<KKRefreshFooterAutoViewDelegate> delegate;
@property(nonatomic,assign)KKFAutoRefreshState state;
@property(nonatomic,assign)CGFloat initOffsetY;
@property(nonatomic,assign)BOOL haveKVO;
@property(nonatomic,assign)CGFloat initEdgeInsetsBottom;

- (id)initWithScrollView:(UIScrollView*)scrollView
                delegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate
                 offsetY:(CGFloat)offsetY;

- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView;

- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView;;

- (void)startLoadingMore;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@implementation KKRefreshFooterAutoView


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
                delegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate
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
        
        self.stateView = [[KKRefreshFooterAutoStateView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [self bannerViewHeight])];
        [self addSubview:self.stateView];
        
        [scrollView addSubview:self];
        
        if ([UIDevice isSystemVersionBigerThan:@"11.0"] &&
            [scrollView isKindOfClass:[UITableView class]]) {
            UITableView *table = (UITableView*)scrollView;
            table.estimatedRowHeight = 0;
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
        }
        
        [self setState:KKFAutoRefreshState_Normal];
        
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        edgeInsets.bottom = self.initEdgeInsetsBottom+self.initOffsetY+[self bannerViewHeight];
        [scrollView setContentInset:edgeInsets];
        
        [self addKVO_ForScrollView:scrollView];
    }
    return self;
}

- (void)Notification_ViewControllerWillDealloc:(NSNotification*)notice{
    UIViewController *viewController = notice.object;
    if (viewController==self.viewController &&
        [self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)self.superview;
        [scrollView hideRefreshFooterAuto];
    }
}


#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KKFAutoRefreshState)aState{
    
    if (_state==KKFAutoRefreshState_NoMoreData) {
        return;
    }
    
    [self.stateView reloadUIForState:aState];
    _state = aState;
    
    for (UIView *subView in [self subviews]) {
        if (subView!=self.stateView) {
            [subView removeFromSuperview];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshFooterAutoView:customerViewForState:)]) {
        
        UIView *view = [self.delegate KKRefreshFooterAutoView:self customerViewForState:_state];
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshFooterAutoView_heightForCustomerView:)]) {
            
            CGFloat height = [self.delegate KKRefreshFooterAutoView_heightForCustomerView:self];
            if (height>0) {
                return height;
            }
            else{
                return KKRefreshFooterAutoStateView_H;
            }
        }
        else{
            return KKRefreshFooterAutoStateView_H;
        }
    }
    else{
        return self.stateView.frame.size.height;
    }
}



#pragma mark ==================================================
#pragma mark == KKRefreshFooterAutoView 的私有方法
#pragma mark ==================================================
/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setNoMoreData{
    [self setState:KKFAutoRefreshState_NoMoreData];
}

/* 手动加载更多 */
- (void)startLoadingMore{
    
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
    
    [self setState:KKFAutoRefreshState_Normal];
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
    
    UIScrollView * scrollView = (UIScrollView *)self.superview;
    
    if (scrollView.contentOffset.y<0) {
        return;
    }
    
    if (scrollView.contentOffset.y+scrollView.frame.size.height-self.initOffsetY<=scrollView.contentSize.height) {
        return;
    }
    
    if (_state == KKFAutoRefreshState_Loading ){
        return;
    }

    CGFloat cha = 0;
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        cha = scrollView.contentOffset.y+scrollView.frame.size.height - scrollView.contentSize.height;
    }
    else{
        cha = scrollView.contentOffset.y;
    }
        
    if (cha > ([self bannerViewHeight]+self.initOffsetY)*(1/1) ){

        if (_state!=KKFAutoRefreshState_NoMoreData) {
            [self setState:KKFAutoRefreshState_Loading];
        }
        
        if (_state!=KKFAutoRefreshState_NoMoreData) {

            Class currentClass = object_getClass(_delegate);//添加了KVO currentClass变成了NSKVONotifying_Class
            if (([[currentClass description] containsString:[delegateClass description]]) && [_delegate respondsToSelector:@selector(KKRefreshFooterAutoView_BeginLoadMore:)]) {
                [_delegate KKRefreshFooterAutoView_BeginLoadMore:self];
            }

        }
    }
}

- (void)scrollViewContentSizeChanged:(CGSize)contentSize{
    
    UIScrollView * scrollView = (UIScrollView *)self.superview;
    
    CGRect rect = self.frame;
    rect.origin.y = MAX(scrollView.frame.size.height, scrollView.contentSize.height)+self.initOffsetY;
    rect.size.height = MAX(scrollView.frame.size.height, scrollView.contentSize.height);
    self.frame = rect;
}

#pragma mark ==================================================
#pragma mark == KKRefreshFooterAutoStateViewDelegate
#pragma mark ==================================================
- (NSString*)KKRefreshFooterAutoStateView:(KKRefreshFooterAutoStateView*)aView
                             textForState:(KKFAutoRefreshState)state{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshFooterAutoView_TextForState:)]) {
        return [self.delegate KKRefreshFooterAutoView_TextForState:state];
    }
    else{
        return nil;
    }
}

@end

#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KKUIScrollViewFooterAExtension)
@dynamic refreshFooterAuto;
@dynamic haveFooterAuto;

- (void)setHaveFooterAuto:(BOOL)haveFooterAuto{
    objc_setAssociatedObject(self, @"haveFooterAuto", [NSNumber numberWithBool:haveFooterAuto], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)haveFooterAuto{
    NSNumber *number = objc_getAssociatedObject(self, @"haveFooterAuto");
    return [number boolValue];
}

- (void)setRefreshFooterAuto:(KKRefreshFooterAutoView *)refreshFooterAuto{
    objc_setAssociatedObject(self, @"refreshFooterAuto", refreshFooterAuto, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KKRefreshFooterAutoView *)refreshFooterAuto{
    if ([objc_getAssociatedObject(self, @"haveFooterAuto") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshFooterAuto");
    }
    else{
        return nil;
    }
}

/*开启 加载更多*/
- (void)showRefreshFooterAutoWithDelegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate{
    [self showRefreshFooterAutoWithDelegate:aDelegate offsetY:0];
}

/*开启 加载更多 增加一点偏移量，相当于KKRefreshFooterAutoView的顶部不是与ScrollView的底部齐平，有一段间隙*/
- (void)showRefreshFooterAutoWithDelegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate
                                  offsetY:(CGFloat)offsetY{
    
    [self hideRefreshFooterAuto];
    if (!self.refreshFooterAuto) {
        KKRefreshFooterAutoView *footerView = [[KKRefreshFooterAutoView alloc] initWithScrollView:self delegate:aDelegate offsetY:offsetY];
        [self setRefreshFooterAuto:footerView];
        [self setHaveFooterAuto:YES];
        
        footerView.backgroundColor = [UIColor clearColor];
        footerView.stateView.statusLabel.font = [UIFont systemFontOfSize:11];
        footerView.stateView.statusLabel.textColor = [UIColor grayColor];
    }
}


/*关闭 加载更多*/
- (void)hideRefreshFooterAuto{
    if (self.refreshFooterAuto) {
        KKRefreshFooterAutoView *footer = self.refreshFooterAuto;
        objc_removeAssociatedObjects(self.refreshFooterAuto);
        [footer removeFromSuperview];
        [self setHaveFooterAuto:NO];
    }

}

/*开始 加载更多*/
- (void)startRefreshFooterAuto{
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto startLoadingMore];
    }
}


/*停止 加载更多*/
- (void)stopRefreshFooterAuto{
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto refreshScrollViewDataSourceDidFinishedLoading:self];
    }
}

/**
 设置 已经没有更多数据了，将不再触发加载更多数据
 */
- (void)setRefreshFooterAutoNoMoreData{
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto setNoMoreData];
    }
}


@end



