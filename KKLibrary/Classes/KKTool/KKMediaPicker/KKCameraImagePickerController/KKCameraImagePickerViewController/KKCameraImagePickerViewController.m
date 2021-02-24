//
//  KKCameraImagePickerViewController.m
//  HeiPa
//
//  Created by liubo on 2019/3/11.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import "KKCameraImagePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "KKCameraImageTopBar.h"
#import "KKCameraImageToolBar.h"
#import "KKImageCropperViewController.h"
#import "KKCameraImageShowViewController.h"
#import "KKCategory.h"
#import "KKAuthorizedCamera.h"
#import "KKAlertView.h"
#import "KKCameraHelper.h"
#import "KKCameraWaitingView.h"

@interface KKCameraImagePickerViewController ()
<KKCameraImageTopBarDelegate,
KKCameraImageToolBarDelegate,
UIGestureRecognizerDelegate,
KKCameraImageShowViewControllerDelegate,
AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong)KKCameraHelper *cameraHelper;


// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong)AVCaptureSession *captureSession;

// AVCaptureDeviceInput 对象是输入流
@property (nonatomic, strong)AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, assign)AVCaptureFlashMode flashMode;
// AVCapturePhotoOutput 照片输出流对象
@property (nonatomic, strong)AVCapturePhotoOutput *capturePhotoOutput;

// 放置预览图层的View
@property (nonatomic, strong)UIView *cameraShowView;
// 预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;
// 放置图像处理时候的等待View
@property (nonatomic, strong)KKCameraWaitingView *waitingView;
// 放置图像拍摄成功的预览View
@property (nonatomic, strong)UIImageView *previewImageView;

// 顶部操作Bar
@property (nonatomic, strong)KKCameraImageTopBar *topBar;
// 底部操作Bar
@property (nonatomic, strong)KKCameraImageToolBar *toolBar;

// 保存拍摄的照片
@property(nonatomic,strong)NSMutableArray *imageInformationArray;

// 聚焦的View
@property (nonatomic, strong)UIView *focusView;

@property(nonatomic,assign)CGFloat beginGestureScale;

@property(nonatomic,assign)CGFloat effectiveScale;


@end

@implementation KKCameraImagePickerViewController

- (void)dealloc{
    [self.cameraHelper stopMotionManager];
}

- (instancetype)initWithDelegate:(id<KKCameraImagePickerDelegate>)aDelegate
      numberOfPhotosNeedSelected:(NSInteger)aNumberOfPhotosNeedSelected
                      editEnable:(BOOL)aEditEnable
                        cropSize:(CGSize)aCropSize
                imageFileMaxSize:(NSInteger)aImageFileMaxSize
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
        self.numberOfPhotosNeedSelected = aNumberOfPhotosNeedSelected;
        self.editEnable = aEditEnable;
        self.cropSize = aCropSize;
        self.imageFileMaxSize = aImageFileMaxSize;
        
        self.imageInformationArray = [[NSMutableArray alloc] init];
        
        self.effectiveScale = 1.0f;
        self.beginGestureScale = 1.0f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    BOOL authorized = [KKAuthorizedCamera.defaultManager isCameraAuthorized_ShowAlert:YES andAPPName:nil];
    if (authorized) {
        self.cameraHelper = [[KKCameraHelper alloc] init];
        [self.cameraHelper startMotionManager];

        [self initialSession];
        
        [self initPreviewImageView];
        
        [self initCameraShowView];
        
        /*顶部*/
        self.topBar = [[KKCameraImageTopBar alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKStatusBarAndNavBarHeight)];
        self.topBar.delegate = self;
        [self.view addSubview:self.topBar];
        
        /*底部工具栏*/
        self.toolBar = [[KKCameraImageToolBar alloc] initWithFrame:CGRectMake(0, KKScreenHeight-KKSafeAreaBottomHeight-60, KKScreenWidth, 60)];
        self.toolBar.delegate = self;
        [self.view addSubview:self.toolBar];
        [[UIScreen mainScreen] createiPhoneXFooterForView:self.toolBar withBackGroudColor:[[UIColor blackColor] colorWithAlphaComponent:0.25]];
        [self.toolBar setNumberOfPic:0 maxNumberOfPic:self.numberOfPhotosNeedSelected];
        
        [self initWaitingView];
    }
    else{
        /*顶部*/
        self.topBar = [[KKCameraImageTopBar alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKStatusBarAndNavBarHeight)];
        self.topBar.delegate = self;
        [self.view addSubview:self.topBar];

        self.topBar.doneButton.hidden = YES;
        self.topBar.cameraDeviceButton.hidden = YES;
        self.topBar.cameraFlashModeButton.hidden = YES;

//        [self navigationControllerDismiss];
    }
    
    if (self.numberOfPhotosNeedSelected==1) {
        self.toolBar.infoLabel.hidden = YES;
        self.toolBar.infoBoxView.hidden = YES;
        self.toolBar.myImageButton.hidden = YES;
        self.topBar.doneButton.hidden = YES;
    }
    
}

