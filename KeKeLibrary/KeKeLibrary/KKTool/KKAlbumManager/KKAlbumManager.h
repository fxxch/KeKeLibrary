//
//  KKAlbumManager.h
//  GouUseCore
//
//  Created by liubo on 2017/9/7.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

/*读取图片原始图完成的Block*/
typedef void (^KKAlbumManager_LoadOriginImage_FinishedBlock)(
NSData   * _Nullable imageData,
NSString * _Nullable dataUTI,
UIImageOrientation orientation,
NSDictionary * _Nullable info
);

/*下载图片原始图完成的Block*/
typedef void (^KKAlbumManager_downLoadOriginImage_FinishedBlock)(
                                                             NSData   * _Nullable imageData,
                                                             NSString * _Nullable dataUTI,
                                                             UIImageOrientation orientation,
                                                             NSDictionary * _Nullable info
                                                             );

/*读取图片缩略图完成的Block*/
typedef void (^KKAlbumManager_LoadThumbnailImage_FinishedBlock)(
UIImage  * _Nullable aImage,
NSDictionary * _Nullable info
);

/*读取相册封面完成的Block*/
typedef void (^KKAlbumManager_LoadCover_FinishedBlock)(
UIImage  * _Nullable aImage,
NSDictionary * _Nullable info
);


#define NotificationName_KKAlbumManager_Changed @"NotificationName_KKAlbumManager_Changed"

@interface KKAlbumManager : NSObject

+ (KKAlbumManager *_Nonnull)defaultManager;

- (BOOL)isPHAssetInLocal:(PHAsset *_Nullable)aAsset;
- (BOOL)addLoadingPHAsset:(PHAsset *_Nullable)aAsset;
- (void)removeLoadingPHAsset:(PHAsset *_Nullable)aAsset;
- (BOOL)isLoadingPHAsset:(PHAsset *_Nullable)aAsset;

#pragma mark ==================================================
#pragma mark == 遍历所有资源
#pragma mark ==================================================
/**
 查询相簿里面的所有类型的对象
 
 @param aAssetMediaType 对象类型
 @return 集合对象
 */
- (NSArray<PHAsset *> *_Nullable)loadAllPHAsset_withPHAssetMediaType:(PHAssetMediaType)aAssetMediaType;

#pragma mark ==================================================
#pragma mark == 遍历所有目录
#pragma mark ==================================================
/**
 返回所有的相册目录NSMutableArray<PHAssetCollection *>
 
 @return 返回所有的相册目录
 */
- (NSMutableArray<PHAssetCollection *> *_Nullable)loadAlbumDirectory_withPHAssetMediaType:(PHAssetMediaType)aAssetMediaType;


/**
 返回某个相册目录下，指定类型的对象数量
 
 @param aAssetCollection 相册目录
 @param aAssetMediaType 对象类型
 @return 返回数量
 */
- (NSInteger)objectsCount_InPHAssetCollection:(PHAssetCollection*_Nullable)aAssetCollection
                         withPHAssetMediaType:(PHAssetMediaType)aAssetMediaType;


/**
 获取某个相册的所有图片
 
 @param aAssetCollection 相册目录
 @return 某个相册的所有图片
 */
- (NSArray*_Nonnull)loadAlbumImages_InPHAssetCollection:(PHAssetCollection*_Nullable)aAssetCollection;

/**
 返回某个相册的封面
 
 @param aAssetCollection 相册目录
 @param aAssetMediaType 对象类型
 @param aTargetSize 返回图片的尺寸
 @param finishedBlock 返回block
 */
- (void)loadAlbumDirectoryCover_InPHAssetCollection:(PHAssetCollection*_Nullable)aAssetCollection
                               withPHAssetMediaType:(PHAssetMediaType)aAssetMediaType
                                         targetSize:(CGSize)aTargetSize
                                        resultBlock:(KKAlbumManager_LoadCover_FinishedBlock _Nullable )finishedBlock;

/**
 获取缩略图（200*200）
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
- (void)loadThumbnailImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                           resultBlock:(KKAlbumManager_LoadThumbnailImage_FinishedBlock _Nullable )finishedBlock;

/**
 获取原始图片
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
- (void)loadOriginImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                        resultBlock:(KKAlbumManager_LoadOriginImage_FinishedBlock _Nullable )finishedBlock;

/**
 云端下载原始图片
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
- (void)downloadOriginImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                            resultBlock:(KKAlbumManager_downLoadOriginImage_FinishedBlock _Nullable )finishedBlock;

#pragma mark ==================================================
#pragma mark == 相册视频 相关
#pragma mark ==================================================
/**
 播放手机系统相册里面的视频
 （* 其实是将相册里面的视频数据Data 读取出来之后，写入到一个临时目录下面，再返回这个临时文件的文件地址，在进行本地文件播放*）
 
 @param asset PHAsset
 @param navigationController 从哪个导航控制器push到播放界面
 */
- (void)playVideoFromPHAsset:(PHAsset * _Nullable)asset
    fromNavigationController:(UINavigationController * _Nullable)navigationController;

///*读取视频完成Block*/
//typedef void (^KKAlbumManager_ReadVideo_FinishedBlock)(
//NSString * _Nullable filePath,
//NSString * _Nullable fileName
//);

/*读取视频完成Block*/
typedef void (^KKAlbumManager_ReadVideoPHAsset_FinishedBlock)(
NSString * _Nullable fileIdentifier
);


///**
// 从手机系统相册里面读取视频
// （* 其实是将相册里面的视频数据Data 读取出来之后，写入到一个临时目录下面，再返回这个临时文件的文件地址*）
//
// @param asset PHAsset
// @param fileWillBeSavedInPath 保存的临时文件完整路径 /abc/aaa.mov
// @param result 读取结果
// */
//- (void)readVideoFromPHAsset:(PHAsset* _Nullable)asset
//       fileWillBeSavedInPath:(NSString* _Nullable)savePath
//                    complete:(KKAlbumManager_ReadVideo_FinishedBlock _Nullable)result;

/**
 从手机系统相册里面读取视频
 （* 其实是将相册里面的视频数据Data 读取出来之后，写入到一个临时目录下面，再返回这个临时文件的文件地址*）
 
 @param asset PHAsset
 @param result 读取结果(会返回文件的身份标识符)
 */
- (void)readVideoFromPHAsset:(PHAsset* _Nullable)asset
                    complete:(KKAlbumManager_ReadVideoPHAsset_FinishedBlock _Nullable)result;

@end
