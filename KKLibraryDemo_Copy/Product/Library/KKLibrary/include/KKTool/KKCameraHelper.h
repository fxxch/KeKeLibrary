//
//  KKCameraHelper.h
//  BM
//
//  Created by 刘波 on 2020/2/24.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "KKLibraryDefine.h"
#import "KKLocalizationManager.h"
#import "KKLog.h"

@interface KKCameraHelper : NSObject

@property (nonatomic, strong)CMMotionManager * _Nullable cmotionManager;

/* 硬件 */
@property (nonatomic, assign)UIDeviceOrientation currentDeviceOrientation;//当前设备的方向
@property (nonatomic, assign)AVCaptureVideoOrientation captureVideoOrientation;//拍摄时候的的设备方向

#pragma mark ==================================================
#pragma mark == 陀螺定位设备方向
#pragma mark ==================================================
- (void)startMotionManager;

- (void)stopMotionManager;

#pragma mark ==================================================
#pragma mark == 获取前后摄像头输入对象的方法
#pragma mark ==================================================
+ (AVCaptureDevice *_Nullable)cameraVideoWithPosition:(AVCaptureDevicePosition)position;

#pragma mark ==================================================
#pragma mark == 重置输出图片配置
#pragma mark ==================================================
+ (void)reloadAVCapturePhotoSettings:(AVCapturePhotoOutput*_Nullable)aCapturePhotoOutput flashMode:(AVCaptureFlashMode)aFlashMode;

+ (AVCapturePhotoSettings*_Nonnull)getAVCapturePhotoSettings:(AVCaptureFlashMode)aFlashMode;

@end
