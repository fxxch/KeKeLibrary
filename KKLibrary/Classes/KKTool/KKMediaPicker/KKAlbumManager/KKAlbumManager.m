//
//  KKAlbumManager.m
//  GouUseCore
//
//  Created by liubo on 2017/9/7.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKAlbumManager.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKToastView.h"
#import "KKSharedInstance.h"
#import "KKTool.h"

@interface KKAlbumManager ()

@end

@implementation KKAlbumManager

+ (KKAlbumManager *_Nonnull)defaultManager{
    static KKAlbumManager *KKAlbumManager_defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAlbumManager_defaultManager =  [[KKAlbumManager alloc] init];
    });
    return KKAlbumManager_defaultManager;
}

#pragma mark ==================================================
#pragma mark == 遍历所有目录
#pragma mark ==================================================
/**
 返回所有的相册目录NSMutableArray<PHAssetCollection *>

 @return 返回所有的相册目录
 */
+ (NSArray<KKAlbumDirectoryModal *> *_Nullable)loadDirectory_WithMediaType:(KKAssetMediaType)aAssetMediaType{
    
    NSMutableArray *dataSource = [NSMutableArray array];
    NSMutableArray *directoryArray = [NSMutableArray array];

    PHAssetCollectionSubtype subType = PHAssetCollectionSubtypeAny;
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeiTunesSynced;
    
    /* PHAssetCollectionTypeSmartAlbum 相机胶卷中所有照片*/
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:subType options:options];
    for (PHAssetCollection *directory in smartAlbums) {
        if (![directoryArray containsObject:directory]) {
            NSArray *array = [KKAlbumManager loadObjects_InDirectory:directory mediaType:aAssetMediaType];
            if ([array count]>0) {
                KKAlbumDirectoryModal *modal = [[KKAlbumDirectoryModal alloc] init];
                modal.assetCollection = directory;
                modal.count = [array count];
                modal.title = [KKAlbumManager ablumTitleForPHAssetCollection:directory];
                modal.assetsArray = array;
                [dataSource addObject:modal];
                [directoryArray addObject:directory];
            }
        }
    }
    
    /* PHAssetCollectionTypeAlbum 所有的自定义相簿相册 */
    PHFetchResult *Album = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:subType options:options];
    for (PHAssetCollection *directory in Album) {
        if (![directoryArray containsObject:directory]) {
            NSArray *array = [KKAlbumManager loadObjects_InDirectory:directory mediaType:aAssetMediaType];
            if ([array count]>0) {
                KKAlbumDirectoryModal *modal = [[KKAlbumDirectoryModal alloc] init];
                modal.assetCollection = directory;
                modal.count = [array count];
                modal.title = [KKAlbumManager ablumTitleForPHAssetCollection:directory];
                modal.assetsArray = array;
                [dataSource addObject:modal];
                [directoryArray addObject:directory];
            }
        }
    }
    
    NSArray *array = [[dataSource reverseObjectEnumerator] allObjects];
    
//    NSArray *array = [NSArray arrayWithArray:dataSource];

    return array;
}

/**
 获取某个相册的所有图片
 
 @param aAssetCollection 相册目录
 @return 某个相册的所有图片
 */
