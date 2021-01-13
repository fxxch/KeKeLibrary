//
//  KKAlbumImageShowCollectionBarItem.m
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKAlbumImageShowCollectionBarItem.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"

#pragma mark ==================================================
#pragma mark == KKAlbumImageShowCollectionBarItem
#pragma mark ==================================================
@implementation KKAlbumImageShowCollectionBarItem

- (void)dealloc{
    [self unobserveAllNotification];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.mainImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.mainImageView addTarget:self action:@selector(mainViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mainImageView];
        self.mainImageView.userInteractionEnabled = NO;
        self.mainImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.mainImageView.clipsToBounds = YES;
        
        self.videoLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.mainImageView.bottom-5-14, 21, 14)];
        self.videoLogoView.image = [KKAlbumManager themeImageForName:@"VideoLogo"];
        [self addSubview:self.videoLogoView];

        [self observeNotification:NotificationName_KKAlbumAssetModalEditImageFinished selector:@selector(Notification_KKAlbumAssetModalEditImageFinished:)];
    }
    return self;
}

- (void)reloadWithInformation:(KKAlbumAssetModal*)aInformation
                       select:(BOOL)select{
    
    self.assetModal = aInformation;

    if (select) {
        [self.mainImageView setBorderColor:[UIColor colorWithHexString:@"#1E95FF"] width:2.0];
    }
    else{
        [self.mainImageView setBorderColor:[UIColor clearColor] width:0];
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
    }
    else{
        self.videoLogoView.hidden = YES;
    }
    
}

- (void)mainViewClicked:(UIButton*)aButton{

}

- (void)Notification_KKAlbumAssetModalEditImageFinished:(NSNotification*)notice{
    [self.mainImageView setImage:self.assetModal.smallImageForShowing forState:UIControlStateNormal];
}


@end
