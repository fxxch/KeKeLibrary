//
//  KKCameraCaptureShowViewController.m
//  BM
//
//  Created by 刘波 on 2020/2/29.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKCameraCaptureShowViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KKCategory.h"
#import "KKWaitingView.h"
#import "KKFileCacheManager.h"

@interface KKCameraCaptureShowViewController ()<UIScrollViewDelegate>

@property (nonatomic , strong) KKCameraCaptureDataModal *dataModal;
@property (nonatomic , strong) UIImage* placholderImage;
@property (nonatomic , assign) CGRect myImageViewOriginFrame;

@property (nonatomic , weak) UIButton* chaButton;
@property (nonatomic , weak) UIButton* goButton;

@property (nonatomic , strong) UIScrollView* myScrollView;
@property (nonatomic , strong) UIImageView* myImageView;

@end

@implementation KKCameraCaptureShowViewController{
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    AVPlayerItem *playerItem;
    UIImageView* videoView;
    UIImageView* playImg;
}

- (instancetype _Nullable)initWithDataModal:(KKCameraCaptureDataModal*_Nullable)aDataModal
                            placholderImage:(UIImage*_Nullable)aImage{
    self = [super init];
    if (self) {
        self.dataModal = aDataModal;
        self.placholderImage = aImage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
    if (self.dataModal.isImage) {
        [self initImageUI];
    }
    else{
        [self initVideoUI];
    }

    [self initBottomButtons];
}

- (void)initBottomButtons{
    UIImage *chaImage = [NSBundle imageInBundle:@"KKCameraCapture.bundle" imageName:@"chexiao"];
    UIButton *chaButton = [[UIButton alloc] initWithFrame:CGRectMake(15, KKScreenHeight-KKSafeAreaBottomHeight-90-30, 90, 90)];
    [chaButton setImage:chaImage forState:UIControlStateNormal];
    [self.view addSubview:chaButton];
    [chaButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    chaButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    [chaButton setCornerRadius:chaButton.width/2.0];
    self.chaButton = chaButton;
    
    UIImage *gouImage = [NSBundle imageInBundle:@"KKCameraCapture.bundle" imageName:@"gou"];
    UIButton *gouButton = [[UIButton alloc] initWithFrame:CGRectMake(KKScreenWidth-15-90, KKScreenHeight-KKSafeAreaBottomHeight-90-30, 90, 90)];
    [gouButton setImage:gouImage forState:UIControlStateNormal];
    [self.view addSubview:gouButton];
    [gouButton addTarget:self action:@selector(finishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    gouButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.15];
    [gouButton setCornerRadius:chaButton.width/2.0];
    self.goButton = gouButton;
    
    [self.chaButton setCenterX:KKScreenWidth/2.0];
    [self.goButton setCenterX:KKScreenWidth/2.0];
}

- (void)bottomButtonsAnimated{
    [UIView animateWithDuration:0.5 animations:^{
        [self.chaButton setCenterX:30+self.chaButton.width/2.0];
        [self.goButton setCenterX:KKScreenWidth-30-self.goButton.width/2.0];
    }];
}

#pragma mark ==================================================
#pragma mark == 视频
#pragma mark ==================================================
- (void)initVideoUI{
    CGRect frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);
    if ([[UIDevice currentDevice] isiPhoneX]) {
        frame = CGRectMake(0, KKStatusBarHeight, KKScreenWidth, KKScreenHeight-KKStatusBarHeight-KKSafeAreaBottomHeight);
    }
    videoView = [[UIImageView alloc] initWithFrame:frame];
    videoView.backgroundColor = [UIColor clearColor];
    videoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:videoView];
    videoView.userInteractionEnabled = YES;
    videoView.image = self.placholderImage;

    NSURL *videoURL = [NSURL fileURLWithPath:self.dataModal.movFileFullPath];

    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];

    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = videoView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [videoView.layer addSublayer:playerLayer];
    if (@available(iOS 11.0, *)) {
        [playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            
        }];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [playerItem seekToTime:kCMTimeZero];
#pragma clang diagnostic pop
    }

    playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    playImg.center = CGPointMake(videoView.frame.size.width/2, videoView.frame.size.height/2);
    [playerLayer addSublayer:playImg.layer];
    UIImage *playImage = [NSBundle imageInBundle:@"KKCameraCapture.bundle" imageName:@"play"];
    [playImg setImage:playImage];

    UITapGestureRecognizer *playTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause)];
    [videoView addGestureRecognizer:playTap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

//重拍
- (void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:NO];
}

