//
//  UIImageView+KKWebCache.m
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import "UIImageView+KKWebCache.h"
#import "KKNetWorkObserver.h"
#import <objc/runtime.h>
#import "UIImage+KKCategory.h"
#import "KKCategory.h"

@implementation UIImageView (KKWebCache)
@dynamic imageDataURLString;

NSString *const imageDataURLString_ImageView      = @"imageDataURLString";


#pragma mark ==================================================
#pragma mark ==扩展
#pragma mark ==================================================
- (void)setImageDataURLString:(NSString *)imageDataURLString{
    objc_setAssociatedObject(self, &imageDataURLString_ImageView, imageDataURLString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)imageDataURLString{
    return objc_getAssociatedObject(self, &imageDataURLString_ImageView);
}

#pragma mark ==================================================
#pragma mark ==设置图片
#pragma mark ==================================================
/*普通*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder{
    
    [self setImageWithURL:url
            requestONWifi:requestONWifi
         placeholderImage:placeholder
        showActivityStyle:KKActivityIndicatorViewStyleNone
                completed:nil];
}

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle{
    
    [self setImageWithURL:url
            requestONWifi:requestONWifi
         placeholderImage:placeholder
        showActivityStyle:aStyle
                completed:nil];
}


/*GCD*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
              completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self setImageWithURL:url
            requestONWifi:requestONWifi
         placeholderImage:placeholder
        showActivityStyle:KKActivityIndicatorViewStyleNone
                completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
              completed:(KKImageLoadCompletedBlock)completedBlock{
    
    if ([KKFileCacheManager isExistCacheData:[url absoluteString]]) {
        NSData *data = [KKFileCacheManager readCacheData:[url absoluteString]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showImageData:data inFrame:self.frame];
        });
        
        if(completedBlock){
            completedBlock(data,nil,NO);
        }
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = placeholder;
        });

        [self setImageDataURLString:[url absoluteString]];

        //只有WIFI情况下才加载
        if (requestONWifi) {
            if ([[KKNetWorkObserver sharedInstance] status] == ReachableViaWiFi) {
                //加载
            }
            else{
                //不加载
                return;
            }
        }
        else{
            //加载
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self addActivityIndicatorView:aStyle];
        });

        NSURLRequest *reque = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:reque completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            if ([[response.URL absoluteString] isEqualToString:[self imageDataURLString]]) {
                
                // location : 临时文件的路径（下载好的文件）
                NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                
                // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
                NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
                
                // 将临时文件剪切或者复制Caches文件夹
                NSFileManager *mgr = [NSFileManager defaultManager];
                
                // AtPath : 剪切前的文件路径
                // ToPath : 剪切后的文件路径
                [mgr moveItemAtPath:location.path toPath:file error:nil];
                NSData *data = [NSData dataWithContentsOfFile:file];
                [mgr removeItemAtPath:file error:nil];

                if (data &&
                    ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_JPG] ||
                     [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_PNG] ||
                     [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_BMP] ||
                     [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF] ||
                     [[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_TIFF] )) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //刷新界面
                            [self showImageData:data inFrame:self.frame];
                            
                            //移除转圈圈
                            [self removeActivityIndicatorView];

                        });
                        
                        //缓存图片
                        NSString *extention = [UIImage contentTypeExtensionForImageData:data];
                        [KKFileCacheManager saveData:data
                                    toCacheDirectory:KKFileCacheManager_CacheDirectoryOfWebImage
                                       dataExtension:extention
                                         displayName:[file lastPathComponent]
                                          identifier:[url absoluteString]
                                     dataInformation:nil];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            //返回块
                            if (completedBlock) {
                                completedBlock(data,error,YES);
                            }
                        });

                    }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //移除转圈圈
                        [self removeActivityIndicatorView];
                        
                        //返回块
                        if (completedBlock) {
                            completedBlock(data,error,YES);
                        }
                    });
                    
                }
            }
        }];
        
        //开始任务
        [task resume];
    }
}


#pragma mark ==================================================
#pragma mark ==通用
#pragma mark ==================================================
- (void)addActivityIndicatorView:(KKActivityIndicatorViewStyle)aStyle{
    if (aStyle==KKActivityIndicatorViewStyleNone) {
        return;
    }
    else if (aStyle==KKActivityIndicatorViewStyleWhiteLarge){
        UIActivityIndicatorView *activeView = (UIActivityIndicatorView*)[self viewWithTag:20141024];
        if (!activeView) {
            activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activeView.tag = 20141024;
            [self addSubview:activeView];
            [activeView startAnimating];
            if (self.layer.mask) {
                activeView.center = self.layer.mask.position;
            }
            else{
                activeView.center = self.center;
            }
            activeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        }
        else{
            [self bringSubviewToFront:activeView];
            [activeView startAnimating];
            if (self.layer.mask) {
                activeView.center = self.layer.mask.position;
            }
            else{
                activeView.center = self.center;
            }
        }
    }
    else if (aStyle==KKActivityIndicatorViewStyleWhite){
        UIActivityIndicatorView *activeView = (UIActivityIndicatorView*)[self viewWithTag:20141024];
        if (!activeView) {
            activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activeView.tag = 20141024;
            [self addSubview:activeView];
            [activeView startAnimating];
            if (self.layer.mask) {
                activeView.center = self.layer.mask.position;
            }
            else{
                activeView.center = self.center;
            }
            activeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        }
        else{
            [self bringSubviewToFront:activeView];
            [activeView startAnimating];
            if (self.layer.mask) {
                activeView.center = self.layer.mask.position;
            }
            else{
                activeView.center = self.center;
            }
        }
    }
    else if (aStyle==KKActivityIndicatorViewStyleGray){
        UIActivityIndicatorView *activeView = (UIActivityIndicatorView*)[self viewWithTag:20141024];
        if (!activeView) {
            activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activeView.tag = 20141024;
            [self addSubview:activeView];
            [activeView startAnimating];
            if (self.layer.mask) {
                activeView.center = self.layer.mask.position;
            }
            else{
                activeView.center = self.center;
            }
            activeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        }
        else{
            [self bringSubviewToFront:activeView];
            [activeView startAnimating];
            if (self.layer.mask) {
                activeView.center = self.layer.mask.position;
            }
            else{
                activeView.center = self.center;
            }
            activeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        }
    }
    else{
        
    }
}

- (void)removeActivityIndicatorView{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *activeView in [self subviews]) {
            if ([activeView isKindOfClass:[UIActivityIndicatorView class]] && activeView.tag==20141024) {
                [(UIActivityIndicatorView*)activeView stopAnimating];
                [activeView removeFromSuperview];
            }
        }
    });
}


@end



