//
//  KKAlbumManager.m
//  GouUseCore
//
//  Created by liubo on 2017/9/7.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKAlbumManager.h"
#import "KKCategory.h"
#import "KeKeLibraryDefine.h"
#import "KKToastView.h"
#import "KKSharedInstance.h"
#import "KKTool.h"

@interface KKAlbumManager ()

@property(nonatomic,strong)NSMutableDictionary *loadingPHAssetDictionary;
@property(nonatomic,strong)NSMutableDictionary *iCloudPHAssetDictionary;

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

- (instancetype)init{
    self = [super init];
    if (self) {
        self.loadingPHAssetDictionary = [[NSMutableDictionary alloc] init];
        self.iCloudPHAssetDictionary = [[NSMutableDictionary alloc] init];

//        [KKAuthorizedManager isAlbumAuthorized_ShowAlert:YES block:^(BOOL authorized) {
//            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];    //创建监听者
//            //        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];    //移除监听者
//            [self reload];
//        }];
        
    }
    return self;
}


/**
 判断本地相册是否存在对应的PHAsset资源（只判断图片）

 @param aAsset aAsset
 @return 是否存在
 */
- (BOOL)isPHAssetInLocal:(PHAsset *)aAsset{
    if (aAsset.mediaType==PHAssetMediaTypeImage) {
        /* 方案一 比较费时 */
        //asset is a PHAsset object for which you want to get the information
//        NSArray *resourceArray = [PHAssetResource assetResourcesForAsset:aAsset];
//        BOOL bIsLocallayAvailable = [[resourceArray.firstObject valueForKey:@"locallyAvailable"] boolValue];
//        // If this returns NO, then the asset is in iCloud and not saved locally yet
//        return bIsLocallayAvailable;
        
        /* 方案二 费时相对好一点 */
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.networkAccessAllowed = NO;
        option.synchronous = YES;
        
        NSString *localIdentifier = [aAsset localIdentifier];
        if ([NSString isStringNotEmpty:localIdentifier]) {
            if ([self.iCloudPHAssetDictionary objectForKey:localIdentifier]) {
                return [[self.iCloudPHAssetDictionary objectForKey:localIdentifier] boolValue];
            }
            else{
                KKWeakSelf(self);
                __block BOOL isInLocalAblum = YES;
                [[PHImageManager defaultManager] requestImageDataForAsset:aAsset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    
                    isInLocalAblum = imageData ? YES : NO;
                    [weakself.iCloudPHAssetDictionary setObject:[NSNumber numberWithBool:isInLocalAblum] forKey:localIdentifier];
                }];
                
                return isInLocalAblum;
            }
        }
        else{
            return YES;
        }
    }
    else if (aAsset.mediaType==PHAssetMediaTypeVideo){
        return YES;
    }
    else{
        return YES;
    }
}

- (BOOL)addLoadingPHAsset:(PHAsset *_Nullable)aAsset{
    NSString *localIdentifier = [aAsset localIdentifier];
    if ([NSString isStringNotEmpty:localIdentifier]) {
        [self.loadingPHAssetDictionary setObject:localIdentifier forKey:localIdentifier];
        return YES;
    }
    else{
        return NO;
    }
}

- (void)removeLoadingPHAsset:(PHAsset *_Nullable)aAsset{
    NSString *localIdentifier = [aAsset localIdentifier];
    if ([NSString isStringNotEmpty:localIdentifier]) {
        [self.loadingPHAssetDictionary removeObjectForKey:localIdentifier];
    }
}