//完成
- (void)finishButtonClicked{
    if (self.dataModal.isImage) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraCaptureShowViewController_ClickedOK:)]) {
            [self.delegate KKCameraCaptureShowViewController_ClickedOK:self.dataModal.imageFilePath];
        }
    }
    else{
        NSURL *url = [NSURL fileURLWithPath:self.dataModal.movFileFullPath];
        [self expotVideoToMP4_WithFileURL:url];
    }
}

//播放暂停
- (void)playOrPause{
    if (playImg.isHidden) {
        playImg.hidden = NO;
        [player pause];
    }else{
        playImg.hidden = YES;
        [player play];
    }
}

- (void)playingEnd:(NSNotification *)notification{
    if (@available(iOS 11.0, *)) {
        [playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            
        }];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [playerItem seekToTime:kCMTimeZero];
#pragma clang diagnostic pop
    }
    playImg.hidden = NO;
}

#pragma mark ==================================================
#pragma mark == 导出MP4视频
#pragma mark ==================================================
- (void)expotVideoToMP4WithFileURL:(NSURL *)fileURL{
    //    NSLog(@"开始导出MP4");

    [KKWaitingView showInView:self.view withType:KKWaitingViewType_White blackBackground:NO text:@""];

    NSError *error = nil;

    CGSize renderSize = CGSizeMake(0, 0);

    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];

    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];

    CMTime totalDuration = kCMTimeZero;

    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    AVAsset *asset = [AVAsset assetWithURL:fileURL];
    [assetArray addObject:asset];

    NSArray* tmpAry =[asset tracksWithMediaType:AVMediaTypeVideo];
    if (tmpAry.count>0) {
        AVAssetTrack *assetTrack = [tmpAry objectAtIndex:0];
        [assetTrackArray addObject:assetTrack];
        renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
        renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
    } else {
        //        NSLog(@"无法读取到视频文件:%@",fileURL);
        [KKWaitingView hideForView:self.view animation:YES];
        return;
    }

    CGFloat renderW = MIN(renderSize.width, renderSize.height);

    CGFloat preLayerHWRate = self.view.bounds.size.height/self.view.bounds.size.width;

    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {

        AVAsset *asset = [assetArray objectAtIndex:i];
        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];

        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];

        NSArray*dataSourceArray= [asset tracksWithMediaType:AVMediaTypeAudio];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:([dataSourceArray count]>0)?[dataSourceArray objectAtIndex:0]:nil
                             atTime:totalDuration
                              error:nil];

        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];

        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];

        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];

        totalDuration = CMTimeAdd(totalDuration, asset.duration);

        CGFloat rate;
        rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);

        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);

        //        CGFloat wid01 = -(assetTrack.naturalSize.width - assetTrack.naturalSize.height)/2.0;
        //        CGFloat wid02 = preLayerHWRate*(self.view.bounds.size.height-self.view.bounds.size.width)/2;
        //        CGFloat width01 = wid01 + wid02;
        //        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, width01));
        //        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0+preLayerHWRate*(self.view.bounds.size.height-self.view.bounds.size.width)/2));
        layerTransform = CGAffineTransformScale(layerTransform, rate, rate);

        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];

        [layerInstructionArray addObject:layerInstruciton];
    }

    NSURL *mergeFileURL = [NSURL fileURLWithPath:self.dataModal.mp4FileFullPath];

    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 100);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW*preLayerHWRate);

    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"导出MP4成功:%@",exporter.outputURL);
            if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraCaptureShowViewController_ClickedOK:)]) {
                [self.delegate KKCameraCaptureShowViewController_ClickedOK:[exporter.outputURL path]];
            }
            [KKWaitingView hideForView:self.view animation:YES];
        });
    }];
}

