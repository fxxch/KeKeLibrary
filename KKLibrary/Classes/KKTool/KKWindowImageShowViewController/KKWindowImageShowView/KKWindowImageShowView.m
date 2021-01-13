//
//  KKWindowImageShowView.m
//  BM
//
//  Created by 刘波 on 2020/3/3.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKWindowImageShowView.h"
#import "KKViewController.h"
#import "KKLibraryDefine.h"
#import "KKCategory.h"
#import "KKTool.h"

@interface KKWindowImageShowView ()<KKWindowActionViewDelegate,KKWindowImageShowItemViewDelegate>

@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)UIPageControl *myPageControl;
@property (nonatomic,strong)KKPageScrollView *myPageView;
@property (nonatomic,strong)KKWindowImageShowItemView *animationView;

@property (nonatomic,assign)NSInteger initSelectIndex;
@property (nonatomic,assign)CGRect initViewRect;

@property (nonatomic,assign)UIStatusBarStyle nowStatusBarStyle;

@end


@implementation KKWindowImageShowView


#pragma mark ==================================================
#pragma mark == 【初始化】新的的方式
#pragma mark ==================================================
+ (KKWindowImageShowView*_Nullable)showWithItems:(NSArray<KKWindowImageItem*>*_Nonnull)aItemsArray
                                   selectedIndex:(NSInteger)aSelectedIndex{

    if (aItemsArray && [aItemsArray isKindOfClass:[NSArray class]] && [aItemsArray count] >0) {
        UIWindow *window = [UIWindow currentKeyWindow];
        if ([window viewWithTag:2020030301]) {
            return nil;
        }

        KKWindowImageShowView *windowImageView = [[KKWindowImageShowView alloc] initWithFrame:window.bounds items:aItemsArray selectedIndex:aSelectedIndex];
        windowImageView.tag = 2020030301;
        windowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];

        [windowImageView show];

        return windowImageView;
    }
    else{
        return nil;
    }
}

- (id)initWithFrame:(CGRect)frame
              items:(NSArray<KKWindowImageItem*>*)aItemsArray
      selectedIndex:(NSInteger)aSelectedIndex{
    self = [super initWithFrame:frame];
    if (self) {
        self.initSelectIndex = aSelectedIndex;
        if (self.initSelectIndex>=aItemsArray.count ||
            self.initSelectIndex < 0) {
            self.initSelectIndex = 0;
        }

        self.itemsArray = [[NSMutableArray alloc]init];
        [self.itemsArray addObjectsFromArray:aItemsArray];

        self.nowSelectedIndex = self.initSelectIndex;

        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.userInteractionEnabled = NO;
        self.backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.backgroundView];

        self.backgroundColor = [UIColor clearColor];

        self.myPageView = [[KKPageScrollView alloc] initWithFrame:self.bounds];
        self.myPageView.delegate = self;
        self.myPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.myPageView.clipsToBounds = YES;
        [self.myPageView showPageIndex:self.nowSelectedIndex animated:NO];
        [self.myPageView setPageSpace:10];
        [self.myPageView reloadData];
        [self.myPageView clearBackgroundColor];
        [self addSubview:self.myPageView];

        self.myPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 20)];
        self.myPageControl.hidesForSinglePage = YES;
        self.myPageControl.numberOfPages = [self.itemsArray count];
        self.myPageControl.currentPage = self.nowSelectedIndex;
        self.myPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.myPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:self.myPageControl];
        self.myPageControl.hidden = YES;

        KKWindowImageItem *item = [self.itemsArray objectAtIndex_Safe:self.nowSelectedIndex];
        if (item.inView == nil || CGSizeEqualToSize(item.inView.frame.size, CGSizeZero)) {
            self.initViewRect = CGRectMake((self.frame.size.width-2)/2.0, (self.frame.size.height-2)/2.0, 2, 2);
        } else {
            self.initViewRect = [item.inView convertRect:item.inView.bounds toView:[UIWindow currentKeyWindow]];
        }
    }
    return self;
}

