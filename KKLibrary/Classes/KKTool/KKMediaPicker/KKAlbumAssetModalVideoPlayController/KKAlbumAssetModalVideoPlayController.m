//
//  KKAlbumAssetModalVideoPlayController.m
//  BM
//
//  Created by sjyt on 2020/4/7.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumAssetModalVideoPlayController.h"
#import "KKAlbumAssetModalVideoPlayBar.h"
#import "KKAlbumAssetModalVideoPlayView.h"
#import "KKFileCacheManager.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKLocalizationManager.h"
#import "KKAlertView.h"
#import "KKButton.h"

#define HiddenPlayerBarTimerMax 3

@interface KKAlbumAssetModalVideoPlayController ()
<KKAlbumAssetModalVideoPlayBarDelegate,UIGestureRecognizerDelegate,KKAlbumAssetModalVideoPlayViewDelegate>

@property (nonatomic,strong)KKAlbumAssetModalVideoPlayBar *toolBarView;
@property (nonatomic,strong)KKAlbumAssetModalVideoPlayView *player;
@property (nonatomic,strong)UIButton *playButton;
@property (nonatomic,assign)BOOL isGestureON;
@property (nonatomic,assign)CGSize videoFrameSize;
@property (nonatomic,assign) BOOL isVideo;
@property (nonatomic,strong) NSTimer *myTimer;//定时隐藏操作Bar
@property (nonatomic,assign) NSInteger myTimerCount;//定时隐藏操作Bar
@property (nonatomic,assign) BOOL isBarHidden;

@property (nonatomic , strong) KKAlbumAssetModal *albumAssetModal;

@end

@implementation KKAlbumAssetModalVideoPlayController

- (void)dealloc{
    [self destroyTimer];
}

- (instancetype)initWitKKAlbumAssetModal:(KKAlbumAssetModal*)aKKAlbumAssetModal{
    self = [super init];
    if (self) {
        self.albumAssetModal = aKKAlbumAssetModal;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //播放器
    self.player = [[KKAlbumAssetModalVideoPlayView alloc] initWithFrame:self.view.bounds albumAssetModal:self.albumAssetModal];
    self.player.delegate = self;
    [self.view addSubview:self.player];
    //添加手势
    [self addGestureRecognizerOnView:self.player];
    
    //底部播放控制栏
    self.toolBarView = [[KKAlbumAssetModalVideoPlayBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-64, KKApplicationWidth, 64)];
    self.toolBarView.delegate = self;
    self.toolBarView.durationtime = 1.0;
    self.toolBarView.currentTime = 0;
    [self.view addSubview:self.toolBarView];
    
    [self reloadSubViewsFrame];
    
    self.toolBarView.moreButton.hidden = YES;

    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.playButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    UIImage *playImage = [NSBundle imageInBundle:@"KKVideoPlay_Resource.bundle" imageName:@"VideoPlay_PlayBig"];
    [self.playButton setBackgroundImage:playImage forState:UIControlStateNormal];
    [self.playButton setCenter:self.player.center];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    delegate.onlySupportPortrait = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self closeInteractivePopGestureRecognizer];
    [self.player startPlay];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.player stopPlay];
}

- (void)navigationControllerPopBack{
//    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    delegate.onlySupportPortrait = YES;
    
    if (self.navigationController.presentingViewController) {
        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:^{

        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)playButtonClicked{
    [self.player startPlay];
}

#pragma mark ==================================================
#pragma mark == 屏幕旋转
#pragma mark ==================================================
//屏幕旋转之后，屏幕的宽高互换，我们借此判断重新布局
//横屏：size.width > size.height
//竖屏: size.width < size.height
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
        NSLog(@"转屏前调入");
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
        NSLog(@"转屏后调入");
        [self reloadSubViewsFrame];
    }];

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)reloadSubViewsFrame{
    UIInterfaceOrientation currentIsPortrait = [UIApplication sharedApplication].statusBarOrientation;
    switch (currentIsPortrait) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:{
            self.player.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);

            self.toolBarView.frame = CGRectMake(0, self.player.height-(KKSafeAreaBottomHeight+120), self.player.width, 120+KKSafeAreaBottomHeight);
            [self.playButton setCenter:self.player.center];
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown:{
            CGFloat statusH = 0;
//            if ([[UIDevice currentDevice] isiPhoneX]) {
//                statusH = KKStatusBarHeight;
//            }

            self.player.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);

            self.toolBarView.frame = CGRectMake(0, self.player.height-(statusH+120), self.player.width, 120+statusH);
            [self.playButton setCenter:self.player.center];
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:{
            self.player.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);
            /* 横屏 */
            self.toolBarView.frame = CGRectMake(0, self.player.height-60, self.player.width, 60);
            [self.playButton setCenter:self.player.center];
            break;
        }
        case UIInterfaceOrientationLandscapeRight:{
            CGFloat statusH = 0;
            if ([[UIDevice currentDevice] isiPhoneX]) {
                statusH = KKStatusBarHeight;
            }

            self.player.frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);
            /* 横屏 */
            self.toolBarView.frame = CGRectMake(0, self.player.height-60, self.player.width, 60);
            [self.playButton setCenter:self.player.center];
            break;
        }
        default:
            break;
    }
}

#pragma mark ****************************************
#pragma mark 屏幕方向
#pragma mark ****************************************
//1.决定当前界面是否开启自动转屏，如果返回NO，后面两个方法也不会被调用，只是会支持默认的方向
- (BOOL)shouldAutorotate {
    return YES;
}

