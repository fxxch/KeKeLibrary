//
//  NSFileManager+KKCategory.m
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import "NSFileManager+KKCategory.h"
#import "KKLog.h"
#import "NSString+KKCategory.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSFileManager (KKCategory)

#pragma mark ==================================================
#pragma mark == 沙盒路径
#pragma mark ==================================================
+ (NSString*_Nonnull)kk_documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*_Nonnull)kk_libraryDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*_Nonnull)kk_cachesDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*_Nonnull)kk_temporaryDirectory{
    NSString *documentsDirectory = NSTemporaryDirectory();
    return documentsDirectory;
}

/**
 【文件夹里面：所有子目录列表】
 @param path 文件夹完整路径
 @return 返回所有子目录列表
 */
+ (NSArray*_Nonnull)kk_subDirectoryListAtDirectory:(NSString*_Nullable)path{
    NSMutableArray *directoryArrary = [NSMutableArray array];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //fileArrary便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];

    BOOL isDirectory = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *directory in fileList) {
        NSString *filePath = [path stringByAppendingPathComponent:directory];
        [fileManager fileExistsAtPath:filePath isDirectory:(&isDirectory)];
        if (isDirectory) {
            [directoryArrary addObject:directory];
        }
        isDirectory = NO;
    }

    return directoryArrary;
}

/**
 【文件夹里面：所有文件列表】
 @param path 文件夹完整路径
 @return 返回所有文件列表
 */
+ (NSArray*_Nonnull)kk_fileListAtDirectory:(NSString*_Nullable)path{
    NSMutableArray *fileArrary = [NSMutableArray array];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //fileArrary便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];

    BOOL isDirectory = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *filePath = [path stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:filePath isDirectory:(&isDirectory)];
        if (isDirectory) {
        }
        else{
            [fileArrary addObject:file];
        }
        isDirectory = NO;
    }
    return fileArrary;
}

#pragma mark ==================================================
#pragma mark == 文件类型【大类】
#pragma mark ==================================================
/* 图片类 */
+ (BOOL)kk_isFileType_IMG:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"png"] ||
        [[fileExtention lowercaseString] isEqualToString:@"jpg"] ||
        [[fileExtention lowercaseString] isEqualToString:@"bmp"] ||
        [[fileExtention lowercaseString] isEqualToString:@"gif"] ||
        [[fileExtention lowercaseString] isEqualToString:@"jpeg"]||
        [[fileExtention lowercaseString] isEqualToString:@"tiff"]) {
        return YES;
    }
    else{
        return NO;
    }
}

/* 视频类 */
+ (BOOL)kk_isFileType_VIDEO:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"mov"] ||
        [[fileExtention lowercaseString] isEqualToString:@"mp4"] ||
        [[fileExtention lowercaseString] isEqualToString:@"flv"] ||
        [[fileExtention lowercaseString] isEqualToString:@"avi"] ||
        [[fileExtention lowercaseString] isEqualToString:@"mkv"] ||
        [[fileExtention lowercaseString] isEqualToString:@"rm"] ||
        [[fileExtention lowercaseString] isEqualToString:@"rmvb"] ||
        [[fileExtention lowercaseString] isEqualToString:@"wmv"] ||
        [[fileExtention lowercaseString] isEqualToString:@"mpeg"] ||
        [[fileExtention lowercaseString] isEqualToString:@"mpg"] ||
        [[fileExtention lowercaseString] isEqualToString:@"3gp"]) {
        return YES;
    }
    else{
        return NO;
    }
}

/* 音频类 */
+ (BOOL)kk_isFileType_AUDIO:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"mp3"] ||
        [[fileExtention lowercaseString] isEqualToString:@"wma"] ||
        [[fileExtention lowercaseString] isEqualToString:@"aac"] ||
        [[fileExtention lowercaseString] isEqualToString:@"mid"] ||
        [[fileExtention lowercaseString] isEqualToString:@"flac"] ||
        [[fileExtention lowercaseString] isEqualToString:@"ape"] ||
        [[fileExtention lowercaseString] isEqualToString:@"ogg"] ||
        [[fileExtention lowercaseString] isEqualToString:@"wav"] ||
        [[fileExtention lowercaseString] isEqualToString:@"wave"] ||
        [[fileExtention lowercaseString] isEqualToString:@"amr"] ||
        [[fileExtention lowercaseString] isEqualToString:@"m4a"]) {
        return YES;
    }
    else{
        return NO;
    }
}

/* 文档类 */
+ (BOOL)kk_isFileType_Office:(NSString*_Nullable)fileExtention{
    if ([NSFileManager kk_isFileType_MicrosoftOffice:fileExtention] ||
        [NSFileManager kk_isFileType_AppleOffice:fileExtention] ||
        [NSFileManager kk_isFileType_OtherOffice:fileExtention] ) {
        return YES;
    }
    else{
        return NO;
    }

}

