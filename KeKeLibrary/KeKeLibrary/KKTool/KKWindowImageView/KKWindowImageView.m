//
//  KKWindowImageView.m
//  Social
//
//  Created by liubo on 13-4-19.
//  Copyright (c) 2013年 ibm. All rights reserved.
//

#import "KKWindowImageView.h"
#import "KKViewController.h"
#import "KeKeLibraryDefine.h"
#import "KKCategory.h"
#import "KKTool.h"

@interface KKWindowImageView ()<KKActionSheetDelegate>
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)UIPageControl *myPageControl;
@property (nonatomic,strong)KKPageScrollView *myPageView;
@property (nonatomic,strong)NSMutableArray *originViews;
@property (nonatomic,strong)NSMutableArray *imageURLStringArray;
@property (nonatomic,strong)KKWindowImageItem *animationView;

@property (nonatomic,assign)BOOL nowImageIsGIF;
@property (nonatomic,assign)NSInteger nowSelectedIndex;
@property (nonatomic,assign)UIStatusBarStyle nowStatusBarStyle;

//老的方式
@property (nonatomic,strong)NSMutableArray *imageInformationArray;
@property (nonatomic,assign)BOOL isOldType;

@end


@implementation KKWindowImageView



#pragma mark ==================================================
#pragma mark == 【初始化】老的方式
#pragma mark ==================================================
+ (void)showImageWithURLString:(NSString*)imageURLString placeholderImage:(UIImage*)image{
    if (imageURLString && ![imageURLString isKindOfClass:[NSNull class]]) {
        UIWindow *window = ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]);
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:imageURLString forKey:KKWindowImageView_URL];
        if (image && [image isKindOfClass:[UIImage class]]) {
            [dic setObject:image forKey:KKWindowImageView_PlaceHolderImage];
        }
        NSArray *array = [[NSArray alloc] initWithObjects:dic, nil];
        
        KKWindowImageView *windowImageView = [[KKWindowImageView alloc]initWithFrame:window.bounds imageArray:array selectedIndex:0];
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];
    }
}

+ (void)showImage:(UIImage*)image{
    if (image && [image isKindOfClass:[UIImage class]]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        NSArray *array = [[NSArray alloc] initWithObjects:dic, nil];
        [dic setObject:image forKey:KKWindowImageView_PlaceHolderImage];
        
        UIWindow *window = ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]);
        KKWindowImageView *windowImageView = [[KKWindowImageView alloc]initWithFrame:window.bounds imageArray:array selectedIndex:0];
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];
    }
}

+ (void)showImageWithURLStringArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index{
    if (aImageInformationArray && [aImageInformationArray isKindOfClass:[NSArray class]]
        && [aImageInformationArray count]>0) {
        UIWindow *window = ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]);
        KKWindowImageView *windowImageView = [[KKWindowImageView alloc]initWithFrame:window.bounds imageArray:aImageInformationArray selectedIndex:index];
        [window addSubview:windowImageView];
        [window bringSubviewToFront:windowImageView];
    }
    
}

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray*)aImageInformationArray selectedIndex:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self) {
        self.isOldType = YES;
        self.imageInformationArray = [[NSMutableArray alloc]init];
        [self.imageInformationArray addObjectsFromArray:aImageInformationArray];
        
        self.backgroundColor = [UIColor blackColor];
        
        self.myPageView = [[KKPageScrollView alloc] initWithFrame:self.bounds];
        self.myPageView.delegate = self;
        [self.myPageView showPageIndex:index animated:NO];
        [self.myPageView setPageSpace:10];
        [self.myPageView reloadData];
        [self.myPageView clearBackgroundColor];
        [self addSubview:self.myPageView];
        
        self.myPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 20)];
        self.myPageControl.hidesForSinglePage = YES;
        self.myPageControl.numberOfPages = [self.imageInformationArray count];
        self.myPageControl.currentPage = index;
        self.myPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.myPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:self.myPageControl];
        
        KKWeakSelf(self);
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
            [weakself hideStatusBar];
            
        }];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 【初始化】新的的方式
#pragma mark ==================================================
+ (KKWindowImageView*)showFromViews:(NSArray*)aOriginViews imageURLStringArray:(NSArray*)aImageURLStringArray selectedIndex:(NSInteger)aSelectedIndex{
    
    if (aOriginViews && [aOriginViews isKindOfClass:[NSArray class]] &&
        aImageURLStringArray && [aImageURLStringArray isKindOfClass:[NSArray class]] &&
        [aOriginViews count]==[aImageURLStringArray count] &&
        aSelectedIndex <= [aImageURLStringArray count]-1) {
        UIWindow *window = ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]);

        for (UIView *subView in [window subviews]) {
            if ([subView isKindOfClass:[KKWindowImageView class]] &&
                subView.tag==20151208) {
                [subView removeFromSuperview];
            }
        }

        KKWindowImageView *windowImageView = [[KKWindowImageView alloc]initWithFrame:window.bounds originViews:aOriginViews imageURLStringArray:aImageURLStringArray selectedIndex:aSelectedIndex];
        windowImageView.tag = 20151208;
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

