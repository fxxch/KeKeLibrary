//
//  KKCameraCaptureTopBar.h
//  BM
//
//  Created by 刘波 on 2020/2/29.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKView.h"
#import <AVFoundation/AVFoundation.h>

@protocol KKCameraCaptureTopBarDelegate;

@interface KKCameraCaptureTopBar : UIImageView


@property(nonatomic,weak)id<KKCameraCaptureTopBarDelegate> delegate;

@property(nonatomic,strong)UIButton *cancelButton;//返回按钮

@property(nonatomic,assign)AVCaptureFlashMode  cameraFlashMode;//闪光灯模式
@property(nonatomic,strong)UIButton *cameraFlashModeButton;//闪光灯模式按钮

@property(nonatomic,strong)UIButton *cameraDeviceButton;//摄像头方向（前置摄像头/后置摄像头）
@property(nonatomic,assign)AVCaptureDevicePosition  cameraDevicePosition;//摄像头方向

@property(nonatomic,strong)UIButton *doneButton;//确定

@end


@protocol KKCameraCaptureTopBarDelegate <NSObject>

/*取消*/
- (void)KKCameraCaptureTopBar_CancelButtonClicked:(KKCameraCaptureTopBar*)topView;

/*闪光灯*/
- (void)KKCameraCaptureTopBar:(KKCameraCaptureTopBar*)topView cameraFlashModeButtonClicked:(AVCaptureFlashMode)aCameraFlashMode;

/*摄像头*/
- (void)KKCameraCaptureTopBar:(KKCameraCaptureTopBar*)topView  cameraDeviceButtonClicked:(AVCaptureDevicePosition)aCameraDevicePositon;

/*完成*/
- (void)KKCameraCaptureTopBar_DoneButtonClicked:(KKCameraCaptureTopBar*)topView;


@end