- (void)expotVideoToMP4_WithFileURL:(NSURL *)fileURL{
    //fileURL为视频的输入地址
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:fileURL options:options];
    NSArray *array = [urlAsset tracksWithMediaType:AVMediaTypeVideo];
    // 这个是视频输入源错误
    if (!array.count)return;

    [KKWaitingView showInView:self.view withType:KKWaitingViewType_White blackBackground:NO text:@""];

    // 视频输出
    // AVAssetExportPresetMediumQuality高质量的 常用的如下
    /**
     1，固定分辨率预设属性
     （1）AVAssetExportPreset640x480：设置视频分辨率640x480
     （2）AVAssetExportPreset960x540：设置视频分辨率960x540
     （3）AVAssetExportPreset1280x720：设置视频分辨率1280x720
     （4）AVAssetExportPreset1920x1080：设置视频分辨率1920x1080
     （5）AVAssetExportPreset3840x2160：设置视频分辨率3840x2160

     2，相对质量预设属性
     （1）AVAssetExportPresetLowQuality：低质量
     （2）AVAssetExportPresetMediumQuality：中等质量
     （3）AVAssetExportPresetHighestQuality：高质量
     这种设置方式，最终生成的视频分辨率与具体的拍摄设备有关。比如 iPhone6 拍摄的视频：
     使用AVAssetExportPresetHighestQuality则视频分辨率是1920x1080（不压缩）。
     AVAssetExportPresetMediumQuality视频分辨率是568x320
     AVAssetExportPresetLowQuality视频分辨率是224x128
     **/
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:urlAsset presetName:AVAssetExportPresetMediumQuality];
    // 视频的输出地址
    NSURL *mergeFileURL = [NSURL fileURLWithPath:self.dataModal.mp4FileFullPath];
    exportSession.outputURL = mergeFileURL;
    // 视频的输出格式
    exportSession.outputFileType = AVFileTypeMPEG4;
    // 这个一般设置为yes（指示输出文件应针对网络使用进行优化，例如QuickTime电影文件应支持“快速启动”）
    exportSession.shouldOptimizeForNetworkUse = YES;
    // 文件的最大多大的设置
    exportSession.fileLengthLimit = 10 * 1024 * 1024;

    // 输出的时候需要判断视频的角度是不是0（视频角度0度是  是home建在右边，视频横着拍摄的视频；角度是90度是home键在下面竖着拍摄的；180度是home键在左边横着拍摄的；270度是home键在上面，竖着拍摄） 根据自己的需来调整视频的角度，一般为了方便处理是需要输入视频的时候把角度调为0度
    // 视频角度校正
    if ([self degressFromVideoFileWithAVAsset:urlAsset] != 0){
        // 修正角度
        exportSession.videoComposition = [self fixedCompositionWithAsset:urlAsset];
    }
    [exportSession exportAsynchronouslyWithCompletionHandler:^{

        // 完成后的操作在这个里面执行 这里面不是主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exportSession.status == AVAssetExportSessionStatusCancelled){
                NSLog(@"导出MP4失败:%@",exportSession.outputURL);
                [KKWaitingView hideForView:self.view animation:YES];
            } else if (exportSession.status == AVAssetExportSessionStatusFailed){
                NSLog(@"导出MP4失败:%@",exportSession.outputURL);
                [KKWaitingView hideForView:self.view animation:YES];
            } else if (exportSession.status == AVAssetExportSessionStatusCompleted){
                NSLog(@"导出MP4成功:%@",exportSession.outputURL);
                if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraCaptureShowViewController_ClickedOK:)]) {
                    [self.delegate KKCameraCaptureShowViewController_ClickedOK:[exportSession.outputURL path]];
                }
                [KKWaitingView hideForView:self.view animation:YES];
            }
        });

    }];
}

- (int)degressFromVideoFileWithAVAsset:(AVAsset *)videoAsset {

    NSArray *array = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    // 这个是视频输入源错误
    if (!array.count) return 0;

    // 输出的时候需要判断视频的角度是不是0（视频角度0度是  是home建在右边，视频横着拍摄的视频；角度是90度是home键在下面竖着拍摄的；180度是home键在左边横着拍摄的；270度是home键在上面，竖着拍摄） 根据自己的需来调整视频的角度，一般为了方便处理是需要输入视频的时候把角度调为0度
    AVAssetTrack *videoTrack = [array firstObject];

    int degress = 0;
    // 视频的transform
    CGAffineTransform t = videoTrack.preferredTransform;
    // 矩阵的abcd来判断视频的角度
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
        // Portrait
        degress = 90;
    } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
        // PortraitUpsideDown
        degress = 270;
    } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
        // LandscapeRight
        degress = 0;
    } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        // LandscapeLeft
        degress = 180;
    }
    return degress;
}

// 处理视频角度
- (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset {
    // AVMutableVideoComposition 指示是否启用视频合成导出，并提供视频合成说明。导出预设为AVAssetExportPresetPassthrough时忽略
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self degressFromVideoFileWithAVAsset:videoAsset];
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        videoComposition.frameDuration = CMTimeMake(1, 30);

        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        if (!tracks.count)return nil;
        AVAssetTrack *videoTrack = [tracks firstObject];
        // 视频合成器的具体操作类
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        // 具体操作视频的大小角度的一个类
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];

        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }

        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // 加入视频方向信息
        videoComposition.instructions = @[roateInstruction];
    }
    return videoComposition;
}