- (id)initWithFrame:(CGRect)frame originViews:(NSArray*)aOriginViews imageURLStringArray:(NSArray*)aImageURLStringArray selectedIndex:(NSInteger)aSelectedIndex{
    self = [super initWithFrame:frame];
    if (self) {
        self.isOldType = NO;
        self.originViews = [[NSMutableArray alloc]init];
        [self.originViews addObjectsFromArray:aOriginViews];
        
        self.imageURLStringArray = [[NSMutableArray alloc]init];
        [self.imageURLStringArray addObjectsFromArray:aImageURLStringArray];

        self.nowSelectedIndex = aSelectedIndex;
        
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
        self.myPageControl.numberOfPages = [aImageURLStringArray count];
        self.myPageControl.currentPage = self.nowSelectedIndex;
        self.myPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.myPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:self.myPageControl];
        self.myPageControl.hidden = YES;
        
//        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
//        [UIView animateWithDuration:0.25 animations:^{
//            self.transform = CGAffineTransformMakeScale(1, 1);
//        } completion:^(BOOL finished) {
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//        }];
        

    }
    return self;
}

- (void)show{
    self.nowStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    self.myPageView.hidden = YES;
    
    UIView *originView = [self.originViews objectAtIndex:self.nowSelectedIndex];
    CGRect windowFrame = [originView convertRect:originView.bounds toView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];

    self.animationView = [[KKWindowImageItem alloc] initWithFrame:windowFrame];
    self.animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.animationView.delegate = nil;

    NSString *urlString = [self.imageURLStringArray objectAtIndex:self.nowSelectedIndex];
    UIView *view = [self.originViews objectAtIndex:self.nowSelectedIndex];
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImage *defaultImage = [(UIImageView*)view image];
        [self.animationView reloaWithImageURLString:urlString placeholderImage:defaultImage];
    }
    else if ([view isKindOfClass:[UIButton class]]){
        UIImage *defaultImage = [(UIButton*)view currentImage];
        if (!defaultImage) {
            defaultImage = [(UIButton*)view currentBackgroundImage];
        }
        [self.animationView reloaWithImageURLString:urlString placeholderImage:defaultImage];
    }
    else{
        UIImage *defaultImage = nil;
        [self.animationView reloaWithImageURLString:urlString placeholderImage:defaultImage];
    }

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

    if (self.isOldType) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformScale(self.transform, 1.0, 1.0);
            self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else{
        UIView *originView = [self.originViews objectAtIndex:self.nowSelectedIndex];
        CGRect windowFrame = [originView convertRect:originView.bounds toView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
        
        self.animationView = [[KKWindowImageItem alloc] initWithFrame:self.bounds];
        self.animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.animationView.delegate = nil;
        
        NSString *urlString = [self.imageURLStringArray objectAtIndex:self.nowSelectedIndex];
        UIView *view = [self.originViews objectAtIndex:self.nowSelectedIndex];
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImage *defaultImage = [(UIImageView*)view image];
            [self.animationView reloaWithImageURLString:urlString placeholderImage:defaultImage];
        }
        else if ([view isKindOfClass:[UIButton class]]){
            UIImage *defaultImage = [(UIButton*)view currentImage];
            if (!defaultImage) {
                defaultImage = [(UIButton*)view currentBackgroundImage];
            }
            [self.animationView reloaWithImageURLString:urlString placeholderImage:defaultImage];
        }
        else{
            UIImage *defaultImage = nil;
            [self.animationView reloaWithImageURLString:urlString placeholderImage:defaultImage];
        }
        
        [self addSubview:self.animationView];
        self.myPageView.hidden = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0;
            self.animationView.frame = windowFrame;
        } completion:^(BOOL finished) {

        }];
        
        [self performSelector:@selector(hideSelfAnimated) withObject:nil afterDelay:0.2];
    }
}

- (void)hideSelfAnimated{
    [UIView animateWithDuration:0.1 animations:^{
        self.animationView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.animationView removeFromSuperview];
        self.animationView = nil;
        [self removeFromSuperview];
    }];
}

