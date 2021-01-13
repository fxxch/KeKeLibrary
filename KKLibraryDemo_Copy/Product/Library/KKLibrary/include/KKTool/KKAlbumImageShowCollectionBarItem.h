//
//  KKAlbumImageShowCollectionBarItem.h
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAlbumManager.h"
#import "KKAlbumImagePickerManager.h"

#pragma mark ==================================================
#pragma mark == KKAlbumImageShowCollectionBarItem
#pragma mark ==================================================

static NSString *KKAlbumImageShowCollectionBarItem_ID = @"KKAlbumImageShowCollectionBarItem_ID";

@interface KKAlbumImageShowCollectionBarItem : UICollectionViewCell

@property (nonatomic,strong) UIButton *mainImageView;
@property (nonatomic,strong) UIImageView *videoLogoView;
@property (nonatomic,strong) KKAlbumAssetModal *assetModal;

- (void)reloadWithInformation:(KKAlbumAssetModal*)aInformation select:(BOOL)select;

@end