#pragma mark ==================================================
#pragma mark == 图片
#pragma mark ==================================================
- (void)initImageUI{
    CGRect frame = CGRectMake(0, 0, KKScreenWidth, KKScreenHeight);
    if ([[UIDevice currentDevice] isiPhoneX]) {
        frame = CGRectMake(0, KKStatusBarHeight, KKScreenWidth, KKScreenHeight-KKStatusBarHeight-KKSafeAreaBottomHeight);
    }
    self.myScrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.myScrollView.backgroundColor = [UIColor clearColor];
    self.myScrollView.bounces = YES;
    self.myScrollView.minimumZoomScale = 1.0;
    self.myScrollView.maximumZoomScale = 5.0;
    self.myScrollView.delegate = self;
    [self.view addSubview:self.myScrollView];
    if (@available(iOS 11.0, *)) {
        self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.myImageView = [[UIImageView alloc]initWithFrame:self.myScrollView.bounds];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.myImageView.backgroundColor = [UIColor clearColor];
    UIImage *originImage = [UIImage imageWithContentsOfFile:self.dataModal.imageFilePath];
    self.myImageView.image = originImage;
    [self.myScrollView addSubview:self.myImageView];
    [self initImageViewFrame];
}

#pragma mark ==================================================
#pragma mark == 缩放
#pragma mark ==================================================
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.myImageView;//返回ScrollView上添加的需要缩放的视图
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self reloadImageViewFrame];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    [self reloadImageViewFrame];
//    NSLog(@"%@: SCALE:%.1f",view,scale);
}

- (void)reloadImageViewFrame{
    float imageWidth = self.myImageViewOriginFrame.size.width * self.myScrollView.zoomScale;
    float imageHeight = self.myImageViewOriginFrame.size.height * self.myScrollView.zoomScale;
    float newScrollWidth = MAX(self.myScrollView.contentSize.width, self.myScrollView.width);
    float newScrollHeight = MAX(self.myScrollView.contentSize.height, self.myScrollView.height);
    self.myImageView.frame = CGRectMake((newScrollWidth-imageWidth)/2.0, (newScrollHeight-imageHeight)/2.0, imageWidth, imageHeight);
//    NSLog(@"AAA scale:%.1f frame:%@",self.myScrollView.zoomScale,NSStringFromCGRect(self.myImageView.frame));
}

- (void)initImageViewFrame{
    if (self.myImageView.image) {
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 5.0;
        
        float widthRatio = self.myScrollView.bounds.size.width / self.myImageView.image.size.width;
        float heightRatio = self.myScrollView.bounds.size.height / self.myImageView.image.size.height;
        float scale = MIN(widthRatio,heightRatio);
        float imageWidth = scale * self.myImageView.image.size.width * self.myScrollView.zoomScale;
        float imageHeight = scale * self.myImageView.image.size.height * self.myScrollView.zoomScale;
        self.myImageView.frame = CGRectMake((self.myScrollView.width-imageWidth)/2.0, (self.myScrollView.height-imageHeight)/2.0, imageWidth, imageHeight);
        self.myImageViewOriginFrame = self.myImageView.frame;
    } else {
        [self.myScrollView setZoomScale:1.0 animated:YES];;
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 1.0;
        
        if ([NSArray isArrayNotEmpty:self.myImageView.animationImages]) {
            float widthRatio = self.myScrollView.bounds.size.width;
            float heightRatio = self.myScrollView.bounds.size.height;
            float scale = MIN(widthRatio,heightRatio);
            float imageWidth = scale * self.myImageView.bounds.size.width * self.myScrollView.zoomScale;
            float imageHeight = scale * self.myImageView.bounds.size.height * self.myScrollView.zoomScale;
            self.myImageView.frame = CGRectMake((self.myScrollView.width-imageWidth)/2.0, (self.myScrollView.height-imageHeight)/2.0, imageWidth, imageHeight);
            self.myImageViewOriginFrame = self.myImageView.frame;
        }
    }
}



#pragma mark ==================================================
#pragma mark == 主体颜色
#pragma mark ==================================================
/* 子类可重写该方法，不重写的话默认是白色 */
- (UIColor*)kk_DefaultNavigationBarBackgroundColor{
    return [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self bottomButtonsAnimated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


@end