- (void)show{
    self.nowStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    self.myPageView.hidden = YES;

    self.animationView = [[KKWindowImageShowItemView alloc] initWithFrame:self.initViewRect];
    self.animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.animationView.delegate = nil;

    KKWindowImageItem *item = [self.itemsArray objectAtIndex_Safe:self.nowSelectedIndex];
    [self.animationView reloaWithItem:item];
    [self addSubview:self.animationView];

    KKWeakSelf(self);
    self.backgroundView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.animationView.frame = self.bounds;
        self.backgroundView.alpha = 1.0;
    } completion:^(BOOL finished) {

        [weakself hideStatusBar];

        [self.animationView removeFromSuperview];
        self.animationView = nil;
        self.myPageView.hidden = NO;
    }];
}


#pragma mark ==================================================
#pragma mark == 消失自己
#pragma mark ==================================================
//隐藏自己
- (void) cancelSelf{

    [self showStatusBar];

    CGRect nowFrame = CGRectZero;
    KKWindowImageItem *item = [self.itemsArray objectAtIndex_Safe:self.nowSelectedIndex];
    if (item.inView == nil || CGSizeEqualToSize(item.inView.frame.size, CGSizeZero)) {
        nowFrame = self.initViewRect;
    } else {
        UIWindow *currentKeyWindow = [UIWindow currentKeyWindow];
        CGRect windowF = [item.inView convertRect:item.inView.bounds toView:currentKeyWindow];
//        if ( (windowF.origin.x < currentKeyWindow.bounds.size.width ) &&
//            (windowF.origin.y < currentKeyWindow.bounds.size.height ) &&
//            (windowF.origin.x + windowF.size.width) >0 &&
//            (windowF.origin.y + windowF.size.height) >0 ) {
//            nowFrame = windowF;
//        }
        if (CGRectContainsRect(currentKeyWindow.bounds, windowF)) {
            nowFrame = windowF;
        }
        else {
            nowFrame = self.initViewRect;
        }
    }

    self.animationView = [[KKWindowImageShowItemView alloc] initWithFrame:self.bounds];
    self.animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.animationView.delegate = nil;

    [self.animationView reloaWithItem:item];
    [self addSubview:self.animationView];
    self.myPageView.hidden = YES;

    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0;
        self.animationView.frame = nowFrame;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideSelfAnimated) withObject:nil afterDelay:0];
    }];
    
    [self performSelector:@selector(hideSelfAlpha) withObject:nil afterDelay:0.25];
}

- (void)hideSelfAlpha{
    [UIView animateWithDuration:0.05 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {

    }];
}

- (void)hideSelfAnimated{
    [UIView animateWithDuration:0 animations:^{
        self.animationView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.animationView removeFromSuperview];
        self.animationView = nil;
        if (self.viewController.navigationController) {
            [self.viewController.navigationController dismissViewControllerAnimated:NO completion:^{

            }];
        } else {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark ==================================================
#pragma mark == KKPageScrollViewDelegate
#pragma mark ==================================================
- (UIView*)pageView:(KKPageScrollView*)pageView viewForPage:(NSInteger)pageIndex{

    KKWindowImageShowItemView *itemView = (KKWindowImageShowItemView*)[self.myPageView viewForPageIndex:pageIndex];
    if (!itemView) {
        itemView = [[KKWindowImageShowItemView alloc] initWithFrame:pageView.bounds];
        itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        itemView.delegate = self;
    }

    KKWindowImageItem *item = [self.itemsArray objectAtIndex_Safe:pageIndex];
    [itemView reloaWithItem:item];

    return itemView;
}

- (NSInteger)numberOfPagesInPageView:(KKPageScrollView*)pageView{
    return [self.itemsArray count];
}

- (BOOL)pageViewCanRepeat:(KKPageScrollView*)pageView{
    return NO;
}

- (void)pageView:(KKPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex{
    self.myPageControl.currentPage = pageIndex;
    KKWindowImageShowItemView *itemView = (KKWindowImageShowItemView*)[self.myPageView viewForPageIndex:pageIndex];
    [itemView.myScrollView setZoomScale:1.0 animated:NO];
    self.nowSelectedIndex = pageIndex;
}

#pragma mark ==================================================
#pragma mark == KKWindowImageShowItemViewDelegate
#pragma mark ==================================================
- (void)KKWindowImageShowItemViewSingleTap:(KKWindowImageShowItemView*_Nonnull)itemView{
    [self cancelSelf];
}

- (void)KKWindowImageShowItemViewLongPressed:(KKWindowImageShowItemView*_Nonnull)itemView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageShowView:longPressedItemView:)]) {
        [self.delegate KKWindowImageShowView:self longPressedItemView:itemView];
    } else {
        if (itemView.currentIsGif == NO) {
            [self showActionWithItemView:itemView];
        }
    }
}

