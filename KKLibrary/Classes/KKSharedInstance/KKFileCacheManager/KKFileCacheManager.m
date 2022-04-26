//
//  KKFileCacheManager.m
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import "KKFileCacheManager.h"
#import "KKUserDefaultsManager.h"
#import "KKCategory.h"
#import "KKSharedInstance.h"
#import "KKLog.h"
#import "KKFileCacheManagerDB.h"

@implementation KKFileCacheManager

- (void)dealloc{
    [self kk_unobserveAllNotification];
}

+ (KKFileCacheManager *_Nonnull)defaultManager{
    
    static KKFileCacheManager *KKFileCacheManager_defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKFileCacheManager_defaultManager =  [[KKFileCacheManager alloc] init];
    });
    return KKFileCacheManager_defaultManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        // Init the memory cache
        NSString *nameData = [NSString stringWithFormat:@"%@.MemoryCacheData",[NSBundle kk_bundleIdentifier]];
        self.memoryCacheData = [[NSCache alloc] init];
        self.memoryCacheData.name = nameData;
        
        NSString *nameImage = [NSString stringWithFormat:@"%@.MemoryCacheImage",[NSBundle kk_bundleIdentifier]];
        self.memoryCacheImage = [[NSCache alloc] init];
        self.memoryCacheImage.name = nameImage;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

