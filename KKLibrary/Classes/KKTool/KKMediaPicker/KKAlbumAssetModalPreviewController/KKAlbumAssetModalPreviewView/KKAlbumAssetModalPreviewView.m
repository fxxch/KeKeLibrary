//
//  KKAlbumAssetModalPreviewView.m
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumAssetModalPreviewView.h"
#import "KKCategory.h"
#import "KKAlertView.h"
#import "KKSharedInstance.h"
#import "KKLibraryDefine.h"
#import "KKViewController.h"

@interface KKAlbumAssetModalPreviewView ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
KKAlbumAssetModalPreviewItemDelegate>

@property (nonatomic , strong) UIView *backgroundView;
@property (nonatomic , strong) UICollectionView *mainCollectionView;
@property (nonatomic , strong) UIPageControl *myPageControl;
@property (nonatomic , assign) NSInteger initSelectIndex;

@property (nonatomic,strong)KKAlbumAssetModalPreviewItem *animationView;
@property (nonatomic,assign)UIStatusBarStyle nowStatusBarStyle;
@property (nonatomic,assign)CGRect fromRect;
@property (nonatomic , strong) UIButton *closeButton;

@end

@implementation KKAlbumAssetModalPreviewView

- (id)initWithFrame:(CGRect)frame
              items:(NSArray<KKAlbumAssetModal*>*)aItemsArray
      selectedIndex:(NSInteger)aSelectedIndex
           fromRect:(CGRect)aFromRect{
    self = [super initWithFrame:frame];
    if (self) {
        self.fromRect = aFromRect;
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

        //主图片
        CGRect collectionViewFrame= self.bounds;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.mainCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
        self.mainCollectionView.showsVerticalScrollIndicator = NO;
        self.mainCollectionView.showsHorizontalScrollIndicator = NO;
        self.mainCollectionView.backgroundColor = [UIColor blackColor];
        self.mainCollectionView.dataSource = self;
        self.mainCollectionView.delegate = self;
        self.mainCollectionView.bounces = YES;
        self.mainCollectionView.alwaysBounceHorizontal = YES;
        [self.mainCollectionView registerClass:[KKAlbumAssetModalPreviewItem class] forCellWithReuseIdentifier:KKAlbumAssetModalPreviewItem_ID];
        self.mainCollectionView.pagingEnabled = YES;
        [self addSubview:self.mainCollectionView];

        self.myPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 20)];
        self.myPageControl.hidesForSinglePage = YES;
        self.myPageControl.numberOfPages = [self.itemsArray count];
        self.myPageControl.currentPage = self.nowSelectedIndex;
        self.myPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.myPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:self.myPageControl];
        self.myPageControl.hidden = YES;

        if (self.itemsArray.count>0) {
            [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath   indexPathForRow:self.initSelectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            self.myPageControl.currentPage = 0;
        }
        
        //关闭按钮
        self.closeButton = [[UIButton alloc] init];
        self.closeButton.frame = CGRectMake(30, self.height-KKSafeAreaBottomHeight-30-44, 44, 44);
        [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        UIImage *image02 = [NSBundle imageInBundle:@"KKCameraCapture.bundle" imageName:@"close"];
        [self.closeButton setImage:image02 forState:UIControlStateNormal];

        KKAlbumAssetModal *assetModal = [self.itemsArray objectAtIndex_Safe:self.nowSelectedIndex];
        if (assetModal.asset.mediaType == PHAssetMediaTypeVideo) {
            self.closeButton.hidden = NO;
        } else {
            self.closeButton.hidden = YES;
        }
    }
    return self;
}

- (void)closeButtonClicked{
    [self cancelSelf];
}

