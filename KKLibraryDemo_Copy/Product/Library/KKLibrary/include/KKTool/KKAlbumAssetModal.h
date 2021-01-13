//
//  KKAlbumAssetModal.h
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface KKAlbumAssetModal : NSObject

@property (nonatomic , strong) PHAsset  * _Nullable asset;
@property (nonatomic , copy)   NSString * _Nullable fileName;
@property (nonatomic , copy)   NSURL    * _Nullable fileURL;//文件存放的路径
@property (nonatomic , strong) UIImage  * _Nullable thumbImage;//缩略图
@property (nonatomic , strong) UIImage  * _Nullable bigImage;//全屏图

/* 图片相关 */
@property (nonatomic , assign) BOOL img_isInLocal;
@property (nonatomic , copy)   NSString * _Nullable img_fileIdentifier;//图片的沙盒缓存ID
@property (nonatomic , strong) UIImage * _Nullable img_croppedbImage;//裁切好的图
///==============================
@property (nonatomic , strong, readonly) NSDictionary * _Nullable img_originInfo;//原始信息
@property (nonatomic , strong, readonly) NSData * _Nullable img_originData;//原始图
@property (nonatomic , copy, readonly)   NSString * _Nullable img_dataUTI;
@property (nonatomic , assign, readonly) UIImageOrientation img_orientation;
@property (nonatomic , assign) long long img_originDataSize;//原始文件的文件大小
@property (nonatomic , strong) UIImage * _Nullable img_EditeImage;//编辑好的图
///==============================
@property (nonatomic , assign) long long img_compressDataSize;//压缩文件的文件大小
@property (nonatomic , strong) UIImage * _Nullable img_CompressImage;//压缩好的图
@property (nonatomic , copy)   NSURL   * _Nullable compressfileURL;//压缩文件存放的路径
@property (nonatomic , copy)   NSString * _Nullable img_CompressFileIdentifier;//图片的沙盒缓存ID
@property (nonatomic , copy)   NSString * _Nullable compressfileName;


/* 视频相关 */
@property (nonatomic , assign) BOOL video_isInLocal;
///==============================
@property (nonatomic , strong, readonly) NSDictionary * _Nullable video_originInfo;//原始信息
@property (nonatomic , strong, readonly) NSData * _Nullable video_originData;//原始图
@property (nonatomic , copy, readonly)   NSString * _Nullable video_dataUTI;
@property (nonatomic , assign, readonly) UIImageOrientation video_orientation;
@property (nonatomic , assign) long long video_originDataSize;//原始文件的文件大小
@property (nonatomic , assign) long long videoPlayDuration;

- (UIImage*_Nullable)bigImageForShowing;

- (UIImage*_Nullable)smallImageForShowing;

/* 视频的真实播放时长，比如慢动作视频录制了10秒，但实际播放时间可能是60秒，而这里返回的就是60秒 */
- (void)videoPlayDuration:(void (^_Nullable)(double dur))resultBlock;

- (BOOL)setOriginImageInfo:(NSDictionary * _Nullable)info
                 imageData:(NSData * _Nullable)imageData
              imageDataUTI:(NSString * _Nullable)dataUTI
          imageOrientation:(UIImageOrientation)orientation
               filePathURL:(NSURL*_Nullable)aFilePathURL;

- (BOOL)setCompressImageData:(NSData * _Nullable)imageData
                 filePathURL:(NSURL* _Nullable)aFilePathURL;

@end
