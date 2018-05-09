//
//  KKPageScrollView.m
//  Seagate
//
//  Created by liubo on 14-9-23.
//  Copyright (c) 2014年 BearTech. All rights reserved.
//

#import "KKPageScrollView.h"

typedef enum {
    ScrollDirectionNone = 0,
    ScrollDirectionLeft = 1,
    ScrollDirectionRight = 2
}ScrollDirection;


#pragma mark ==================================================
#pragma mark == UIView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIView (KKPageScrollView_UIViewExtension)
@property (nonatomic, copy, readonly) NSString *KKPageScrollView_PageIndex;
@property (nonatomic, copy, readonly) NSString *KKPageScrollView_Location;
@property (nonatomic, copy, readonly) NSString *KKPageScrollView_Real;
@end

#pragma mark ==================================================
#pragma mark == UIView扩展
#pragma mark ==================================================
@implementation UIView (KKPageScrollView_UIViewExtension)
@dynamic KKPageScrollView_PageIndex,KKPageScrollView_Location;

NSString *const KKPageScrollView_PageIndex      = @"KKPageScrollView_PageIndex";
NSString *const KKPageScrollView_Location      = @"KKPageScrollView_Location";
NSString *const KKPageScrollView_Real      = @"KKPageScrollView_Real";

- (void)setKKPageScrollView_PageIndex:(NSString *)pageIndex{
    objc_setAssociatedObject(self, &KKPageScrollView_PageIndex, pageIndex, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)KKPageScrollView_PageIndex{
    NSString *returnString = objc_getAssociatedObject(self, &KKPageScrollView_PageIndex);
    return returnString;
}

- (void)setKKPageScrollView_Location:(NSString *)location{
    objc_setAssociatedObject(self, &KKPageScrollView_Location, location, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)KKPageScrollView_Location{
    NSString *returnString = objc_getAssociatedObject(self, &KKPageScrollView_Location);
    return returnString;
}

- (void)setKKPageScrollView_Real:(NSString *)KKPageScrollView_Real{
    objc_setAssociatedObject(self, &KKPageScrollView_Real, KKPageScrollView_Real, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)KKPageScrollView_Real{
    NSString *returnString = objc_getAssociatedObject(self, &KKPageScrollView_Real);
    return returnString;
}


@end



#pragma mark ==================================================
#pragma mark ==私有扩展
#pragma mark ==================================================
@interface KKPageScrollView ()<UIScrollViewDelegate>

@property(nonatomic,assign)CGFloat nowOffsetX;
@property(nonatomic,assign)NSInteger numberOfPages;
@property(nonatomic,assign)NSInteger canRepeat;
@property(nonatomic,assign)CGFloat pageSpace;//页面间距（默认是5）

@end

@implementation KKPageScrollView
@synthesize delegate = myDelegate;


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.currentPageIndex = 0;
        self.pageSpace = 0;
        self.nowOffsetX = 0;
        
        self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-_pageSpace, 0, self.frame.size.width+_pageSpace*2, self.bounds.size.height)];
        self.mainScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        self.mainScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
        
        self.mainScrollView.pagingEnabled = YES;
        self.mainScrollView.delegate = self;
        self.mainScrollView.backgroundColor = [UIColor clearColor];
        [self.mainScrollView setShowsHorizontalScrollIndicator:NO];
        self.mainScrollView.userInteractionEnabled = YES;
        [self addSubview:self.mainScrollView];
    }
    return self;
}

- (void)setPageSpace:(CGFloat)pageSpace{
    if (_pageSpace!=pageSpace) {
        _pageSpace = pageSpace;
        [self reloadData];
    }
}

- (void)setDelegate:(id<KKPageScrollViewDelegate>)delegate{
    myDelegate = delegate;
    delegateClass = object_getClass(myDelegate);
}

- (void)reloadData{
    for (UIView *view in [self.mainScrollView subviews]) {
        [view removeFromSuperview];
    }
    self.mainScrollView.frame = CGRectMake(-self.pageSpace, 0, self.frame.size.width+self.pageSpace*2, self.frame.size.height);
    [self showPageIndex:self.currentPageIndex animated:NO];
}

