//
//  KKPageScrollView.h
//  Seagate
//
//  Created by liubo on 14-9-23.
//  Copyright (c) 2014年 BearTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKPageScrollViewDelegate;

@interface KKPageScrollView : UIImageView{
    Class delegateClass;
    __weak id<KKPageScrollViewDelegate> myDelegate;
}

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,assign)NSInteger currentPageIndex;
@property(nonatomic,weak)id<KKPageScrollViewDelegate> delegate;

/*设置页面之间间隙*/
- (void)setPageSpace:(CGFloat)pageSpace;

/*重新装载*/
- (void)reloadData;

/*滚动到某个页面*/
- (void)showPageIndex:(NSInteger)index animated:(BOOL)animated;

/*View复用的时候需要*/
- (UIView*)viewForPageIndex:(NSInteger)aIndex;

- (void)showPreviousPageWithAnimated:(BOOL)animated;

- (void)showNextPageWithAnimated:(BOOL)animated;

@end


#pragma mark ==================================================
#pragma mark ==代理
#pragma mark ==================================================
@protocol KKPageScrollViewDelegate <NSObject>

@required
- (UIView*)pageView:(KKPageScrollView*)pageView viewForPage:(NSInteger)pageIndex;

- (NSInteger)numberOfPagesInPageView:(KKPageScrollView*)pageView;

- (BOOL)pageViewCanRepeat:(KKPageScrollView*)pageView;

@optional

- (void)pageView:(KKPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex;


@end
