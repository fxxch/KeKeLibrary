//
//  KKAlbumImageShowItemView.h
//  HeiPa
//
//  Created by liubo on 2019/3/16.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAlbumManager.h"
#import <AVFoundation/AVFoundation.h>

@class KKAlbumImageShowItemView;
#pragma mark ==================================================
#pragma mark == KKAlbumImageShowItemViewDelegate
#pragma mark ==================================================
@protocol KKAlbumImageShowItemViewDelegate <NSObject>
@optional

- (void)KKAlbumImageShowItemViewSingleTap:(KKAlbumImageShowItemView*)aItemView;

- (void)KKAlbumImageShowItemView:(KKAlbumImageShowItemView*)aItemView
                       playVideo:(BOOL)aPlay;

@end


static NSString *KKAlbumImageShowItemView_ID = @"KKAlbumImageShowItemView_ID";

@interface KKAlbumImageShowItemView : UICollectionViewCell
<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong) UIImageView *myImageView;
@property (nonatomic,strong) UIButton *videoPlayButton;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@property (nonatomic , weak) id<KKAlbumImageShowItemViewDelegate> delegate;
@property (nonatomic , assign) NSInteger row;
@property (nonatomic , strong) KKAlbumAssetModal *assetModal;
@property (nonatomic , strong) UIView *waitingView;

- (void)reloadWithInformation:(KKAlbumAssetModal*)aModal
                          row:(NSInteger)aRow;

@end
