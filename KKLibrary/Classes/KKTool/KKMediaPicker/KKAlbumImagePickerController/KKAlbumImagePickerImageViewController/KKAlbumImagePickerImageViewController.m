//
//  KKAlbumImagePickerImageViewController.m
//  HeiPa
//
//  Created by liubo on 2019/3/13.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImagePickerImageViewController.h"
#import "KKAlbumImageToolBar.h"
#import "KKImageCropperViewController.h"
#import "KKAlbumImageShowViewController.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKAlertView.h"
#import "KKToastView.h"
#import "KKButton.h"
#import "KKLocalizationManager.h"
#import "KKLog.h"
#import "KKAlbumImagePickerDirectoryList.h"
#import "KKAlbumImagePickerNavTitleBar.h"
#import "AlbumImageCollectionViewCell.h"
#import "KKAuthorizedManager.h"

@interface KKAlbumImagePickerImageViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
KKAlbumImageToolBarDelegate,
AlbumImageCollectionViewCellDelegate,
KKAlbumImageShowViewControllerDelegate,
KKAlbumImagePickerDirectoryListDelegate,
KKAlbumImagePickerNavTitleBarDelegate>

@property (nonatomic , strong) UICollectionView *mainCollectionView;
@property (nonatomic , strong) KKAlbumImageToolBar *toolBar;
@property (nonatomic , strong) KKAlbumImagePickerNavTitleBar *titleBar;
@property (nonatomic , strong) KKAlbumImagePickerDirectoryList *directoryList;
// 放置图像处理时候的等待View
@property (nonatomic , strong)UIView *waitingView;
@property (nonatomic , strong) KKAlbumDirectoryModal *directoryModal;

@end

@implementation KKAlbumImagePickerImageViewController

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self name:NotificationName_KKAlbumManagerLoadSourceFinished object:nil];
    KKLogDebug(@"KKAlbumImagePickerImageViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    KKButton *buttonL = [self setNavLeftButtonTitle:KKLibLocalizable_Common_Cancel titleColor:[UIColor whiteColor] selector:@selector(navigationControllerDismiss)];
    buttonL.textLabel.font = [UIFont systemFontOfSize:17];

    self.titleBar = [[KKAlbumImagePickerNavTitleBar alloc] initWithFrame:CGRectMake(0, 0, KKApplicationWidth, KKNavigationBarHeight)];
    self.navigationItem.titleView = self.titleBar;
    self.titleBar.delegate = self;
    
    KKButton *buttonR = [self setNavRightButtonTitle:KKLibLocalizable_Common_Cancel titleColor:[UIColor whiteColor] selector:@selector(navigationControllerDismiss)];
    buttonR.hidden = YES;

    [self initUI];
    
    self.directoryList = [[KKAlbumImagePickerDirectoryList alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKApplicationHeight-KKNavigationBarHeight)];
    [self.view addSubview:self.directoryList];
    self.directoryList.hidden = YES;
    self.directoryList.delegate = self;
    
    [self initWaitingView];
    [self observeNotification:NotificationName_KKAlbumManagerLoadSourceFinished selector:@selector(Notification_KKAlbumManagerLoadSourceFinished:)];
    
    BOOL authorized = [KKAuthorizedManager.defaultManager isAlbumAuthorized_ShowAlert:YES andAPPName:nil];
    if (authorized) {        
        // 为了防止界面卡住，可以异步执行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            KKAssetMediaType type = [KKAlbumImagePickerManager defaultManager].mediaType;
            NSArray *array = [KKAlbumManager loadDirectory_WithMediaType:type];

            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [NSNotificationCenter.defaultCenter postNotificationName:NotificationName_KKAlbumManagerLoadSourceFinished object:array];
                
            });
            
        });

    } else {
        [NSNotificationCenter.defaultCenter postNotificationName:NotificationName_KKAlbumManagerLoadSourceFinished object:nil];
    }
}

