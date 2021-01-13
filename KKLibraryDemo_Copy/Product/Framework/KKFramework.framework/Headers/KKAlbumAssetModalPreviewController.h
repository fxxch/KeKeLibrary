//
//  KKAlbumAssetModalPreviewController.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKViewController.h"
#import "KKAlbumAssetModal.h"

@interface KKAlbumAssetModalPreviewController : KKViewController

+ (void)showFromNavigationController:(UINavigationController*_Nullable)aNavController
                               items:(NSArray<KKAlbumAssetModal*>*_Nullable)aItemsArray
                       selectedIndex:(NSInteger)aSelectedIndex
                            fromRect:(CGRect)aFromRect;

@end
