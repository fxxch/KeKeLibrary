//
//  KKFileCacheManager.h
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  产品类型
 */
typedef NS_ENUM(NSInteger, KKFileType){
    KKFileType_UnKnown = 0,//未知
    KKFileType_doc = 1,//doc
    KKFileType_ppt = 2,//ppt
    KKFileType_xls = 3,//xls
    KKFileType_img = 3,//img
    KKFileType_video = 4,//video
    KKFileType_audio = 5,//audio
    KKFileType_pdf = 6,//pdf
    KKFileType_txt = 7,//txt
    KKFileType_zip = 8,//zip
};

/**缓存文件的沙盒路径不能保存起来下次直接使用，因为这个沙盒路径下次有可能改变，一定要使用directoryPathInCachesDirectory+文件名的方式找到文件。
 例如：第一次directoryPathInCachesDirectory路径是 /var/………………/SDJKAHDJKAJNAGDAJDAK/KKLibraryTempFile/Image/aa.png
 此时这个路径不能保存起来下次使用，因为下次使用的时候，这个directoryPathInCachesDirectory的路径就不是/var/………………/SDJKAHDJKAJNAGDAJDAK/KKLibraryTempFile/了，也就是说SDJKAHDJKAJNAGDAJDAK这个沙河路径会改变的。我们只能记住这个aa.png，然后动态读取directoryPathInCachesDirectory路径，加上aa.png，才能找到图片
 */

typedef NS_ENUM(NSInteger, KKActivityIndicatorViewStyle) {
    KKActivityIndicatorViewStyleWhiteLarge = UIActivityIndicatorViewStyleWhiteLarge,
    KKActivityIndicatorViewStyleWhite  = UIActivityIndicatorViewStyleWhite,
    KKActivityIndicatorViewStyleGray = UIActivityIndicatorViewStyleGray,
    KKActivityIndicatorViewStyleNone = NSNotFound,
};

typedef NS_OPTIONS(NSUInteger, KKControlState) {
    KKControlStateNormal      = UIControlStateNormal,
    KKControlStateHighlighted = UIControlStateHighlighted,
    KKControlStateDisabled    = UIControlStateDisabled,
    KKControlStateSelected    = UIControlStateSelected,
    KKControlStateApplication = UIControlStateApplication,
    KKControlStateReserved    = UIControlStateReserved,
    KKControlStateNone        = NSNotFound
};

#define KKFileCacheManager_PlistFileName               @"KKFileCacheManager_Plist"


//====================各种缓存目录====================
/*----------KKLibraryTempFile
 ---------------Web_Image
 -------------------------PNG
 -------------------------JPG
 -------------------------PDF
 ---------------Album_Image
 -------------------------PNG
 -------------------------JPG
 -------------------------PDF
 ---------------Camera_Video
 -------------------------PNG
 -------------------------JPG
 -------------------------PDF
 */
/*所有缓存目录的根目录*/
#define KKFileCacheManager_CacheDirectoryOfRoot        @"KKLibraryTempFile"
/*网络下载的图片将保存在这个目录*/
#define KKFileCacheManager_CacheDirectoryOfWebImage    @"Web_Image"
/*从本地相册选择的图片将保存在这个目录*/
#define KKFileCacheManager_CacheDirectoryOfAlbumImage  @"Album_Image"
/*从本地相册选择的视频将保存在这个目录*/
#define KKFileCacheManager_CacheDirectoryOfAlbumVideo  @"Album_Video"
/*从相机拍摄的照片将保存在这个目录*/
//#define KKFileCacheManager_CacheDirectoryOfCameraImage @"Camera_Image"
/*从相机拍摄的视频将保存在这个目录*/
#define KKFileCacheManager_CacheDirectoryOfCameraVideo @"Camera_Video"
/*缓存文件临时目录*/
//#define KKFileCacheManager_CacheDirectoryOfReadTemp    @"CacheDirectoryOfReadTemp"
/*网络文件（doc、xls、ppt、txt、pdf、音频、视频、图片文件等）*/
#define KKFileCacheManager_CacheDirectoryOfWebDocument @"Web_Document"



