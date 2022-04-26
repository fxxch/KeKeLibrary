//
//  NSFileManager+KKCategory.h
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  文件类型
 */
typedef NS_ENUM(NSInteger, KKFileType){
    KKFileType_UnKnown = 0,//未知
    KKFileType_doc     = 1,//doc
    KKFileType_ppt     = 2,//ppt
    KKFileType_xls     = 3,//xls
    KKFileType_img     = 4,//img
    KKFileType_video   = 5,//video
    KKFileType_audio   = 6,//audio
    KKFileType_pdf     = 7,//pdf
    KKFileType_txt     = 8,//txt
    KKFileType_zip     = 9,//zip
};

typedef void(^KKComputeFolderSizeCompletedBlock)(float dataSize);

@interface NSFileManager (KKCategory)

#pragma mark ==================================================
#pragma mark == 沙盒路径
#pragma mark ==================================================
+ (NSString*_Nonnull)kk_documentsDirectory;

+ (NSString*_Nonnull)kk_libraryDirectory;

+ (NSString*_Nonnull)kk_cachesDirectory;

+ (NSString*_Nonnull)kk_temporaryDirectory;

/**
 【文件夹里面：所有子目录列表】
 @param path 文件夹完整路径
 @return 返回所有子目录列表
 */
+ (NSArray*_Nonnull)kk_subDirectoryListAtDirectory:(NSString*_Nullable)path;

/**
 【文件夹里面：所有文件列表】
 @param path 文件夹完整路径
 @return 返回所有文件列表
 */
+ (NSArray*_Nonnull)kk_fileListAtDirectory:(NSString*_Nullable)path;

#pragma mark ==================================================
#pragma mark == 文件类型【大类】
#pragma mark ==================================================
/* 图片类 */
+ (BOOL)kk_isFileType_IMG:(NSString*_Nullable)fileExtention;

/* 视频类 */
+ (BOOL)kk_isFileType_VIDEO:(NSString*_Nullable)fileExtention;

/* 音频类 */
+ (BOOL)kk_isFileType_AUDIO:(NSString*_Nullable)fileExtention;

/* 文档类 */
+ (BOOL)kk_isFileType_Office:(NSString*_Nullable)fileExtention;

+ (BOOL)kk_isFileType_MicrosoftOffice:(NSString*_Nullable)fileExtention;

+ (BOOL)kk_isFileType_AppleOffice:(NSString*_Nullable)fileExtention;

+ (BOOL)kk_isFileType_OtherOffice:(NSString*_Nullable)fileExtention;

/* 压缩包类 */
+ (BOOL)kk_isFileType_ZIP:(NSString*_Nullable)fileExtention;

#pragma mark ==================================================
#pragma mark == 文件类型【子类】
#pragma mark ==================================================
+ (BOOL)kk_isFileType_DOC:(NSString*_Nullable)fileExtention;

+ (BOOL)kk_isFileType_PPT:(NSString*_Nullable)fileExtention;

+ (BOOL)kk_isFileType_XLS:(NSString*_Nullable)fileExtention;

+ (BOOL)kk_isFileType_PDF:(NSString*_Nullable)fileExtention;

+ (BOOL)kk_isFileType_TXT:(NSString*_Nullable)fileExtention;

+ (KKFileType)kk_fileTypeAtPath:(NSString*_Nullable)aFilePath;

#pragma mark ==================================================
#pragma mark == 文件大小格式化
#pragma mark ==================================================
/**
 @brief 格式化文件的大小
 @discussion 例如：将1024byte 转换成1KB
 @param aFileSize 文件的大小，单位byte
 */
+ (NSString*_Nonnull)kk_fileSizeStringFormat:(CGFloat)aFileSize;

#pragma mark ==================================================
#pragma mark == 文件与文件夹操作
#pragma mark ==================================================
+ (BOOL)kk_deleteFileAtPath:(NSString*_Nullable)aFilePath;

+ (BOOL)kk_deleteDirectoryAtPath:(NSString*_Nullable)aDirectoryPath;

/**
 @brief 计算文件的大小
 @discussion 计算文件的大小
 @param filePath 文件的完整路径【例如：/var/………………/KKLibraryTempFile/PNG/aa.png 】
 @return 函数调用成功 返回文件有多少Byte
 */
+ (long long)kk_fileSizeAtPath:(NSString*_Nullable)filePath;

/**
 @brief 计算文件夹的大小
 @discussion 计算文件夹的大小
 @param directoryPath 文件夹的完整路径【例如：/var/………………/KKLibraryTempFile/PNG 】
 */
+ (void)kk_directorySizeAtPath:(NSString*_Nullable)directoryPath completed:(KKComputeFolderSizeCompletedBlock _Nonnull )completedBlock;

/**
 @brief 期望在将某个文件保存到指定文件夹下面，如果已经存在改文件名，则会添加（1），再返回改文件名
 @discussion 例如：将 happy.jpg 保存在某文件夹下面，已经存在，就会自动更名为 happy(1).jpg
 @param aFileName 文件名
 @param aFilePath 保存的路径
 @return 返回真实的文件名
*/
+ (NSString*_Nullable)kk_realFileNameForExpectFileName:(NSString*_Nullable)aFileName inPath:(NSString*_Nullable)aFilePath;

#pragma mark ==================================================
#pragma mark == 获取视频第一帧
#pragma mark ==================================================
+ (UIImage*_Nullable)kk_getVideoPreViewImageWithURL:(NSURL*_Nullable)aURL;

#pragma mark ==================================================
#pragma mark == 获取视频的角度
#pragma mark ==================================================
+ (NSUInteger)kk_degressFromVideoFileWithURL:(NSURL*_Nullable)url;

@end