+ (BOOL)kk_isFileType_MicrosoftOffice:(NSString*_Nullable)fileExtention{
    //微软的
    if ([NSFileManager kk_isFileType_PPT:fileExtention] ||
        [NSFileManager kk_isFileType_DOC:fileExtention] ||
        [NSFileManager kk_isFileType_XLS:fileExtention] ) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)kk_isFileType_AppleOffice:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"rtf"] ||
        [[fileExtention lowercaseString] isEqualToString:@"rtfd"] ) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)kk_isFileType_OtherOffice:(NSString*_Nullable)fileExtention{
    if ([NSFileManager kk_isFileType_PDF:fileExtention] ||
        [NSFileManager kk_isFileType_TXT:fileExtention] ||
        [[fileExtention lowercaseString] isEqualToString:@"wps"]) {
        return YES;
    } else {
        return NO;
    }
}

/* 压缩包类 */
+ (BOOL)kk_isFileType_ZIP:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"zip"] ||
        [[fileExtention lowercaseString] isEqualToString:@"rar"]) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark ==================================================
#pragma mark == 文件类型【子类】
#pragma mark ==================================================
+ (BOOL)kk_isFileType_DOC:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"doc"] ||
        [[fileExtention lowercaseString] isEqualToString:@"docx"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)kk_isFileType_PPT:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"ppt"] ||
        [[fileExtention lowercaseString] isEqualToString:@"pptx"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)kk_isFileType_XLS:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"xls"] ||
        [[fileExtention lowercaseString] isEqualToString:@"xlsx"] ||
        [[fileExtention lowercaseString] isEqualToString:@"csv"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)kk_isFileType_PDF:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"pdf"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)kk_isFileType_TXT:(NSString*_Nullable)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"txt"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (KKFileType)kk_fileTypeAtPath:(NSString*_Nullable)aFilePath{
    NSString *fileExtention = [aFilePath pathExtension];
    if ([NSFileManager kk_isFileType_DOC:fileExtention]) {
        return KKFileType_doc;
    }
    else if ([NSFileManager kk_isFileType_PPT:fileExtention]) {
        return KKFileType_ppt;
    }
    else if ([NSFileManager kk_isFileType_XLS:fileExtention]) {
        return KKFileType_xls;
    }
    else if ([NSFileManager kk_isFileType_IMG:fileExtention]) {
        return KKFileType_img;
    }
    else if ([NSFileManager kk_isFileType_VIDEO:fileExtention]) {
        return KKFileType_video;
    }
    else if ([NSFileManager kk_isFileType_AUDIO:fileExtention]) {
        return KKFileType_audio;
    }
    else if ([NSFileManager kk_isFileType_PDF:fileExtention]) {
        return KKFileType_pdf;
    }
    else if ([NSFileManager kk_isFileType_TXT:fileExtention]) {
        return KKFileType_txt;
    }
    else if ([NSFileManager kk_isFileType_ZIP:fileExtention]) {
        return KKFileType_zip;
    }
    else {
        return KKFileType_UnKnown;
    }
}

#pragma mark ==================================================
#pragma mark == 文件大小格式化
#pragma mark ==================================================
/**
 @brief 格式化文件的大小
 @discussion 例如：将1024byte 转换成1KB
 @param aFileSize 文件的大小，单位byte
 */
+ (NSString*_Nonnull)kk_fileSizeStringFormat:(CGFloat)aFileSize{

    long long KB = 1024;
    long long MB = 1024*1024;
    long long GB = 1024*1024*1024;

    if (aFileSize < KB) {
        return [NSString stringWithFormat:@"%ldByte",(long)aFileSize];
    }
    else if (aFileSize >= KB && aFileSize < MB){
        return [NSString stringWithFormat:@"%.1fKB",(aFileSize/KB)];
    }
    else if (aFileSize >= MB && aFileSize < GB){
        return [NSString stringWithFormat:@"%.1fMB",(aFileSize/MB)];
    }
    else{
        return [NSString stringWithFormat:@"%.1fGB",(aFileSize/GB)];
    }
}