//====================缓存文件的配置字段====================
/* 所处的文件夹类型Web_Image、Album_Image…… */
#define KKFileCacheManager_FileKey_CacheDirectory  @"CacheDirectory"
/* 文件扩展名（PNG、MP4、pdf…………）*/
#define KKFileCacheManager_FileKey_Extention       @"Extention"
/* 本地文件名(20141212_094434_123999) */
#define KKFileCacheManager_FileKey_LocalName       @"LocalName"
/* 本地文件名(20141212_094434_123999.png) */
#define KKFileCacheManager_FileKey_LocalFullName   @"LocalFullName"
/* 远程文件名/显示的文件名(国庆出游.png) */
#define KKFileCacheManager_FileKey_DisplayName     @"DisplayName"
/* 文件标示符（一般是文件的远程URL字符串）*/
#define KKFileCacheManager_FileKey_Identifier      @"Identifier"
/* 文件的PHAsset信息（如果此文件是来自手机相册的话，会有此字段，其他情况下此字段为nil）*/
#define KKFileCacheManager_FileKey_PHAsset         @"PHAsset"
/* 文件信息（扩展字段）*/
#define KKFileCacheManager_FileKey_Information     @"Information"


typedef void(^KKImageLoadCompletedBlock)(NSData *imageData, NSError *error,BOOL isFromRequest);
typedef void(^KKComputeFolderSizeCompletedBlock)(float dataSize);

@interface KKFileCacheManager : NSObject


@property (strong, nonatomic) NSCache *memoryCacheImage;
@property (strong, nonatomic) NSCache *memoryCacheData;


+ (KKFileCacheManager *)defaultManager;

#pragma mark ==================================================
#pragma mark == 沙盒路径
#pragma mark ==================================================
/**
 【Documents（Documents）目录】
 @return 完整目录路径
 */
+ (NSString*)documentsDirectory;

/**
 【Library（Library）目录】
 @return 完整目录路径
 */
+ (NSString*)libraryDirectory;

/**
 【Caches（Library/Caches）目录】
 @return 完整目录路径
 */
+ (NSString*)cachesDirectory;

/**
 【Temporary（tmp）目录】
 @return 完整目录路径
 */
+ (NSString*)temporaryDirectory;

/**
 【文件夹里面：所有子目录列表】
 @param path 文件夹完整路径
 @return 返回所有子目录列表
 */
+ (NSArray*)subDirectoryListAtDirectory:(NSString*)path;

/**
 【文件夹里面：所有文件列表】
 @param path 文件夹完整路径
 @return 返回所有文件列表
 */
+ (NSArray*)fileListAtDirectory:(NSString*)path;


#pragma mark ==================================================
#pragma mark == 缓存操作
#pragma mark ==================================================
/**
 创建一个临时文件路径
 @param aCacheDirectory 存储于哪个目录（
 KKFileCacheManager_CacheDirectoryOfWebImage、
 KKFileCacheManager_CacheDirectoryOfAlbumImage、
 KKFileCacheManager_CacheDirectoryOfCameraImage，
 也可自定义）
 @param aFileName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @return 函数调用成功返回 文件完整路径
 */
+ (NSString*)createFilePathInCacheDirectory:(NSString*)aCacheDirectory
                                   fileName:(NSString*)aFileName;

/**
 将Data保存到本地
 @param data 文件二进制数据
 @param aCacheDirectory 存储与哪个目录（
 KKFileCacheManager_CacheDirectoryOfWebImage、
 KKFileCacheManager_CacheDirectoryOfAlbumImage、
 KKFileCacheManager_CacheDirectoryOfCameraImage，
 也可自定义）
 @param aExtension 扩展名
 @param aDisplayName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @param aDataInformation 文件信息
 @return 函数调用成功返回 结果
 */
+ (BOOL)saveData:(NSData*)data
toCacheDirectory:(NSString*)aCacheDirectory
   dataExtension:(NSString*)aExtension
     displayName:(NSString*)aDisplayName
      identifier:(NSString*)aIdentifier
 dataInformation:(NSDictionary*)aDataInformation;

/**
 将Data保存到本地
 @param data 文件二进制数据
 @param aCacheDirectory 存储与哪个目录（KKFileCacheManager_CacheDirectoryOfWebImage、KKFileCacheManager_CacheDirectoryOfAlbumImage、KKFileCacheManager_CacheDirectoryOfCameraImage，也可自定义）
 @param aExtension 扩展名
 @param aDisplayName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @param aDataInformation 文件信息
 @return 文件标示符 (一般是文件的远程URL字符串)
 */
+ (NSString*)saveData:(NSData*)data
     toCacheDirectory:(NSString*)aCacheDirectory
        dataExtension:(NSString*)aExtension
          displayName:(NSString*)aDisplayName
      dataInformation:(NSDictionary*)aDataInformation;

/**
 判断缓存文件是否存在
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 结果
 */
+ (BOOL)isExistCacheData:(NSString*)aIdentifier;

/**
 获取缓存文件路径
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 文件路径
 */
+ (NSString*)cacheDataPath:(NSString*)aIdentifier;