+ (NSArray<KKAlbumAssetModal*>*_Nonnull)loadObjects_InDirectory:(PHAssetCollection*_Nullable)aAssetCollection
                                  mediaType:(KKAssetMediaType)aAssetMediaType{
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeiTunesSynced;
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];

    PHFetchResult *fetchResult2 = [PHAsset fetchAssetsInAssetCollection:aAssetCollection
                                                                options:options];
    
    NSMutableArray *returnArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult2) {
        
        if (aAssetMediaType==KKAssetMediaType_All) {
            KKAlbumAssetModal *modal = [[KKAlbumAssetModal alloc] init];
            modal.asset = asset;
            
            //文件名
            NSString *filename = [asset valueForKey:@"filename"];
            modal.fileName = filename;

            [returnArray addObject:modal];
        }
        else if (aAssetMediaType==KKAssetMediaType_Video){
            if ([asset mediaType]==PHAssetMediaTypeVideo
                ) {
                KKAlbumAssetModal *modal = [[KKAlbumAssetModal alloc] init];
                modal.asset = asset;
                
                //文件名
                NSString *filename = [asset valueForKey:@"filename"];
                modal.fileName = filename;
                
                [returnArray addObject:modal];
            }
        }
        else if (aAssetMediaType==KKAssetMediaType_ImageAll){
            if ([asset mediaType]==PHAssetMediaTypeImage
                ) {
                KKAlbumAssetModal *modal = [[KKAlbumAssetModal alloc] init];
                modal.asset = asset;
                
                //文件名
                NSString *filename = [asset valueForKey:@"filename"];
                modal.fileName = filename;
                
                [returnArray addObject:modal];
            }
        }
        else if (aAssetMediaType==KKAssetMediaType_ImageGif){
            if ([asset mediaType]==PHAssetMediaTypeImage &&
                asset.isGif == YES
                ) {
                KKAlbumAssetModal *modal = [[KKAlbumAssetModal alloc] init];
                modal.asset = asset;

                //文件名
                NSString *filename = [asset valueForKey:@"filename"];
                modal.fileName = filename;

                [returnArray addObject:modal];
            }
        }
        else if (aAssetMediaType==KKAssetMediaType_ImageNormal){
            if ([asset mediaType]==PHAssetMediaTypeImage &&
                asset.isGif == NO
                ) {
                KKAlbumAssetModal *modal = [[KKAlbumAssetModal alloc] init];
                modal.asset = asset;

                //文件名
                NSString *filename = [asset valueForKey:@"filename"];
                modal.fileName = filename;

                [returnArray addObject:modal];
            }
        }
        else{
            
        }
    }
    return returnArray;
}