#pragma mark - ==================================================
#pragma mark == UICollectionViewDataSource
#pragma mark ====================================================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.itemsArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KKAlbumAssetModalPreviewItem *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:KKAlbumAssetModalPreviewItem_ID forIndexPath:indexPath];
    cell.delegate = self;


    KKAlbumAssetModal *assetModal = [self.itemsArray objectAtIndex:indexPath.row];
    
    [cell reloadWithInformation:assetModal row:indexPath.row];
    
    return cell;
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(KKScreenWidth, KKScreenHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = self.mainCollectionView.contentOffset.x/KKScreenWidth;
    KKAlbumAssetModal *assetModal = [self.itemsArray objectAtIndex:index];
    if (assetModal.asset.mediaType == PHAssetMediaTypeVideo) {
        self.closeButton.hidden = NO;
    } else {
        self.closeButton.hidden = YES;
    }
    self.myPageControl.currentPage = index;
    [self postNotification:@"NotificationName_KKAlbumAssetModalPreviewItemResetZoomScale" object:[NSNumber numberWithInteger:index]];
}

#pragma mark ==================================================
#pragma mark == 展示/消失自己
#pragma mark ==================================================
- (void)show{
    self.nowStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    self.mainCollectionView.hidden = YES;

    self.animationView = [[KKAlbumAssetModalPreviewItem alloc] initWithFrame:self.fromRect];
    self.animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    KKAlbumAssetModal *assetModal = [self.itemsArray objectAtIndex_Safe:self.nowSelectedIndex];
    [self.animationView reloadWithInformation:assetModal row:self.nowSelectedIndex];
    [self addSubview:self.animationView];

    if (CGRectEqualToRect(self.fromRect, CGRectZero)) {
        [self.animationView removeFromSuperview];
        self.animationView = nil;
        self.mainCollectionView.hidden = NO;
        self.backgroundView.alpha = 1.0;
        [self hideStatusBar];
    } else {
        KKWeakSelf(self);
        self.backgroundView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.animationView.frame = self.bounds;
            self.backgroundView.alpha = 1.0;
        } completion:^(BOOL finished) {

            [weakself hideStatusBar];

            [self.animationView removeFromSuperview];
            self.animationView = nil;
            self.mainCollectionView.hidden = NO;
        }];
    }
}

//隐藏自己
- (void) cancelSelf{

    [self showStatusBar];

    if (CGRectEqualToRect(self.fromRect, CGRectZero)) {
        if (self.viewController.navigationController) {
            [self.viewController.navigationController dismissViewControllerAnimated:YES completion:^{

            }];
        } else {
            [self removeFromSuperview];
        }
    } else {
        CGRect nowFrame = self.fromRect;

        self.animationView = [[KKAlbumAssetModalPreviewItem alloc] initWithFrame:self.bounds];
        self.animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.animationView.delegate = nil;

        [self.animationView reloadWithInformation:[self.itemsArray objectAtIndex_Safe:self.nowSelectedIndex]
                                              row:self.nowSelectedIndex];
        [self addSubview:self.animationView];
        self.mainCollectionView.hidden = YES;

        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0;
            self.animationView.frame = nowFrame;
            self.animationView.alpha = 0.3;
        } completion:^(BOOL finished) {
            self.animationView.myImageView.contentMode = UIViewContentModeScaleAspectFill;
            
            [self.animationView removeFromSuperview];
            self.animationView = nil;
            if (self.viewController.navigationController) {
                [self.viewController.navigationController dismissViewControllerAnimated:NO completion:^{

                }];
            } else {
                [self removeFromSuperview];
            }

//            [self performSelector:@selector(hideSelfAnimated) withObject:nil afterDelay:0];
        }];
    }

}

- (void)hideSelfAnimated{
    [UIView animateWithDuration:0.1 animations:^{
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
#pragma mark == KKWindowImageShowItemViewDelegate
#pragma mark ==================================================
- (void)KKAlbumAssetModalPreviewItemSingleTap:(KKAlbumAssetModalPreviewItem*)aItemView{
    [self cancelSelf];
}

- (void)KKAlbumAssetModalPreviewItem:(KKAlbumAssetModalPreviewItem*)aItemView
                                  playVideo:(BOOL)aPlay{
    
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