- (void)clearMemory{
    [self.memoryCacheData removeAllObjects];
    [self.memoryCacheImage removeAllObjects];
}

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
                                        fileFullName:(NSString*_Nullable)aFileFullName{
    if ([NSString kk_isStringEmpty:aCacheDirectory]) {
        KKLogErrorFormat(@"创建文件失败：aCacheDirectory：%@",KKValidString(aCacheDirectory));
        return nil;
    }
    if ([NSString kk_isStringEmpty:aFileFullName]) {
        KKLogErrorFormat(@"创建文件失败：aFileName：%@",KKValidString(aFileFullName));
        return nil;
    }
    
    NSString *aExtension = [aFileFullName pathExtension];
    if ([NSString kk_isStringEmpty:aExtension]) {
        KKLogErrorFormat(@"缓存文件失败：aExtension：%@",KKValidString(aExtension));
        return nil;
    }
        
    //KK缓存目录
    NSString *kkcachesDirectory = [KKFileCacheManager kkCacheDirectoryFullPath:aCacheDirectory];
    //文件完整目录
    NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@",kkcachesDirectory,[aExtension uppercaseString]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![fileManager contentsOfDirectoryAtPath:fileFullDirectoryPath error:&error]){
        BOOL result = [fileManager createDirectoryAtPath:fileFullDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            KKLogErrorFormat(@"%@",KKValidString([error localizedDescription]));
            return nil;
        }
    }
    
    NSString *expectFileName = [NSFileManager kk_realFileNameForExpectFileName:aFileFullName inPath:fileFullDirectoryPath];
    //文件完整目录
    NSString *fileFullPath = [fileFullDirectoryPath stringByAppendingPathComponent:expectFileName];
    
    return fileFullPath;
}


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
 dataInformation:(NSDictionary*_Nullable)aDataInformation{
    if (!data || [data isKindOfClass:[NSNull class]]) {
        KKLogErrorFormat(@"缓存文件失败：data：%@",KKValidString(data));
        return NO;
    }
    
    if ([NSString kk_isStringEmpty:aCacheDirectory]) {
        KKLogErrorFormat(@"缓存文件失败：aCacheDirectory：%@",KKValidString(aCacheDirectory));
        return NO;
    }
    
    if ([NSString kk_isStringEmpty:aIdentifier]) {
        KKLogErrorFormat(@"缓存文件失败：aIdentifier：%@",KKValidString(aIdentifier));
        return NO;
    }

    if ([NSString kk_isStringEmpty:aDisplayFullName]) {
        KKLogErrorFormat(@"缓存文件失败：aDisplayFullName：%@",KKValidString(aDisplayFullName));
        return NO;
    }

    NSString *aExtension = [aDisplayFullName pathExtension];
    if ([NSString kk_isStringEmpty:aExtension]) {
        KKLogErrorFormat(@"缓存文件失败：aExtension：%@",KKValidString(aExtension));
        return NO;
    }

    NSString *extraInformationJson = @"";
    if ([NSDictionary kk_isDictionaryNotEmpty:aDataInformation]) {
        extraInformationJson = [aDataInformation kk_translateToJSONString];
        if ([NSString kk_isStringEmpty:extraInformationJson]) {
            KKLogErrorFormat(@"缓存文件失败(附加信息不能够转换成json字符串)：aDataInformation：%@",aDataInformation);
            return NO;
        }
    }

    if ([KKFileCacheManager isExistCacheData:aIdentifier]) {
        [KKFileCacheManager deleteCacheData:aIdentifier];
    }
    
    //KK缓存目录
    NSString *kkcachesDirectory = [KKFileCacheManager kkCacheDirectoryFullPath:aCacheDirectory];
    //文件完整目录
    NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@",kkcachesDirectory,[aExtension uppercaseString]];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![fileManager contentsOfDirectoryAtPath:fileFullDirectoryPath error:&error]){
        BOOL result = [fileManager createDirectoryAtPath:fileFullDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            KKLogErrorFormat(@"%@",KKValidString([error localizedDescription]));
            return NO;
        }
    }
    
    NSString *expectFileName = [NSFileManager kk_realFileNameForExpectFileName:aDisplayFullName inPath:fileFullDirectoryPath];
    //文件完整目录
    NSString *fileFullPath = [fileFullDirectoryPath stringByAppendingPathComponent:expectFileName];

    
    if([data writeToFile:fileFullPath atomically:YES]){

        //KK缓存目录
        NSString *kkcachesDirectory = [KKFileCacheManager kkCacheDirectoryFullPath:aCacheDirectory];
        //文件完整目录
        NSString *localPath = [NSString stringWithFormat:@"%@/%@/%@",kkcachesDirectory,[aExtension uppercaseString],expectFileName];

        BOOL result = [KKFileCacheManagerDB saveFileCache_WithIdentifer:KKValidString(aIdentifier)
                                                             remote_url:aRemoteURL
                                                        cache_directory:aCacheDirectory
                                                              extention:aExtension
                                                             local_path:localPath
                                                             local_name:aDisplayFullName
                                                        local_full_name:expectFileName
                                                           display_name:aDisplayFullName
                                                      extra_information:extraInformationJson];
        return result;
    }
    else{
        KKLogError(@"缓存文件失败");
        return NO;
    }
}

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
      dataInformation:(NSDictionary*_Nullable)aDataInformation{
    
    if (!data || [data isKindOfClass:[NSNull class]]) {
        KKLogErrorFormat(@"缓存文件失败：data：%@",KKValidString(data));
        return nil;
    }
    
    if ([NSString kk_isStringEmpty:aCacheDirectory]) {
        KKLogErrorFormat(@"缓存文件失败：aCacheDirectory：%@",KKValidString(aCacheDirectory));
        return nil;
    }

    if ([NSString kk_isStringEmpty:aDisplayFullName]) {
        KKLogErrorFormat(@"缓存文件失败：aDisplayFullName：%@",KKValidString(aDisplayFullName));
        return nil;
    }

    NSString *aExtension = [aDisplayFullName pathExtension];
    if ([NSString kk_isStringEmpty:aExtension]) {
        KKLogErrorFormat(@"缓存文件失败：aExtension：%@",KKValidString(aExtension));
        return nil;
    }

    NSString *extraInformationJson = @"";
    if ([NSDictionary kk_isDictionaryNotEmpty:aDataInformation]) {
        extraInformationJson = [aDataInformation kk_translateToJSONString];
        if ([NSString kk_isStringEmpty:extraInformationJson]) {
            KKLogErrorFormat(@"缓存文件失败(附加信息不能够转换成json字符串)：aDataInformation：%@",aDataInformation);
            return nil;
        }
    }

    //文件标识符 20141212_094434_123999
    NSString *identifier = [KKFileCacheManager createRandomFileName];
    
    NSString *realDisplayName = [aDisplayFullName kk_fileNameWithOutExtention];

    //KK缓存目录
    NSString *kkcachesDirectory = [KKFileCacheManager kkCacheDirectoryFullPath:aCacheDirectory];
    //文件完整目录
    NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@",kkcachesDirectory,[aExtension uppercaseString]];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![fileManager contentsOfDirectoryAtPath:fileFullDirectoryPath error:&error]){
        BOOL result = [fileManager createDirectoryAtPath:fileFullDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
            KKLogErrorFormat(@"%@",KKValidString([error localizedDescription]));
            return nil;
        }
    }
    
    NSString *expectFileName = [NSFileManager kk_realFileNameForExpectFileName:aDisplayFullName inPath:fileFullDirectoryPath];
    //文件完整目录
    NSString *fileFullPath = [fileFullDirectoryPath stringByAppendingPathComponent:expectFileName];
    
    if([data writeToFile:fileFullPath atomically:YES]){
        //KK缓存目录
        NSString *kkcachesDirectory = [KKFileCacheManager kkCacheDirectoryFullPath:aCacheDirectory];
        //文件完整目录
        NSString *localPath = [NSString stringWithFormat:@"%@/%@/%@",kkcachesDirectory,[aExtension uppercaseString],expectFileName];

        BOOL result = [KKFileCacheManagerDB saveFileCache_WithIdentifer:identifier
                                                             remote_url:@""
                                                        cache_directory:aCacheDirectory
                                                              extention:aExtension
                                                             local_path:localPath
                                                             local_name:realDisplayName
                                                        local_full_name:expectFileName
                                                           display_name:aDisplayFullName
                                                      extra_information:extraInformationJson];
        if (result) {
            return identifier;
        } else {
            [NSFileManager.defaultManager removeItemAtPath:fileFullPath error:nil];
            return nil;
        }
    }
    else{
        KKLogError(@"缓存文件失败");
        return nil;
    }
}