/**
 获取缩略图（200*200）
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)loadThumbnailImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                            targetSize:(CGSize)aSize
                           resultBlock:(KKAlbumManager_LoadThumbnailImage_FinishedBlock _Nullable )finishedBlock{
    //异步执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.networkAccessAllowed = YES;
        //synchronous：指定请求是否同步执行。
        option.synchronous = YES;
        //resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
        option.resizeMode = PHImageRequestOptionsResizeModeNone;
        //deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效
        option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        //normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。

        CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize targetSize = CGSizeMake(aSize.width*scale, aSize.height*scale);
        
        //资源转图片
        [[PHCachingImageManager defaultManager] requestImageForAsset:aPHAsset
                                                   targetSize:targetSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:option
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
                                                    //主线刷新列表
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        finishedBlock(result,info);
                                                    });
                                                    
                                                }];
        
    });
}

/**
 获取高清大图
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)loadBigImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                      targetSize:(CGSize)aSize
                     resultBlock:(KKAlbumManager_LoadBigImage_FinishedBlock _Nullable )finishedBlock{
    //异步执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.networkAccessAllowed = YES;
        //synchronous：指定请求是否同步执行。
        option.synchronous = YES;
        //resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
        option.resizeMode = PHImageRequestOptionsResizeModeNone;
        //deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效
        option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        //normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。

        CGFloat scale = [[UIScreen mainScreen] scale];
        CGSize targetSize = CGSizeMake(aSize.width*scale, aSize.height*scale);
        
        //资源转图片
        [[PHCachingImageManager defaultManager] requestImageForAsset:aPHAsset
                                                   targetSize:targetSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:option
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
                                                    //主线刷新列表
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        finishedBlock(result,info);
                                                    });
                                                    
                                                }];
        
    });
}

#pragma mark ==================================================
#pragma mark == 导出原始图片和原始视频
#pragma mark ==================================================
/**
 云端下载原始图片
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)startExportImageWithPHAsset:(PHAsset*_Nullable)aPHAsset
                        resultBlock:(KKAlbumManager_downLoadOriginImage_FinishedBlock _Nullable )finishedBlock{
    
    //判断图片是否是HEIF图片
    __block BOOL isHEIF = NO;
    NSArray *resourceList = [PHAssetResource assetResourcesForAsset:aPHAsset];
    [resourceList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetResource *resource = obj;
        NSString *UTI = resource.uniformTypeIdentifier;
        if ([UTI isEqualToString:@"public.heif"] || [UTI isEqualToString:@"public.heic"]) {
            isHEIF = YES;
            *stop = YES;
        }
    }];

    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //networkAccessAllowed：如果本地没有是否从iCloud下载。默认NO
    option.networkAccessAllowed = YES;
    //synchronous：指定请求是否同步执行。
    option.synchronous = YES;
    //resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    //deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。
    
    //资源转图片
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:aPHAsset
                                                      options:option
                                                resultHandler:^( NSData * _Nullable imageData,
                                                                NSString * _Nullable dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary * _Nullable info) {
        if (isHEIF) {
            CIImage *ciImage = [CIImage imageWithData:imageData];
            CIContext *context = [CIContext context];
            NSData *jpgData = [context JPEGRepresentationOfImage:ciImage colorSpace:ciImage.colorSpace options:@{}];
            finishedBlock(jpgData,
                          dataUTI,
                          orientation,
                          info);
        } else {
            finishedBlock(imageData,
                          dataUTI,
                          orientation,
                          info);
        }
    }];
}

/**
导出原始视频文件（会转换成MP4格式）

@param aPHAsset PHAsset 对象
@param aFilePathURL NSURL 指定的导出路径
@param finishedBlock 返回block
*/
+ (void)startExportVideoWithPHAsset:(PHAsset*_Nullable)aPHAsset
                        filePathURL:(NSURL*_Nullable)aFilePathURL
                        resultBlock:(KKAlbumManager_loadOriginVideoFile_FinishedBlock _Nullable )finishedBlock{
    
    /* 方法一 https://www.jianshu.com/p/93f4ea2d3552 */
//    //给定一个地址URL
//    NSString *fileName1 = [KKFileCacheManager createRandomFileName];
//    NSString *fileName = [NSString stringWithFormat:@"%@.mov",fileName1];
//    NSString *filePathTemp = [KKFileCacheManager createFilePathInCacheDirectory:KKFileCacheManager_CacheDirectoryOfAlbumVideo fileName:fileName];
//    NSURL *urlTemp = [NSURL fileURLWithPath:filePathTemp];
//
//    //将这个地址设为视频的输出地址
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:aPHAsset presetName:AVAssetExportPresetHighestQuality];
//    exporter.outputURL = urlTemp;
//    exporter.outputFileType = AVFileTypeQuickTimeMovie;
//    exporter.shouldOptimizeForNetworkUse = YES;
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (exporter.status == AVAssetExportSessionStatusCompleted) {
//                NSURL*URL = exporter.outputURL;
//                finishedBlock(URL);
//            }
//            else{
//                finishedBlock(nil);
//            }
//        });
//
//    }];

    /* 方法二 */
//    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:aPHAsset];
//    PHAssetResource *resource;
//    for (PHAssetResource *assetRes in assetResources) {
//        if (assetRes.type == PHAssetResourceTypePairedVideo ||
//            assetRes.type == PHAssetResourceTypeVideo) {
//            resource = assetRes;
//        }
//    }
        
    if (aPHAsset.mediaType == PHAssetMediaTypeVideo ||
        aPHAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive)
    {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestExportSessionForVideo:aPHAsset
                                      options:options
                                 exportPreset:AVAssetExportPresetHighestQuality
                                resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
           
            NSURL *exportOutURL = aFilePathURL;
            if (aFilePathURL==nil) {
                NSString *fileName1 = [KKFileCacheManager createRandomFileName];
                NSString *fileName = [NSString stringWithFormat:@"%@.mp4",fileName1];
                NSString *filePathTemp = [KKFileCacheManager createFilePathInCacheDirectory:KKFileCacheManager_CacheDirectoryOfAlbumVideo fileFullName:fileName];
                exportOutURL = [NSURL fileURLWithPath:filePathTemp];
            }
            
            exportSession.outputURL = exportOutURL;
            exportSession.shouldOptimizeForNetworkUse = YES;
            exportSession.outputFileType = AVFileTypeMPEG4;

            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    NSURL*URL = exportSession.outputURL;
                    finishedBlock(URL);
                }
                else{
                    finishedBlock(nil);
                }

            }];
            
        }];
    }
    else{
        finishedBlock(nil);
    }
        
}



