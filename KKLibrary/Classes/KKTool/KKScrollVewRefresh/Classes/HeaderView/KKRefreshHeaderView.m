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
#import "KKLibraryDefine.h"
#import "KKViewController.h"

@interface KKRefreshHeaderView ()<KKRefreshHeaderStateViewDelegate>{
    
    __weak id _delegate;
    Class delegateClass;
}

@property(nonatomic,weak) id <KKRefreshHeaderViewDelegate> delegate;
@property(nonatomic,assign)KKHPullRefreshState state;
@property(nonatomic,assign)CGFloat initOffsetY;
@property(nonatomic,assign)BOOL haveKVO;
@property(nonatomic,assign)CGFloat initEdgeInsetsTop;


- (id)initWithScrollView:(UIScrollView*)scrollView
                delegate:(id<KKRefreshHeaderViewDelegate>)aDelegate
                 offsetY:(CGFloat)offsetY;

- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView;

- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView;;

- (void)startRefresh;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@implementation KKRefreshHeaderView

- (void)dealloc{
    [self revertEdgeInsetsTop];
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
    
    [self revertEdgeInsetsTop];
}

- (void)revertEdgeInsetsTop{
    if (self.superview && [self.superview isKindOfClass:[UIScrollView class]]) {

        UIScrollView *scrollView = (UIScrollView*)self.superview;
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        edgeInsets.top = self.initEdgeInsetsTop;
        [scrollView setContentInset:edgeInsets];
    }
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView
                delegate:(id<KKRefreshHeaderViewDelegate>)aDelegate
                 offsetY:(CGFloat)offsetY{

    if(self = [super initWithFrame:CGRectMake(0, -scrollView.frame.size.height+offsetY, scrollView.frame.size.width, scrollView.frame.size.height)]) {
        
        [self observeNotification:NotificationName_ViewControllerWillDealloc selector:@selector(Notification_ViewControllerWillDealloc:)];

        self.initOffsetY = offsetY;
        self.initEdgeInsetsTop = scrollView.contentInset.top;

        _delegate = aDelegate;
        delegateClass = object_getClass(_delegate);

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        
        self.stateView = [[KKRefreshHeaderStateView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-[self bannerViewHeight], self.frame.size.width, [self bannerViewHeight])];
        self.stateView.delegate = self;
        [self addSubview:self.stateView];
        
        [scrollView addSubview:self];
        
        if ([UIDevice isSystemVersionBigerThan:@"11.0"] &&
            [scrollView isKindOfClass:[UITableView class]]) {
            UITableView *table = (UITableView*)scrollView;
            table.estimatedRowHeight = 0;
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
        }
        
        [self setState:KKHPullRefreshState_Normal];
        
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        edgeInsets.top = self.initEdgeInsetsTop-self.initOffsetY;
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
        [scrollView hideRefreshHeader];
    }
}


#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KKHPullRefreshState)aState{
    [self.stateView reloadUIForState:aState];
    _state = aState;
    
    for (UIView *subView in [self subviews]) {
        if (subView!=self.stateView) {
            [subView removeFromSuperview];
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshHeaderView:customerViewForState:)]) {
        
        UIView *view = [self.delegate KKRefreshHeaderView:self customerViewForState:_state];
        if (view) {
            self.stateView.hidden = YES;

            view.frame =CGRectMake(0, self.frame.size.height-[self bannerViewHeight], view.width, [self bannerViewHeight]);
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
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshHeaderView_heightForCustomerView:)]) {
        
            CGFloat height = [self.delegate KKRefreshHeaderView_heightForCustomerView:self];
            if (height>0) {
                return height;
            }
            else{
                return KKRefreshHeaderStateView_H;
            }
        }
        else{
            return KKRefreshHeaderStateView_H;
        }
    }
    else{
        return self.stateView.frame.size.height;
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

- (void)scrollViewContentOffsetChanged:(CGPoint)contentOffset{
    
    UIScrollView * scrollView = (UIScrollView *)self.superview;
    
    if (scrollView.contentOffset.y>=self.initOffsetY) {
        return;
    }
    
    if (self.state == KKHPullRefreshState_Loading) {
        return;
    }
    
    if (scrollView.isDragging) {
        if ([scrollView contentOffset].y <= -[self bannerViewHeight]-1+self.initOffsetY){
            //将状态修改成 释放更新
            if (_state == KKHPullRefreshState_Normal) {
                [self setState:KKHPullRefreshState_Pulling];
            }
        }
        else if ([scrollView contentOffset].y > -[self bannerViewHeight]+self.initOffsetY &&
                 [scrollView contentOffset].y < 0.0f+self.initOffsetY) {
            //将状态修改成 下拉刷新
            if (_state == KKHPullRefreshState_Pulling) {
                [self setState:KKHPullRefreshState_Normal];
            }
        }
        else{
            
        }
    }
    else{
        if (scrollView.contentOffset.y <= -[self bannerViewHeight]-1+self.initOffsetY ||
            _state==KKHPullRefreshState_Pulling) {
            [self setState:KKHPullRefreshState_Loading];
            
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            edgeInsets.top = self.initEdgeInsetsTop-self.initOffsetY+[self bannerViewHeight];
            [scrollView setContentInset:edgeInsets];

            Class currentClass = object_getClass(_delegate);//添加了KVO currentClass变成了NSKVONotifying_Class
            if (([[currentClass description] containsString:[delegateClass description]]) && [_delegate respondsToSelector:@selector(KKRefreshHeaderView_BeginRefresh:)]) {
                [_delegate KKRefreshHeaderView_BeginRefresh:self];
            }
        }
    }
}

#pragma mark ==================================================
#pragma mark == KKRefreshHeaderView 的私有方法
#pragma mark ==================================================
/* 手动刷新 */
- (void)startRefresh{
    UIScrollView *scrollView = (UIScrollView*)(self.superview);
    [scrollView setContentOffset:CGPointMake(0, -[self bannerViewHeight]-2+self.initOffsetY) animated:YES];
}

/* 监听ScrollView的contentOffset值 */
- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView{
    if (aScrollView) {
        if (self.haveKVO==NO) {
            self.haveKVO = YES;
            // 设置永远支持垂直弹簧效果
            aScrollView.alwaysBounceVertical = YES;
            [aScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

/* 取消监听ScrollView的contentOffset值 */
- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView{
    if (aScrollView) {
        if (self.haveKVO==YES) {
            self.haveKVO = NO;
            [aScrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
}

/* 加载完毕 */
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{

    [self setState:KKHPullRefreshState_Normal];

    

    KKWeakSelf(self);
    [UIView animateWithDuration:0.3 animations:^{

        UIEdgeInsets edgeInsets = scrollView.contentInset;
        edgeInsets.top = weakself.initEdgeInsetsTop-weakself.initOffsetY;
        [scrollView setContentInset:edgeInsets];

    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark ==================================================
#pragma mark == KKRefreshHeaderStateViewDelegate
#pragma mark ==================================================
- (NSString*)KKRefreshHeaderStateView:(KKRefreshHeaderStateView*)aView
                         textForState:(KKHPullRefreshState)state{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKRefreshHeaderView_TextForState:)]) {
        return [self.delegate KKRefreshHeaderView_TextForState:state];
    }
    else{
        return nil;
    }
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
    return [self showRefreshHeaderWithDelegate:aDelegate offsetY:0];
}

/*开启 刷新数据 增加一点偏移量，相当于RefreshHeaderView的底部不是与ScrollView的顶部齐平，有一段间隙*/
- (void)showRefreshHeaderWithDelegate:(id<KKRefreshHeaderViewDelegate>)aDelegate
                              offsetY:(CGFloat)offsetY{
    
    [self hideRefreshHeader];
    if (!self.refreshHeader) {
        KKRefreshHeaderView *headView = [[KKRefreshHeaderView alloc] initWithScrollView:self delegate:aDelegate offsetY:offsetY];
        //将Header与ScrollView动态绑定
        [self setRefreshHeader:headView];
        [self setHaveHeader:YES];
        
        headView.backgroundColor = [UIColor clearColor];
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
- (void)stopRefreshHeader{
    if (self.refreshHeader) {
        [self.refreshHeader refreshScrollViewDataSourceDidFinishedLoading:self];
    }
}

@end