#pragma mark ==================================================
#pragma mark == KKPageScrollViewDelegate
#pragma mark ==================================================
- (UIView*)pageView:(KKPageScrollView*)pageView viewForPage:(NSInteger)pageIndex{
    
    if (self.isOldType) {
        KKWindowImageItem *itemView = (KKWindowImageItem*)[self.myPageView viewForPageIndex:pageIndex];
        if (!itemView) {
            itemView = [[KKWindowImageItem alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            itemView.delegate = self;
        }
        
        NSString *urlString = [[self.imageInformationArray objectAtIndex:pageIndex] objectForKey:KKWindowImageView_URL];
        UIImage *defaultImage = [[self.imageInformationArray objectAtIndex:pageIndex] objectForKey:KKWindowImageView_PlaceHolderImage];
        [itemView reloaWithImageURLString:urlString placeholderImage:defaultImage];
        return itemView;
    }
    else{
        KKWindowImageItem *itemView = (KKWindowImageItem*)[self.myPageView viewForPageIndex:pageIndex];
        if (!itemView) {
            itemView = [[KKWindowImageItem alloc] init];
            itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            itemView.delegate = self;
        }
        
        NSString *urlString = [self.imageURLStringArray objectAtIndex:pageIndex];
        UIView *view = [self.originViews objectAtIndex:pageIndex];
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImage *defaultImage = [(UIImageView*)view image];
            [itemView reloaWithImageURLString:urlString placeholderImage:defaultImage];
        }
        else if ([view isKindOfClass:[UIButton class]]){
            UIImage *defaultImage = [(UIButton*)view currentImage];
            if (!defaultImage) {
                defaultImage = [(UIButton*)view currentBackgroundImage];
            }
            [itemView reloaWithImageURLString:urlString placeholderImage:defaultImage];
        }
        else{
            UIImage *defaultImage = nil;
            [itemView reloaWithImageURLString:urlString placeholderImage:defaultImage];
        }
        
        return itemView;
    }
}

- (NSInteger)numberOfPagesInPageView:(KKPageScrollView*)pageView{
    if (self.isOldType) {
        return [self.imageInformationArray count];
    }
    else{
        return [self.imageURLStringArray count];
    }
}

- (BOOL)pageViewCanRepeat:(KKPageScrollView*)pageView{
    return NO;
}

- (void)pageView:(KKPageScrollView*)pageView didScrolledToPageIndex:(NSInteger)pageIndex{
    if (self.isOldType) {
        self.myPageControl.currentPage = pageIndex;
        KKWindowImageItem *itemView = (KKWindowImageItem*)[self.myPageView viewForPageIndex:pageIndex];
        [itemView.myScrollView setZoomScale:1.0 animated:NO];
    }
    else{
        self.myPageControl.currentPage = pageIndex;
        KKWindowImageItem *itemView = (KKWindowImageItem*)[self.myPageView viewForPageIndex:pageIndex];
        [itemView.myScrollView setZoomScale:1.0 animated:NO];
        self.nowSelectedIndex = pageIndex;
    }
}


#pragma mark ==================================================
#pragma mark == KKWindowImageItemDelegate
#pragma mark ==================================================
- (void)KKWindowImageItem:(KKWindowImageItem*)itemView isGIF:(BOOL)isGIF{
    self.nowImageIsGIF = isGIF;
}

- (void)KKWindowImageItemSingleTap:(KKWindowImageItem*)itemView{
    //    CGPoint p = [tap locationInView:tap.view];
    [self cancelSelf];
}

- (void)KKWindowImageItemLongPressed:(KKWindowImageItem*)itemView{
    if (!self.nowImageIsGIF) {
        KKActionSheet *sheet = [[KKActionSheet alloc] initWithTitle:nil subTitle:@"保存照片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存到手机相册",nil];
        [sheet show];
    }
}

#pragma mark ****************************************
#pragma mark KKActionSheetDelegate
#pragma mark ****************************************
- (void)KKActionSheet:(KKActionSheet*)aActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {//保存到相册
        [self saveNowImage];
    }
    else{//取消

    }
}

#pragma mark ==================================================
#pragma mark == 保存图片
#pragma mark ==================================================
-(void) saveNowImage{
    KKWindowImageItem *itemView = (KKWindowImageItem*)[self.myPageView viewForPageIndex:self.myPageView.currentPageIndex];
    UIImageWriteToSavedPhotosAlbum(itemView.myImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

#if 1
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil){
//        KKShowNoticeMessage(@"保存成功");
    }
    else{
//        KKShowNoticeMessage(@"保存失败");
    }
}
#endif

#pragma mark ==================================================
#pragma mark == StatusBar
#pragma mark ==================================================
- (void)hideStatusBar{
    UIViewController *controller = [Window0 topViewController];
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
    UIViewController *controller = [Window0 topViewController];
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
