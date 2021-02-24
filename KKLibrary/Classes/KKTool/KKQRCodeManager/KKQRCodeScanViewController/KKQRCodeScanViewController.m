//
//  KKQRCodeScanViewController.m
//  BM
//
//  Created by sjyt on 2020/1/10.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKQRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KKQRCodeScanNavigarionBar.h"
#import "KKCategory.h"
#import "KKQRCodeManager.h"
#import "KKToastView.h"
#import "KKLocalizationManager.h"
#import "KKAuthorizedCamera.h"
#import "KKLibraryDefine.h"
#import "KKQRCodeBackgroundAlphaView.h"
#import "KKAlbumImagePickerController.h"

@interface KKQRCodeScanViewController ()
<AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
KKAlbumImagePickerDelegate,
UIGestureRecognizerDelegate>

/**
 *  KKQRCodeScanVCStatus
 */
typedef NS_ENUM(NSInteger,KKQRCodeScanVCStatus) {
    
    KKQRCodeScanVCStatusNormal = 0,/* 正常 */
    
    KKQRCodeScanVCStatusWillPopBack = 1,/* 返回 */
    
    KKQRCodeScanVCStatusWillPush = 2,/* PUSH到下个界面*/

    KKQRCodeScanVCStatusWillShowAlbum = 3,/* 选相册 */
    
};

@property (nonatomic, strong) AVCaptureSession * session;//输入输出的中间桥梁
/* 输入流 */
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;// AVCaptureDeviceInput 对象是输入流
/* 展示层 */
@property (nonatomic, strong) UIView *cameraShowView;// 放置预览图层的View
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;// 预览图层，来显示照相机拍摄到的画面
/* 输出流 */
@property (nonatomic, strong)AVCaptureMetadataOutput *output;// AVCaptureMetadataOutput 输出流对象
@property (nonatomic, strong)AVCapturePhotoOutput *stillImageOutput;//拍照

/* 自定义界面层 */
@property (nonatomic , strong) KKQRCodeScanNavigarionBar *navBar;//导航栏
@property (nonatomic , strong) KKQRCodeBackgroundAlphaView *blackAlphaView;//黑色蒙层
@property (nonatomic , strong) UIImageView *scanBoxView;//扫描框
@property (nonatomic , strong) UIView *focusView;//聚焦
@property (nonatomic , strong) UIImageView *scanLineView;//扫描线
@property (nonatomic , strong) UILabel *msgLabel;//提示文字
@property (nonatomic , strong) KKButton *albumButton;//相册按钮
@property (nonatomic , strong) KKButton *flashButton;//手电筒按钮
@property (nonatomic , strong) UIActivityIndicatorView *waitingView;//扫描出结果之后的等待圈圈

@property(nonatomic,assign)CGFloat beginGestureScale;
@property(nonatomic,assign)CGFloat effectiveScale;
@property(nonatomic,assign)UIStatusBarStyle codeInStatusBarStyle;
@property(nonatomic,assign)BOOL codeInStatusBarHidden;
@property(nonatomic,assign)BOOL codeInNavigationBarHidden;
@property(nonatomic,assign)KKQRCodeScanVCStatus codeInStatus;//0 正常 1、popback 2、选择相册

@end

@implementation KKQRCodeScanViewController

- (void)dealloc{
    [self removeKVOObserver];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.effectiveScale = 1.0f;
    self.beginGestureScale = 1.0f;
    self.codeInStatusBarStyle = UIApplication.sharedApplication.statusBarStyle;
    self.codeInStatusBarHidden = UIApplication.sharedApplication.isStatusBarHidden;
    self.codeInNavigationBarHidden = self.navigationController.navigationBarHidden;
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatusBarHidden:NO statusBarStyle:UIStatusBarStyleLightContent withAnimation:UIStatusBarAnimationFade];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setUpCameraLayer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.codeInStatus==KKQRCodeScanVCStatusWillPopBack ) {
        [self.navigationController setNavigationBarHidden:self.codeInNavigationBarHidden animated:YES];
        [self setStatusBarHidden:self.codeInStatusBarHidden statusBarStyle:self.codeInStatusBarStyle withAnimation:UIStatusBarAnimationFade];
    } else if (self.codeInStatus==KKQRCodeScanVCStatusWillShowAlbum) {
        
    } else if (self.codeInStatus==KKQRCodeScanVCStatusWillPush) {
        [self.navigationController setNavigationBarHidden:self.codeInNavigationBarHidden animated:YES];
        [self setStatusBarHidden:self.codeInStatusBarHidden statusBarStyle:self.codeInStatusBarStyle withAnimation:UIStatusBarAnimationFade];
    } else {
        
    }
}

