//
//  AlbumImageCollectionViewCell.m
//  HeiPa
//
//  Created by liubo on 2019/3/13.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "AlbumImageCollectionViewCell.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"

#pragma mark ==================================================
#pragma mark == AlbumImageCollectionViewCell
#pragma mark ==================================================
@implementation AlbumImageCollectionViewCell

- (void)dealloc{
    [self unobserveAllNotification];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.mainImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.mainImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.mainImageView addTarget:self action:@selector(mainViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mainImageView];
        self.mainImageView.clipsToBounds = YES;

        self.videoLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.mainImageView.bottom-5-14, 21, 14)];
        self.videoLogoView.image = [KKAlbumManager themeImageForName:@"VideoLogo"];
        [self addSubview:self.videoLogoView];

        NSString *text = @"99:99:99";
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:10] maxWidth:1000];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.videoLogoView.right+5, 0, self.mainImageView.width-(self.videoLogoView.right+5)-5, size.height)];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.timeLabel];

        self.selectedImageView = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-2-25, 2, 25, 25)];
        [self.selectedImageView addTarget:self action:@selector(selectViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectedImageView];

        self.selectedButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-2-25, 2, 25, 25)];
        [self.selectedButton addTarget:self action:@selector(selectViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.selectedButton];
        [self.selectedButton setCornerRadius:self.selectedButton.width/2.0];

        if ([KKAlbumImagePickerManager defaultManager].numberOfPhotosNeedSelected>1) {
            self.selectedImageView.hidden = YES;
            self.selectedButton.hidden = NO;
        }
        else{
            self.selectedImageView.hidden = YES;
            self.selectedButton.hidden = YES;
        }

        [self observeNotification:NotificationName_KKAlbumManagerDataSourceChanged selector:@selector(Notification_KKAlbumManagerDataSourceChanged:)];
        [self observeNotification:NotificationName_KKAlbumAssetModalEditImageFinished selector:@selector(Notification_KKAlbumAssetModalEditImageFinished:)];
    }
    return self;
}

- (void)reloadWithInformation:(KKAlbumAssetModal*)aInformation
                       select:(BOOL)select{

    self.assetModal = aInformation;
    
    if (select) {
        UIImage *image = [KKAlbumManager themeImageForName:@"SelectedH"];
        [self.selectedImageView setBackgroundImage:image forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [KKAlbumManager themeImageForName:@"UnSelected"];
        [self.selectedImageView setBackgroundImage:image forState:UIControlStateNormal];
    }

    if (select) {
        NSInteger index = [KKAlbumImagePickerManager.defaultManager.allSource indexOfObject:aInformation];
        NSString *title = [NSString stringWithInteger:index+1];

        [self.selectedButton setBackgroundColor:[UIColor colorWithHexString:@"#1E95FF"] forState:UIControlStateNormal];
        [self.selectedButton setTitle:title forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [KKAlbumManager themeImageForName:@"UnSelected"];
        [self.selectedButton setBackgroundImage:image forState:UIControlStateNormal];
        [self.selectedButton setTitle:@"" forState:UIControlStateNormal];
    }


    
    [self.mainImageView setImage:nil forState:UIControlStateNormal];
    
    if ([aInformation isKindOfClass:[KKAlbumAssetModal class]]) {
        
        if (self.assetModal.smallImageForShowing) {
            [self.mainImageView setImage:self.assetModal.smallImageForShowing forState:UIControlStateNormal];
        }
        else{
            KKWeakSelf(self);
            [KKAlbumManager loadThumbnailImage_withPHAsset:((KKAlbumAssetModal*)aInformation).asset targetSize:self.mainImageView.frame.size resultBlock:^(UIImage * _Nullable aImage, NSDictionary * _Nullable info) {
                weakself.assetModal.thumbImage = aImage;
                [weakself.mainImageView setImage:aImage forState:UIControlStateNormal];
            }];
        }
    }
    
    if (self.assetModal.asset.mediaType==PHAssetMediaTypeVideo) {
        self.videoLogoView.hidden = NO;
        self.timeLabel.hidden = NO;


        [self.assetModal videoPlayDuration:^(double dur) {
            NSString *text = [NSDate timeDurationFormatShortString:dur];
            self.timeLabel.text = text;
            self.timeLabel.adjustsFontSizeToFitWidth = YES;
            [self.timeLabel setCenterY:self.videoLogoView.centerY];
        }];
    }
    else{
        self.videoLogoView.hidden = YES;
        self.timeLabel.hidden = YES;
    }
    
}

- (void)mainViewClicked:(UIButton*)aButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AlbumImageCollectionViewCell_MainButtonClicked:)]) {
        [self.delegate AlbumImageCollectionViewCell_MainButtonClicked:self];
    }
}

- (void)selectViewClicked:(UIButton*)aButton{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AlbumImageCollectionViewCell_SelectButtonClicked:)]) {
        [self.delegate AlbumImageCollectionViewCell_SelectButtonClicked:self];
    }
}

- (void)Notification_KKAlbumManagerDataSourceChanged:(NSNotification*)notice{
    if ([KKAlbumImagePickerManager.defaultManager.allSource containsObject:self.assetModal]) {
        NSInteger index = [KKAlbumImagePickerManager.defaultManager.allSource indexOfObject:self.assetModal];
        NSString *title = [NSString stringWithInteger:index+1];

        [self.selectedButton setBackgroundColor:[UIColor colorWithHexString:@"#1E95FF"] forState:UIControlStateNormal];
        [self.selectedButton setTitle:title forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [KKAlbumManager themeImageForName:@"UnSelected"];
        [self.selectedButton setBackgroundImage:image forState:UIControlStateNormal];
        [self.selectedButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)Notification_KKAlbumAssetModalEditImageFinished:(NSNotification*)notice{
    [self.mainImageView setImage:self.assetModal.smallImageForShowing forState:UIControlStateNormal];
}


@end