/**
 判断缓存文件是否存在
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 结果
 */
+ (BOOL)isExistCacheData:(NSString*_Nullable)aIdentifier{
    if ([NSString kk_isStringNotEmpty:aIdentifier]) {
        NSString *fileFullPath = [KKFileCacheManager cacheDataPath:aIdentifier];
        if (fileFullPath && [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath]) {
//            KKLogInfoFormat(@"KKFileCacheManager缓存存在:  %@",KKValidString(aIdentifier));
            return YES;
        }
        else{
            [NSFileManager.defaultManager removeItemAtPath:fileFullPath error:nil];
            return NO;
        }
    }
    else{
        return NO;
    }
}

/**
 获取缓存文件路径
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 文件路径
 */
+ (NSString*_Nullable)cacheDataPath:(NSString*_Nullable)aIdentifier{
    if ([NSString kk_isStringNotEmpty:aIdentifier]) {

        NSDictionary *document = [KKFileCacheManagerDB DBQuery_KKFileCache_WithIdentifer:aIdentifier];
        if ([NSDictionary kk_isDictionaryNotEmpty:document]) {
            NSString *aCacheDirectory = [document kk_validStringForKey:Table_KKFileCacheManager_cache_directory];
            NSString *aExtension = [document kk_validStringForKey:Table_KKFileCacheManager_extention];
            NSString *aLocalFullName = [document kk_validStringForKey:Table_KKFileCacheManager_local_full_name];

            //KK缓存目录
            NSString *kkcachesDirectory = [KKFileCacheManager kkCacheDirectoryFullPath:aCacheDirectory];
            //文件完整目录
            NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@",kkcachesDirectory,[aExtension uppercaseString]];

            //文件完整目录
            NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@",fileFullDirectoryPath,aLocalFullName];

            if (fileFullPath && [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath]) {
                return fileFullPath;
            }
            else{
                [KKFileCacheManagerDB DBDelete_KKFileCache_WithIdentifer:aIdentifier];
                return nil;
            }
        } else {
            return nil;
        }

}
    else {
        return nil;
    }
}

/**
 获取缓存文件信息
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 文件信息
 */
+ (NSDictionary*_Nullable)cacheDataInformation:(NSString*_Nullable)aIdentifier{
    if ([NSString kk_isStringNotEmpty:aIdentifier]) {
        NSDictionary *document = [KKFileCacheManagerDB DBQuery_KKFileCache_WithIdentifer:aIdentifier];
        return document;
    }
    else{
        return nil;
    }
}

/**
 读取缓存数据Data
 @param aIdentifier 文件标示符
 @return 函数调用成功返回缓存数据
 */
+ (NSData*_Nullable)readCacheData:(NSString*_Nullable)aIdentifier{
    if ([[[KKFileCacheManager defaultManager] memoryCacheData] objectForKey:aIdentifier]) {
        return [[[KKFileCacheManager defaultManager] memoryCacheData] objectForKey:aIdentifier];
    } else {
        NSString *fileFullPath = [KKFileCacheManager cacheDataPath:aIdentifier];
        NSData *data = [NSData dataWithContentsOfFile:fileFullPath];
//        KKLogInfoFormat(@"KKFileCacheManager读取缓存成功:  %@",KKValidString(aIdentifier));
//        [[[KKFileCacheManager defaultManager] memoryCacheData] setObject:data forKey:aIdentifier];
        return data;
    }
}