/**
 获取缓存文件信息
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 文件信息
 */
+ (NSDictionary*)cacheDataInformation:(NSString*)aIdentifier;

/**
 读取缓存数据Data
 @param aIdentifier 文件标示符
 @return 函数调用成功返回缓存数据
 */
+ (NSData*)readCacheData:(NSString*)aIdentifier;

/**
 删除缓存数据Data
 @param aIdentifier 文件标示符
 @return  函数调用成功返回结果
 */
+ (BOOL)deleteCacheData:(NSString*)aIdentifier;

/**
 删除所有缓存数据
 @return 函数调用成功返回结果
 */
+ (BOOL)deleteCacheDataAll;

/**
 删除某个缓存文件夹下面的所有缓存数据
 @param aCacheDirectory 文件夹名称【例如：Web_Image、Album_Image……】
 @return 函数调用成功返回结果
 */
+ (BOOL)deleteCacheDataInCacheDirectory:(NSString*)aCacheDirectory;

/**
 保存某个文件信息
 @param documentInformation 文档信息
 @param aKey 文档标识符
 */
+ (void)saveDocumentInformation:(NSDictionary*)documentInformation forKey:(NSString*)aKey;

/**
 移除某个文件信息
 @param aKey 文档标识符
 */
+ (void)removeDocumentInformationForKey:(NSString*)aKey;

/**
 所有的缓存文件信息
 @return 函数调用成功返回结果
 */
+ (NSDictionary*)allCacheDocumentInformation;

#pragma mark ==================================================
#pragma mark == 文件与文件夹操作
#pragma mark ==================================================
/**
 创建一个随机的文件名【例如：YYYYMMdd_HHmmss_SSS????】
 其中YYYYMMdd是"年月日",HHmmss是"时分秒",SSS是毫秒,????是一个0-1000的四位随机数整数)
 @return 函数调用成功返回创建的文件名
 */
+ (NSString*)createRandomFileName;

/**
 删除文件
 @param aFilePath 文件的完整路径【例如：/var/………………/KKLibraryTempFile/aa.png 】
 @return 函数调用成功返回结果
 */
+ (BOOL)deleteFileAtPath:(NSString*)aFilePath;


/**
 删除文件夹
 @param aDirectoryPath 文件夹的完整路径【例如：/var/………………/KKLibraryTempFile/PNG 】
 @return 函数调用成功返回结果
 */
+ (BOOL)deleteDirectoryAtPath:(NSString*)aDirectoryPath;


/**
 计算文件的大小
 @param filePath 文件的完整路径【例如：/var/………………/KKLibraryTempFile/PNG/aa.png 】
 @return 返回文件有多少Byte
 */
+ (long long)fileSizeAtPath:(NSString*)filePath;


/**
 计算文件夹的大小
 @param directoryPath 文件夹的完整路径【例如：/var/………………/KKLibraryTempFile/PNG 】
 @param completedBlock 回调块
 */
+ (void)directorySizeAtPath:(NSString*)directoryPath completed:(KKComputeFolderSizeCompletedBlock)completedBlock;

#pragma mark ==================================================
#pragma mark == 文件类型
#pragma mark ==================================================
+ (BOOL)isFileType_DOC:(NSString*)fileExtention;

+ (BOOL)isFileType_PPT:(NSString*)fileExtention;

+ (BOOL)isFileType_XLS:(NSString*)fileExtention;

+ (BOOL)isFileType_IMG:(NSString*)fileExtention;

+ (BOOL)isFileType_VIDEO:(NSString*)fileExtention;

+ (BOOL)isFileType_AUDIO:(NSString*)fileExtention;

+ (BOOL)isFileType_PDF:(NSString*)fileExtention;

+ (BOOL)isFileType_TXT:(NSString*)fileExtention;

+ (BOOL)isFileType_ZIP:(NSString*)fileExtention;

+ (KKFileType)fileTypeAtPath:(NSString*)aFilePath;

/**
 根据文件类型，返回对应的icon图标
 
 @param fileExtention 文件扩展名
 @return icon图片
 */
+ (UIImage*)fileTypeImageLForExtention:(NSString*)fileExtention;

/**
 根据文件类型，返回对应的icon图标
 
 @param fileExtention 文件扩展名
 @return icon图片
 */
+ (UIImage*)fileTypeImageSForExtention:(NSString*)fileExtention;

#pragma mark ==================================================
#pragma mark == 项目特殊需求【只清除 KKFileCacheManager_CacheDirectoryOfWebImage】
#pragma mark ==================================================
+ (NSString*)webCachePath;

+ (void)deleteWebCacheData;

@end
