//
//  KKCameraHelper.m
//  BM
//
//  Created by 刘波 on 2020/2/24.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKCameraHelper.h"

@implementation KKCameraHelper

- (void)dealloc{
    if (self.cmotionManager) {
        [self.cmotionManager stopDeviceMotionUpdates];
        self.cmotionManager = nil;
    }
}

#pragma mark ==================================================
#pragma mark == 陀螺定位设备方向
#pragma mark ==================================================
- (void)startMotionManager{
    self.cmotionManager = [[CMMotionManager alloc] init];
    self.cmotionManager.deviceMotionUpdateInterval = 1/15.0;
    if (self.cmotionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        [self.cmotionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }
}

- (void)stopMotionManager{
    [self.cmotionManager stopDeviceMotionUpdates];
    self.cmotionManager = nil;
}

//根据陀螺仪检测到当前的状态，判断设备的旋转方向
- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x)){
        if (y >= 0){
            self.currentDeviceOrientation = UIDeviceOrientationPortraitUpsideDown;
        }
        else{
            self.currentDeviceOrientation = UIDeviceOrientationPortrait;
        }
    }
    else{
        if (x >= 0){
            self.currentDeviceOrientation = UIDeviceOrientationLandscapeRight;
        }
        else{
            self.currentDeviceOrientation = UIDeviceOrientationLandscapeLeft;
        }
    }
}

- (AVCaptureVideoOrientation)captureVideoOrientation{
    AVCaptureVideoOrientation result;

    //    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (_currentDeviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            //如果这里设置成AVCaptureVideoOrientationPortraitUpsideDown，则视频方向和拍摄时的方向是相反的。
            result = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            result = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            result = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
            result = AVCaptureVideoOrientationPortrait;
            break;
    }
    _captureVideoOrientation = result;

    return result;
}

#pragma mark ==================================================
#pragma mark == 获取前后摄像头输入对象的方法
#pragma mark ==================================================
+ (AVCaptureDevice *)cameraVideoWithPosition:(AVCaptureDevicePosition)position{

    AVCaptureDeviceDiscoverySession *devicesIOS10 = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:[NSArray arrayWithObject:AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    NSArray *devicesIOS  = devicesIOS10.devices;
    for (AVCaptureDevice *device in devicesIOS) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

#pragma mark ==================================================
#pragma mark == 重置输出图片配置
#pragma mark ==================================================
+ (void)reloadAVCapturePhotoSettings:(AVCapturePhotoOutput*)aCapturePhotoOutput flashMode:(AVCaptureFlashMode)aFlashMode{
    AVCapturePhotoSettings *outputSettings = [self getAVCapturePhotoSettings:aFlashMode];
    [aCapturePhotoOutput setPhotoSettingsForSceneMonitoring:outputSettings];
}

+ (AVCapturePhotoSettings*)getAVCapturePhotoSettings:(AVCaptureFlashMode)aFlashMode{

    // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    if (@available(iOS 11.0, *)) {
        NSDictionary *setDic = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecTypeJPEG, AVVideoCodecKey, nil];
        AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
        outputSettings.flashMode = aFlashMode;
        return outputSettings;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
        NSDictionary *setDic = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
        AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
        outputSettings.flashMode = aFlashMode;
        return outputSettings;
#pragma clang diagnostic pop
    }
}

@end