- (BOOL)isLoadingPHAsset:(PHAsset *_Nullable)aAsset{
    NSString *localIdentifier = [aAsset localIdentifier];
    if ([NSString isStringNotEmpty:localIdentifier]) {
        if ([self.loadingPHAssetDictionary objectForKey:localIdentifier]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

#pragma mark ==================================================
#pragma mark == 遍历所有资源
#pragma mark ==================================================
/**
 查询相簿里面的所有类型的对象

 @param aAssetMediaType 对象类型
 @return 集合对象
 */
- (NSArray<PHAsset *> *_Nullable)loadAllPHAsset_withPHAssetMediaType:(PHAssetMediaType)aAssetMediaType{
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeiTunesSynced;

    PHFetchResult * result = [PHAsset fetchAssetsWithMediaType:aAssetMediaType options:options];
    
    NSMutableArray *newArray = [NSMutableArray array];
    for (PHAsset *asset in result) {
//        //只返回本地相册有的，iCloud的照片排除在外
//        if ([self isPHAssetInLocal:asset]) {
//            [newArray addObject:asset];
//        }
        
        [newArray addObject:asset];
    }
    
    return newArray;
}

#pragma mark ==================================================
#pragma mark == 遍历所有目录
#pragma mark ==================================================
/**
 返回所有的相册目录NSMutableArray<PHAssetCollection *>

 @return 返回所有的相册目录
 */
- (NSMutableArray<PHAssetCollection *> *_Nullable)loadAlbumDirectory_withPHAssetMediaType:(PHAssetMediaType)aAssetMediaType{
    
    NSMutableArray *dataSource = [NSMutableArray array];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeiTunesSynced;
    
    //用户同步的照片PHAssetCollectionTypeAlbum
    PHFetchResult *fetchResult_Album =
    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                             subtype:PHAssetCollectionSubtypeAny
                                             options:options];
    for (PHAssetCollection *sub in fetchResult_Album) {
        if (![dataSource containsObject:sub]) {
            [dataSource addObject:sub];
        }
    }

    //来自相机的照片PHAssetCollectionTypeAlbum
    PHFetchResult *fetchResult_SmartAlbum =
    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                             subtype:PHAssetCollectionSubtypeAny
                                             options:options];
    for (PHAssetCollection *sub in fetchResult_SmartAlbum) {
        if (![dataSource containsObject:sub]) {
            [dataSource addObject:sub];
        }
    }

    return dataSource;
}


/**
 返回某个相册目录下，指定类型的对象数量

 @param aAssetCollection 相册目录
 @param aAssetMediaType 对象类型
 @return 返回数量
 */
- (NSInteger)objectsCount_InPHAssetCollection:(PHAssetCollection*_Nullable)aAssetCollection
                         withPHAssetMediaType:(PHAssetMediaType)aAssetMediaType{
 
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeiTunesSynced;
    PHFetchResult *fetchResult2 = [PHAsset fetchAssetsInAssetCollection:aAssetCollection
                                                                options:options];
    NSInteger count =0;
    
    for (PHAsset *asset in fetchResult2) {
        //只返回本地相册有的，iCloud的照片排除在外
        if ([asset mediaType]==aAssetMediaType &&
            [self isPHAssetInLocal:asset]
            ) {
            count++;
        }
    }

    return count;
}


#pragma mark ==================================================
#pragma mark == 遍历图片Block
#pragma mark ==================================================

/**
 获取某个相册的所有图片

 @param aAssetCollection 相册目录
 @return 某个相册的所有图片
 */
- (NSArray*_Nonnull)loadAlbumImages_InPHAssetCollection:(PHAssetCollection*_Nullable)aAssetCollection{
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeiTunesSynced;

    PHFetchResult *fetchResult2 = [PHAsset fetchAssetsInAssetCollection:aAssetCollection
                                                                options:options];
    
    NSMutableArray *returnArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult2) {
        //只返回本地相册有的，iCloud的照片排除在外
        if ([asset mediaType]==PHAssetMediaTypeImage &&
            [self isPHAssetInLocal:asset]
            ) {
            [returnArray addObject:asset];
        }
    }
    return returnArray;
}

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
                                        resultBlock:(KKAlbumManager_LoadCover_FinishedBlock _Nullable )finishedBlock{
    
    PHAsset *asset_result = nil;
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeiTunesSynced;

    PHFetchResult *fetchResult2 = [PHAsset fetchAssetsInAssetCollection:aAssetCollection
                                                                options:options];
    for (NSInteger i=0; i<[fetchResult2 count]; i++) {
        PHAsset *asset = [fetchResult2 objectAtIndex:i];
        //只筛选照片
        if ([asset mediaType]==aAssetMediaType) {
            asset_result=asset;
            break;
        }
    }
    
    if (asset_result) {
        
        //异步执行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            //synchronous：指定请求是否同步执行。
            option.synchronous = YES;
            //resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
            option.resizeMode = PHImageRequestOptionsResizeModeFast;
            //deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效
            option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
            //normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。
            
            //资源转图片
            [[PHImageManager defaultManager] requestImageForAsset:asset_result
                                                       targetSize:aTargetSize
                                                      contentMode:PHImageContentModeAspectFill options:option
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        
                                                        //主线刷新列表
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            finishedBlock(result,info);
                                                        });
                                                        
                                                    }];
            
        });
    }
    else{
        finishedBlock(nil,nil);
    }
}


