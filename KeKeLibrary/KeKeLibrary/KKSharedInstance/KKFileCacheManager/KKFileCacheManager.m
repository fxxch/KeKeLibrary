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

@implementation KKFileCacheManager

- (void)dealloc{
    [self unobserveAllNotification];
}

+ (KKFileCacheManager *)defaultManager{
    
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
        NSString *nameData = [NSString stringWithFormat:@"%@.MemoryCacheData",[NSBundle bundleIdentifier]];
        self.memoryCacheData = [[NSCache alloc] init];
        self.memoryCacheData.name = nameData;
        
        NSString *nameImage = [NSString stringWithFormat:@"%@.MemoryCacheImage",[NSBundle bundleIdentifier]];
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
#pragma mark == 沙盒路径
#pragma mark ==================================================
+ (NSString*)documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*)libraryDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*)cachesDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString*)temporaryDirectory{
    NSString *documentsDirectory = NSTemporaryDirectory();
    return documentsDirectory;
}



/**
 【文件夹里面：所有子目录列表】
 @param path 文件夹完整路径
 @return 返回所有子目录列表
 */
+ (NSArray*)subDirectoryListAtDirectory:(NSString*)path{
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
+ (NSArray*)fileListAtDirectory:(NSString*)path{
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
                                   fileName:(NSString*)aFileName{
    if (!aCacheDirectory || [aCacheDirectory isKindOfClass:[NSNull class]] || [aCacheDirectory length]<1) {
#ifdef DEBUG
        NSLog(@"创建文件失败：aCacheDirectory：%@",aCacheDirectory);
#endif
        
        return nil;
    }
    
    if (!aFileName || [aFileName isKindOfClass:[NSNull class]] || [aFileName length]<1) {
#ifdef DEBUG
        NSLog(@"创建文件失败：aFileName：%@",aFileName);
#endif
        
        return nil;
    }
    
    NSString *aExtension = [aFileName pathExtension];

    if (!aExtension || [aExtension isKindOfClass:[NSNull class]] || [aExtension length]<1) {
#ifdef DEBUG
        NSLog(@"缓存文件失败：aExtension：%@",aExtension);
#endif
        
        return nil;
    }
    
    NSString *realDisplayName = [aFileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",[aFileName pathExtension]] withString:@""];
    
    //缓存目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    //文件完整目录
    NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@/%@",cachesDirectory,KKFileCacheManager_CacheDirectoryOfRoot,aCacheDirectory,[aExtension uppercaseString]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![fileManager contentsOfDirectoryAtPath:fileFullDirectoryPath error:&error]){
        BOOL result = [fileManager createDirectoryAtPath:fileFullDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
#ifdef DEBUG
            NSLog(@"%@",[error localizedDescription]);
#endif
            return nil;
        }
    }
    
    //文件完整目录
    NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@.%@",fileFullDirectoryPath,realDisplayName,aExtension];
    
    if ([fileManager fileExistsAtPath:fileFullPath]) {
        for (NSInteger i=0; i<1000; i++) {
            fileFullPath = [NSString stringWithFormat:@"%@/%@(%ld).%@",fileFullDirectoryPath,realDisplayName,(long)i,aExtension];
            
            if ([fileManager fileExistsAtPath:fileFullPath]) {
                continue;
            }
            else{
                break;
            }
        }
    }
    
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
 @param aExtension 扩展名
 @param aDisplayName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @param aDataInformation 文件信息
 @return 函数调用成功返回 结果
 */
+ (BOOL)saveData:(NSData*)data toCacheDirectory:(NSString*)aCacheDirectory
   dataExtension:(NSString*)aExtension
     displayName:(NSString*)aDisplayName
      identifier:(NSString*)aIdentifier
 dataInformation:(NSDictionary*)aDataInformation{
    if (!data || [data isKindOfClass:[NSNull class]]) {
#ifdef DEBUG
        NSLog(@"缓存文件失败：data：%@",data);
#endif
        return NO;
    }
    
    if (!aCacheDirectory || [aCacheDirectory isKindOfClass:[NSNull class]] || [aCacheDirectory length]<1) {
#ifdef DEBUG
        NSLog(@"缓存文件失败：aCacheDirectory：%@",aCacheDirectory);
#endif
        return NO;
    }
    
    if (!aIdentifier || [aIdentifier isKindOfClass:[NSNull class]] || [aIdentifier length]<1) {
#ifdef DEBUG
        NSLog(@"缓存文件失败：aIdentifier：%@",aIdentifier);
#endif
        return NO;
    }
    
    if (!aExtension || [aExtension isKindOfClass:[NSNull class]] || [aExtension length]<1) {
#ifdef DEBUG
        NSLog(@"缓存文件失败：aExtension：%@",aExtension);
#endif
        return NO;
    }
    
    if ([KKFileCacheManager isExistCacheData:aIdentifier]) {
        [KKFileCacheManager deleteCacheData:aIdentifier];
    }
    
    //文件名 20141212_094434_123999
    NSString *realDisplayName = @"";
    if ([NSString isStringNotEmpty:aDisplayName]) {
        realDisplayName = [aDisplayName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",[aDisplayName pathExtension]] withString:@""];
    }
    else{
        if ([[aIdentifier lowercaseString] hasPrefix:@"http"]) {
            NSString *fileName0 = [aIdentifier lastPathComponent];
            realDisplayName = [fileName0 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",[aDisplayName pathExtension]] withString:@""];
        }
        else{
            realDisplayName = [KKFileCacheManager createRandomFileName];
        }
    }

    //缓存目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    //文件完整目录
    NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@/%@",cachesDirectory,KKFileCacheManager_CacheDirectoryOfRoot,aCacheDirectory,[aExtension uppercaseString]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![fileManager contentsOfDirectoryAtPath:fileFullDirectoryPath error:&error]){
        BOOL result = [fileManager createDirectoryAtPath:fileFullDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
#ifdef DEBUG
            NSLog(@"%@",[error localizedDescription]);
#endif
            
            return NO;
        }
    }
    
    //文件完整目录
    NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@.%@",fileFullDirectoryPath,realDisplayName,[aExtension lowercaseString]];
    
    if ([fileManager fileExistsAtPath:fileFullPath]) {
        for (NSInteger i=0; i<1000; i++) {
            fileFullPath = [NSString stringWithFormat:@"%@/%@(%ld).%@",fileFullDirectoryPath,realDisplayName,(long)i,[aExtension lowercaseString]];
            
            if ([fileManager fileExistsAtPath:fileFullPath]) {
                continue;
            }
            else{
                realDisplayName = [NSString stringWithFormat:@"%@(%ld)",realDisplayName,(long)i];
                break;
            }
        }
    }

    
    if([data writeToFile:fileFullPath atomically:YES]){
        NSMutableDictionary *document = [NSMutableDictionary dictionary];
        
        NSString *fileFullName = [NSString stringWithFormat:@"%@.%@",realDisplayName,[aExtension lowercaseString]];

        [document setObject:aCacheDirectory?aCacheDirectory:@"" forKey:KKFileCacheManager_FileKey_CacheDirectory];
        [document setObject:aExtension?aExtension:@"" forKey:KKFileCacheManager_FileKey_Extention];
        [document setObject:realDisplayName?realDisplayName:@"" forKey:KKFileCacheManager_FileKey_LocalName];
        [document setObject:fileFullName?fileFullName:@"" forKey:KKFileCacheManager_FileKey_LocalFullName];
        
        [document setObject:fileFullName?fileFullName:@"" forKey:KKFileCacheManager_FileKey_DisplayName];
        
        [document setObject:aIdentifier?aIdentifier:@"" forKey:KKFileCacheManager_FileKey_Identifier];
        if (aDataInformation) {
            [document setObject:[aDataInformation translateToJSONString] forKey:KKFileCacheManager_FileKey_Information];
        }
        
        [KKFileCacheManager saveDocumentInformation:document forKey:aIdentifier];
        return YES;
    }
    else{
#ifdef DEBUG
        NSLog(@"缓存文件失败");
#endif
        return NO;
    }
}

/**
 将Data保存到本地
 @param data 文件二进制数据
 @param aCacheDirectory 存储与哪个目录（KKFileCacheManager_CacheDirectoryOfWebImage、KKFileCacheManager_CacheDirectoryOfAlbumImage、KKFileCacheManager_CacheDirectoryOfCameraImage，也可自定义）
 @param aExtension 扩展名
 @param aDisplayName 例如：考勤数据表.xls” 仅作参考，如果涉及到重名，可能会变成“考勤数据表(0).xls”
 @param aDataInformation 文件信息
 @return 文件标示符 (一般是文件的远程URL字符串)
 */
+ (NSString*)saveData:(NSData*)data toCacheDirectory:(NSString*)aCacheDirectory
        dataExtension:(NSString*)aExtension
          displayName:(NSString*)aDisplayName
      dataInformation:(NSDictionary*)aDataInformation{
    
    if (!data || [data isKindOfClass:[NSNull class]]) {
#ifdef DEBUG
        NSLog(@"缓存文件失败：data：%@",data);
#endif
        return nil;
    }
    
    if (!aCacheDirectory || [aCacheDirectory isKindOfClass:[NSNull class]] || [aCacheDirectory length]<1) {
#ifdef DEBUG
        NSLog(@"缓存文件失败：aCacheDirectory：%@",aCacheDirectory);
#endif
        
        return nil;
    }
    
    if (!aExtension || [aExtension isKindOfClass:[NSNull class]] || [aExtension length]<1) {
#ifdef DEBUG
        NSLog(@"缓存文件失败：aExtension：%@",aExtension);
#endif
        
        return nil;
    }
    
    //文件标识符 20141212_094434_123999
    NSString *identifier = [KKFileCacheManager createRandomFileName];
    
    NSString *realDisplayName = @"";
    if ([NSString isStringNotEmpty:aDisplayName]) {
        realDisplayName = [aDisplayName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@",[aDisplayName pathExtension]] withString:@""];
    }
    else{
        realDisplayName = identifier;
    }
    
    //缓存目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    //文件完整目录
    NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@/%@",cachesDirectory,KKFileCacheManager_CacheDirectoryOfRoot,aCacheDirectory,[aExtension uppercaseString]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![fileManager contentsOfDirectoryAtPath:fileFullDirectoryPath error:&error]){
        BOOL result = [fileManager createDirectoryAtPath:fileFullDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!result) {
#ifdef DEBUG
            NSLog(@"%@",[error localizedDescription]);
#endif
            
            return nil;
        }
    }
    
    //文件完整目录
    NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@.%@",fileFullDirectoryPath,realDisplayName,[aExtension lowercaseString]];
    
    if ([fileManager fileExistsAtPath:fileFullPath]) {
        for (NSInteger i=0; i<1000; i++) {
            fileFullPath = [NSString stringWithFormat:@"%@/%@(%ld).%@",fileFullDirectoryPath,realDisplayName,(long)i,[aExtension lowercaseString]];
            
            if ([fileManager fileExistsAtPath:fileFullPath]) {
                continue;
            }
            else{
                realDisplayName = [NSString stringWithFormat:@"%@(%ld)",realDisplayName,(long)i];
                break;
            }
        }
    }
    
    if([data writeToFile:fileFullPath atomically:YES]){
        NSMutableDictionary *document = [NSMutableDictionary dictionary];
        
        NSString *fileFullName = [NSString stringWithFormat:@"%@.%@",realDisplayName,[aExtension lowercaseString]];
        
        [document setObject:aCacheDirectory?aCacheDirectory:@"" forKey:KKFileCacheManager_FileKey_CacheDirectory];
        [document setObject:aExtension?aExtension:@"" forKey:KKFileCacheManager_FileKey_Extention];
        [document setObject:realDisplayName?realDisplayName:@"" forKey:KKFileCacheManager_FileKey_LocalName];
        [document setObject:fileFullName?fileFullName:@"" forKey:KKFileCacheManager_FileKey_LocalFullName];
        
        [document setObject:fileFullName?fileFullName:@"" forKey:KKFileCacheManager_FileKey_DisplayName];
        
        [document setObject:identifier?identifier:@"" forKey:KKFileCacheManager_FileKey_Identifier];
        if (aDataInformation) {
            [document setObject:[aDataInformation translateToJSONString] forKey:KKFileCacheManager_FileKey_Information];
        }
        
        [KKFileCacheManager saveDocumentInformation:document forKey:identifier];
        return identifier;
    }
    else{
#ifdef DEBUG
        NSLog(@"缓存文件失败");
#endif
        return nil;
    }
}

/**
 判断缓存文件是否存在
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 结果
 */
+ (BOOL)isExistCacheData:(NSString*)aIdentifier{
    if (aIdentifier && ![aIdentifier isKindOfClass:[NSNull class]]) {
        NSString *fileFullPath = [KKFileCacheManager cacheDataPath:aIdentifier];
        if (fileFullPath && [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath]) {
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

/**
 获取缓存文件路径
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 文件路径
 */
+ (NSString*)cacheDataPath:(NSString*)aIdentifier{
    if (aIdentifier && ![aIdentifier isKindOfClass:[NSNull class]]) {
        
        NSDictionary *plistDictionary = [KKFileCacheManager allCacheDocumentInformation];
        
        if (plistDictionary){
            NSDictionary *document = [plistDictionary objectForKey:aIdentifier];
            if (document) {
                NSString *aCacheDirectory = [document validStringForKey:KKFileCacheManager_FileKey_CacheDirectory];
                NSString *aExtension = [document validStringForKey:KKFileCacheManager_FileKey_Extention];
                NSString *aLocalFullName = [document validStringForKey:KKFileCacheManager_FileKey_LocalFullName];
                
                //缓存目录
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString *cachesDirectory = [paths objectAtIndex:0];
                //文件完整目录
                NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@/%@",cachesDirectory,KKFileCacheManager_CacheDirectoryOfRoot,aCacheDirectory,[aExtension uppercaseString]];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error = nil;
                if(![fileManager contentsOfDirectoryAtPath:fileFullDirectoryPath error:&error]){
                    BOOL result = [fileManager createDirectoryAtPath:fileFullDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error];
                    if (!result) {
#ifdef DEBUG
                        NSLog(@"%@",[error localizedDescription]);
#endif
                        
                        return nil;
                    }
                }
                
                //文件完整目录
                NSString *fileFullPath = [NSString stringWithFormat:@"%@/%@",fileFullDirectoryPath,aLocalFullName];
                
                if (fileFullPath && [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath]) {
                    return fileFullPath;
                }
                else{
                    [KKFileCacheManager removeDocumentInformationForKey:aIdentifier];
                    return nil;
                }
            }
            else{
                return nil;
            }
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

/**
 获取缓存文件信息
 @param aIdentifier 文件标示符 (一般是文件的远程URL字符串)
 @return 函数调用成功返回 文件信息
 */
+ (NSDictionary*)cacheDataInformation:(NSString*)aIdentifier{
    if (aIdentifier && ![aIdentifier isKindOfClass:[NSNull class]]) {
        NSDictionary *plistDictionary = [KKFileCacheManager allCacheDocumentInformation];
        if (plistDictionary){
            NSDictionary *document = [plistDictionary objectForKey:aIdentifier];
            return document;
        }
        else{
            return nil;
        }
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
+ (NSData*)readCacheData:(NSString*)aIdentifier{
    if ([KKFileCacheManager isExistCacheData:aIdentifier]) {
        
        if ([[[KKFileCacheManager defaultManager] memoryCacheData] objectForKey:aIdentifier]) {
            return [[[KKFileCacheManager defaultManager] memoryCacheData] objectForKey:aIdentifier];
        }

        NSString *fileFullPath = [KKFileCacheManager cacheDataPath:aIdentifier];
        NSData *data = [NSData dataWithContentsOfFile:fileFullPath];
        
//        [[[KKFileCacheManager defaultManager] memoryCacheData] setObject:data forKey:aIdentifier];

        return data;
    }
    else{
        return nil;
    }
}



+ (BOOL)deleteCacheData:(NSString*)aIdentifier{
    
    [[[KKFileCacheManager defaultManager] memoryCacheData] removeObjectForKey:aIdentifier];
    
    if ([KKFileCacheManager isExistCacheData:aIdentifier]) {
        NSString *fileFullPath = [KKFileCacheManager cacheDataPath:aIdentifier];
        BOOL result = [KKFileCacheManager deleteFileAtPath:fileFullPath];
        if (result) {
            [KKFileCacheManager removeDocumentInformationForKey:aIdentifier];
            return YES;
        }
        else{
#ifdef DEBUG
            NSLog(@"删除缓存图片失败：imageURLString：%@",aIdentifier);
#endif
            
            return NO;
        }
    }
    else{
#ifdef DEBUG
        NSLog(@"删除缓存图片失败：imageURLString：%@",aIdentifier);
#endif
        
        return NO;
    }
}

/**
 删除所有缓存数据
 @return 函数调用成功返回结果
 */
+ (BOOL)deleteCacheDataAll{
    
    BOOL result = YES;
    
    NSDictionary *plistDictionary = [KKFileCacheManager allCacheDocumentInformation];
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    [newDictionary setValuesForKeysWithDictionary:plistDictionary];
    
    NSArray *allKeys = [newDictionary allKeys];
    for (NSInteger i=0; i<[allKeys count]; i++) {
        NSString *aIdentifier = [allKeys objectAtIndex:i];
        NSString *fileFullPath = [KKFileCacheManager cacheDataPath:aIdentifier];
        
        BOOL result = [KKFileCacheManager deleteFileAtPath:fileFullPath];
        if (result) {
            [newDictionary removeObjectForKey:aIdentifier];
        }
        else{
#ifdef DEBUG
            NSLog(@"删除缓存文件失败：imageURLString：%@",aIdentifier);
#endif
        }
    }
    
    [KKUserDefaultsManager setObject:newDictionary forKey:KKFileCacheManager_PlistFileName identifier:nil];
    
    return result;
}

/**
 删除某个缓存文件夹下面的所有缓存数据
 @param aCacheDirectory 文件夹名称【例如：Web_Image、Album_Image…… 】
 @return 函数调用成功返回结果
 */
+ (BOOL)deleteCacheDataInCacheDirectory:(NSString*)aCacheDirectory{
    
    BOOL result = YES;
    
    NSDictionary *plistDictionary = [KKFileCacheManager allCacheDocumentInformation];
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    [newDictionary setValuesForKeysWithDictionary:plistDictionary];
    
    NSArray *allKeys = [newDictionary allKeys];
    for (NSInteger i=0; i<[allKeys count]; i++) {
        NSString *aIdentifier = [allKeys objectAtIndex:i];
        NSDictionary *document = [newDictionary objectForKey:aIdentifier];
        NSString *directory = [document objectForKey:KKFileCacheManager_FileKey_CacheDirectory];
        if ([directory isEqualToString:aCacheDirectory]) {
            NSString *fileFullPath = [KKFileCacheManager cacheDataPath:aIdentifier];
            [KKFileCacheManager deleteFileAtPath:fileFullPath];
            [newDictionary removeObjectForKey:aIdentifier];
        }
    }
    [KKUserDefaultsManager setObject:newDictionary forKey:KKFileCacheManager_PlistFileName identifier:nil];
    
    //缓存目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    //文件完整目录
    NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachesDirectory,KKFileCacheManager_CacheDirectoryOfRoot,aCacheDirectory];
    
    result = [KKFileCacheManager deleteDirectoryAtPath:fileFullDirectoryPath];
    
    return result;
}


/**
 保存某个文件信息
 @param documentInformation 文档信息
 @param aKey 文档标识符
 */
+ (void)saveDocumentInformation:(NSDictionary*)documentInformation forKey:(NSString*)aKey{
    if (documentInformation && [documentInformation isKindOfClass:[NSDictionary class]] && aKey && [aKey isKindOfClass:[NSString class]]) {
        NSMutableDictionary *plistDictionary = [NSMutableDictionary dictionaryWithDictionary:[KKUserDefaultsManager objectForKey:KKFileCacheManager_PlistFileName identifier:nil]];
        if (!plistDictionary) {
            plistDictionary = [NSMutableDictionary dictionary];
        }
        [plistDictionary setObject:documentInformation forKey:aKey];
        [KKUserDefaultsManager setObject:plistDictionary forKey:KKFileCacheManager_PlistFileName identifier:nil];
    }
}

/**
 移除某个文件信息
 @param aKey 文档标识符
 */
+ (void)removeDocumentInformationForKey:(NSString*)aKey{
    NSDictionary *dictionary = [KKFileCacheManager allCacheDocumentInformation];
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    [newDictionary setValuesForKeysWithDictionary:dictionary];
    [newDictionary removeObjectForKey:aKey];
    [KKUserDefaultsManager setObject:newDictionary forKey:KKFileCacheManager_PlistFileName identifier:nil];
}

/**
 所有的缓存文件信息
 @return 函数调用成功返回结果
 */
+ (NSDictionary*)allCacheDocumentInformation{
    NSMutableDictionary *plistDictionary = [NSMutableDictionary dictionaryWithDictionary:[KKUserDefaultsManager objectForKey:KKFileCacheManager_PlistFileName identifier:nil]];
    return plistDictionary;
}


#pragma mark ==================================================
#pragma mark == 文件与文件夹操作
#pragma mark ==================================================
/**
 @brief 创建一个随机的文件名【例如：YYYYMMdd_HHmmss_SSS????】
 @discussion 其中YYYYMMdd是"年月日",HHmmss是"时分秒",SSS是毫秒,????是一个0-1000的四位随机数整数)
 @return 函数调用成功返回创建的文件名
 */
+ (NSString*)createRandomFileName{
    //当前时间
    NSDateFormatter *dateFormatter = [NSDateFormatter defaultFormatter];
    [dateFormatter setDateFormat:@"YYYYMMdd_HHmmss_SSS"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    //随机码
    int value = (arc4random() % 1000) + 1;
    NSString *randomCode = [NSString stringWithFormat:@"%04d",value];
    
    NSString *savePathName = [NSString stringWithFormat:@"%@%@",dateStr,randomCode];
    
    return savePathName;
}

/**
 @brief 删除文件
 @discussion 删除文件
 @param aFilePath 文件的完整路径【例如：/var/………………/KKLibraryTempFile/aa.png 】
 @return 函数调用成功返回结果
 */
+ (BOOL)deleteFileAtPath:(NSString*)aFilePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if([fileManager fileExistsAtPath:aFilePath]){
        BOOL result = [fileManager removeItemAtPath:aFilePath error:&error];
        if (result) {
            return YES;
        }
        else{
#ifdef DEBUG
            NSLog(@"%@",[error localizedDescription]);
#endif
            
            return NO;
        }
    }
    else{
        return YES;
    }
}

/**
 @brief 删除文件夹
 @discussion 删除文件夹
 @param aDirectoryPath 文件夹的完整路径【例如：/var/………………/KKLibraryTempFile/PNG 】
 @return 函数调用成功返回结果
 */
+ (BOOL)deleteDirectoryAtPath:(NSString*)aDirectoryPath{
    
    BOOL isDirectory = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if([fileManager fileExistsAtPath:aDirectoryPath isDirectory:&isDirectory]){
        BOOL result = [fileManager removeItemAtPath:aDirectoryPath error:&error];
        if (result) {
            return YES;
        }
        else{
#ifdef DEBUG
            NSLog(@"%@",[error localizedDescription]);
#endif
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
+ (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSError *error = nil;
        NSDictionary *dic = [manager attributesOfItemAtPath:filePath error:&error];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            return [dic fileSize];
        }
        else{
#ifdef DEBUG
            NSLog(@"%@",[error localizedDescription]);
#endif
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
+ (void)directorySizeAtPath:(NSString*)directoryPath completed:(KKComputeFolderSizeCompletedBlock)completedBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:directoryPath]) {
#ifdef DEBUG
            NSLog(@"文件夹不存在");
#endif
            
            completedBlock(0);
        }
        
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:directoryPath] objectEnumerator];
        NSString* fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [directoryPath stringByAppendingPathComponent:fileName];
            folderSize += [KKFileCacheManager fileSizeAtPath:fileAbsolutePath];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completedBlock) {
                completedBlock(folderSize);
            }
        });
    });
}

#pragma mark ==================================================
#pragma mark == 文件类型
#pragma mark ==================================================
+ (BOOL)isFileType_DOC:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"doc"] ||
        [[fileExtention lowercaseString] isEqualToString:@"docx"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_PPT:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"ppt"] ||
        [[fileExtention lowercaseString] isEqualToString:@"pptx"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_XLS:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"xls"] ||
        [[fileExtention lowercaseString] isEqualToString:@"xlsx"] ||
        [[fileExtention lowercaseString] isEqualToString:@"csv"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_IMG:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"png"] ||
        [[fileExtention lowercaseString] isEqualToString:@"jpg"] ||
        [[fileExtention lowercaseString] isEqualToString:@"bmp"] ||
        [[fileExtention lowercaseString] isEqualToString:@"gif"] ||
        [[fileExtention lowercaseString] isEqualToString:@"jpeg"]) {
        return YES;
    }
    else{
        return NO;
    }
}

//视频格式
+ (BOOL)isFileType_VIDEO:(NSString*)fileExtention{
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

//音频格式
+ (BOOL)isFileType_AUDIO:(NSString*)fileExtention{
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

+ (BOOL)isFileType_PDF:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"pdf"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_TXT:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"txt"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_ZIP:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"zip"] ||
        [[fileExtention lowercaseString] isEqualToString:@"rar"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (KKFileType)fileTypeAtPath:(NSString*)aFilePath{
    NSString *fileExtention = [aFilePath pathExtension];
    if ([KKFileCacheManager isFileType_DOC:fileExtention]) {
        return KKFileType_doc;
    }
    else if ([KKFileCacheManager isFileType_PPT:fileExtention]) {
        return KKFileType_ppt;
    }
    else if ([KKFileCacheManager isFileType_XLS:fileExtention]) {
        return KKFileType_xls;
    }
    else if ([KKFileCacheManager isFileType_IMG:fileExtention]) {
        return KKFileType_img;
    }
    else if ([KKFileCacheManager isFileType_VIDEO:fileExtention]) {
        return KKFileType_video;
    }
    else if ([KKFileCacheManager isFileType_AUDIO:fileExtention]) {
        return KKFileType_audio;
    }
    else if ([KKFileCacheManager isFileType_PDF:fileExtention]) {
        return KKFileType_pdf;
    }
    else if ([KKFileCacheManager isFileType_TXT:fileExtention]) {
        return KKFileType_txt;
    }
    else if ([KKFileCacheManager isFileType_ZIP:fileExtention]) {
        return KKFileType_zip;
    }
    else {
        return KKFileType_UnKnown;
    }
}

/**
 根据文件类型，返回对应的icon图标
 
 @param fileExtention 文件扩展名
 @return icon图片
 */
+ (UIImage*)fileTypeImageLForExtention:(NSString*)fileExtention{
    
    if ([KKFileCacheManager isFileType_DOC:fileExtention]) {
        return KKThemeImage(@"FileTypeL_DOC");
    }
    else if ([KKFileCacheManager isFileType_PPT:fileExtention]) {
        return KKThemeImage(@"FileTypeL_PPT");
    }
    else if ([KKFileCacheManager isFileType_XLS:fileExtention]) {
        return KKThemeImage(@"FileTypeL_XLS");
    }
    else if ([KKFileCacheManager isFileType_IMG:fileExtention]) {
        return KKThemeImage(@"FileTypeL_IMG");
    }
    else if ([KKFileCacheManager isFileType_VIDEO:fileExtention]) {
        return KKThemeImage(@"FileTypeL_VIDEO");
    }
    else if ([KKFileCacheManager isFileType_AUDIO:fileExtention]) {
        return KKThemeImage(@"FileTypeL_AUDIO");
    }
    else if ([KKFileCacheManager isFileType_PDF:fileExtention]) {
        return KKThemeImage(@"FileTypeL_PDF");
    }
    else if ([KKFileCacheManager isFileType_TXT:fileExtention]) {
        return KKThemeImage(@"FileTypeL_TXT");
    }
    else if ([KKFileCacheManager isFileType_ZIP:fileExtention]) {
        return KKThemeImage(@"FileTypeL_ZIP");
    }
    else{
        return KKThemeImage(@"FileTypeL_XXX");
    }
}

/**
 根据文件类型，返回对应的icon图标
 
 @param fileExtention 文件扩展名
 @return icon图片
 */
+ (UIImage*)fileTypeImageSForExtention:(NSString*)fileExtention{
    
    if ([KKFileCacheManager isFileType_DOC:fileExtention]) {
        return KKThemeImage(@"FileTypeS_DOC");
    }
    else if ([KKFileCacheManager isFileType_PPT:fileExtention]) {
        return KKThemeImage(@"FileTypeS_PPT");
    }
    else if ([KKFileCacheManager isFileType_XLS:fileExtention]) {
        return KKThemeImage(@"FileTypeS_XLS");
    }
    else if ([KKFileCacheManager isFileType_IMG:fileExtention]) {
        return KKThemeImage(@"FileTypeS_IMG");
    }
    else if ([KKFileCacheManager isFileType_VIDEO:fileExtention]) {
        return KKThemeImage(@"FileTypeS_VIDEO");
    }
    else if ([KKFileCacheManager isFileType_AUDIO:fileExtention]) {
        return KKThemeImage(@"FileTypeS_AUDIO");
    }
    else if ([KKFileCacheManager isFileType_PDF:fileExtention]) {
        return KKThemeImage(@"FileTypeS_PDF");
    }
    else if ([KKFileCacheManager isFileType_TXT:fileExtention]) {
        return KKThemeImage(@"FileTypeS_TXT");
    }
    else if ([KKFileCacheManager isFileType_ZIP:fileExtention]) {
        return KKThemeImage(@"FileTypeS_ZIP");
    }
    else{
        return KKThemeImage(@"FileTypeS_XXX");
    }
}

#pragma mark ==================================================
#pragma mark == 项目特殊需求【只清除 KKFileCacheManager_CacheDirectoryOfWebImage】
#pragma mark ==================================================
+ (NSString*)webCachePath{
    //缓存目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    //文件完整目录
    NSString *fileFullDirectoryPath = [NSString stringWithFormat:@"%@/%@/%@",cachesDirectory,KKFileCacheManager_CacheDirectoryOfRoot,KKFileCacheManager_CacheDirectoryOfWebImage];
    return fileFullDirectoryPath;
}

+ (void)deleteWebCacheData{
    
    NSMutableDictionary *plistDictionary = [NSMutableDictionary dictionaryWithDictionary:[KKUserDefaultsManager objectForKey:KKFileCacheManager_PlistFileName identifier:nil]];
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    [newDictionary setValuesForKeysWithDictionary:plistDictionary];
    
    NSArray *allKeys = [newDictionary allKeys];
    for (NSInteger i=0; i<[allKeys count]; i++) {
        NSString *aIdentifier = [allKeys objectAtIndex:i];
        NSDictionary *document = [newDictionary objectForKey:aIdentifier];
        NSString *cacheDirectory = [document validStringForKey:KKFileCacheManager_FileKey_CacheDirectory];
        if ([cacheDirectory isEqualToString:KKFileCacheManager_CacheDirectoryOfWebImage]) {
            NSString *fileFullPath = [KKFileCacheManager cacheDataPath:aIdentifier];
            BOOL result = [KKFileCacheManager deleteFileAtPath:fileFullPath];
            if (result) {
                [newDictionary removeObjectForKey:aIdentifier];
            }
            else{
#ifdef DEBUG
                NSLog(@"删除缓存图片失败：imageURLString：%@",aIdentifier);
#endif
                
            }
        }
    }
    
    [KKUserDefaultsManager setObject:newDictionary forKey:KKFileCacheManager_PlistFileName identifier:nil];
}


@end