- (void)setUpCameraLayer{
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        //UIView的clipsToBounds属性和CALayer的setMasksToBounds属性表达的意思是一致的
        //决定子视图的显示范围。当取值为YES的时候，剪裁超出父视图范围的子视图部分，当取值为NO时，不剪裁子视图。
        [self.cameraShowView.layer setMasksToBounds:YES];
        [self.previewLayer setFrame:self.cameraShowView.bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        [self.cameraShowView.layer addSublayer:self.previewLayer];
    }
}

- (void)startScan{
    if (self.session.isRunning) {
        return;
    }
    KKWeakSelf(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself.session startRunning];
        [weakself hideWaitingView];
    });
}

- (void)willPush{
    self.codeInStatus = KKQRCodeScanVCStatusWillPush;
    [self.navigationController setNavigationBarHidden:self.codeInNavigationBarHidden animated:YES];
    [self setStatusBarHidden:self.codeInStatusBarHidden statusBarStyle:self.codeInStatusBarStyle withAnimation:UIStatusBarAnimationFade];
}


#pragma mark - ==================================================
#pragma mark == UI
#pragma mark ====================================================
- (void)initUI{
    [self initialSession];
    
    //相机摄像头拍摄到的画面预览层
    [self initCameraShowView];
    
    //自定义j上层界面
    [self initOverlayPickerView];
    
    //导航栏
    self.navBar = [[KKQRCodeScanNavigarionBar alloc] initWithFrame:CGRectMake(0, 0, KKApplicationWidth, KKStatusBarAndNavBarHeight)];
    self.navBar.titleLabel.text = KKLibLocalizable_QRCode_Title;
    [self.view addSubview:self.navBar];
    [self.navBar.leftButton addTarget:self action:@selector(navLeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.rightButton addTarget:self action:@selector(navRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navBar.rightButton.hidden = YES;
        
    [self addKVOObserver];
    
    //开始捕获
    [self startScan];
}

#pragma mark - ==================================================
#pragma mark == 配置相机属性
#pragma mark ====================================================
- (void)initialSession{
    
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];

    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    //创建输出流
    self.output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }

    self.stillImageOutput = [[AVCapturePhotoOutput alloc] init];
    [self reloadAVCapturePhotoSettings];
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    NSMutableArray *a = [[NSMutableArray alloc] init];
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
        [a addObject:AVMetadataObjectTypeQRCode];
    }
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
        [a addObject:AVMetadataObjectTypeEAN13Code];
    }
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
        [a addObject:AVMetadataObjectTypeEAN8Code];
    }
    if ([self.output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
        [a addObject:AVMetadataObjectTypeCode128Code];
    }
    self.output.metadataObjectTypes=a;

}

/* 展示层 */
- (void)initCameraShowView{
    self.cameraShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight)];
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

