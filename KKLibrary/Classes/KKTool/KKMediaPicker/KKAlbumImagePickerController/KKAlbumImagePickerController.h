//
//  KKAlbumImagePickerController.h
//  HeiPa
//
//  Created by liubo on 2019/3/12.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKNavigationController.h"
#import "KKAlbumImagePickerManager.h"

@interface KKAlbumImagePickerController : UINavigationController

/* 初始化 */
- (instancetype)initWithDelegate:(id<KKAlbumImagePickerDelegate>)aDelegate
      numberOfPhotosNeedSelected:(NSInteger)aNumberOfPhotosNeedSelected
                      cropEnable:(BOOL)aCropEnable
                        cropSize:(CGSize)aCropSize
                  assetMediaType:(KKAssetMediaType)aMediaType;

@end
