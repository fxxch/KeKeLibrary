//
//  KKAlbumAssetModalPreviewController.m
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumAssetModalPreviewController.h"
#import "KKNavigationController.h"
#import "KKAlbumAssetModalPreviewView.h"
#import "KKAlbumAssetModal.h"
#import "KKLibraryDefine.h"
#import "KKCategory.h"

@interface KKAlbumAssetModalPreviewController ()

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) NSArray *itemsArray;
@property (nonatomic , assign) NSInteger selectIndex;
@property (nonatomic , weak) UINavigationController *NavController;
@property (nonatomic , assign) CGRect fromRect;

@end

@implementation KKAlbumAssetModalPreviewController

+ (void)showFromNavigationController:(UINavigationController*_Nullable)aNavController
                               items:(NSArray<KKAlbumAssetModal*>*_Nullable)aItemsArray
                       selectedIndex:(NSInteger)aSelectedIndex
                            fromRect:(CGRect)aFromRect{
    if ([aItemsArray count]<=0 ||
        aNavController == nil) {
        return;
    }

    if (CGRectEqualToRect(aFromRect, CGRectZero)) {
        KKAlbumAssetModalPreviewController *viewController = [[KKAlbumAssetModalPreviewController alloc] initWithNavigationController:aNavController items:aItemsArray selectedIndex:aSelectedIndex fromRect:aFromRect];
        KKNavigationController *nav = [[KKNavigationController alloc] initWithRootViewController:viewController];
        [aNavController presentViewController:nav animated:YES completion:^{

        }];
    } else {
        KKAlbumAssetModalPreviewController *viewController = [[KKAlbumAssetModalPreviewController alloc] initWithNavigationController:aNavController items:aItemsArray selectedIndex:aSelectedIndex fromRect:aFromRect];
        KKNavigationController *nav = [[KKNavigationController alloc] initWithRootViewController:viewController];
        [aNavController presentViewController:nav animated:NO completion:^{

        }];
    }
    
}

- (instancetype)initWithNavigationController:(UINavigationController*)aNavController
                                       items:(NSArray<KKAlbumAssetModal*>*_Nullable)aItemsArray
                               selectedIndex:(NSInteger)aSelectedIndex
                                    fromRect:(CGRect)aFromRect{
    self = [super init];
    if (self) {
        self.fromRect = aFromRect;
        self.NavController = aNavController;
        self.itemsArray = aItemsArray;
        self.selectIndex = aSelectedIndex;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight)];
    [self.view addSubview:self.imageView];
    self.imageView.image = [self.NavController.view snapshot];
}

- (void)show{
    if (self.itemsArray) {
        KKAlbumAssetModalPreviewView *windowImageView = [[KKAlbumAssetModalPreviewView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight) items:self.itemsArray selectedIndex:self.selectIndex fromRect:self.fromRect];
        windowImageView.tag = 2020040701;
        windowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:windowImageView];

        [windowImageView show];

        self.itemsArray = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self show];
}


@end