/**
 获取缩略图（200*200）

 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
- (void)loadThumbnailImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                           resultBlock:(KKAlbumManager_LoadThumbnailImage_FinishedBlock _Nullable )finishedBlock{
    //异步执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //资源转图片
        [[PHImageManager defaultManager] requestImageForAsset:aPHAsset
                                                   targetSize:CGSizeMake(200, 200)
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:nil
                                                resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                    
                                                    //主线刷新列表
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        finishedBlock(result,info);
                                                    });
                                                    
                                                }];
        
    });
}

/**
 获取原始图片
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
- (void)loadOriginImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                        resultBlock:(KKAlbumManager_LoadOriginImage_FinishedBlock _Nullable )finishedBlock{
    //异步执行
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        //synchronous：指定请求是否同步执行。
        option.synchronous = YES;
        //resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        //deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效
        option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        //normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。

        //资源转图片
        [[PHImageManager defaultManager] requestImageDataForAsset:aPHAsset
                                                          options:option
                                                    resultHandler:^( NSData * _Nullable imageData,
                                                                    NSString * _Nullable dataUTI,
                                                                    UIImageOrientation orientation,
                                                                    NSDictionary * _Nullable info) {
                                                        
                                                        //主线刷新列表
//                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            finishedBlock(imageData,
                                                                          dataUTI,
                                                                          orientation,
                                                                          info);
//                                                        });
                                                        
                                                    }];
        
//    });
}

/**
 云端下载原始图片
 
 @param aPHAsset PHAsset 对象
 @param finishedBlock 返回block
 */
- (void)downloadOriginImage_withPHAsset:(PHAsset*_Nullable)aPHAsset
                        resultBlock:(KKAlbumManager_downLoadOriginImage_FinishedBlock _Nullable )finishedBlock{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //networkAccessAllowed：如果本地没有是否从iCloud下载。默认NO
    option.networkAccessAllowed = YES;
    //synchronous：指定请求是否同步执行。
    option.synchronous = NO;
    //resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    //deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    //normalizedCropRect：用于对原始尺寸的图像进行裁剪，基于比例坐标。只在 resizeMode 为 Exact 时有效。

    [[KKAlbumManager defaultManager] addLoadingPHAsset:aPHAsset];

    //资源转图片
    [[PHImageManager defaultManager] requestImageDataForAsset:aPHAsset
                                                      options:option
                                                resultHandler:^( NSData * _Nullable imageData,
                                                                NSString * _Nullable dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary * _Nullable info) {
                                                    
                                                    [[KKAlbumManager defaultManager] removeLoadingPHAsset:aPHAsset];
                                                    if (imageData) {
                                                        NSString *localIdentifier = [aPHAsset localIdentifier];

                                                        [self.iCloudPHAssetDictionary setObject:[NSNumber numberWithBool:YES] forKey:localIdentifier];
                                                    }
                                                    
                                                    //主线刷新列表
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        finishedBlock(imageData,
                                                                      dataUTI,
                                                                      orientation,
                                                                      info);

                                                    });
                                                }];
}


#pragma mark ==================================================
#pragma mark == 相册视频 相关
#pragma mark ==================================================
/**
 播放手机系统相册里面的视频
 （* 其实是将相册里面的视频数据Data 读取出来之后，写入到一个临时目录下面，再返回这个临时文件的文件地址，在进行本地文件播放*）

 @param asset PHAsset
 @param navigationController 从哪个导航控制器push到播放界面
 */
- (void)playVideoFromPHAsset:(PHAsset *)asset
    fromNavigationController:(UINavigationController*)navigationController{
    
//    [NSObject showWaitingViewInView:Window0 withText:@"正在处理视频文件"];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        [[KKAlbumManager defaultManager] readVideoFromPHAsset:asset fileWillBeSavedInPath:nil complete:^(NSString * _Nullable filePath, NSString * _Nullable fileName) {
//
//            if ([NSString isStringNotEmpty:filePath]) {
//                NSURL *url =[NSURL fileURLWithPath:filePath];
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    [NSObject hideWaitingViewForView:Window0];
//
//                    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
//                        NSLog(@"文件存在");
//                        KKVideoPlayViewController *viewController =
//                        [[KKVideoPlayViewController alloc] initWithDocumentURLString:[url absoluteString]
//                                                                        documentName:fileName
//                                                                 documentInformation:nil];
//                        [navigationController pushViewController:viewController animated:NO];
//                    }
//                    else{
//                        NSLog(@"文件不存在");
//                    }
//
//                });
//
//            }
//            else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [NSObject hideWaitingViewForView:Window0];
//                    NSLog(@"文件不存在");
//                });
//            }
//        }];
//    });
    
    [KKWaitingView showInView:Window0 withType:KKWaitingViewType_White blackBackground:YES text:@"正在处理视频文件"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[KKAlbumManager defaultManager] readVideoFromPHAsset:asset complete:^(NSString * _Nullable fileIdentifier) {
            
            if ([NSString isStringNotEmpty:fileIdentifier]) {
                NSString *filePath = [KKFileCacheManager cacheDataPath:fileIdentifier];
                NSURL *url =[NSURL fileURLWithPath:filePath];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [KKWaitingView hideForView:Window0 animation:YES];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
                        KKLog(@"文件存在");
//                        KKVideoPlayViewController *viewController =
//                        [[KKVideoPlayViewController alloc] initWithDocumentURLString:[url absoluteString]
//                                                                        documentName:[filePath lastPathComponent]
//                                                                 documentInformation:nil];
//                        [navigationController pushViewController:viewController animated:NO];
                    }
                    else{
                        KKLog(@"文件不存在");
                    }
                    
                });
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KKWaitingView hideForView:Window0 animation:YES];
                    KKLog(@"文件不存在");
                });
            }
        }];
    });

}