+ (BOOL)deleteCacheData:(NSString*_Nullable)aIdentifier{
    if ([NSString kk_isStringEmpty:aIdentifier]) {
        return NO;
    }

    [[[KKFileCacheManager defaultManager] memoryCacheData] removeObjectForKey:aIdentifier];
    
    if ([KKFileCacheManager isExistCacheData:aIdentifier]) {
        NSString *fileFullPath = [KKFileCacheManager cacheDataPath:aIdentifier];
        BOOL result = [NSFileManager kk_deleteFileAtPath:fileFullPath];
        if (result) {
            [KKFileCacheManagerDB DBDelete_KKFileCache_WithIdentifer:aIdentifier];
            return YES;
        }
        else{
            KKLogErrorFormat(@"删除缓存图片失败：imageURLString：%@",KKValidString(aIdentifier));
            return NO;
        }
    }
    else{
        KKLogErrorFormat(@"删除缓存图片失败：imageURLString：%@",KKValidString(aIdentifier));
        return NO;
    }
}

/**
 删除所有缓存数据
 */
+ (BOOL)deleteCacheDataAll{
    NSArray *allCache = [KKFileCacheManagerDB allCacheDocumentInformation];
    for (NSInteger i=0; i<[allCache count]; i++) {
        NSString *aIdentifier = [[allCache objectAtIndex:i] kk_validStringForKey:Table_KKFileCacheManager_identifier];
        [KKFileCacheManager deleteCacheData:aIdentifier];
    }
    return YES;
}

/**
 删除某个缓存文件夹下面的所有缓存数据
 @param aCacheDirectory 文件夹名称【例如：Web_Image、Album_Image…… 】
 */
+ (BOOL)deleteCacheDataInCacheDirectory:(NSString*_Nullable)aCacheDirectory{
    if ([NSString kk_isStringEmpty:aCacheDirectory]) {
        return YES;
    }

    NSArray *allCache = [KKFileCacheManagerDB DBQuery_KKFileCache_WithCacheDirectory:aCacheDirectory];
    for (NSInteger i=0; i<[allCache count]; i++) {
        NSString *aIdentifier = [[allCache objectAtIndex:i] kk_validStringForKey:Table_KKFileCacheManager_identifier];
        [KKFileCacheManager deleteCacheData:aIdentifier];
    }

    return YES;
}

#pragma mark ==================================================
#pragma mark == 文件与文件夹操作
#pragma mark ==================================================
/**
 @brief 创建一个随机的文件名【例如：YYYYMMdd_HHmmss_SSS????】
 @discussion 其中YYYYMMdd是"年月日",HHmmss是"时分秒",SSS是毫秒,????是一个0-1000的四位随机数整数)
 @return 函数调用成功返回创建的文件名
 */
+ (NSString*_Nonnull)createRandomFileName{
    //当前时间
    NSDateFormatter *dateFormatter = [NSDateFormatter kk_defaultFormatter];
    [dateFormatter setDateFormat:@"YYYYMMdd_HHmmss_SSS"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    //随机码
    int value = (arc4random() % 1000) + 1;
    NSString *randomCode = [NSString stringWithFormat:@"%04d",value];
    
    NSString *savePathName = [NSString stringWithFormat:@"%@%@",dateStr,randomCode];
    
    return savePathName;
}


/// 返回KKLibraryTempFile的某个文件夹完整目录
/// @param aDirectoryName 文件夹名称
+ (NSString*_Nonnull)kkCacheDirectoryFullPath:(NSString*_Nullable)aDirectoryName{
    //缓存目录
    NSString *cachesDirectory = [NSFileManager kk_cachesDirectory];
    //文件完整目录
    NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachesDirectory,KKFileCacheManager_CacheDirectoryOfRoot,aDirectoryName];
    return fileFullDirectoryPath;
}

/// 删除某个目录
/// @param aDirectoryName 文件夹名称
+ (void)deleteCacheDirectory:(NSString*_Nullable)aDirectoryName{
    //缓存目录
    NSString *cachesDirectory = [KKFileCacheManager kkCacheDirectoryFullPath:aDirectoryName];
    [NSFileManager kk_deleteDirectoryAtPath:cachesDirectory];
}


#pragma mark ==================================================
#pragma mark == 项目特殊需求【只清除 KKFileCacheManager_CacheDirectoryOfWebImage】
#pragma mark ==================================================
+ (NSString*_Nonnull)webCachePath{
    //文件完整目录
    NSString *fileFullDirectoryPath = [KKFileCacheManager kkCacheDirectoryFullPath:KKFileCacheManager_CacheDirectoryOfWebImage];
    return fileFullDirectoryPath;
}

+ (void)deleteWebCacheData{
    [NSFileManager kk_deleteDirectoryAtPath:[KKFileCacheManager webCachePath]];
}



@end