- (void)initialSession{
    self.captureSession = [[AVCaptureSession alloc] init];
    self.flashMode = AVCaptureFlashModeOff;
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:[KKCameraHelper cameraVideoWithPosition:AVCaptureDevicePositionBack] error:nil];

    /* ========== 输入流 ==========*/
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }

    /* ========== 输出图片 ==========*/
    self.capturePhotoOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.captureSession canAddOutput:self.capturePhotoOutput]) {
        [self.captureSession addOutput:self.capturePhotoOutput];
    }
    [KKCameraHelper reloadAVCapturePhotoSettings:self.capturePhotoOutput flashMode:self.flashMode];
}

- (void)initPreviewImageView{
    self.previewImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.previewImageView.backgroundColor = [UIColor clearColor];
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.previewImageView];
    self.previewImageView.clipsToBounds = YES;
    self.previewImageView.userInteractionEnabled = NO;
}

- (void)initCameraShowView{
    self.cameraShowView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.cameraShowView];
    
    self.focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.focusView.layer.borderColor = [UIColor colorWithR:252 G:208 B:52 alpha:1.0].CGColor;
    self.focusView.layer.borderWidth = 2.0f;
    self.focusView.hidden = YES;
    self.focusView.alpha = 0.0;
    [self.view addSubview:self.focusView];
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.cameraShowView addGestureRecognizer:pinch];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusAction:)];
    [self.cameraShowView addGestureRecognizer:tap];
}

