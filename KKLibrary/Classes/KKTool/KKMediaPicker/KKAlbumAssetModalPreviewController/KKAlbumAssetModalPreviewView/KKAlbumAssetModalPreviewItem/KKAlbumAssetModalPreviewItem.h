//
//  KKAlbumAssetModalPreviewItem.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKView.h"
#import "KKAlbumManager.h"
#import <AVFoundation/AVFoundation.h>

@class KKAlbumAssetModalPreviewItem;
#pragma mark ==================================================
#pragma mark == KKAlbumAssetModalPreviewItemDelegate
#pragma mark ==================================================
@protocol KKAlbumAssetModalPreviewItemDelegate <NSObject>
@optional

- (void)KKAlbumAssetModalPreviewItemSingleTap:(KKAlbumAssetModalPreviewItem*)aItemView;

- (void)KKAlbumAssetModalPreviewItem:(KKAlbumAssetModalPreviewItem*)aItemView
                                  playVideo:(BOOL)aPlay;

@end


static NSString *KKAlbumAssetModalPreviewItem_ID = @"KKAlbumAssetModalPreviewItem_ID";

@interface KKAlbumAssetModalPreviewItem : UICollectionViewCell
<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong) UIImageView *myImageView;
@property (nonatomic,strong) UIButton *videoPlayButton;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@property (nonatomic , weak) id<KKAlbumAssetModalPreviewItemDelegate> delegate;
@property (nonatomic , assign) NSInteger row;
@property (nonatomic , strong) KKAlbumAssetModal *assetModal;
@property (nonatomic , strong) UIView *waitingView;

- (void)reloadWithInformation:(KKAlbumAssetModal*)aModal
                          row:(NSInteger)aRow;


@end
