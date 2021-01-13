//
//  KKImageCropperViewController.h
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKViewController.h"
#import "KKImageCropperView.h"
#import "KKAlbumManager.h"

typedef void(^KKImageCropperFinishedBlock)(KKAlbumAssetModal *aModal,UIImage *newImage);

@interface KKImageCropperViewController : KKViewController

- (id)initWithAssetModal:(KKAlbumAssetModal *)aModal cropSize:(CGSize)cropSize;

- (id)initWithImage:(UIImage *)aImage cropSize:(CGSize)cropSize;

- (void)cropImage:(KKImageCropperFinishedBlock)block;

@end