/* 自定义界面层 */
- (void)initOverlayPickerView{
     
    CGFloat QRCodeImageSize = (KKScreenWidth-100);
    CGRect scanBoxViewFrame = CGRectMake((KKApplicationWidth-QRCodeImageSize)/2.0,KKStatusBarAndNavBarHeight+50, QRCodeImageSize, QRCodeImageSize);
    
    /* 黑色蒙层 */
    self.blackAlphaView = [[KKQRCodeBackgroundAlphaView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight) boxFrame:scanBoxViewFrame];
    self.blackAlphaView.userInteractionEnabled = NO;
    self.blackAlphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:self.blackAlphaView];
    self.blackAlphaView.userInteractionEnabled = NO;
    
    /* 扫描框 */
    self.scanBoxView = [[UIImageView alloc] initWithFrame:scanBoxViewFrame];
    self.scanBoxView.image = [KKQRCodeManager themeImageForName:@"scan_frame"];
    self.scanBoxView.contentMode = UIViewContentModeScaleAspectFit;
    self.scanBoxView.backgroundColor = [UIColor clearColor];
    [self.scanBoxView setBorderColor:[UIColor whiteColor] width:1.0];
    [self.view addSubview:self.scanBoxView];
    self.scanBoxView.userInteractionEnabled = NO;

    /* 扫描线 */
    self.scanLineView = [[UIImageView alloc] initWithFrame:CGRectMake((KKApplicationWidth-QRCodeImageSize)/2.0,self.scanBoxView.top, QRCodeImageSize, 30)];
    self.scanLineView.image = [KKQRCodeManager themeImageForName:@"scanner"];
    self.scanLineView.contentMode = UIViewContentModeScaleAspectFill;
    self.scanLineView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scanLineView];
    self.scanLineView.userInteractionEnabled = NO;

    /* 等待转圈圈 */
    self.waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.waitingView.center = self.scanBoxView.center;
    [self.view addSubview:self.waitingView];
    self.waitingView.userInteractionEnabled = NO;

    /* 文字提示 */
    UIFont *msgFont = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.msgLabel = [UILabel kk_initWithTextColor:[UIColor whiteColor] font:msgFont text:KKLibLocalizable_QRCode_Notice];
    self.msgLabel.frame = CGRectMake((KKApplicationWidth-self.msgLabel.width-20)/2.0, self.scanBoxView.bottom+10, self.msgLabel.width+20, self.msgLabel.height+10);
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    self.msgLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:self.msgLabel];
    [self.msgLabel setCornerRadius:self.msgLabel.height/2.0];
    self.msgLabel.userInteractionEnabled = NO;

    /* 手电筒 */
    self.flashButton = [[KKButton alloc] initWithFrame:CGRectMake(self.scanBoxView.left,self.msgLabel.bottom+15,50,
               50) type:KKButtonType_ImgTopTitleBottom_Center];
    self.flashButton.imageViewSize = CGSizeMake(30, 30);
    self.flashButton.spaceBetweenImgTitle = 0;
    [self.flashButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateNormal];
    [self.flashButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateHighlighted];
    [self.flashButton setImage:[KKQRCodeManager themeImageForName:@"icon_light_off"] forState:UIControlStateNormal];
    [self.flashButton setImage:[KKQRCodeManager themeImageForName:@"icon_light_on"] forState:UIControlStateSelected];
    [self.flashButton addTarget:self action:@selector(flashButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    [self.flashButton setCornerRadius:self.flashButton.height/2.0];

    /* 手机相册 */
    self.albumButton = [[KKButton alloc] initWithFrame:CGRectMake(self.scanBoxView.right-50,self.msgLabel.bottom+15,50,
               50) type:KKButtonType_ImgTopTitleBottom_Center];
    self.albumButton.imageViewSize = CGSizeMake(30, 30);
    self.albumButton.spaceBetweenImgTitle = 0;
    [self.albumButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateNormal];
    [self.albumButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6] forState:UIControlStateHighlighted];
    [self.albumButton setImage:[KKQRCodeManager themeImageForName:@"btn_NavAlbum"] forState:UIControlStateNormal];
    [self.albumButton setImage:[KKQRCodeManager themeImageForName:@"btn_NavAlbum"] forState:UIControlStateSelected];
    [self.albumButton addTarget:self action:@selector(albumButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.albumButton];
    [self.albumButton setCornerRadius:self.albumButton.height/2.0];
}

#pragma mark - ==================================================
#pragma mark == 按钮事件
#pragma mark ====================================================
- (void)navLeftButtonClicked{
    self.codeInStatus = KKQRCodeScanVCStatusWillPopBack;
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKQRCodeScanViewController_NavletfButtonClicked)]) {
        [self.delegate KKQRCodeScanViewController_NavletfButtonClicked];
    }
}

