//
//  KKCameraImageShowViewController.m
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKCameraImageShowViewController.h"
#import "KKCameraImageShowItemView.h"
#import "KKCameraImageShowNavBar.h"
#import "KKCameraImageShowToolBar.h"
#import "UIScreen+KKCategory.h"
#import "NSArray+KKCategory.h"

@interface KKCameraImageShowViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
KKCameraImageShowNavBarDelegate,
KKCameraImageShowItemViewDelegate,
KKCameraImageShowToolBarDelegate>

@property (nonatomic , strong) UICollectionView *mainCollectionView;
@property (nonatomic , strong) KKCameraImageShowNavBar *topBar;
@property (nonatomic , strong) KKCameraImageShowToolBar *toolBar;
@property (nonatomic , weak) id<KKCameraImageShowViewControllerDelegate> delegate;
@property (nonatomic , weak) id<KKCameraImagePickerDelegate> pickerDelegate;
@property (nonatomic , strong) NSMutableArray *dataSource;
@property (nonatomic , assign) NSInteger maxNumber;

@end

@implementation KKCameraImageShowViewController

/* 初始化 */
- (instancetype)initWithDelegate:(id<KKCameraImageShowViewControllerDelegate>)aDelegate
                  pickerDelegate:(id<KKCameraImagePickerDelegate>)aPickerDelegate
                     imagesArray:(NSArray*)aImageArray
                       maxNumber:(NSInteger)amax{
    self = [super init];
    if (self) {
        self.dataSource = [[NSMutableArray alloc] init];
        [self.dataSource addObjectsFromArray:aImageArray];
        self.delegate = aDelegate;
        self.pickerDelegate = aPickerDelegate;
        self.maxNumber = amax;
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
    [self.mainCollectionView registerClass:[KKCameraImageShowItemView class] forCellWithReuseIdentifier:KKCameraImageShowItemView_ID];
    self.mainCollectionView.pagingEnabled = YES;
    [self.view addSubview:self.mainCollectionView];

    /*顶部工具栏*/
    self.topBar = [[KKCameraImageShowNavBar alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKStatusBarAndNavBarHeight)];
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];
    self.topBar.titleLabel.text = [NSString stringWithFormat:@"1/%ld",(long)self.dataSource.count];
    
    /*底部工具栏*/
    self.toolBar = [[KKCameraImageShowToolBar alloc] initWithFrame:CGRectMake(0, KKScreenHeight-(KKSafeAreaBottomHeight+50), KKScreenWidth, (KKSafeAreaBottomHeight+50))];
    self.toolBar.delegate = self;
    [self.view addSubview:self.toolBar];
    [[UIScreen mainScreen] createiPhoneXFooterForView:self.toolBar withBackGroudColor:[UIColor blackColor]];
    [self.toolBar setNumberOfPic:self.dataSource.count maxNumberOfPic:self.maxNumber];
}

- (void)KKCameraImageShowNavBar_LeftButtonClicked{
    [self navigationControllerPopBack];
}

- (void)KKCameraImageShowNavBar_RightButtonClicked{
    
    NSInteger index = self.mainCollectionView.contentOffset.x/KKScreenWidth;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImageShowViewController_DeleteItemAtIndex:)]) {
        [self.delegate KKCameraImageShowViewController_DeleteItemAtIndex:index];
    }
    
    [self.dataSource removeObjectAtIndex:index];
    if ([NSArray isArrayEmpty:self.dataSource]) {
        [self navigationControllerDismiss];
    }
    else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.mainCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        
        NSInteger indexN = self.mainCollectionView.contentOffset.x/KKScreenWidth;
        
        if (indexN+1>self.dataSource.count) {
            self.topBar.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)(self.dataSource.count),(long)self.dataSource.count];
        }
        else{
            self.topBar.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)(indexN+1),(long)self.dataSource.count];
        }
        
        [self.toolBar setNumberOfPic:self.dataSource.count maxNumberOfPic:self.maxNumber];
    }
}

- (void)KKCameraImageShowToolBar_OKButtonClicked:(KKCameraImageShowToolBar*)toolView{
    if (self.pickerDelegate && [self.pickerDelegate respondsToSelector:@selector(KKCameraImagePicker_didFinishedPickImages:)]) {
        [self.pickerDelegate KKCameraImagePicker_didFinishedPickImages:self.dataSource];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - ==================================================
#pragma mark == UICollectionViewDataSource
#pragma mark ====================================================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KKCameraImageShowItemView *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:KKCameraImageShowItemView_ID forIndexPath:indexPath];
    
    cell.delegate = self;
    [cell setImage:[self.dataSource objectAtIndex:indexPath.row]];
    cell.row = indexPath.row;
    
    return cell;
}

- (void)KKCameraImageShowItemViewSingleTap:(KKCameraImageShowItemView*)aItemView{
    if (self.topBar.alpha>0) {
//        [self setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.25 animations:^{
            self.topBar.alpha = 0;
            self.toolBar.alpha = 0;
        }];
    }
    else{
//        [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.25 animations:^{
            self.topBar.alpha = 1.0;
            self.toolBar.alpha = 1.0;
        }];
    }
}


#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KKScreenWidth, KKScreenHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
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

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = self.mainCollectionView.contentOffset.x/KKScreenWidth;
    self.topBar.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)(index+1),(long)self.dataSource.count];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationName_KKCameraImageShowItemViewResetZoomScale" object:[NSNumber numberWithInteger:index]];
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
    [self setStatusBarHidden:YES statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
}

@end