- (void)showPageIndex:(NSInteger)index animated:(BOOL)animated{
    
    for (UIView *view in [self.mainScrollView subviews]) {
        if (!view.KKPageScrollView_Real) {
            [view removeFromSuperview];
        }
    }
    
    BOOL YESDelegate = NO;
    Class currentClass = object_getClass(myDelegate);
    if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(pageView:viewForPage:)]
        && [myDelegate respondsToSelector:@selector(pageViewCanRepeat:)]
        && [myDelegate respondsToSelector:@selector(numberOfPagesInPageView:)]) {
        YESDelegate = YES;
    }
//    NSAssert(YESDelegate, @"KKPage delegate must not be nil");
    if (YESDelegate==NO) {
        return;
    }
    
    self.numberOfPages = [myDelegate numberOfPagesInPageView:self];
//    NSAssert(numberOfPages>0, @"KKPageScrollView delegate must not be nil");
    if (self.numberOfPages<=0) {
        return;
    }
    
    self.canRepeat = [myDelegate pageViewCanRepeat:self];
    
    if (self.numberOfPages<=0) {
        return;
    }
    else if (0<self.numberOfPages && self.numberOfPages<=5) {
        if (self.numberOfPages==1) {
            self.pageSpace = 0;
        }
        [self showPageIndex_Few:index  animated:animated];
    }
    else{
        [self showPageIndex_More:index animated:animated];
    }
}

- (void)showPreviousPageWithAnimated:(BOOL)animated{
    NSInteger oldIndex = self.currentPageIndex;

    BOOL YESDelegate = NO;
    Class currentClass = object_getClass(myDelegate);
    if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(pageView:viewForPage:)]
        && [myDelegate respondsToSelector:@selector(pageViewCanRepeat:)]
        && [myDelegate respondsToSelector:@selector(numberOfPagesInPageView:)]) {
        YESDelegate = YES;
    }
    //    NSAssert(YESDelegate, @"KKPage delegate must not be nil");
    if (YESDelegate==NO) {
        return;
    }
    
    NSInteger allNumberOfPages = [myDelegate numberOfPagesInPageView:self];
    //    NSAssert(numberOfPages>0, @"KKPageScrollView delegate must not be nil");
    if (allNumberOfPages<=0) {
        return;
    }
    
    BOOL isCanRepeat = [myDelegate pageViewCanRepeat:self];
    
    if (allNumberOfPages<=0) {
        return;
    }
    else{
        NSInteger newIndex = oldIndex - 1;
        if (isCanRepeat) {
            if (newIndex<0) {
                newIndex = allNumberOfPages - 1;
            }
        }
        else{
            if (newIndex<0) {
                return;
            }
        }
        
        [self showPageIndex:newIndex animated:animated];
    }

    
}

- (void)showNextPageWithAnimated:(BOOL)animated{
    NSInteger oldIndex = self.currentPageIndex;
    
    BOOL YESDelegate = NO;
    Class currentClass = object_getClass(myDelegate);
    if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(pageView:viewForPage:)]
        && [myDelegate respondsToSelector:@selector(pageViewCanRepeat:)]
        && [myDelegate respondsToSelector:@selector(numberOfPagesInPageView:)]) {
        YESDelegate = YES;
    }
    //    NSAssert(YESDelegate, @"KKPage delegate must not be nil");
    if (YESDelegate==NO) {
        return;
    }
    
    NSInteger allNumberOfPages = [myDelegate numberOfPagesInPageView:self];
    //    NSAssert(numberOfPages>0, @"KKPageScrollView delegate must not be nil");
    if (allNumberOfPages<=0) {
        return;
    }
    
    BOOL isCanRepeat = [myDelegate pageViewCanRepeat:self];
    
    if (allNumberOfPages<=0) {
        return;
    }
    else{
        NSInteger newIndex = oldIndex + 1;
        if (isCanRepeat) {
            if (newIndex>allNumberOfPages - 1) {
                newIndex = 0;
            }
        }
        else{
            if (newIndex>allNumberOfPages - 1) {
                return;
            }
        }
        
        [self showPageIndex:newIndex animated:animated];
    }
}


