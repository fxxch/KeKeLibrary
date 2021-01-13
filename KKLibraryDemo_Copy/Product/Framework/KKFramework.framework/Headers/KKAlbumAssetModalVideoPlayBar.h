//
//  KKAlbumAssetModalVideoPlayBar.h
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKView.h"

@interface KKAlbumAssetModalVideoPlaySlider : UISlider

@end

@protocol KKAlbumAssetModalVideoPlayBarDelegate;

@interface KKAlbumAssetModalVideoPlayBar : UIView{
    NSTimeInterval _currentTime;//当前时间
    NSTimeInterval _durationtime;//当前时间
}

@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,strong)KKAlbumAssetModalVideoPlaySlider *mySlider;
@property (nonatomic,strong)UILabel *currentTimeLabel;
@property (nonatomic,strong)UILabel *durationtimeLabel;
@property (nonatomic,assign)NSTimeInterval currentTime;//当前时间
@property (nonatomic,assign)NSTimeInterval durationtime;//当前时间
@property (nonatomic,strong)UIButton *stopPlayButton;
@property (nonatomic,strong)UIButton *backButton;//返回（×）
@property (nonatomic,strong)UIButton *moreButton;//更多（…）
@property (nonatomic,assign)BOOL isSliderTouched;

@property (nonatomic,assign)id<KKAlbumAssetModalVideoPlayBarDelegate> delegate;

- (void)setButtonStatusStop;

- (void)setButtonStatusPlaying;

@end


@protocol KKAlbumAssetModalVideoPlayBarDelegate <NSObject>

- (void)KKAlbumAssetModalVideoPlayBar_BackButtonClicked:(KKAlbumAssetModalVideoPlayBar*)aView;

- (void)KKAlbumAssetModalVideoPlayBar_MoreButtonClicked:(KKAlbumAssetModalVideoPlayBar*)aView;

- (void)KKAlbumAssetModalVideoPlayBar_PlayButtonClicked:(KKAlbumAssetModalVideoPlayBar*)aView;

- (void)KKAlbumAssetModalVideoPlayBar_PauseButtonClicked:(KKAlbumAssetModalVideoPlayBar*)aView;

- (void)KKAlbumAssetModalVideoPlayBar:(KKAlbumAssetModalVideoPlayBar*)aView currentTimeChanged:(NSTimeInterval)aCurrentTime;

@end