- (void)initWaitingView{
    self.waitingView = [[KKCameraWaitingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.waitingView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
}

- (void)setUpCameraLayer{
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        
        UIView * view = self.cameraShowView;
        CALayer * viewLayer = [view layer];
        // UIView的clipsToBounds属性和CALayer的setMasksToBounds属性表达的意思是一致的,决定子视图的显示范围。当取值为YES的时候，剪裁超出父视图范围的子视图部分，当取值为NO时，不剪裁子视图。
        [viewLayer setMasksToBounds:YES];
        CGRect bounds = [view bounds];
        [self.previewLayer setFrame:bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        [viewLayer addSublayer:self.previewLayer];
    }
}

- (void)reloadToolBar{    
    if (self.numberOfPhotosNeedSelected==1) {
        self.topBar.doneButton.hidden = YES;
        self.toolBar.myImageButton.hidden = YES;
        self.toolBar.infoBoxView.hidden = YES;
        self.toolBar.infoLabel.hidden = YES;
    }
    else{
        self.topBar.doneButton.hidden = NO;
        self.toolBar.myImageButton.hidden = NO;
        self.toolBar.infoBoxView.hidden = NO;
        self.toolBar.infoLabel.hidden = NO;
    }
    
    if ([self.imageInformationArray count]==0) {
        [self.toolBar.myImageButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    else{
        if (self.numberOfPhotosNeedSelected==1) {
            [self.imageInformationArray removeAllObjects];
        }
        else{
            UIImage *image = [self.imageInformationArray lastObject];
            [self.toolBar.myImageButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    [self.toolBar setNumberOfPic:[self.imageInformationArray count] maxNumberOfPic:self.numberOfPhotosNeedSelected];
}

#pragma mark ==================================================
#pragma mark == KKCameraImageToolBarDelegate
#pragma mark ==================================================
/*图片*/
- (void)KKCameraImageToolBar_ImageButtonClicked:(KKCameraImageToolBar*)toolView{
    if ([self.imageInformationArray count]==0) {
        return;
    }

    KKCameraImageShowViewController *photo = [[KKCameraImageShowViewController alloc] initWithDelegate:self pickerDelegate:self.delegate imagesArray:self.imageInformationArray maxNumber:self.numberOfPhotosNeedSelected];

    [self.navigationController pushViewController:photo animated:YES];

}

/*照相*/
- (void)KKCameraImageToolBar_TakePicButtonClicked:(KKCameraImageToolBar*)toolView{
    
    if ([self.imageInformationArray count]>=self.numberOfPhotosNeedSelected) {

        NSString *message = KKLibLocalizable_Album_MaxLimited;
        
        KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:KKLibLocalizable_Common_Notice subTitle:nil message:message delegate:nil buttonTitles:KKLibLocalizable_Common_OK,nil];
        [alertView show];
        return;
    }
        
    [self shutterCamera];
}

#pragma mark ==================================================
#pragma mark == 拍照
#pragma mark ==================================================
// 这是拍照按钮的方法
- (void)shutterCamera{
    AVCaptureConnection *videoConnection = [self.capturePhotoOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        return;
    }
    
    if (videoConnection.active) {
        videoConnection.videoOrientation = [self.cameraHelper captureVideoOrientation];
        AVCapturePhotoSettings *outputSettings = [KKCameraHelper getAVCapturePhotoSettings:self.flashMode];
        [self.capturePhotoOutput capturePhotoWithSettings:outputSettings delegate:self];
    }
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error API_AVAILABLE(ios(11.0)){
    
    // 这个就是HEIF(HEIC)的文件数据,直接保存即可
    NSData *data = photo.fileDataRepresentation;
    UIImage *image = [UIImage imageWithData:data].fixOrientation;
    
    [self shutterCameraFinished:image];
}

- (void)shutterCameraFinished:(UIImage*)aImage{
    
    if (self.numberOfPhotosNeedSelected==1) {
        if (self.editEnable) {
            KKImageCropperViewController *cropImageViewController = [[KKImageCropperViewController alloc] initWithImage:aImage cropSize:self.cropSize];
            [self.navigationController pushViewController:cropImageViewController animated:YES];
            KKWeakSelf(self)
            [cropImageViewController cropImage:^(KKAlbumAssetModal *aModal, UIImage *newImage) {
                
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(KKCameraImagePicker_didFinishedPickImages:)]) {
                    [weakself.delegate KKCameraImagePicker_didFinishedPickImages:[NSArray arrayWithObject:newImage]];
                }
                [weakself.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
        }
        else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImagePicker_didFinishedPickImages:)]) {
                [self.delegate KKCameraImagePicker_didFinishedPickImages:[NSArray arrayWithObject:aImage]];
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
    else{
        KKWeakSelf(self);
        self.cameraShowView.hidden = YES;
        self.waitingView.hidden = NO;
        self.previewImageView.image = aImage;
        [NSData convertImage:[NSArray arrayWithObject:aImage] toDataSize:self.imageFileMaxSize oneCompleted:^(NSData * _Nullable imageData, NSInteger index) {
            weakself.waitingView.hidden = YES;
            self.cameraShowView.hidden = NO;
            self.previewImageView.image = nil;
            UIImage *newImage = [UIImage imageWithData:imageData];
            [weakself.imageInformationArray addObject:newImage];
            [weakself reloadToolBar];
        } allCompletedBlock:^{
            
        }];
    }
}

#pragma mark ==================================================
#pragma mark == KKCameraImageTopBarViewDelegate
#pragma mark ==================================================
/*取消*/
- (void)KKCameraImageTopBar_CancelButtonClicked:(KKCameraImageTopBar*)topView{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

/*闪光灯*/
- (void)KKCameraImageTopBar:(KKCameraImageTopBar*)topView cameraFlashModeButtonClicked:(AVCaptureFlashMode)aCameraFlashMode{
    [self toggleFlashMode:aCameraFlashMode];
}

/*摄像头*/
- (void)KKCameraImageTopBar:(KKCameraImageTopBar*)topView  cameraDeviceButtonClicked:(AVCaptureDevicePosition)aCameraDevicePositon{
    
    [self toggleCamera:aCameraDevicePositon];
}

/*完成*/
- (void)KKCameraImageTopBar_DoneButtonClicked:(KKCameraImageTopBar*)topView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraImagePicker_didFinishedPickImages:)]) {
        [self.delegate KKCameraImagePicker_didFinishedPickImages:self.imageInformationArray];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark ==================================================
#pragma mark == 前后摄像头
#pragma mark ==================================================
// 这是切换镜头的按钮方法
- (void)toggleCamera:(AVCaptureDevicePosition)aCameraDevicePositon{
    
    AVCaptureDeviceDiscoverySession *captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                          mediaType:AVMediaTypeVideo
                                           position: AVCaptureDevicePositionUnspecified];
    NSArray *captureDevices = [captureDeviceDiscoverySession devices];
    NSUInteger cameraCount = [captureDevices count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[KKCameraHelper cameraVideoWithPosition:aCameraDevicePositon] error:&error];
        
        if (newVideoInput != nil) {
            [self.captureSession beginConfiguration];
            [self.captureSession removeInput:self.captureDeviceInput];
            
            if ([self.captureSession canAddInput:newVideoInput]) {
                [self.captureSession addInput:newVideoInput];
                self.captureDeviceInput = newVideoInput;
            }
            else {
                [self.captureSession addInput:self.captureDeviceInput];
            }
            
            [self.captureSession commitConfiguration];
            
        }
        else if (error) {
            KKLogErrorFormat(@"toggle carema failed, error = %@", KKValidString(error));
        }
    }
    
}


#pragma mark ==================================================
#pragma mark == 闪光灯
#pragma mark ==================================================
// 这是切换镜头的按钮方法
- (void)toggleFlashMode:(AVCaptureFlashMode)aCaptureFlashMode{

    AVCaptureDevice *device = self.captureDeviceInput.device;
    //修改前必须先锁定
    [self.captureDeviceInput.device lockForConfiguration:nil];
    
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([self.captureDeviceInput.device hasFlash]) {
        if (aCaptureFlashMode == AVCaptureFlashModeOff) {
            self.flashMode = AVCaptureFlashModeOff;
            self.captureDeviceInput.device.torchMode = AVCaptureFlashModeOff;
        }
        else if (aCaptureFlashMode == AVCaptureFlashModeOn) {
            self.flashMode = AVCaptureFlashModeOn;
            self.captureDeviceInput.device.torchMode = AVCaptureTorchModeOn;
        }
        else{
            self.flashMode = AVCaptureFlashModeAuto;
            self.captureDeviceInput.device.torchMode = AVCaptureTorchModeAuto;
        }
    }
    [device unlockForConfiguration];
}

#pragma mark ==================================================
#pragma mark == 聚焦
#pragma mark ==================================================
- (void)focusAction:(UITapGestureRecognizer *)sender{
    CGPoint location = [sender locationInView:self.cameraShowView];
    CGPoint pointInsect = CGPointMake(location.x / self.view.width, location.y / self.view.height);
    
    [self.focusView setCenter:location];
    self.focusView.hidden = NO;
    [UIView animateWithDuration:0.45 animations:^{
        self.focusView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.45 animations:^{
            self.focusView.alpha = 0.0;
        }completion:^(BOOL finished) {
            self.focusView.hidden = YES;
        }];
    }];
    
    if ([self.captureDeviceInput.device isFocusPointOfInterestSupported] && [self.captureDeviceInput.device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError *error;
        if ([self.captureDeviceInput.device lockForConfiguration:&error])
        {
            if ([self.captureDeviceInput.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            {
                [self.captureDeviceInput.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [self.captureDeviceInput.device setFocusPointOfInterest:pointInsect];
            }
            
            if([self.captureDeviceInput.device isExposurePointOfInterestSupported] && [self.captureDeviceInput.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [self.captureDeviceInput.device setExposurePointOfInterest:pointInsect];
                [self.captureDeviceInput.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                
            }
            
            [self.captureDeviceInput.device unlockForConfiguration];
        }
    }
    
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    
    if (recognizer.state ==UIGestureRecognizerStateBegan) {
        
    }
    
    if (recognizer.state ==UIGestureRecognizerStateChanged) {
        
        BOOL allTouchesAreOnThePreviewLayer = YES;
        NSUInteger numTouches = [recognizer numberOfTouches], i;
        for ( i = 0; i < numTouches; ++i ) {
            CGPoint location = [recognizer locationOfTouch:i inView:self.cameraShowView];
            CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
            if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
                allTouchesAreOnThePreviewLayer = NO;
                break;
            }
        }
        
        if ( allTouchesAreOnThePreviewLayer ) {
            
            
            self.effectiveScale = self.beginGestureScale * recognizer.scale;
            if (self.effectiveScale < 1.0){
                self.effectiveScale = 1.0;
            }
            
            CGFloat maxScaleAndCropFactor = [[self.capturePhotoOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
            
            if (self.effectiveScale > maxScaleAndCropFactor)
                self.effectiveScale = maxScaleAndCropFactor;
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:.025];
            [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
            [CATransaction commit];

            //设置视频方向
            UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
            AVCaptureVideoOrientation avcaptureOrientation = (AVCaptureVideoOrientation)curDeviceOrientation;
            if (curDeviceOrientation == UIDeviceOrientationLandscapeLeft){
                avcaptureOrientation = AVCaptureVideoOrientationLandscapeRight;
            }else if(curDeviceOrientation == UIDeviceOrientationLandscapeRight){
                avcaptureOrientation = AVCaptureVideoOrientationLandscapeLeft;
            }

            /*========== 图片 ==========*/
            //获取指定连接
            AVCaptureConnection *stillImageConnection = [self.capturePhotoOutput connectionWithMediaType:AVMediaTypeVideo];
            [stillImageConnection setVideoOrientation:avcaptureOrientation];
            [stillImageConnection setVideoScaleAndCropFactor:self.effectiveScale];
        }

    }
    
    // 当手指离开屏幕时
    if ((recognizer.state ==UIGestureRecognizerStateEnded) ||
        (recognizer.state ==UIGestureRecognizerStateCancelled)) {
        self.beginGestureScale = self.effectiveScale;
    }
    
}


#pragma mark ==================================================
#pragma mark == 编辑 KKCameraImageShowViewControllerDelegate
#pragma mark ==================================================
- (void)KKCameraImageShowViewController_DeleteItemAtIndex:(NSInteger)aIndex{
    [self.imageInformationArray removeObjectAtIndex:aIndex];
    [self reloadToolBar];
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
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //导航栏底部线清除
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self setUpCameraLayer];

    [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
}

@end