- (void)navRightButtonClicked{
    
}

// 打开手电筒开关按钮点击事件
- (void)flashButtonClicked:(KKButton *)sender{
    
    sender.selected = !sender.isSelected;
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (sender.isSelected) {
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }
            else {
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }
}

- (void)albumButtonClicked:(KKButton *)sender{
    if ([KKAuthorizedCamera.defaultManager isCameraAuthorized_ShowAlert:YES andAPPName:nil]) {
        KKAlbumImagePickerController *vc = [[KKAlbumImagePickerController alloc] initWithDelegate:self numberOfPhotosNeedSelected:1 cropEnable:NO cropSize:CGSizeMake(KKApplicationWidth*2, KKScreenHeight*2) assetMediaType:KKAssetMediaType_ImageNormal];
        if ([UIDevice isSystemVersionBigerThan:@"13.0"]) {
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        if (self.navigationController) {
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        } else {
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (void)KKAlbumImagePicker_didFinishedPickImages:(NSArray<KKAlbumAssetModal*>*)aImageArray{
    KKAlbumAssetModal *modal = aImageArray.firstObject;
        
    [self showWaitingView];
    
    __block NSString *content = @"" ;
    // 为了防止界面卡住，可以异步执行
    KKWeakSelf(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imageData  = [NSData dataWithContentsOfURL:modal.fileURL];
        CIImage *ciImage = [CIImage imageWithData:imageData];
        if (imageData && ciImage) {
            //创建探测器
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
            NSArray *feature = nil;
            NSDictionary *options = @{ CIDetectorTypeQRCode: @YES };
            
            feature = [detector featuresInImage:ciImage options:options];
            
            //取出探测到的数据
            for (CIQRCodeFeature *result in feature) {
                content = result.messageString;
            }
        }
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakself hideWaitingView];
            
            if ([NSString isStringEmpty:content]) {
                [KKToastView showInView:[UIWindow currentKeyWindow] text:KKLibLocalizable_QRCode_Failed image:nil alignment:KKToastViewAlignment_Center hideAfterDelay:2.0];
            } else {
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(KKQRCodeScanViewController_FinishedWithQRCodeValue:)]) {
                    [weakself.delegate KKQRCodeScanViewController_FinishedWithQRCodeValue:content];
                }
            }
        });
        
    });
}

