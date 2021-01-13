//
//  KKImageCropperViewController.m
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKImageCropperViewController.h"
#import "UIScreen+KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKSharedInstance.h"
#import "KKCategory.h"

@interface KKImageCropperViewController ()

@property (nonatomic , strong) KKAlbumAssetModal *inModal;
@property (nonatomic , strong) UIImage *inImage;
@property (nonatomic , assign) CGSize inCropSize;
@property (nonatomic , strong) KKImageCropperView  *imageCropperView;
@property (nonatomic , copy) KKImageCropperFinishedBlock _Nullable finishedBlock;

@end


@implementation KKImageCropperViewController

- (void)dealloc{

}

- (id)initWithAssetModal:(KKAlbumAssetModal *)aModal cropSize:(CGSize)cropSize{
    if (self = [super init]) {
        self.inModal = aModal;
        UIImage *tempImage = [UIImage imageWithData:aModal.img_originData];
        self.inImage = [tempImage fixOrientation];
        self.inCropSize = cropSize;
    }
    return self;
}

- (id)initWithImage:(UIImage *)aImage cropSize:(CGSize)cropSize{
    if (self = [super init]) {
        self.inImage = [aImage fixOrientation];
        self.inCropSize = cropSize;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = KKLibLocalizable_Album_ImageCut;
    
    UIImage *leftImage = [KKAlbumManager themeImageForName:@"NavBack"];
    [self setNavLeftButtonImage:leftImage highlightImage:nil selector:@selector(navigationControllerPopBack)];

    [self setNavRightButtonTitle:KKLibLocalizable_Common_OK titleColor:[UIColor whiteColor] selector:@selector(croppedImage)];
    
    [self initUI];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor blackColor]];

    self.imageCropperView = [[KKImageCropperView alloc] initWithFrame:CGRectMake(0,0,KKScreenWidth,KKApplicationHeight-44)];
    [self.imageCropperView setImage:self.inImage];
    [self.imageCropperView setCropSize:self.inCropSize];
    [self.view addSubview:self.imageCropperView];
}

- (void)cropImage:(KKImageCropperFinishedBlock)block{
    if (self.finishedBlock != block) {
        self.finishedBlock = block;
    }
}

- (void)croppedImage {
    if (self.finishedBlock != nil) {
        self.finishedBlock(self.inModal,self.imageCropperView.croppedImage);
    }
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
    //导航栏底部线清除
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
}


@end