- (void)showActionWithItemView:(KKWindowImageShowItemView*)aItemView{
    NSMutableArray *itemArray = [NSMutableArray array];

    KKWindowActionViewItem *item1 = [[KKWindowActionViewItem alloc] initWithImage:nil title:KKLibLocalizable_Common_SaveToAlbum keyId:@"-2020030302"];
    [itemArray addObject:item1];

    KKWindowActionViewItem *item3 = [[KKWindowActionViewItem alloc] initWithImage:nil title:KKLibLocalizable_Common_Cancel keyId:@"-2020030301"];

    KKWindowActionView *aView = [KKWindowActionView showWithItems:itemArray cancelItem:item3 delegate:self];
    aView.tagInfo = aItemView;
}

#pragma mark ****************************************
#pragma mark KKWindowActionViewDelegate
#pragma mark ****************************************
- (void)KKWindowActionView:(KKWindowActionView*)aView
              clickedIndex:(NSInteger)buttonIndex
                      item:(KKWindowActionViewItem*)aItem{

    KKWindowImageShowItemView *itemView = (KKWindowImageShowItemView*)aView.tagInfo;
    if (itemView == nil ||
        ![itemView isKindOfClass:[KKWindowImageShowItemView class]]) {
        return;
    }

    if ([aItem.keyId isEqualToString:@"-2020030302"]) {
        [self saveNowImage:itemView.myImageView.image];
    }
    else {

    }
}

#pragma mark ==================================================
#pragma mark == 保存图片
#pragma mark ==================================================
- (void) saveNowImage:(UIImage*)aImage{
    if (aImage) {
        BOOL authorized = [KKAuthorizedManager.defaultManager isAlbumAuthorized_ShowAlert:YES andAPPName:nil];
        if (authorized) {
            UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil){
        [KKToastView showInView:[UIWindow currentKeyWindow] text:KKLibLocalizable_Common_Success image:nil  alignment:KKToastViewAlignment_Center];
    }
    else{
        [KKToastView showInView:[UIWindow currentKeyWindow] text:KKLibLocalizable_Common_Failed image:nil  alignment:KKToastViewAlignment_Center];
    }
}

#pragma mark ==================================================
#pragma mark == StatusBar
#pragma mark ==================================================
- (void)hideStatusBar{
    UIViewController *controller = [[UIWindow currentKeyWindow] currentTopViewController];
    if ([controller isKindOfClass:[KKViewController class]]) {
        KKViewController *kkcontroller = (KKViewController*)controller;
        [kkcontroller setStatusBarHidden:YES
                          statusBarStyle:self.nowStatusBarStyle
                           withAnimation:UIStatusBarAnimationFade];
    }
    else{
        /*========== 20171122 刘波 新增代码 屏蔽此文件的deprecated-declarations类型的编译警告 开始*/
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        /*========== 20171122 刘波 新增代码 屏蔽此文件的deprecated-declarations类型的编译警告 结束*/
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        /*========== 20171122 刘波 新增代码 屏蔽此文件的deprecated-declarations类型的编译警告 开始*/
#pragma clang diagnostic pop
        /*========== 20171122 刘波 新增代码 屏蔽此文件的deprecated-declarations类型的编译警告 结束*/

    }
}

- (void)showStatusBar{
    UIViewController *controller = [[UIWindow currentKeyWindow] currentTopViewController];
    if ([controller isKindOfClass:[KKViewController class]]) {
        KKViewController *kkcontroller = (KKViewController*)controller;
        [kkcontroller setStatusBarHidden:NO
                          statusBarStyle:self.nowStatusBarStyle
                           withAnimation:UIStatusBarAnimationFade];
    }
    else{
        /*========== 20171122 刘波 新增代码 屏蔽此文件的deprecated-declarations类型的编译警告 开始*/
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        /*========== 20171122 刘波 新增代码 屏蔽此文件的deprecated-declarations类型的编译警告 结束*/
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        /*========== 20171122 刘波 新增代码 屏蔽此文件的deprecated-declarations类型的编译警告 开始*/
#pragma clang diagnostic pop
        /*========== 20171122 刘波 新增代码 屏蔽此文件的deprecated-declarations类型的编译警告 结束*/

    }
}



@end