- (void)initUI{
    if ([KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected>1) {
        //主图片
        CGRect collectionViewFrame= CGRectMake(0, 0, KKApplicationWidth, KKApplicationHeight-44-60);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.mainCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
        self.mainCollectionView.showsVerticalScrollIndicator = NO;
        self.mainCollectionView.showsHorizontalScrollIndicator = NO;
        self.mainCollectionView.backgroundColor = [UIColor whiteColor];
        self.mainCollectionView.dataSource = self;
        self.mainCollectionView.delegate = self;
        self.mainCollectionView.bounces = YES;
        self.mainCollectionView.alwaysBounceVertical = YES;
        [self.mainCollectionView registerClass:[AlbumImageCollectionViewCell class] forCellWithReuseIdentifier:AlbumImageCollectionViewCell_ID];
        [self.view addSubview:self.mainCollectionView];

        /*底部工具栏*/
        self.toolBar = [[KKAlbumImageToolBar alloc] initWithFrame:CGRectMake(0, KKApplicationHeight-44-50, KKScreenWidth, (KKSafeAreaBottomHeight+50))];
        self.toolBar.delegate = self;
        [self.view addSubview:self.toolBar];
        [self.toolBar setNumberOfPic:0 maxNumberOfPic:[KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected];
        [[UIScreen mainScreen] createiPhoneXFooterForView:self.toolBar withBackGroudColor:[[UIColor blackColor] colorWithAlphaComponent:0.25]];
    }
    else{
        //主图片
        CGRect collectionViewFrame= CGRectMake(0, 0, KKApplicationWidth, KKApplicationHeight-44);
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.mainCollectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:flowLayout];
        self.mainCollectionView.showsVerticalScrollIndicator = NO;
        self.mainCollectionView.showsHorizontalScrollIndicator = NO;
        self.mainCollectionView.backgroundColor = [UIColor whiteColor];
        self.mainCollectionView.dataSource = self;
        self.mainCollectionView.delegate = self;
        self.mainCollectionView.bounces = YES;
        self.mainCollectionView.alwaysBounceVertical = YES;
        [self.mainCollectionView registerClass:[AlbumImageCollectionViewCell class] forCellWithReuseIdentifier:AlbumImageCollectionViewCell_ID];
        [self.view addSubview:self.mainCollectionView];
    }

    if (self.directoryModal.assetsArray.count>0) {
        [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.directoryModal.assetsArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }

    [self observeNotification:NotificationName_KKAlbumImagePickerSelectModal selector:@selector(Notification_KKAlbumImagePickerSelectModal:)];
    [self observeNotification:NotificationName_KKAlbumImagePickerUnSelectModal selector:@selector(Notification_KKAlbumImagePickerUnSelectModal:)];
}

- (void)initWaitingView{
    self.waitingView = [[UIView alloc] initWithFrame:CGRectMake((KKScreenWidth-80)/2.0, (KKScreenHeight-KKStatusBarAndNavBarHeight-80)/2.0, 80, 80)];
    self.waitingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.waitingView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.waitingView];
    self.waitingView.clipsToBounds = YES;
    self.waitingView.userInteractionEnabled = YES;
    [self.waitingView setCornerRadius:10];

    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activeView startAnimating];
    activeView.frame = CGRectMake(0, 0, 50, 50);
    activeView.center = CGPointMake(self.waitingView.frame.size.width/2.0, self.waitingView.frame.size.height/2.0);
    [self.waitingView addSubview:activeView];
    self.waitingView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.directoryModal==nil) {
        self.waitingView.hidden = NO;
    }
}

