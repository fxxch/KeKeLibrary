//
//  KKAlbumAssetModalVideoPlayView.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "KKAlbumAssetModal.h"

@protocol KKAlbumAssetModalVideoPlayViewDelegate;


@interface KKAlbumAssetModalVideoPlayView : KKView

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
@property (nonatomic , strong) KKAlbumAssetModal *assetModal;
@property (nonatomic , weak) id<KKAlbumAssetModalVideoPlayViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame albumAssetModal:(KKAlbumAssetModal*)aKKAlbumAssetModal;

- (void)startPlay;

- (void)stopPlay;

- (void)pausePlay;

- (void)seekToBackTime:(NSTimeInterval)aTime;

- (BOOL)isPlaying;

@end


#pragma mark ==================================================
#pragma mark == KKAlbumAssetModalVideoPlayViewDelegate
#pragma mark ==================================================
@protocol KKAlbumAssetModalVideoPlayViewDelegate <NSObject>
@optional

- (void)KKAlbumAssetModalVideoPlayView:(KKAlbumAssetModalVideoPlayView*)aView
                             playVideo:(BOOL)playVideo;

@required
//播放开始
- (void)KKAlbumAssetModalVideoPlayView_PlayDidStart:(KKAlbumAssetModalVideoPlayView*)player;

//继续开始
- (void)KKAlbumAssetModalVideoPlayView_PlayDidContinuePlay:(KKAlbumAssetModalVideoPlayView*)player;

//播放结束
- (void)KKAlbumAssetModalVideoPlayView_PlayDidFinished:(KKAlbumAssetModalVideoPlayView*)player;

//播放暂停
- (void)KKAlbumAssetModalVideoPlayView_PlayDidPause:(KKAlbumAssetModalVideoPlayView*)player;

//播放时间改变
- (void)KKAlbumAssetModalVideoPlayView:(KKAlbumAssetModalVideoPlayView*)player
                   playBackTimeChanged:(NSTimeInterval)currentTime
                          durationtime:(NSTimeInterval)durationtime;

@end

