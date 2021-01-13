//
//  KKCameraImageTopBar.h
//  HeiPa
//
//  Created by liubo on 2019/3/11.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKAlbumManager.h"

@protocol KKCameraImageTopBarDelegate;

@interface KKCameraImageTopBar : UIImageView


@property(nonatomic,weak)id<KKCameraImageTopBarDelegate> delegate;

@property(nonatomic,strong)UIButton *cancelButton;//返回按钮

@property(nonatomic,assign)AVCaptureFlashMode  cameraFlashMode;//闪光灯模式
@property(nonatomic,strong)UIButton *cameraFlashModeButton;//闪光灯模式按钮

@property(nonatomic,strong)UIButton *cameraDeviceButton;//摄像头方向（前置摄像头/后置摄像头）
@property(nonatomic,assign)AVCaptureDevicePosition  cameraDevicePosition;//摄像头方向

@property(nonatomic,strong)UIButton *doneButton;//确定

@end


@protocol KKCameraImageTopBarDelegate <NSObject>

/*取消*/
- (void)KKCameraImageTopBar_CancelButtonClicked:(KKCameraImageTopBar*)topView;

/*闪光灯*/
- (void)KKCameraImageTopBar:(KKCameraImageTopBar*)topView cameraFlashModeButtonClicked:(AVCaptureFlashMode)aCameraFlashMode;

/*摄像头*/
- (void)KKCameraImageTopBar:(KKCameraImageTopBar*)topView  cameraDeviceButtonClicked:(AVCaptureDevicePosition)aCameraDevicePositon;

/*完成*/
- (void)KKCameraImageTopBar_DoneButtonClicked:(KKCameraImageTopBar*)topView;


@end