#pragma mark ==================================================
#pragma mark == 展示方式
#pragma mark ==================================================
/*布局视图【总页数<=5个页面】*/
- (void)showPageIndex_Few:(NSInteger)index animated:(BOOL)animated{
    
    NSInteger P_old = self.currentPageIndex;
    NSInteger P_new = index;
    self.currentPageIndex = index;
    
    if (self.canRepeat) {
        
        /*移除全部*/
        for (UIView *subView in [self.mainScrollView subviews]) {
            if ([subView KKPageScrollView_Real]) {
                [subView removeFromSuperview];
                subView.KKPageScrollView_Real = @"0";
            }
        }
        
        /*定位索引——开始值*/
        NSInteger pageIndex = self.currentPageIndex-2;
        if (pageIndex<0) {
            pageIndex = MAX(pageIndex + self.numberOfPages, 0);
        }
        
        /*准备视图*/
        NSMutableArray *willViews = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<5; i++) {
            UIView *subPageView = [myDelegate pageView:self viewForPage:pageIndex];
            subPageView.KKPageScrollView_PageIndex = [NSString stringWithFormat:@"%ld",(long)pageIndex];
            subPageView.KKPageScrollView_Location = [NSString stringWithFormat:@"%ld",(long)i];
            subPageView.KKPageScrollView_Real = @"1";
            subPageView.frame = CGRectMake(i*self.mainScrollView.frame.size.width+_pageSpace, 0, self.frame.size.width,self.frame.size.height);
            [willViews addObject:subPageView];
            
            /*索引递增*/
            pageIndex = pageIndex + 1;
            if (pageIndex>self.numberOfPages-1) {
                pageIndex = 0;
            }
        }
        
        /*展示视图*/
        for (NSInteger i=0; i<[willViews count]; i++) {
            UIView *subPageView = [willViews objectAtIndex:i];
            [self.mainScrollView addSubview:subPageView];
        }
        
        self.mainScrollView.contentSize = CGSizeMake([willViews count]*self.mainScrollView.frame.size.width, self.frame.size.height);
        
        //设置ScrollView位置
        if (P_new>P_old) {
            if (P_new==self.numberOfPages-1) {
                NSInteger center = ((self.numberOfPages-1)/2.0);
                if (P_old<center || center==0) {
                    CGFloat offsetOld = 3*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
                }
                else{
                    CGFloat offsetOld = 1*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
                }
            }
            else{
                CGFloat offsetOld = 1*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
        }
        else if (P_new==P_old){
            self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
            [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:NO];
        }
        else{
            if (P_new==0) {
                NSInteger center = ((self.numberOfPages-1)/2.0);
                if (P_old<=center) {
                    CGFloat offsetOld = 3*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
                }
                else{
                    CGFloat offsetOld = 1*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
                }
            }
            else{
                CGFloat offsetOld = 3*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
        }
        
        Class currentClass = object_getClass(myDelegate);
        if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
            [myDelegate pageView:self didScrolledToPageIndex:self.currentPageIndex];
        }
        
    }
    else{
        //还没初始化
        if ([[self.mainScrollView subviews] count]==0) {
            for (NSInteger i=0; i<self.numberOfPages; i++) {
                UIView *subPageView = [myDelegate pageView:self viewForPage:i];
                subPageView.KKPageScrollView_PageIndex = [NSString stringWithFormat:@"%ld",(long)i];
                subPageView.KKPageScrollView_Location = [NSString stringWithFormat:@"%ld",(long)i];
                subPageView.KKPageScrollView_Real = @"1";
                subPageView.frame = CGRectMake(i*self.mainScrollView.frame.size.width+_pageSpace, 0, self.frame.size.width,self.frame.size.height);
                
                [self.mainScrollView addSubview:subPageView];
                self.mainScrollView.contentSize = CGSizeMake(CGRectGetMaxX(subPageView.frame)+_pageSpace, self.frame.size.height);
            }
            
            //设置ScrollView位置
            self.nowOffsetX = index*self.mainScrollView.frame.size.width;
            [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            
            Class currentClass = object_getClass(myDelegate);
            if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
                [myDelegate pageView:self didScrolledToPageIndex:self.currentPageIndex];
            }
        }
        else{
            NSArray *subViews = [self.mainScrollView subviews];
            for (NSInteger i=0; i<[subViews count]; i++) {
                UIView *subPageView = [subViews objectAtIndex:i];
                subPageView.frame = CGRectMake(i*self.mainScrollView.frame.size.width+_pageSpace, 0, self.frame.size.width,self.frame.size.height);
                self.mainScrollView.contentSize = CGSizeMake(CGRectGetMaxX(subPageView.frame)+_pageSpace, self.frame.size.height);
            }
            
            //设置ScrollView位置
            self.nowOffsetX = index*self.mainScrollView.frame.size.width;
            [self.mainScrollView setContentOffset:CGPointMake(P_old*self.mainScrollView.frame.size.width, 0) animated:NO];
            [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            
            Class currentClass = object_getClass(myDelegate);
            if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
                [myDelegate pageView:self didScrolledToPageIndex:self.currentPageIndex];
            }
        }
    }
}

