//
//  KKCameraCaptureDataModal.m
//  BM
//
//  Created by 刘波 on 2020/3/16.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKCameraCaptureDataModal.h"
#import "KKFileCacheManager.h"

@implementation KKCameraCaptureDataModal

- (instancetype)init{
    self = [super init];
    if (self) {
        NSString *path = NSStringFromClass([self class]);
        [KKFileCacheManager deleteCacheDataInCacheDirectory:path];
        [KKFileCacheManager deleteCacheDirectory:path];

        self.helper = [[KKCameraHelper alloc] init];

        [self reset];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 数据复位
#pragma mark ==================================================
- (void)reset{
    NSString *path = NSStringFromClass([self class]);
    [KKFileCacheManager deleteCacheDataInCacheDirectory:path];
    [KKFileCacheManager deleteCacheDirectory:path];

    /* 公共的 */
    _fileName = nil;
    _fileName = [KKFileCacheManager createRandomFileName];

    /* 视频mov */
    _movFileFullPath = nil;

    /* 视频mP4 */
    _mp4FileFullPath = nil;

    /* 图片 */
    _imageFilePath = nil;
    _imageEditFilePath = nil;
}

#pragma mark ==================================================
#pragma mark == getter
#pragma mark ==================================================
- (NSString *)movFileFullPath{
    if (_movFileFullPath==nil) {
        NSString *path = NSStringFromClass([self class]);
        NSString *movFullName = [NSString stringWithFormat:@"%@.mov",_fileName];
        _movFileFullPath = [KKFileCacheManager createFilePathInCacheDirectory:path fileFullName:movFullName];
    }
    return _movFileFullPath;
}

- (NSString *)mp4FileFullPath{
    if (_mp4FileFullPath==nil) {
        NSString *path = NSStringFromClass([self class]);
        NSString *mp4FullName = [NSString stringWithFormat:@"%@.mp4",_fileName];
        _mp4FileFullPath = [KKFileCacheManager createFilePathInCacheDirectory:path fileFullName:mp4FullName];
    }
    return _mp4FileFullPath;
}

- (NSString *)imageFilePath{
    if (_imageFilePath==nil) {
        NSString *path = NSStringFromClass([self class]);
        NSString *imgFullName = [NSString stringWithFormat:@"%@.png",_fileName];
        _imageFilePath = [KKFileCacheManager createFilePathInCacheDirectory:path fileFullName:imgFullName];
    }
    return _imageFilePath;
}

- (NSString *)imageEditFilePath{
    if (_imageEditFilePath==nil) {
        NSString *path = NSStringFromClass([self class]);
        NSString *imgEditFullName = [NSString stringWithFormat:@"%@_Edit.png",_fileName];
        _imageEditFilePath = [KKFileCacheManager createFilePathInCacheDirectory:path fileFullName:imgEditFullName];
    }
    return _imageEditFilePath;
}

#pragma mark ==================================================
#pragma mark == 陀螺定位设备方向
#pragma mark ==================================================
- (void)startMotionManager{
    [self.helper startMotionManager];
}

- (void)stopMotionManager{
    [self.helper stopMotionManager];
}

- (UIImage*) movSnipImageWithURL:(NSURL*)aURL{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:aURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.requestedTimeToleranceAfter = kCMTimeZero;
    gen.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}


@end
