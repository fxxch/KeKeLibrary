//
//  KKAlbumImageShowViewController.m
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImageShowViewController.h"
#import "KKAlbumImageShowItemView.h"
#import "KKAlbumImageShowNavBar.h"
#import "KKAlbumImageShowToolBar.h"
#import "KKAlbumImageShowCollectionBar.h"
#import "KKCategory.h"
#import "KKAlertView.h"
#import "KKSharedInstance.h"
#import "KKLibraryDefine.h"
//#import "IJSImagePickerController.h"
//#import "IJSImageManagerController.h"
//#import <IJSFoundation/IJSFoundation.h>
//#import "IJSMapViewModel.h"

@interface KKAlbumImageShowViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
KKAlbumImageShowNavBarDelegate,
KKAlbumImageShowItemViewDelegate,
KKAlbumImageShowToolBarDelegate,
KKAlbumImageShowCollectionBarDelegate>

@property (nonatomic , strong) UICollectionView *mainCollectionView;
@property (nonatomic , strong) KKAlbumImageShowNavBar *topBar;
@property (nonatomic , strong) KKAlbumImageShowToolBar *toolBar;
@property (nonatomic , strong) KKAlbumImageShowCollectionBar *collectionBar;
@property (nonatomic , strong) NSMutableArray *dataSource;
@property (nonatomic , assign) NSInteger inIndex;

@end

@implementation KKAlbumImageShowViewController

/* 初始化 */
- (instancetype)initWithArray:(NSArray*)aImageArray
                  selectIndex:(NSInteger)aIndex{
self = [super init];
    if (self) {
        self.inIndex = aIndex;
        self.dataSource = [[NSMutableArray alloc] init];
        [self.dataSource addObjectsFromArray:aImageArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //主图片
    CGRect collectionViewFrame= CGRectMake(0, 0, KKApplicationWidth, KKScreenHeight-KKStatusBarHeight);
    
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
    [self.mainCollectionView registerClass:[KKAlbumImageShowItemView class] forCellWithReuseIdentifier:KKAlbumImageShowItemView_ID];
    self.mainCollectionView.pagingEnabled = YES;
    [self.view addSubview:self.mainCollectionView];
    
    /*顶部工具栏*/
    self.topBar = [[KKAlbumImageShowNavBar alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKStatusBarAndNavBarHeight)];
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];
    self.topBar.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.inIndex+1,(long)self.dataSource.count];
    KKAlbumAssetModal *modal = [self.dataSource objectAtIndex_Safe:self.inIndex];
    if ([[KKAlbumImagePickerManager defaultManager] isSelectAssetModal:modal]) {
        [self.topBar setSelect:YES item:modal];
    }
    else{
        [self.topBar setSelect:NO item:modal];
    }
    
    /*底部工具栏*/
    self.collectionBar = [[KKAlbumImageShowCollectionBar alloc] initWithFrame:CGRectMake(0, KKScreenHeight-(KKSafeAreaBottomHeight+50)-60, KKScreenWidth, 60)];
    self.collectionBar.delegate = self;
    [self.view addSubview:self.collectionBar];
    [self.collectionBar selectModal:modal];

    /*底部工具栏*/
    self.toolBar = [[KKAlbumImageShowToolBar alloc] initWithFrame:CGRectMake(0, KKScreenHeight-50, KKScreenWidth, 50)];
    self.toolBar.delegate = self;
    [self.view addSubview:self.toolBar];
    [[UIScreen mainScreen] createiPhoneXFooterForView:self.toolBar withBackGroudColor:[[UIColor blackColor] colorWithAlphaComponent:0.25]];

    [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.inIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [self observeNotification:NotificationName_KKAlbumImagePickerSelectModal selector:@selector(Notification_KKAlbumImagePickerSelectModal:)];
    [self observeNotification:NotificationName_KKAlbumImagePickerUnSelectModal selector:@selector(Notification_KKAlbumImagePickerUnSelectModal:)];
    [self observeNotification:NotificationName_KKAlbumManagerDataSourceChanged selector:@selector(Notification_KKAlbumManagerDataSourceChanged:)];

    if (modal.asset.mediaType == PHAssetMediaTypeImage) {
        self.toolBar.editButton.hidden = NO;
    } else {
        self.toolBar.editButton.hidden = YES;
    }
}

- (void)KKAlbumImageShowNavBar_LeftButtonClicked{
    [self navigationControllerPopBack];
}

- (void)KKAlbumImageShowNavBar_RightButtonClicked{
    
    NSInteger index = self.mainCollectionView.contentOffset.x/KKScreenWidth;
    KKAlbumAssetModal *modal = [self.dataSource objectAtIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImageShowViewController_ClickedModal:)]) {
        [self.delegate KKAlbumImageShowViewController_ClickedModal:modal];
    }

}

- (void)KKAlbumImageShowToolBar_EditButtonClicked:(KKAlbumImageShowToolBar*)toolView{

//    NSInteger index = self.mainCollectionView.contentOffset.x/KKScreenWidth;
//    KKAlbumAssetModal *modal = [self.dataSource objectAtIndex:index];
//    UIImage *editImage = modal.bigImageForShowing;
//
//    // TODO:<#title#>
//    //第三方图片剪辑
//    KKWeakSelf(self)
//    IJSImageManagerController *managerVc = [[IJSImageManagerController alloc] initWithEditImage:editImage];
//    [managerVc loadImageOnCompleteResult:^(UIImage *image, NSURL *outputPath, NSError *error) {
//        if (image) {
//            //回到主线程
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakself thirdEditImageFinished:image];
//            });
//
//            return YES;
//        } else {
//            return NO;
//        }
//    }];
//    managerVc.mapImageArr = [managerVc defaultEmojiMapArray];
//    managerVc.modalPresentationStyle = UIModalPresentationFullScreen;
//    managerVc.notBackAnimation = YES;
//    [self.navigationController pushViewController:managerVc animated:NO];
}