#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (void)Notification_KKAlbumImagePickerSelectModal:(NSNotification*)notice{
    KKAlbumAssetModal *modal = notice.object;
    NSInteger index = [self.directoryModal.assetsArray indexOfObject:modal];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.mainCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)Notification_KKAlbumImagePickerUnSelectModal:(NSNotification*)notice{
    KKAlbumAssetModal *modal = notice.object;
    NSInteger index = [self.directoryModal.assetsArray indexOfObject:modal];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.mainCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

- (void)Notification_KKAlbumManagerLoadSourceFinished:(NSNotification*)notice{
    [self.waitingView removeFromSuperview];
    NSArray *array = notice.object;
    for (NSInteger i=0; i<[array count]; i++) {
        KKAlbumDirectoryModal *data = (KKAlbumDirectoryModal*)[array objectAtIndex:i];
        if ([data.title isEqualToString:KKLibLocalizable_Album_UserLibrary]) {
            self.directoryModal = data;
            [self.mainCollectionView reloadData];
            [self.mainCollectionView scrollToBottomWithAnimated:NO];
            break;
        }
    }
}

- (void)KKAlbumImagePickerNavTitleBar_Open:(BOOL)aOpen{
    if (aOpen) {
        [self.directoryList beginShow];
    } else {
        [self.directoryList beginHide];
    }
}

- (void)KKAlbumImagePickerDirectoryList:(KKAlbumImagePickerDirectoryList*)aListView
                 selectedDirectoryModal:(KKAlbumDirectoryModal*)aModal{
    self.directoryModal = aModal;
    [self.titleBar reloadWithDirectoryModal:self.directoryModal];
    [self.mainCollectionView reloadData];
    [self.mainCollectionView scrollToBottomWithAnimated:NO];
}

- (void)KKAlbumImagePickerDirectoryList_WillHide:(KKAlbumImagePickerDirectoryList*)aListView{
    [self.titleBar close];
}

- (void)KKAlbumImagePickerDirectoryList_WillShow:(KKAlbumImagePickerDirectoryList*)aListView{
    [self.titleBar open];
}

#pragma mark - ==================================================
#pragma mark == UICollectionViewDataSource
#pragma mark ====================================================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.directoryModal.assetsArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumImageCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:AlbumImageCollectionViewCell_ID forIndexPath:indexPath];
    cell.delegate = self;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
    
    KKAlbumAssetModal *assetModal = [self.directoryModal.assetsArray objectAtIndex_Safe:indexPath.row];
    if ([[KKAlbumImagePickerManager defaultManager] isSelectAssetModal:assetModal]) {
        [(AlbumImageCollectionViewCell*)cell reloadWithInformation:assetModal select:YES];
    }
    else{
        [(AlbumImageCollectionViewCell*)cell reloadWithInformation:assetModal select:NO];
    }

}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (KKApplicationWidth-25)/4.0;
    return CGSizeMake(itemWidth, itemWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){KKApplicationWidth,0.1};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){KKApplicationWidth,0.1};
}




#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{

}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self collectionViewItem_didSelectAtIndexPath:indexPath];
}

- (void)AlbumImageCollectionViewCell_MainButtonClicked:(AlbumImageCollectionViewCell*)aItemCell{
    NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
    if (maxNumber==1) {
        NSIndexPath *indexPath = [self.mainCollectionView indexPathForCell:aItemCell];
        [self collectionViewItem_didSelectAtIndexPath:indexPath];
    }
    else{
        NSInteger index = [self.mainCollectionView indexPathForCell:aItemCell].row;
        
        //全屏展示
        KKAlbumImageShowViewController *viewController = [[KKAlbumImageShowViewController alloc] initWithArray:self.directoryModal.assetsArray selectIndex:index];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)AlbumImageCollectionViewCell_SelectButtonClicked:(AlbumImageCollectionViewCell*)aItemCell{
    NSIndexPath *indexPath = [self.mainCollectionView indexPathForCell:aItemCell];
    [self collectionViewItem_didSelectAtIndexPath:indexPath];
}


- (void)collectionViewItem_didSelectAtIndexPath:(NSIndexPath *)indexPath{
    
    KKAlbumAssetModal *assetModal = [self.directoryModal.assetsArray objectAtIndex_Safe:indexPath.row];
    [self selectdModalProcess:assetModal];
}



//// 长按某item，弹出copy和paste的菜单
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}
//
//// 使copy和paste有效
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
//    if ([NSStringFromSelector(action) isEqualToString:@"copy:"] || [NSStringFromSelector(action) isEqualToString:@"paste:"])
//    {
//        return YES;
//    }
//
//    return NO;
//}
//
////
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
//{
////    if([NSStringFromSelector(action) isEqualToString:@"copy:"])
////    {
////        //      NSLog(@"-------------执行拷贝-------------");
////        [_collectionView performBatchUpdates:^{
////            [_section0Array removeObjectAtIndex:indexPath.row];
////            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
////        } completion:nil];
////    }
////    else if([NSStringFromSelector(action) isEqualToString:@"paste:"])
////    {
////        NSLog(@"-------------执行粘贴-------------");
////    }
//}

- (void)KKAlbumImageToolBar_PreviewButtonClicked:(KKAlbumImageToolBar*)toolView{
    //全屏展示
    KKAlbumImageShowViewController *viewController = [[KKAlbumImageShowViewController alloc] initWithArray:[KKAlbumImagePickerManager defaultManager].allSource selectIndex:0];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)KKAlbumImageToolBar_OKButtonClicked:(KKAlbumImageToolBar*)toolView{
    [self selectMultipleFinished];
}