#pragma mark ==================================================
#pragma mark == 文件与文件夹操作
#pragma mark ==================================================
+ (BOOL)kk_deleteFileAtPath:(NSString*_Nullable)aFilePath{
    if ([NSString kk_isStringEmpty:aFilePath]) {
        return NO;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if([fileManager fileExistsAtPath:aFilePath]){
        BOOL result = [fileManager removeItemAtPath:aFilePath error:&error];
        if (result) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return YES;
    }
}

+ (BOOL)kk_deleteDirectoryAtPath:(NSString*_Nullable)aDirectoryPath{
    if ([NSString kk_isStringEmpty:aDirectoryPath]) {
        return NO;
    }
    BOOL isDirectory = YES;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if([fileManager fileExistsAtPath:aDirectoryPath isDirectory:&isDirectory]){
        BOOL result = [fileManager removeItemAtPath:aDirectoryPath error:&error];
        if (result) {
            return YES;
        }
        else{
            KKLogErrorFormat(@"%@",KKValidString([error localizedDescription]));
            return NO;
        }
    }
    else{
        return YES;
    }
}

/**
 @brief 计算文件的大小
 @discussion 计算文件的大小
 @param filePath 文件的完整路径【例如：/var/………………/KKLibraryTempFile/PNG/aa.png 】
 @return 函数调用成功 返回文件有多少Byte
 */
+ (long long)kk_fileSizeAtPath:(NSString*_Nullable)filePath{
    if ([NSString kk_isStringEmpty:filePath]) {
        return 0;
    }

    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSError *error = nil;
        NSDictionary *dic = [manager attributesOfItemAtPath:filePath error:&error];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            return [dic fileSize];
        }
        else{
            KKLogErrorFormat(@"%@",KKValidString([error localizedDescription]));
            return 0;
        }
    }
    return 0;
}

/**
 @brief 计算文件夹的大小
 @discussion 计算文件夹的大小
 @param directoryPath 文件夹的完整路径【例如：/var/………………/KKLibraryTempFile/PNG 】
 */
+ (void)kk_directorySizeAtPath:(NSString*_Nullable)directoryPath completed:(KKComputeFolderSizeCompletedBlock)completedBlock{
    if ([NSString kk_isStringEmpty:directoryPath]) {
        if (completedBlock) {
            completedBlock(0);
        }
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:directoryPath]) {
            KKLogError(@"文件夹不存在");
            completedBlock(0);
        }

        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:directoryPath] objectEnumerator];
        NSString* fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [directoryPath stringByAppendingPathComponent:fileName];
            folderSize += [NSFileManager kk_fileSizeAtPath:fileAbsolutePath];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (completedBlock) {
                completedBlock(folderSize);
            }
        });
    });
}

/**
 @brief 期望在将某个文件保存到指定文件夹下面，如果已经存在改文件名，则会添加（1），再返回改文件名
 @discussion 例如：将 happy.jpg 保存在某文件夹下面，已经存在，就会自动更名为 happy(1).jpg
 @param aFileName 文件名
 @param aFilePath 保存的路径
 @return 返回真实的文件名
*/
+ (NSString*_Nullable)kk_realFileNameForExpectFileName:(NSString*_Nullable)aFileName inPath:(NSString*_Nullable)aFilePath{
    
    if ([NSString kk_isStringEmpty:aFileName] ||
        [NSString kk_isStringEmpty:aFilePath] ) {
        KKLogError(@"传入文件名错误，或者路径错误");
        return nil;
    }
    
    NSString *fileNameResult = [NSString stringWithFormat:@"%@",aFileName];
    NSString *aExtension = [fileNameResult pathExtension];
    NSString *fileNameShort = [fileNameResult kk_fileNameWithOutExtention];

    if ([NSString kk_isStringEmpty:fileNameResult] ||
        [NSString kk_isStringEmpty:aExtension]  ||
        [NSString kk_isStringEmpty:fileNameShort] ) {
        KKLogError(@"传入文件名格式错误，或者路径错误");
        return nil;
    }

    //文件完整目录
    NSString *fileFullPath = [aFilePath stringByAppendingPathComponent:fileNameResult];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fileFullPath]) {
        for (NSInteger i=1; i<1000; i++) {
            fileNameResult = [NSString stringWithFormat:@"%@(%ld).%@",fileNameShort,(long)i,aExtension];
            fileFullPath = [aFilePath stringByAppendingPathComponent:fileNameResult];
            if ([fileManager fileExistsAtPath:fileFullPath]) {
                continue;
            }
            else{
                break;
            }
        }
    }
    return fileNameResult;
}

#pragma mark ==================================================
#pragma mark == 获取视频第一帧
#pragma mark ==================================================
+ (UIImage*_Nullable)kk_getVideoPreViewImageWithURL:(NSURL*_Nullable)aURL{
    if (aURL==nil) {
        return nil;
    }
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

#pragma mark ==================================================
#pragma mark == 获取视频的角度
#pragma mark ==================================================
+ (NSUInteger)kk_degressFromVideoFileWithURL:(NSURL*_Nullable)url{
    NSUInteger degress = 0;
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

@end