///**
// 从手机系统相册里面读取视频
// （* 其实是将相册里面的视频数据Data 读取出来之后，写入到一个临时目录下面，再返回这个临时文件的文件地址*）
//
// @param asset PHAsset
// @param fileWillBeSavedInPath 保存的临时文件完整路径 /abc/aaa.mov
// @param result 读取结果
// */
//- (void)readVideoFromPHAsset:(PHAsset *)asset
//       fileWillBeSavedInPath:(NSString*)savePath
//                    complete:(KKAlbumManager_ReadVideo_FinishedBlock)result {
//
//    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
//    PHAssetResource *resource = nil;
//
//    for (PHAssetResource *assetRes in assetResources) {
//        if (assetRes.type == PHAssetResourceTypePairedVideo ||
//            assetRes.type == PHAssetResourceTypeVideo) {
//            resource = assetRes;
//        }
//    }
//
//    /*
//     相册视频不存在
//     */
//    if (resource==nil) {
//        result(nil, nil);
//        return;
//    }
//
//    NSString *fileName = @"";
//    NSString *PATH_MOVIE_FILE = @"";
//    if ([NSString isStringNotEmpty:savePath]) {
//        fileName = [savePath lastPathComponent];
//        PATH_MOVIE_FILE = savePath;
//    }
//    else{
//        if (resource.originalFilename) {
//            fileName = resource.originalFilename;
//        }
//        if ([NSString isStringEmpty:fileName]) {
//            fileName = [NSString stringWithFormat:@"%@.MOV",[KKFileCacheManager createRandomFileName]];
//        }
//
//        PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];;
//    }
//
//    [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
//
//    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
//        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
//        options.version = PHImageRequestOptionsVersionCurrent;
//        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//
//        NSURL *fileURL = [NSURL fileURLWithPath:PATH_MOVIE_FILE];
//        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
//                                                                    toFile:fileURL
//                                                                   options:nil
//                                                         completionHandler:^(NSError * _Nullable error) {
//                                                             if (error) {
//                                                                 result(nil, nil);
//                                                             } else {
//                                                                 result(PATH_MOVIE_FILE, fileName);
//                                                             }
//                                                         }];
//    } else {
//        result(nil, nil);
//    }
//}

/**
 从手机系统相册里面读取视频
 （* 其实是将相册里面的视频数据Data 读取出来之后，写入到一个临时目录下面，再返回这个临时文件的文件地址*）
 
 @param asset PHAsset
 @param result 读取结果(会返回文件的身份标识符)
 */
- (void)readVideoFromPHAsset:(PHAsset* _Nullable)asset
                    complete:(KKAlbumManager_ReadVideoPHAsset_FinishedBlock _Nullable)result{
    
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        // 允许同步网络相册
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        options.networkAccessAllowed = YES;
        options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            if (error) {
                [KKToastView showInView:Window0 text:@"相册同步资源失败" alignment:KKToastViewAlignment_Center];
            }
        };
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            
            NSURL *url = urlAsset.URL;
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data) {
                NSString *identifier = [KKFileCacheManager saveData:data toCacheDirectory:KKFileCacheManager_CacheDirectoryOfAlbumVideo dataExtension:@"MOV" displayName:[url lastPathComponent] dataInformation:nil];
                if ([NSString isStringNotEmpty:identifier]) {
                    result(identifier);
                }
                else{
                    result(nil);
                }
            }
            else{
                result(nil);
            }
        }];
    }
}


@end
