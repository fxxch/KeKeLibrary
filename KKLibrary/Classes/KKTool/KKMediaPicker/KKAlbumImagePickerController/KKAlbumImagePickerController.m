//
//  KKAlbumImagePickerController.m
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImagePickerController.h"
#import "KKFileCacheManager.h"
#import "KKAuthorizedManager.h"
#import "KKAlbumImagePickerImageViewController.h"
#import "KKLibraryDefine.h"
#import "KKCategory.h"

@implementation KKAlbumImagePickerController

- (void)dealloc
{
    [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected = 0;
    [KKAlbumImagePickerManager defaultManager].cropEnable = NO;
    [KKAlbumImagePickerManager defaultManager].cropSize = CGSizeMake(200, 200);
    [KKAlbumImagePickerManager defaultManager].delegate = nil;
    [[KKAlbumImagePickerManager defaultManager] clearAllObjects];
    [KKAlbumImagePickerManager defaultManager].isSelectOrigin = NO;

    [KKFileCacheManager deleteCacheDataInCacheDirectory:KKFileCacheManager_CacheDirectoryOfAlbumImage];
    [KKFileCacheManager deleteCacheDataInCacheDirectory:KKFileCacheManager_CacheDirectoryOfAlbumVideo];
    [KKFileCacheManager deleteCacheDirectory:KKFileCacheManager_CacheDirectoryOfAlbumImage];
    [KKFileCacheManager deleteCacheDirectory:KKFileCacheManager_CacheDirectoryOfAlbumVideo];
}

/* 初始化 */
- (instancetype)initWithDelegate:(id<KKAlbumImagePickerDelegate>)aDelegate
      numberOfPhotosNeedSelected:(NSInteger)aNumberOfPhotosNeedSelected
                      cropEnable:(BOOL)aCropEnable
                        cropSize:(CGSize)aCropSize
                  assetMediaType:(KKAssetMediaType)aMediaType{
    self = [super init];
    if (self) {
        [KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected = aNumberOfPhotosNeedSelected;
        [KKAlbumImagePickerManager defaultManager].cropEnable = aCropEnable;
        [KKAlbumImagePickerManager defaultManager].cropSize = aCropSize;
        [KKAlbumImagePickerManager defaultManager].mediaType = aMediaType;
        [KKAlbumImagePickerManager defaultManager].delegate = aDelegate;
        [[KKAlbumImagePickerManager defaultManager] clearAllObjects];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KKAlbumImagePickerImageViewController *photoViewController = [[KKAlbumImagePickerImageViewController alloc] init];
    [self setViewControllers:@[photoViewController] animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (self.navigationBar.titleTextAttributes) {
        [attributes setValuesForKeysWithDictionary:self.navigationBar.titleTextAttributes];
        [attributes setObject:[UIColor whiteColor]
                       forKey:NSForegroundColorAttributeName];
    }
    else{
        [attributes setValue:[UIFont boldSystemFontOfSize:18]
                      forKey:NSFontAttributeName];
        [attributes setObject:[UIColor whiteColor]
                       forKey:NSForegroundColorAttributeName];
    }
    self.navigationBar.titleTextAttributes = attributes;
}

@end