- (void)thirdEditImageFinished:(UIImage*)aImage{
    NSInteger nowIndex = self.mainCollectionView.contentOffset.x/KKScreenWidth;
    KKAlbumAssetModal *nowModal = [self.dataSource objectAtIndex:nowIndex];
    nowModal.img_EditeImage = aImage;
    [self postNotification:NotificationName_KKAlbumAssetModalEditImageFinished object:nowModal];
}

- (void)KKAlbumImageShowToolBar_OKButtonClicked:(KKAlbumImageShowToolBar*)toolView{
    [[KKAlbumImagePickerManager defaultManager] finishedWithNavigationController:self.navigationController];
}

- (void)KKAlbumImageShowCollectionBar_SelectModal:(KKAlbumAssetModal*)aModal{
    
    NSInteger index = [self.dataSource indexOfObject:aModal];
    [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    self.topBar.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)(index+1),(long)self.dataSource.count];
    [self.collectionBar selectModal:aModal];
    [self.topBar setSelect:YES item:aModal];
    [self postNotification:@"NotificationName_KKAlbumImageShowItemViewResetZoomScale" object:[NSNumber numberWithInteger:index]];

    if (aModal.asset.mediaType == PHAssetMediaTypeImage) {
        self.toolBar.editButton.hidden = NO;
    } else {
        self.toolBar.editButton.hidden = YES;
    }
}

#pragma mark - ==================================================
#pragma mark == UICollectionViewDataSource
#pragma mark ====================================================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KKAlbumImageShowItemView *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:KKAlbumImageShowItemView_ID forIndexPath:indexPath];
    cell.delegate = self;


    KKAlbumAssetModal *assetModal = [self.dataSource objectAtIndex:indexPath.row];
    
    [cell reloadWithInformation:assetModal row:indexPath.row];
    
    return cell;
}

- (void)KKAlbumImageShowItemViewSingleTap:(KKAlbumImageShowItemView*)aItemView{
    if (self.topBar.alpha>0) {
//        [self setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.25 animations:^{
            self.topBar.alpha = 0;
            self.toolBar.alpha = 0;
            self.collectionBar.alpha = 0;
        }];
    }
    else{
//        [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.25 animations:^{
            self.topBar.alpha = 1.0;
            self.toolBar.alpha = 1.0;
            self.collectionBar.alpha = 1.0;
        }];
    }
}

- (void)KKAlbumImageShowItemView:(KKAlbumImageShowItemView*)aItemView
                       playVideo:(BOOL)aPlay{
    if (aPlay) {
        if (self.topBar.alpha>0) {
//            [self setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [UIView animateWithDuration:0.25 animations:^{
                self.topBar.alpha = 0;
                self.toolBar.alpha = 0;
                self.collectionBar.alpha = 0;
            }];
        }
    }
    else{
        if (self.topBar.alpha==0) {
//            [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
            [UIView animateWithDuration:0.25 animations:^{
                self.topBar.alpha = 1.0;
                self.toolBar.alpha = 1.0;
                self.collectionBar.alpha = 1.0;
            }];
        }
    }
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
    KKAlbumAssetModal *modal = [self.dataSource objectAtIndex:index];
    if ([[KKAlbumImagePickerManager defaultManager] isSelectAssetModal:modal]) {
        [self.topBar setSelect:YES item:modal];
    }
    else{
        [self.topBar setSelect:NO item:modal];
    }

    if (modal.asset.mediaType == PHAssetMediaTypeImage) {
        self.toolBar.editButton.hidden = NO;
    } else {
        self.toolBar.editButton.hidden = YES;
    }

    self.topBar.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)(index+1),(long)self.dataSource.count];
    [self.collectionBar selectModal:modal];

    [self postNotification:@"NotificationName_KKAlbumImageShowItemViewResetZoomScale" object:[NSNumber numberWithInteger:index]];
}

#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (void)Notification_KKAlbumImagePickerSelectModal:(NSNotification*)notice{
    NSInteger index = self.mainCollectionView.contentOffset.x/KKScreenWidth;
    KKAlbumAssetModal *modalT = [self.dataSource objectAtIndex:index];
    if ([[KKAlbumImagePickerManager defaultManager] isSelectAssetModal:modalT]) {
        [self.topBar setSelect:YES item:modalT];
    }
    else{
        [self.topBar setSelect:NO item:modalT];
    }
}

- (void)Notification_KKAlbumImagePickerUnSelectModal:(NSNotification*)notice{
    NSInteger index = self.mainCollectionView.contentOffset.x/KKScreenWidth;
    KKAlbumAssetModal *modalT = [self.dataSource objectAtIndex:index];
    if ([[KKAlbumImagePickerManager defaultManager] isSelectAssetModal:modalT]) {
        [self.topBar setSelect:YES item:modalT];
    }
    else{
        [self.topBar setSelect:NO item:modalT];
    }
}

- (void)Notification_KKAlbumManagerDataSourceChanged:(NSNotification*)notice{

}



#pragma mark ==================================================
#pragma mark == 主体颜色
#pragma mark ==================================================
/* 子类可重写该方法，不重写的话默认是白色 */
- (UIColor*)kk_DefaultNavigationBarBackgroundColor{
    return [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //导航栏底部线清除
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationNone];
}


@end


