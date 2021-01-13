//
//  KKCameraCaptureTopBar.m
//  BM
//
//  Created by 刘波 on 2020/2/29.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKCameraCaptureTopBar.h"
#import "KKLibraryDefine.h"
#import "KKLocalizationManager.h"
#import "NSBundle+KKCategory.h"

@implementation KKCameraCaptureTopBar

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    CGFloat space = (((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).bounds.size.width-10-60*4)/3.0;

    self.userInteractionEnabled = YES;
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.25;
    backgroundView.userInteractionEnabled = YES;
    [self addSubview:backgroundView];

    /*取消*/
    self.cancelButton = [[UIButton alloc] init];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    self.cancelButton.frame = CGRectMake(5, self.frame.size.height-44, 60, 44);
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [self themeImageForName:@"Cancel"];
    UIImage *imageH = [self themeImageForName:@"CancelH"];
    [self.cancelButton setImage:image forState:UIControlStateNormal];
    [self.cancelButton setImage:imageH forState:UIControlStateHighlighted];
    [self addSubview:self.cancelButton];

    /*闪光灯模式*/
    self.cameraFlashModeButton = [[UIButton alloc] init];
    self.cameraFlashModeButton.backgroundColor = [UIColor clearColor];
    self.cameraFlashModeButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame)+space, self.frame.size.height-44, 60, 44);
    [self.cameraFlashModeButton addTarget:self action:@selector(cameraFlashModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image02 = [self themeImageForName:@"CameraFlashMode_Auto"];
    [self.cameraFlashModeButton setImage:image02 forState:UIControlStateNormal];
    [self addSubview:self.cameraFlashModeButton];

    self.cameraFlashMode = AVCaptureFlashModeAuto;

    /*摄像头方向*/
    self.cameraDeviceButton = [[UIButton alloc] init];
    self.cameraDeviceButton.backgroundColor = [UIColor clearColor];
    self.cameraDeviceButton.frame = CGRectMake(CGRectGetMaxX(self.cameraFlashModeButton.frame)+space, self.frame.size.height-44, 60, 44);
    [self.cameraDeviceButton addTarget:self action:@selector(cameraDeviceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image03 = [self themeImageForName:@"CameraFlashDevice_Back"];
    [self.cameraDeviceButton setImage:image03 forState:UIControlStateNormal];
    [self addSubview:self.cameraDeviceButton];

    self.cameraDevicePosition = AVCaptureDevicePositionBack;


    /*完成*/
    self.doneButton = [[UIButton alloc] init];
    self.doneButton.backgroundColor = [UIColor clearColor];
    self.doneButton.frame = CGRectMake(CGRectGetMaxX(self.cameraDeviceButton.frame)+space, self.frame.size.height-44, 60, 44);
    [self.doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton setTitle:KKLibLocalizable_Common_Done forState:UIControlStateNormal];
    [self.doneButton setTitle:KKLibLocalizable_Common_Done forState:UIControlStateHighlighted];
    [self addSubview:self.doneButton];
}

/*取消*/
- (void)cancelButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraCaptureTopBar_CancelButtonClicked:)]) {
        [self.delegate KKCameraCaptureTopBar_CancelButtonClicked:self];
    }
}

/*闪光灯*/
- (void)cameraFlashModeButtonClicked{
    if (self.cameraFlashMode == AVCaptureFlashModeAuto) {

        self.cameraFlashMode = AVCaptureFlashModeOn;

        UIImage *image02 = [self themeImageForName:@"CameraFlashMode_On"];
        [self.cameraFlashModeButton setImage:image02 forState:UIControlStateNormal];

    }
    else if (self.cameraFlashMode == AVCaptureFlashModeOn){
        self.cameraFlashMode = AVCaptureFlashModeOff;

        UIImage *image02 = [self themeImageForName:@"CameraFlashMode_Off"];
        [self.cameraFlashModeButton setImage:image02 forState:UIControlStateNormal];

    }
    else if (self.cameraFlashMode == AVCaptureFlashModeOff){
        self.cameraFlashMode = AVCaptureFlashModeAuto;

        UIImage *image02 = [self themeImageForName:@"CameraFlashMode_Auto"];
        [self.cameraFlashModeButton setImage:image02 forState:UIControlStateNormal];
    }
    else{

    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraCaptureTopBar:cameraFlashModeButtonClicked:)]) {
        [self.delegate KKCameraCaptureTopBar:self cameraFlashModeButtonClicked:self.cameraFlashMode];
    }
}

/*摄像头*/
- (void)cameraDeviceButtonClicked{
    if (self.cameraDevicePosition==AVCaptureDevicePositionBack) {
        self.cameraDevicePosition = AVCaptureDevicePositionFront;
        UIImage *image03 = [self themeImageForName:@"CameraFlashDevice_Front"];
        [self.cameraDeviceButton setImage:image03 forState:UIControlStateNormal];

    }
    else{
        self.cameraDevicePosition=AVCaptureDevicePositionBack;

        UIImage *image03 = [self themeImageForName:@"CameraFlashDevice_Back"];
        [self.cameraDeviceButton setImage:image03 forState:UIControlStateNormal];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraCaptureTopBar:cameraDeviceButtonClicked:)]) {
        [self.delegate KKCameraCaptureTopBar:self cameraDeviceButtonClicked:self.cameraDevicePosition];
    }

}

/*完成*/
- (void)doneButtonClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKCameraCaptureTopBar_DoneButtonClicked:)]) {
        [self.delegate KKCameraCaptureTopBar_DoneButtonClicked:self];
    }
}

- (UIImage*)themeImageForName:(NSString*)aImageName{
    UIImage *image = [NSBundle imageInBundle:@"KKCameraCapture.bundle" imageName:aImageName];
    return image;
}



@end