- (void)selectSingleComplete:(KKAlbumAssetModal*)assetModal{
    
    if (assetModal.asset.mediaType==PHAssetMediaTypeImage) {
        if ([KKAlbumImagePickerManager defaultManager].cropEnable) {
            
            if (assetModal.fileURL==nil) {
                KKLogDebug(@"KKAlbumImagePickerManager 图片任务处理开始");
                KKWeakSelf(self)
                [KKAlbumManager startExportImageWithPHAsset:assetModal.asset
                                                resultBlock:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    if (imageData) {
                        [assetModal setOriginImageInfo:info
                                             imageData:imageData
                                          imageDataUTI:dataUTI
                                      imageOrientation:orientation
                                           filePathURL:nil];
                        
                        if (assetModal.fileURL) {
                            KKImageCropperViewController *cropImageViewController = [[KKImageCropperViewController alloc] initWithAssetModal:assetModal cropSize:[KKAlbumImagePickerManager defaultManager].cropSize];
                            [weakself.navigationController pushViewController:cropImageViewController animated:YES];
                            [cropImageViewController cropImage:^(KKAlbumAssetModal *aModal, UIImage *newImage) {
                                aModal.img_croppedbImage = newImage;
                                [[KKAlbumImagePickerManager defaultManager] selectAssetModal:aModal];
                                [weakself selectSingleFinished];
                            }];
                            KKLogDebug(@"KKAlbumImagePickerManager A图片任务处理结束:【成功】");
                        }
                        else{
                            KKLogDebug(@"KKAlbumImagePickerManager B图片任务处理结束:【失败】");
                        }
                    }
                    else{
                        KKLogDebug(@"KKAlbumImagePickerManager C图片任务处理结束:【失败】");
                    }

                }];
            }
            else{
                KKLogDebug(@"KKAlbumImagePickerManager 图片存在");
                KKImageCropperViewController *cropImageViewController = [[KKImageCropperViewController alloc] initWithAssetModal:assetModal cropSize:[KKAlbumImagePickerManager defaultManager].cropSize];
                
                [self.navigationController pushViewController:cropImageViewController animated:YES];
                KKWeakSelf(self)
                [cropImageViewController cropImage:^(KKAlbumAssetModal *aModal, UIImage *newImage) {
                    aModal.img_croppedbImage = newImage;
                    [[KKAlbumImagePickerManager defaultManager] selectAssetModal:aModal];
                    [weakself selectSingleFinished];
                }];
            }
        }
        else{
            [[KKAlbumImagePickerManager defaultManager] selectAssetModal:assetModal];
            [self selectSingleFinished];
        }
    }
    else if (assetModal.asset.mediaType==PHAssetMediaTypeVideo){
        [[KKAlbumImagePickerManager defaultManager] selectAssetModal:assetModal];
        [self selectSingleFinished];
    }
    else{
        
    }
    
}

- (void)selectMultipleFinished{
    [[KKAlbumImagePickerManager defaultManager] finishedWithNavigationController:self.navigationController];
}

- (void)selectSingleFinished{
    [[KKAlbumImagePickerManager defaultManager] finishedWithNavigationController:self.navigationController];
}

- (void)KKAlbumImageShowViewController_ClickedModal:(KKAlbumAssetModal*)aModal{
    [self selectdModalProcess:aModal];
}

- (void)selectdModalProcess:(KKAlbumAssetModal*)assetModal{
    
    /* 最大允许数量 */
    NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
    if (maxNumber==1) {
        [[KKAlbumImagePickerManager defaultManager] clearAllObjects];
        [self selectSingleComplete:assetModal];
    }
    else{
        if ([[KKAlbumImagePickerManager defaultManager] isSelectAssetModal:assetModal]) {
            [[KKAlbumImagePickerManager defaultManager] deselectAssetModal:assetModal];
        }
        else{
            /* 已经达到最大 */
            NSInteger maxNumber = [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected;
            NSInteger selectNumber = [[KKAlbumImagePickerManager defaultManager].allSource count];
            if (selectNumber >= maxNumber) {
  
                NSString *message = KKLibLocalizable_Album_MaxLimited;

                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:KKLibLocalizable_Common_Notice subTitle:nil message:message delegate:nil buttonTitles:KKLibLocalizable_Common_OK,nil];
                [alertView show];
                return;
            }
            [[KKAlbumImagePickerManager defaultManager] selectAssetModal:assetModal];
        }
    }

}

#pragma mark ==================================================
#pragma mark == 主体颜色
#pragma mark ==================================================
/* 子类可重写该方法，不重写的话默认是白色 */
- (UIColor*)kk_DefaultNavigationBarBackgroundColor{
    return [KKAlbumManager navigationBarBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
}


@end



