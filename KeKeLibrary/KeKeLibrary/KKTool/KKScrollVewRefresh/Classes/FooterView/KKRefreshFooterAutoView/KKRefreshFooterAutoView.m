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
#import "KeKeLibraryDefine.h"

#define TEXT_COLOR   [UIColor whiteColor]
#define FLIP_ANIMATION_DURATION 0.18f
#define EdgeInsets_YY 50.0f


@interface KKRefreshFooterAutoView (){
    __weak id _delegate;
    Class delegateClass;
}

@property(nonatomic,weak) id<KKRefreshFooterAutoViewDelegate> delegate;
@property (nonatomic,assign)KKFAutoRefreshState state;

- (id)initWithScrollView:(UIScrollView*)scrollView
                delegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate;

- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView;

- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView;;

- (void)startLoadingMore;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
                                                 text:(NSString*)aText;

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
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate{
    
    if(self = [super initWithFrame:CGRectMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height), scrollView.frame.size.width, scrollView.frame.size.height)]) {

        _delegate = aDelegate;
        delegateClass = object_getClass(_delegate);

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 15.0f, self.frame.size.width, 20.0f)];
        self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.statusLabel.font = [UIFont systemFontOfSize:18.0f];
        self.statusLabel.textColor = TEXT_COLOR;
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLabel];
		
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityView.frame = CGRectMake(105.0f, 15.0f, 20.0f, 20.0f);
        [self addSubview:self.activityView];

		
		[self setState:KKFAutoRefreshState_Normal];
        
        [scrollView addSubview:self];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 自定义样式
#pragma mark ==================================================
- (void)setStatusTextForLoading:(NSString *)statusTextForLoading{
    _statusTextForLoading = statusTextForLoading;
    [self reload];
}

- (void)setStatusTextForNormal:(NSString *)statusTextForNormal{
    _statusTextForNormal = statusTextForNormal;
    [self reload];
}

- (void)reload{
    [self setState:_state];
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KKFAutoRefreshState)aState{
    switch (aState) {
        case KKFAutoRefreshState_Normal:{
            NSString *showText = nil;
            if (self.statusTextForNormal) {
                showText = self.statusTextForNormal;
            }
            else{
                showText = KILocalization(@"加载更多...");
            }
            
            CGSize size = [self.statusLabel.text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
            
            self.statusLabel.frame = CGRectMake((self.frame.size.width-size.width)/2.0, 15.0f, size.width, 20.0f);
            self.statusLabel.text = showText;
            [self.activityView stopAnimating];
            break;
        }
        case KKFAutoRefreshState_Loading:{
            NSString *showText = nil;
            if (self.statusTextForLoading) {
                showText = self.statusTextForLoading;
            }
            else{
                showText = KILocalization(@"加载中...");
            }
            
            CGSize size = [self.statusLabel.text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
            
            self.activityView.frame = CGRectMake((self.frame.size.width-size.width-20-10)/2.0, 15.0f, 20.0f, 20.0f);
            self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.activityView.frame)+10, 15.0f, size.width, 20.0f);
            self.statusLabel.text = showText;
            [self.activityView startAnimating];
            break;
        }
        default:
            break;
    }
    _state = aState;
}

#pragma mark ==================================================
#pragma mark == KKRefreshFooterDraggingView 的私有方法
#pragma mark ==================================================
/* 以下两个方法已经废弃，无需再实现或者调用这两个方法了 */
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView{}
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView{}


/* 手动加载更多 */
- (void)startLoadingMore{
    
    UIScrollView *scrollView = (UIScrollView*)(self.superview);
    
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height+EdgeInsets_YY) animated:YES];
    }
    else{
        [scrollView setContentOffset:CGPointMake(0, EdgeInsets_YY) animated:YES];
    }
}

/* 监听ScrollView的contentOffset值 */
- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView{
    if (aScrollView) {
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

/* 取消监听ScrollView的contentOffset值 */
- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView{
    if (aScrollView) {
        [aScrollView removeObserver:self forKeyPath:@"contentOffset"];
        [aScrollView removeObserver:self forKeyPath:@"contentSize"];
    }
}

/* 加载完毕 */
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    [self refreshScrollViewDataSourceDidFinishedLoading:scrollView text:nil];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
                                                 text:(NSString*)aText{
    
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, scrollView.frame.size.width, scrollView.frame.size.height);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,scrollView.frame.size.width, scrollView.contentSize.height);
    }
    
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
        [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
    } completion:^(BOOL finished) {
        
        [weakself setState:KKFAutoRefreshState_Normal];
        if (text) {
            weakself.statusLabel.text = text;
        }
        
    }];
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
    
    if (scrollView.contentOffset.y+scrollView.frame.size.height<=scrollView.contentSize.height) {
        return;
    }
    
    if (_state == KKFAutoRefreshState_Loading) {
        return;
    }
    
    CGFloat cha = 0;
    CGFloat insetsBottom = 0;
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        cha = scrollView.contentOffset.y+scrollView.frame.size.height - scrollView.contentSize.height;
        insetsBottom = EdgeInsets_YY;
    }
    else{
        cha = scrollView.contentOffset.y;
        insetsBottom = scrollView.frame.size.height-scrollView.contentSize.height+EdgeInsets_YY;
    }
        
    if (cha > 5.0f){
        
        [self setState:KKFAutoRefreshState_Loading];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f, insetsBottom, 0.0f)];
        [UIView commitAnimations];
        Class currentClass = object_getClass(_delegate);//添加了KVO currentClass变成了NSKVONotifying_Class
        if (([[currentClass description] containsString:[delegateClass description]]) && [_delegate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
            [_delegate refreshTableFooterAutoViewDidTriggerRefresh:self];
        }
    }
}

- (void)scrollViewContentSizeChanged:(CGSize)contentSize{
    
    UIScrollView * scrollView = (UIScrollView *)self.superview;
    
    CGRect rect = self.frame;
    rect.origin.y = MAX(scrollView.frame.size.height, scrollView.contentSize.height);
    self.frame = rect;
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
    if (!self.refreshFooterAuto) {
        KKRefreshFooterAutoView *footerView = [[KKRefreshFooterAutoView alloc] initWithScrollView:self delegate:aDelegate];
        
        footerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        footerView.statusLabel.textColor = [UIColor blackColor];
        footerView.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

        [self setRefreshFooterAuto:footerView];
        [self setHaveFooterAuto:YES];
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
- (void)stopRefreshFooterAuto:(NSString*)aText{
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto refreshScrollViewDataSourceDidFinishedLoading:self text:aText];
    }
}

- (void)stopRefreshFooterAuto{
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto refreshScrollViewDataSourceDidFinishedLoading:self];
    }
}


@end



