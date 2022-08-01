//
//  KKFileCacheManager.h
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**缓存文件的沙盒路径不能保存起来下次直接使用，因为这个沙盒路径下次有可能改变，一定要使用directoryPathInCachesDirectory+文件名的方式找到文件。
 例如：第一次directoryPathInCachesDirectory路径是 /var/………………/SDJKAHDJKAJNAGDAJDAK/KKLibraryTempFile/Image/aa.png
 此时这个路径不能保存起来下次使用，因为下次使用的时候，这个directoryPathInCachesDirectory的路径就不是/var/………………/SDJKAHDJKAJNAGDAJDAK/KKLibraryTempFile/了，也就是说SDJKAHDJKAJNAGDAJDAK这个沙河路径会改变的。我们只能记住这个aa.png，然后动态读取directoryPathInCachesDirectory路径，加上aa.png，才能找到图片
 */

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

@interface KKFileCacheManager : NSObject


@property (strong, nonatomic) NSCache *_Nonnull memoryCacheImage;
@property (strong, nonatomic) NSCache *_Nonnull memoryCacheData;


+ (KKFileCacheManager *_Nonnull)defaultManager;

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
 @param aFileFullName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @return 函数调用成功返回 文件完整路径
 */
+ (NSString*_Nullable)createFilePathInCacheDirectory:(NSString*_Nullable)aCacheDirectory
                                        fileFullName:(NSString*_Nullable)aFileFullName;


/**
 将Data保存到本地
 @param data 文件二进制数据
 @param aCacheDirectory 存储与哪个目录（
 KKFileCacheManager_CacheDirectoryOfWebImage、
 KKFileCacheManager_CacheDirectoryOfAlbumImage、
 KKFileCacheManager_CacheDirectoryOfCameraImage，
 也可自定义）
 @param aDisplayFullName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @param aRemoteURL 文件的远程URL字符串
 @param aDataInformation 文件信息
 @return 函数调用成功返回 结果
 */
+ (BOOL)saveData:(NSData*_Nullable)data toCacheDirectory:(NSString*_Nullable)aCacheDirectory
 displayFullName:(NSString*_Nullable)aDisplayFullName
      identifier:(NSString*_Nullable)aIdentifier
       remoteURL:(NSString*_Nullable)aRemoteURL
 dataInformation:(NSDictionary*_Nullable)aDataInformation;

/**
 将某个文件拷贝保存到本地
 @param aOriginFilePath 原文件路径
 @param aCacheDirectory 存储与哪个目录（
 KKFileCacheManager_CacheDirectoryOfWebImage、
 KKFileCacheManager_CacheDirectoryOfAlbumImage、
 KKFileCacheManager_CacheDirectoryOfCameraImage，
 也可自定义）
 @param aDisplayFullName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @param aRemoteURL 文件的远程URL字符串
 @param aDataInformation 文件信息
 @return 函数调用成功返回 结果
 */
+ (BOOL)saveFileInPath:(NSString*_Nullable)aOriginFilePath
      toCacheDirectory:(NSString*_Nullable)aCacheDirectory
       displayFullName:(NSString*_Nullable)aDisplayFullName
            identifier:(NSString*_Nullable)aIdentifier
             remoteURL:(NSString*_Nullable)aRemoteURL
       dataInformation:(NSDictionary*_Nullable)aDataInformation;

/**
 将Data保存到本地
 @param data 文件二进制数据
 @param aCacheDirectory 存储与哪个目录（KKFileCacheManager_CacheDirectoryOfWebImage、KKFileCacheManager_CacheDirectoryOfAlbumImage、KKFileCacheManager_CacheDirectoryOfCameraImage，也可自定义）
 @param aDisplayFullName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @param aDataInformation 文件信息
 @return 文件标示符 (一般是文件的远程URL字符串)
 */
+ (NSString*_Nullable)saveData:(NSData*_Nullable)data toCacheDirectory:(NSString*_Nullable)aCacheDirectory
               displayFullName:(NSString*_Nullable)aDisplayFullName
               dataInformation:(NSDictionary*_Nullable)aDataInformation;

/**
 将某个文件拷贝保存到本地
 @param aOriginFilePath 原文件路径
 @param aCacheDirectory 存储与哪个目录（KKFileCacheManager_CacheDirectoryOfWebImage、KKFileCacheManager_CacheDirectoryOfAlbumImage、KKFileCacheManager_CacheDirectoryOfCameraImage，也可自定义）
 @param aDisplayFullName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @param aDataInformation 文件信息
 @return 文件标示符 (一般是文件的远程URL字符串)
 */
+ (NSString*_Nullable)saveFileInPath:(NSString*_Nullable)aOriginFilePath
                    toCacheDirectory:(NSString*_Nullable)aCacheDirectory
                     displayFullName:(NSString*_Nullable)aDisplayFullName
                     dataInformation:(NSDictionary*_Nullable)aDataInformation;

/**
 判断缓存文件是否存在
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 结果
 */
+ (BOOL)isExistCacheData:(NSString*_Nullable)aIdentifier;

/**
 获取缓存文件路径
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 文件路径
 */
+ (NSString*_Nullable)cacheDataPath:(NSString*_Nullable)aIdentifier;

/**
 获取缓存文件信息
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 文件信息
 */
+ (NSDictionary*_Nullable)cacheDataInformation:(NSString*_Nullable)aIdentifier;

/**
 读取缓存数据Data
 @param aIdentifier 文件标示符
 @return 函数调用成功返回缓存数据
 */
+ (NSData*_Nullable)readCacheData:(NSString*_Nullable)aIdentifier;

+ (BOOL)deleteCacheData:(NSString*_Nullable)aIdentifier;

/**
 删除所有缓存数据
 */
+ (BOOL)deleteCacheDataAll;

/**
 删除某个缓存文件夹下面的所有缓存数据
 @param aCacheDirectory 文件夹名称【例如：Web_Image、Album_Image…… 】
 */
+ (BOOL)deleteCacheDataInCacheDirectory:(NSString*_Nullable)aCacheDirectory;


#pragma mark ==================================================
#pragma mark == 文件与文件夹操作
#pragma mark ==================================================
/**
 @brief 创建一个随机的文件名【例如：YYYYMMdd_HHmmss_SSS????】
 @discussion 其中YYYYMMdd是"年月日",HHmmss是"时分秒",SSS是毫秒,????是一个0-1000的四位随机数整数)
 @return 函数调用成功返回创建的文件名
 */
+ (NSString*_Nonnull)createRandomFileName;

/// 返回KKLibraryTempFile的某个文件夹完整目录
/// @param aDirectoryName 文件夹名称
+ (NSString*_Nonnull)kkCacheDirectoryFullPath:(NSString*_Nullable)aDirectoryName;

/// 删除某个目录
/// @param aDirectoryName 文件夹名称
+ (void)deleteCacheDirectory:(NSString*_Nullable)aDirectoryName;

#pragma mark ==================================================
#pragma mark == 项目特殊需求【只清除 KKFileCacheManager_CacheDirectoryOfWebImage】
#pragma mark ==================================================
+ (NSString*_Nonnull)webCachePath;

+ (void)deleteWebCacheData;



@end
