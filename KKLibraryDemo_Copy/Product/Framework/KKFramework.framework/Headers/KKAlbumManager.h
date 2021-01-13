//
//  KKAlbumManager.h
//  GouUseCore
//
//  Created by liubo on 2017/9/7.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KKAlbumDirectoryModal.h"
#import <CoreServices/CoreServices.h>

/**
 *  KKAssetMediaType
 */
typedef NS_ENUM(NSInteger,KKAssetMediaType) {
    
    KKAssetMediaType_ImageAll = 0,/* 图片 */

    KKAssetMediaType_ImageGif = 1,/* Gif图片 */

    KKAssetMediaType_ImageNormal = 2,/* 普通图片 */

    KKAssetMediaType_Video = 3,/* 视频 */
    
    KKAssetMediaType_All = 4,/* 所有 */
};

/*读取图片缩略图完成的Block*/
typedef void (^KKAlbumManager_LoadThumbnailImage_FinishedBlock)(
    UIImage  * _Nullable aImage,
    NSDictionary * _Nullable info
);

/*读取图片缩略图完成的Block*/
typedef void (^KKAlbumManager_LoadBigImage_FinishedBlock)(
    UIImage  * _Nullable aImage,
    NSDictionary * _Nullable info
);


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

/*下载原始视频完成的Block*/
typedef void (^KKAlbumManager_downLoadOriginVideo_FinishedBlock)(
    AVPlayerItem * _Nullable playerItem,
    NSDictionary * _Nullable info
);

/*获取原始视频文件完成的Block*/
typedef void (^KKAlbumManager_loadOriginVideoFile_FinishedBlock)(
    NSURL    * _Nullable fileURL
);

/*获取资源的文件大小的Block*/
typedef void (^KKAlbumManager_LoadPHAssetFileSize_FinishedBlock)(
    long long fileSize
);


@interface KKAlbumManager : NSObject

+ (KKAlbumManager *_Nonnull)defaultManager;

#pragma mark ==================================================
#pragma mark == 遍历所有目录
#pragma mark ==================================================
/**
 返回所有的相册目录NSMutableArray<PHAssetCollection *>

 @return 返回所有的相册目录
 */
+ (NSArray<KKAlbumDirectoryModal *> *_Nullable)loadDirectory_WithMediaType:(KKAssetMediaType)aAssetMediaType;

/**
 获取某个相册的所有图片
 
 @param aAssetCollection 相册目录
 @return 某个相册的所有图片
 */
+ (NSArray<KKAlbumAssetModal*>*_Nonnull)loadObjects_InDirectory:(PHAssetCollection*_Nullable)aAssetCollection
                                                      mediaType:(KKAssetMediaType)aAssetMediaType;

/**
 获取缩略图（200*200）
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)loadThumbnailImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                            targetSize:(CGSize)aSize
                           resultBlock:(KKAlbumManager_LoadThumbnailImage_FinishedBlock _Nullable )finishedBlock;

/**
 获取高清大图
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)loadBigImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                      targetSize:(CGSize)aSize
                     resultBlock:(KKAlbumManager_LoadBigImage_FinishedBlock _Nullable )finishedBlock;

#pragma mark ==================================================
#pragma mark == 导出原始图片和原始视频
#pragma mark ==================================================
/**
 云端下载原始图片
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)startExportImageWithPHAsset:(PHAsset*_Nullable)aPHAsset
                        resultBlock:(KKAlbumManager_downLoadOriginImage_FinishedBlock _Nullable )finishedBlock;

/**
导出原始视频文件（会转换成MP4格式）

@param aPHAsset PHAsset 对象
@param aFilePathURL NSURL 指定的导出路径
@param finishedBlock 返回block
*/
+ (void)startExportVideoWithPHAsset:(PHAsset*_Nullable)aPHAsset
                        filePathURL:(NSURL*_Nullable)aFilePathURL
                        resultBlock:(KKAlbumManager_loadOriginVideoFile_FinishedBlock _Nullable )finishedBlock;



#pragma mark ==================================================
#pragma mark == 其他
#pragma mark ==================================================
/**
 获取资源的文件大小
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)loadPHAssetFileSize_withPHAsset:(PHAsset*_Nullable)aPHAsset
                            resultBlock:(KKAlbumManager_LoadPHAssetFileSize_FinishedBlock _Nullable )finishedBlock;

#pragma mark ==================================================
#pragma mark == 主题
#pragma mark ==================================================
+ (UIImage*_Nullable)themeImageForName:(NSString*_Nullable)aImageName;

+ (UIColor*_Nullable)navigationBarBackgroundColor;

@end

@interface PHAsset (KKCategory)

- (BOOL)isGif;

@end