//2.返回支持的旋转方向（当前viewcontroller支持哪些转屏方向）
//iPad设备上，默认返回值UIInterfaceOrientationMaskAllButUpSideDwon
//iPad设备上，默认返回值是UIInterfaceOrientationMaskAll
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//3.返回进入界面默认显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark ==================================================
#pragma mark == 手势
#pragma mark ==================================================
//添加手势
- (void)addGestureRecognizerOnView:(UIView*)aView{

    //单击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognizer.delegate = self;
    [aView addGestureRecognizer:tapGestureRecognizer];

    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizer:)];
    doubleRecognizer.numberOfTapsRequired = 2;// 双击
    //关键语句，给self.view添加一个手势监测；
    [aView addGestureRecognizer:doubleRecognizer];
    // 关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
    [tapGestureRecognizer requireGestureRecognizerToFail:doubleRecognizer];
}

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer*)recognizer{
    if ([self.player isPlaying]) {
        [self setAllBarHidden:!self.isBarHidden];
    }
}

- (void)doubleTapGestureRecognizer:(UITapGestureRecognizer*)recognizer{
    if ([self.player isPlaying]) {
        [self.player pausePlay];
    }
    else{
        [self.player startPlay];
    }
}

#pragma mark ==================================================
#pragma mark == 代理事件
#pragma mark ==================================================
- (void)KKAlbumAssetModalVideoPlayBar_BackButtonClicked:(KKAlbumAssetModalVideoPlayBar*)aView{
    UIInterfaceOrientation nowOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (nowOrientation==UIInterfaceOrientationLandscapeLeft ||
        nowOrientation==UIInterfaceOrientationLandscapeRight) {
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [self performSelector:@selector(navigationControllerPopBack) withObject:nil afterDelay:duration*0.5];
    }
    else{
        [self performSelector:@selector(navigationControllerPopBack) withObject:nil afterDelay:0];
    }
}

- (void)KKAlbumAssetModalVideoPlayBar_MoreButtonClicked:(KKAlbumAssetModalVideoPlayBar*)aView{

}

//播放
- (void)KKAlbumAssetModalVideoPlayBar_PlayButtonClicked:(KKAlbumAssetModalVideoPlayBar*)aView{
    [self.player startPlay];
}

//暂停
- (void)KKAlbumAssetModalVideoPlayBar_PauseButtonClicked:(KKAlbumAssetModalVideoPlayBar*)aView{
    [self.player pausePlay];
}

//前进
- (void)KKAlbumAssetModalVideoPlayBar:(KKAlbumAssetModalVideoPlayBar*)aView currentTimeChanged:(NSTimeInterval)aCurrentTime{
    [self.player seekToBackTime:aCurrentTime];
}

#pragma mark ==================================================
#pragma mark == 视频播放代理
#pragma mark ==================================================
//播放开始
- (void)KKAlbumAssetModalVideoPlayView_PlayDidStart:(KKAlbumAssetModalVideoPlayView*)player{
    [self.toolBarView setButtonStatusPlaying];
    [self startTimer];
    self.playButton.hidden = YES;
}

//继续开始
- (void)KKAlbumAssetModalVideoPlayView_PlayDidContinuePlay:(KKAlbumAssetModalVideoPlayView*)player{
    [self.toolBarView setButtonStatusPlaying];
    [self startTimer];
    self.playButton.hidden = YES;
}

//播放结束
- (void)KKAlbumAssetModalVideoPlayView_PlayDidFinished:(KKAlbumAssetModalVideoPlayView*)player{
    [self.toolBarView setButtonStatusStop];
    self.toolBarView.currentTime = 0;
    self.toolBarView.durationtime = 1.0;
    self.toolBarView.mySlider.value = 0;
    
    [self destroyTimer];
    [self setAllBarHidden:NO];
    self.playButton.hidden = NO;
}

//播放暂停
- (void)KKAlbumAssetModalVideoPlayView_PlayDidPause:(KKAlbumAssetModalVideoPlayView*)player{
    [self.toolBarView setButtonStatusStop];
    [self destroyTimer];
    [self setAllBarHidden:NO];
    self.playButton.hidden = NO;
}

//播放时间改变
- (void)KKAlbumAssetModalVideoPlayView:(KKAlbumAssetModalVideoPlayView*)player
                   playBackTimeChanged:(NSTimeInterval)currentTime
                          durationtime:(NSTimeInterval)durationtime{
    if (self.isGestureON==NO && self.toolBarView.isSliderTouched==NO) {
        self.toolBarView.currentTime = currentTime;
        self.toolBarView.durationtime = durationtime;
        self.toolBarView.mySlider.value = currentTime;
    }
}

#pragma mark ==================================================
#pragma mark == 定时器
#pragma mark ==================================================
- (void)startTimer{
    self.myTimerCount = HiddenPlayerBarTimerMax;
    [self destroyTimer];
    KKWeakSelf(self);
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
        [weakself timerLoop];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
}

- (void)timerLoop{
    if (self.toolBarView.isSliderTouched==NO) {
        self.myTimerCount = self.myTimerCount - 1;
    } else {
        self.myTimerCount = HiddenPlayerBarTimerMax;
    }
    if (self.myTimerCount<=0) {
        [self setAllBarHidden:YES];
    }
}

- (void)destroyTimer{
    if (_myTimer) {
        [_myTimer invalidate];
        _myTimer = nil;
    }
}

- (void)setAllBarHidden:(BOOL)hidden{
    if (self.isBarHidden == hidden) {
        return;
    }
    
    self.isBarHidden = hidden;
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    if (self.isBarHidden) {
        [self setStatusBarHidden:YES statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.alpha = 0;
        } completion:^(BOOL finished) {

        }];
    } else {
        self.myTimerCount = HiddenPlayerBarTimerMax;
        [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];

        [UIView animateWithDuration:duration animations:^{
            self.toolBarView.alpha = 1.0;
        } completion:^(BOOL finished) {

        }];
    }
}

@end