/*布局视图【总页数>5个页面】*/
- (void)showPageIndex_More:(NSInteger)index animated:(BOOL)animated{
    
    NSInteger P_old = self.currentPageIndex;
    NSInteger P_new = index;
    self.currentPageIndex = index;
    //    NSInteger pageDifference_ABS = P_new - P_old;
    
    NSInteger pageIndexStart = 0;
    if (self.canRepeat) {
        /*定位索引*/
        pageIndexStart = self.currentPageIndex-2;
        if (pageIndexStart<0) {
            pageIndexStart = MAX(pageIndexStart + self.numberOfPages, 0);
        }
    }
    else{
        /*定位索引*/
        if (self.currentPageIndex<=2) {
            pageIndexStart = 0;
        }
        else if (self.currentPageIndex>=self.numberOfPages-1-2){
            pageIndexStart = self.numberOfPages-1-4;
        }
        else{
            pageIndexStart = MAX(self.currentPageIndex-2, 0);
        }
    }
    
    NSInteger pageIndexStart01 = pageIndexStart;
    /*准备视图*/
    NSMutableArray *willViews = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<5; i++) {
        UIView *subPageView = [myDelegate pageView:self viewForPage:pageIndexStart01];
        [willViews addObject:subPageView];
                
        /*索引递增*/
        pageIndexStart01 = pageIndexStart01 + 1;
        if (pageIndexStart01>self.numberOfPages-1) {
            pageIndexStart01 = 0;
        }
    }
    
    /*移除全部*/
    for (UIView *subView in [self.mainScrollView subviews]) {
        if ([willViews containsObject:subView]) {
            continue;
        }
        else{
            if ([subView KKPageScrollView_Real]) {
                [subView removeFromSuperview];
                subView.KKPageScrollView_Real = @"0";
            }
        }
    }
    
    
    NSInteger pageIndexStart02 = pageIndexStart;
    for (NSInteger i=0; i<[willViews count]; i++) {
        UIView *subPageView = [willViews objectAtIndex:i];
        subPageView.KKPageScrollView_PageIndex = [NSString stringWithFormat:@"%ld",(long)pageIndexStart02];
        subPageView.KKPageScrollView_Location = [NSString stringWithFormat:@"%ld",(long)i];
        subPageView.KKPageScrollView_Real = @"1";
        subPageView.frame = CGRectMake(i*self.mainScrollView.frame.size.width+_pageSpace, 0, self.frame.size.width,self.frame.size.height);
        
        if (!subPageView.superview) {
            [self.mainScrollView addSubview:subPageView];
        }
        self.mainScrollView.contentSize = CGSizeMake(CGRectGetMaxX(subPageView.frame)+_pageSpace, self.frame.size.height);
        /*索引递增*/
        pageIndexStart02 = pageIndexStart02 + 1;
        if (pageIndexStart02>self.numberOfPages-1) {
            pageIndexStart02 = 0;
        }
    }
    
    if (self.canRepeat) {
        //设置ScrollView位置
        if (P_new>P_old) {
            if (P_new==self.numberOfPages-1) {
                NSInteger center = ((self.numberOfPages-1)/2.0);
                if (P_old<=center) {
                    CGFloat offsetOld = 3*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
                }
                else{
                    CGFloat offsetOld = 1*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
                }
            }
            else{
                CGFloat offsetOld = 1*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
        }
        else if (P_new==P_old){
            self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
            [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:NO];
        }
        else{
            if (P_new==0) {
                NSInteger center = ((self.numberOfPages-1)/2.0);
                if (P_old<=center) {
                    CGFloat offsetOld = 3*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
                }
                else{
                    CGFloat offsetOld = 1*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                    self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                    [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
                }
            }
            else{
                CGFloat offsetOld = 3*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
        }
    }
    else{
        if (self.currentPageIndex<=2) {
            //设置ScrollView位置
            if (P_new>P_old) {
                CGFloat offsetOld = MAX(self.currentPageIndex-1, 0)*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = self.currentPageIndex*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
            else if (P_new==P_old){
                self.nowOffsetX = self.currentPageIndex*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:NO];
            }
            else{
                CGFloat offsetOld = MIN(self.currentPageIndex+1, self.numberOfPages-1)*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = self.currentPageIndex*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
        }
        else if (self.currentPageIndex==self.numberOfPages-1-1){
            //设置ScrollView位置
            if (P_new>P_old) {
                CGFloat offsetOld = 2*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 3*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
            else if (P_new==P_old){
                self.nowOffsetX = 3*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:NO];
            }
            else{
                CGFloat offsetOld = 4*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 3*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
        }
        else if (self.currentPageIndex==self.numberOfPages-1-0){
            //设置ScrollView位置
            if (P_new>P_old) {
                CGFloat offsetOld = 3*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 4*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
            else if (P_new==P_old){
                self.nowOffsetX = 4*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:NO];
            }
            else{
                //                CGFloat offsetOld = 5*mainScrollView.frame.size.width;
                //                [mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 4*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:NO];
            }
        }
        else{
            //设置ScrollView位置
            if (P_new>P_old) {
                CGFloat offsetOld = 1*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
            else if (P_new==P_old){
                self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:NO];
            }
            else{
                CGFloat offsetOld = 3*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(offsetOld, 0) animated:NO];
                self.nowOffsetX = 2*self.mainScrollView.frame.size.width;
                [self.mainScrollView setContentOffset:CGPointMake(self.nowOffsetX, 0) animated:animated];
            }
        }
    }
    
    Class currentClass = object_getClass(myDelegate);
    if ((currentClass == delegateClass) && [myDelegate respondsToSelector:@selector(pageView:didScrolledToPageIndex:)]) {
        [myDelegate pageView:self didScrolledToPageIndex:self.currentPageIndex];
    }
    
}


- (UIView*)viewForPageIndex:(NSInteger)aPageIndex{
    UIView *returnView = nil;
    for (UIView *subView in [self.mainScrollView subviews]) {
        if ([subView.KKPageScrollView_PageIndex integerValue]==aPageIndex
            && [subView.KKPageScrollView_Real integerValue]==1) {
            returnView = subView;
            break;
        }
    }
    
    //    if (returnView) {
    //        NSLog(@"存在：%d",aPageIndex);
    //    }
    //    else{
    //        NSLog(@"不存在：%d",aPageIndex);
    //    }
    return returnView;
}


#pragma mark ==================================================
#pragma mark ==滚动处理
#pragma mark ==================================================
- (void)scrollViewDidScrolledWithDirection:(ScrollDirection)direction scrollPages:(NSInteger)pages{
    switch (direction) {
        case ScrollDirectionNone:{
            break;
        }
        case ScrollDirectionLeft:{
            
            NSInteger pageNum = self.currentPageIndex - pages;
            
            if (pageNum<0) {
                pageNum = pageNum + self.numberOfPages;
            }
            
            [self showPageIndex:pageNum animated:NO];
            
            break;
        }
        case ScrollDirectionRight:{
            NSInteger pageNum = self.currentPageIndex + pages;
            
            if (pageNum>self.numberOfPages-1) {
                pageNum = pageNum - self.numberOfPages;
            }
            [self showPageIndex:pageNum animated:NO];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark ==================================================
#pragma mark ==UIScrollViewDelegate
#pragma mark ==================================================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger scrollPages =  ABS(scrollView.contentOffset.x - self.nowOffsetX)/(self.mainScrollView.frame.size.width);
    //    NSLog(@"滚动了%ld个页面",(long)scrollPages);
    
    if (scrollView.contentOffset.x<self.nowOffsetX && scrollPages>0) {
        [self scrollViewDidScrolledWithDirection:ScrollDirectionLeft scrollPages:scrollPages];
    }
    else if (scrollView.contentOffset.x > self.nowOffsetX && scrollPages>0 ){
        [self scrollViewDidScrolledWithDirection:ScrollDirectionRight scrollPages:scrollPages];
    }
    else{
        [self scrollViewDidScrolledWithDirection:ScrollDirectionNone scrollPages:scrollPages];
    }
    
}


@end
