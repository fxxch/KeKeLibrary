//
//  KKRefreshFooterDraggingView.m
//  TableViewRefreshDemo
//
//  Created by 刘 波 on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KKRefreshFooterDraggingView.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KeKeLibraryDefine.h"

#define TEXT_COLOR  [UIColor colorWithRed:0.49f green:0.50f blue:0.49f alpha:1.00f]
#define TEXT_FONT   [UIFont systemFontOfSize:14]
#define FLIP_ANIMATION_DURATION 0.18f
#define EdgeInsets_Y 50.0f


@interface KKRefreshFooterDraggingView (){
    __weak id _delegate;
    Class delegateClass;
}

@property(nonatomic,weak) id <KKRefreshFooterDraggingViewDelegate> delegate;
@property(nonatomic,assign)KKFDraggingRefreshState state;

- (id)initWithScrollView:(UIScrollView*)scrollView
                delegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate;

- (void)addKVO_ForScrollView:(UIScrollView*)aScrollView;

- (void)removeKVO_ForScrollView:(UIScrollView*)aScrollView;;

- (void)startLoadingMore;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
                                                 text:(NSString*)aText;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


@end

@implementation KKRefreshFooterDraggingView

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
        [self addSubview:self.arrowImageView];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.frame = CGRectMake(105.0f, 15.0f, 20.0f, 20.0f);
        [self addSubview:self.activityView];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=11 &&
            [scrollView isKindOfClass:[UITableView class]]) {
            UITableView *table = (UITableView*)scrollView;
            table.estimatedRowHeight = 0;
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
        }

        [self setState:KKFDraggingRefreshState_Normal];
        
        [scrollView addSubview:self];
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
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Black){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blackArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Blue){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blueArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Gray){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/grayArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            self.arrowImageView.image = image;
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_White){
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
#pragma mark == KKRefreshFooterDraggingView 的私有方法
#pragma mark ==================================================
/* 以下两个方法已经废弃，无需再实现或者调用这两个方法了 */
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView{}
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView{}

/* 手动加载更多 */
- (void)startLoadingMore{

    UIScrollView *scrollView = (UIScrollView*)(self.superview);

    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height+EdgeInsets_Y+2) animated:YES];
    }
    else{
        [scrollView setContentOffset:CGPointMake(0, EdgeInsets_Y+2) animated:YES];
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
        
        [weakself setState:KKFDraggingRefreshState_Normal];
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

    if (_state == KKFDraggingRefreshState_Loading ){
        return;
    }
    
    CGFloat cha = 0;
    CGFloat insetsBottom = 0;
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        cha = scrollView.contentOffset.y+scrollView.frame.size.height - scrollView.contentSize.height;
        insetsBottom = EdgeInsets_Y;
    }
    else{
        cha = scrollView.contentOffset.y;
        insetsBottom = scrollView.frame.size.height-scrollView.contentSize.height+EdgeInsets_Y;
    }
    
    if (scrollView.isDragging) {
        
        if (cha <= EdgeInsets_Y){
            //将状态修改成 上拉加载更多
            if (_state == KKFDraggingRefreshState_Pulling) {
                [self setState:KKFDraggingRefreshState_Normal];
            }
        }
        else{
            //将状态修改成 释放加载
            if (_state == KKFDraggingRefreshState_Normal) {
                [self setState:KKFDraggingRefreshState_Pulling];
            }
        }
    }
    else{
        if (cha > EdgeInsets_Y + 1){
            
            [self setState:KKFDraggingRefreshState_Loading];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f, insetsBottom, 0.0f)];
            [UIView commitAnimations];
            Class currentClass = object_getClass(_delegate);//添加了KVO currentClass变成了NSKVONotifying_Class
            if (([[currentClass description] containsString:[delegateClass description]]) && [_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
            }
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
@implementation UIScrollView (KKUIScrollViewFooterDExtension)
@dynamic refreshFooterDragging;
@dynamic haveFooterDragging;

- (void)setHaveFooterDragging:(BOOL)haveFooterDragging {
    objc_setAssociatedObject(self, @"haveFooterDragging", [NSNumber numberWithBool:haveFooterDragging], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)haveFooterDragging{
    NSNumber *number = objc_getAssociatedObject(self, @"haveFooterDragging");
    return [number boolValue];
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
        footerView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        footerView.refreshImageStyle = KKFDraggingRefreshImageStyle_Black;
        
        [self setRefreshFooterDragging:footerView];
        [self setHaveFooterDragging:YES];
    }
}

/*关闭 加载更多*/
- (void)hideRefreshFooterDragging{
    if (self.refreshFooterDragging) {
        KKRefreshFooterDraggingView *footer = self.refreshFooterDragging;
        objc_removeAssociatedObjects(self.refreshFooterDragging);
        [footer removeFromSuperview];
        [self setHaveFooterDragging:NO];
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


