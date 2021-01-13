//
//  KKWebCache.m
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKWebCache.h"
#import "KKCategory.h"
#import "KKLog.h"
#import "KKFileCacheManager.h"

@implementation KKWebCache

/* 缓存图片 */
+ (NSData*)saveWebImage:(NSURL *)location response:(NSURLResponse *)response identifier:(NSString*)aIdentifier{

    // AtPath : 剪切前的文件路径
    // ToPath : 剪切后的文件路径
    if (!location.path) {
        KKLogErrorFormat(@"UIButton+KKWebCache.m moveItemAtPath:location.path path nil,location:%@",KKValidString(location));
        return nil;
    }
    else{
        // location : 临时文件的路径（下载好的文件）
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

        // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
        NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];

        // 将临时文件剪切或者复制Caches文件夹
        NSFileManager *mgr = [NSFileManager defaultManager];

        [mgr moveItemAtPath:location.path toPath:file error:nil];
        NSData *data = [NSData dataWithContentsOfFile:file];

        if (data && data.length>0 &&
            ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_JPG] ||
             [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_PNG] ||
             [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_BMP] ||
             [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF] ||
             [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_TIFF] )) {

            //缓存图片
            NSString *fileName = [file lastPathComponent];
            NSString *pathExt = [fileName pathExtension];
            NSString *displayFullName = @"";
            if ([NSString isStringNotEmpty:pathExt] &&
                [fileName rangeOfString:[NSString stringWithFormat:@".%@",pathExt]].length>0) {
                displayFullName = [file lastPathComponent];
            } else {
                NSString *extention = [UIImage contentTypeExtensionForImageData:data];
                NSString *radom = [KKFileCacheManager createRandomFileName];
                displayFullName = [NSString stringWithFormat:@"%@.%@",radom,extention];
            }
            [KKFileCacheManager saveData:data
                        toCacheDirectory:KKFileCacheManager_CacheDirectoryOfWebImage
                         displayFullName:displayFullName
                              identifier:aIdentifier
                               remoteURL:[response.URL absoluteString]
                         dataInformation:nil];

            [mgr removeItemAtPath:file error:nil];
            return data;
        }
        else{
            KKLogError(@"数据不是图片数据");
            [mgr removeItemAtPath:file error:nil];
            return nil;
        }
    }
}

+ (void)downLoadImageWithURLString:(NSString*)aURLString
                         completed:(KKImageLoadCompletedBlock)completedBlock
{

    NSURL *url = [NSURL URLWithString:aURLString];
    NSURLRequest *reque = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:reque completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {

        NSData *imageData = [KKWebCache saveWebImage:location response:response identifier:aURLString];
        dispatch_async(dispatch_get_main_queue(), ^{
            //返回块
            if (completedBlock) {
                completedBlock(imageData,error,YES);
            }
        });

    }];

    //开始任务
    [task resume];
}

@end