/* 获取扫码结果 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        //扫描字符串
        NSString *data = metadataObject.stringValue;
        if([NSString isStringNotEmpty:data]){
            [self showWaitingView];
            [self.session stopRunning];

            if (self.delegate && [self.delegate respondsToSelector:@selector(KKQRCodeScanViewController_FinishedWithQRCodeValue:)]) {
                [self.delegate KKQRCodeScanViewController_FinishedWithQRCodeValue:data];
            }
        }
        else{
            [KKToastView showInView:[UIWindow currentKeyWindow] text:KKLibLocalizable_QRCode_Failed image:nil alignment:KKToastViewAlignment_Center hideAfterDelay:2.0];
        }
    }
    //扫码数据为空
    else{
        [KKToastView showInView:[UIWindow currentKeyWindow] text:KKLibLocalizable_QRCode_Failed image:nil alignment:KKToastViewAlignment_Center hideAfterDelay:2.0];
    }
}

#pragma mark ==================================================
#pragma mark == 转圈圈（菊花）
#pragma mark ==================================================
- (void)showWaitingView{
    [self.waitingView startAnimating];
    self.flashButton.userInteractionEnabled = NO;
    self.albumButton.userInteractionEnabled = NO;
    self.navBar.rightButton.userInteractionEnabled = NO;
}

- (void)hideWaitingView{
    [self.waitingView stopAnimating];
    self.flashButton.userInteractionEnabled = YES;
    self.albumButton.userInteractionEnabled = YES;
    self.navBar.rightButton.userInteractionEnabled = YES;
}

#pragma mark ==================================================
#pragma mark == KVO 监听事件
#pragma mark ==================================================
//监听
- (void)addKVOObserver{
    [self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
}

//移除监听
- (void)removeKVOObserver{
    [self.session removeObserver:self forKeyPath:@"running" context:nil];
}

/**
 监听扫码状态-修改扫描动画
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

#pragma mark ==================================================
#pragma mark == 扫描动画
#pragma mark ==================================================
- (void)addAnimation{
    self.scanLineView.hidden = NO;
    CABasicAnimation *animation = [self moveYTime:1.0 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:(self.scanBoxView.height-30-2)] rep:OPEN_MAX];
    [self.scanLineView.layer addAnimation:animation forKey:@"LineAnimation"];
}

- (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    //animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}

- (void)removeAnimation{
    [self.scanLineView.layer removeAnimationForKey:@"LineAnimation"];
    self.scanLineView.hidden = YES;
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
    
    if ([self.videoInput.device isFocusPointOfInterestSupported] && [self.videoInput.device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError *error;
        if ([self.videoInput.device lockForConfiguration:&error])
        {
            if ([self.videoInput.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
            {
                [self.videoInput.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [self.videoInput.device setFocusPointOfInterest:pointInsect];
            }
            
            if([self.videoInput.device isExposurePointOfInterestSupported] && [self.videoInput.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
            {
                [self.videoInput.device setExposurePointOfInterest:pointInsect];
                [self.videoInput.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                
            }
            
            [self.videoInput.device unlockForConfiguration];
        }
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
   if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
       self.beginGestureScale = self.effectiveScale;
   }
   return YES;
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
            
            
            
            [self.videoInput.device lockForConfiguration:nil];

            AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[self.stillImageOutput connections]];
            CGFloat maxScaleAndCropFactor = ([[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor])/16;
            if (self.effectiveScale > maxScaleAndCropFactor)
                self.effectiveScale = maxScaleAndCropFactor;
            CGFloat zoom = self.effectiveScale / videoConnection.videoScaleAndCropFactor;
            videoConnection.videoScaleAndCropFactor = self.effectiveScale;

            [self.videoInput.device unlockForConfiguration];

            CGAffineTransform transform = self.cameraShowView.transform;
            [CATransaction begin];
            [CATransaction setAnimationDuration:.025];
            self.cameraShowView.transform = CGAffineTransformScale(transform, zoom, zoom);
            [CATransaction commit];
            
            
//            CGFloat maxScaleAndCropFactor = [[self.output connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
//            if (self.effectiveScale > maxScaleAndCropFactor)
//                self.effectiveScale = maxScaleAndCropFactor;
//
//            [CATransaction begin];
//            [CATransaction setAnimationDuration:.025];
//            [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
//            [CATransaction commit];
            
        }

    }
    
    // 当手指离开屏幕时
    if ((recognizer.state ==UIGestureRecognizerStateEnded) ||
        (recognizer.state ==UIGestureRecognizerStateCancelled)) {
        self.beginGestureScale = self.effectiveScale;
    }
    
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections{
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}

- (void)reloadAVCapturePhotoSettings{
    AVCapturePhotoSettings *outputSettings = [self getAVCapturePhotoSettings];
    [self.stillImageOutput setPhotoSettingsForSceneMonitoring:outputSettings];
}

- (AVCapturePhotoSettings*)getAVCapturePhotoSettings{

    // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    if (@available(iOS 11.0, *)) {
        NSDictionary *setDic = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecTypeJPEG, AVVideoCodecKey, nil];
        AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
        return outputSettings;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
        NSDictionary *setDic = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
        return outputSettings;
#pragma clang diagnostic pop
    }
}

@end
