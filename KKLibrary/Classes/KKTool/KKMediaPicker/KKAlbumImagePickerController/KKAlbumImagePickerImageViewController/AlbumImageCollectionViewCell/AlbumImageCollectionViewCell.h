//
//  AlbumImageCollectionViewCell.h
//  HeiPa
//
//  Created by liubo on 2019/3/13.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAlbumManager.h"
#import "KKAlbumImagePickerManager.h"

@class AlbumImageCollectionViewCell;
#pragma mark ==================================================
#pragma mark == AlbumImageCollectionViewCellDelegate
#pragma mark ==================================================
@protocol AlbumImageCollectionViewCellDelegate <NSObject>
@optional

- (void)AlbumImageCollectionViewCell_MainButtonClicked:(AlbumImageCollectionViewCell*)aItemCell;

- (void)AlbumImageCollectionViewCell_SelectButtonClicked:(AlbumImageCollectionViewCell*)aItemCell;

@end


#pragma mark ==================================================
#pragma mark == AlbumImageCollectionViewCell
#pragma mark ==================================================

static NSString *AlbumImageCollectionViewCell_ID = @"AlbumImageCollectionViewCell_ID";

@interface AlbumImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIButton *mainImageView;
@property (nonatomic,strong) UIButton *selectedImageView;
@property (nonatomic,strong) UIButton *selectedButton;
@property (nonatomic,strong) UIImageView *videoLogoView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) KKAlbumAssetModal *assetModal;
@property (nonatomic , weak) id<AlbumImageCollectionViewCellDelegate> delegate;

- (void)reloadWithInformation:(KKAlbumAssetModal*)aInformation select:(BOOL)select;

@end

