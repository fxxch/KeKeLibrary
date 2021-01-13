//
//  KKCameraCaptureDataModal.h
//  BM
//
//  Created by 刘波 on 2020/3/16.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "KKCameraHelper.h"

@interface KKCameraCaptureDataModal : NSObject

/* 公共的 */
@property (nonatomic , copy)  NSString* fileName;//拍摄出来的文件名称
@property (nonatomic , assign)  BOOL isImage;//当前的类型

/* 视频mov */
@property (nonatomic , copy)  NSString* movFileFullPath;//拍摄出来的原始mov视频文件完整路径
/* 视频mp4 */
@property (nonatomic , copy)  NSString* mp4FileFullPath;//转换成MP4之后的，MP4文件完整路径

/* 图片 */
@property (nonatomic , copy)  NSString* imageFilePath;//拍摄的图片的完整路径
@property (nonatomic , copy)  NSString* imageEditFilePath;//编辑的图片的完整路径

/* 硬件 */
@property (nonatomic , strong) KKCameraHelper *helper;
@property (nonatomic, assign)  AVCaptureDevicePosition  captureDevicePosition;//摄像头的方向

#pragma mark ==================================================
#pragma mark == 数据复位
#pragma mark ==================================================
- (void)reset;

#pragma mark ==================================================
#pragma mark == 陀螺定位设备方向
#pragma mark ==================================================
- (void)startMotionManager;

- (void)stopMotionManager;

@end