#pragma mark ==================================================
#pragma mark == 其他
#pragma mark ==================================================
+ (NSString *)ablumTitleForPHAssetCollection:(PHAssetCollection *)aCollection{
    
    if (aCollection.assetCollectionType==PHAssetCollectionTypeAlbum) {
        if ([aCollection.localizedTitle isEqualToString:@"My Photo Stream"]) {
            return KKLibLocalizable_Album_ImageStream;
        }
        else{
            return aCollection.localizedTitle;
        }
    }

    NSString *returnString = @"";
    switch (aCollection.assetCollectionSubtype) {
        case PHAssetCollectionSubtypeSmartAlbumUserLibrary:{
            returnString = KKLibLocalizable_Album_UserLibrary;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumPanoramas:{
            returnString = KKLibLocalizable_Album_Panoramas;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumVideos:{
            returnString = KKLibLocalizable_Album_Videos;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumFavorites:{
            returnString = KKLibLocalizable_Album_Favorites;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumTimelapses:{
            returnString = KKLibLocalizable_Album_Timelapses;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumRecentlyAdded:{
            returnString = KKLibLocalizable_Album_RecentlyAdded;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumBursts:{
            returnString = KKLibLocalizable_Album_Bursts;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumSlomoVideos:{
            returnString = KKLibLocalizable_Album_SlomoVideos;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumSelfPortraits:{
            returnString = KKLibLocalizable_Album_SelfPortraits;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumScreenshots:{
            returnString = KKLibLocalizable_Album_Screenshots;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumDepthEffect:{
            returnString = KKLibLocalizable_Album_DepthEffect;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumLivePhotos:{
            returnString = KKLibLocalizable_Album_LivePhotos;
            break;
        }
        case PHAssetCollectionSubtypeSmartAlbumAnimated:{
            returnString = KKLibLocalizable_Album_Animated;
            break;
        }
        default:
            break;
    }
    
    if ([NSString isStringEmpty:returnString]) {
        if ([aCollection.localizedTitle isEqualToString:@"Recently Deleted"]) {
            returnString = KKLibLocalizable_Album_RecentlyDeleted;
        }
        else if ([aCollection.localizedTitle isEqualToString:@"All Photos"]) {
            returnString = KKLibLocalizable_Album_AllPhotos;
        }
        else{
            returnString = KKLibLocalizable_Album_DefaultName;
        }
    }
    
    return returnString;
}

/**
 获取资源的文件大小
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)loadPHAssetFileSize_withPHAsset:(PHAsset*_Nullable)aPHAsset
                            resultBlock:(KKAlbumManager_LoadPHAssetFileSize_FinishedBlock _Nullable )finishedBlock{

    // 为了防止界面卡住，可以异步执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:aPHAsset] firstObject];
        long long size = [[resource valueForKey:@"fileSize"] longLongValue];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (finishedBlock) {
                finishedBlock(size);
            }
        });
    });
    
}


#pragma mark ==================================================
#pragma mark == 主题
#pragma mark ==================================================
+ (UIImage*)themeImageForName:(NSString*)aImageName{
    UIImage *image = [NSBundle imageInBundle:@"KKAlbumManager.bundle" imageName:aImageName];
    return image;
}

+ (UIColor*)navigationBarBackgroundColor{
    return [UIColor blackColor];
}


#pragma mark ==================================================
#pragma mark == 废弃方法
#pragma mark ==================================================
/**
 获取原始图片
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)loadOriginImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                        resultBlock:(KKAlbumManager_LoadOriginImage_FinishedBlock _Nullable )finishedBlock{
    //异步执行
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //synchronous：指定请求是否同步执行。
    option.synchronous = YES;
    //resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    //deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。
    
    //资源转图片
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:aPHAsset
                                                      options:option
                                                resultHandler:^( NSData * _Nullable imageData,
                                                                NSString * _Nullable dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary * _Nullable info) {
                                                    
        //主线刷新列表
        dispatch_async(dispatch_get_main_queue(), ^{
            finishedBlock(imageData,
                          dataUTI,
                          orientation,
                          info);
        });

    }];
    
    //    });
}


/**
 云端下载原始图片
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)downloadOriginImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                            resultBlock:(KKAlbumManager_downLoadOriginImage_FinishedBlock _Nullable )finishedBlock{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //networkAccessAllowed：如果本地没有是否从iCloud下载。默认NO
    option.networkAccessAllowed = YES;
    //synchronous：指定请求是否同步执行。
    option.synchronous = YES;
    //resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
    option.resizeMode = PHImageRequestOptionsResizeModeNone;
    //deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    //normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。
    
    //资源转图片
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:aPHAsset
                                                      options:option
                                                resultHandler:^( NSData * _Nullable imageData,
                                                                NSString * _Nullable dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary * _Nullable info) {
        finishedBlock(imageData,
                      dataUTI,
                      orientation,
                      info);

    }];
}

/**
 云端下载原始视频
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
+ (void)downloadOriginVideo_withPHAsset:(PHAsset*_Nullable)aPHAsset
                            resultBlock:(KKAlbumManager_downLoadOriginVideo_FinishedBlock _Nullable )finishedBlock{
    
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;

    [[PHImageManager defaultManager] requestPlayerItemForVideo:aPHAsset options:option resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            finishedBlock(playerItem,info);
            
        });
        
    }];
}

/**
 获取视频文件
 
 @param aPHAsset PHAsset 对象
 @param aFilePathURL NSURL 指定的导出路径
 @param finishedBlock 返回block
 */
+ (void)loadOriginVideo_withPHAsset:(PHAsset*_Nullable)aPHAsset
                        filePathURL:(NSURL*_Nullable)aFilePathURL
                            resultBlock:(KKAlbumManager_loadOriginVideoFile_FinishedBlock _Nullable )finishedBlock{
    
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    //PHVideoRequestOptionsVersionOriginal 如果是慢视频，则提交后播放就和正常视频一样了;
    option.version = PHVideoRequestOptionsVersionOriginal;
    [[PHImageManager defaultManager] requestAVAssetForVideo:aPHAsset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {

        if ([asset isKindOfClass:[AVURLAsset class]]) {
            
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            NSURL *url = urlAsset.URL;
            if (url) {
                //主线刷新列表
                dispatch_async(dispatch_get_main_queue(), ^{
                    finishedBlock(url);
                });
            }
            else{
                [KKAlbumManager startExportVideoWithPHAsset:aPHAsset
                                                   filePathURL:aFilePathURL
                                                   resultBlock:finishedBlock];
            }
        }
        else{
            [KKAlbumManager startExportVideoWithPHAsset:aPHAsset
                                               filePathURL:aFilePathURL
                                               resultBlock:finishedBlock];
        }
        
        
    }];
}


@end


@implementation PHAsset (KKCategory)

- (BOOL)isGif{
    //方法一
//    PHAssetResource * resorce = [[PHAssetResource assetResourcesForAsset:self] firstObject];
    // 通过统一类型标识符(uniform type identifier) UTI 来判断
//    NSString *uti = [resorce uniformTypeIdentifier];
//    CFStringRef cfString = (__bridge CFStringRef)uti;
//    BOOL result = UTTypeConformsTo(cfString, kUTTypeGIF);

    //方法二
    // 或者通过文件名后缀来判断
//    BOOL result = [[resorce.originalFilename lowercaseString] hasSuffix:@".gif"];

    //方法三
//    __block BOOL result = NO;
//    //等待同意后向下执行
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//
//    PHImageRequestOptions *requestOption = [[PHImageRequestOptions alloc] init];
//    requestOption.version = PHImageRequestOptionsVersionUnadjusted;
//    requestOption.synchronous = NO;
//    requestOption.resizeMode = PHImageRequestOptionsResizeModeFast;
//    [PHImageManager.defaultManager requestImageDataForAsset:self options:requestOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//
//        if ([[UIImage contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF]) {
//            result =  YES;
//        } else {
//            result =  NO;
//        }
//
//        dispatch_semaphore_signal(sema);
//
//    }];
//
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

    //方法四
    NSString *filename = [self valueForKey:@"filename"];
    BOOL result = [[filename lowercaseString] hasSuffix:@".gif"];

    return result;
}

@end
