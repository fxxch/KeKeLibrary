//
//  UIButton+KKWebCache.m
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import "UIButton+KKWebCache.h"
#import "KKNetWorkObserver.h"
#import <objc/runtime.h>
#import "KKCategory.h"

#define ButtonGifImageViewTag 20131230

@implementation UIButton (KKWebCache)
@dynamic imageDataURLString;

NSString *const imageDataURLString_Button      = @"imageDataURLString";

#pragma mark ==================================================
#pragma mark ==扩展
#pragma mark ==================================================
- (void)setImageDataURLString:(NSString *)imageDataURLString{
    objc_setAssociatedObject(self, &imageDataURLString_Button, imageDataURLString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)imageDataURLString{
    return objc_getAssociatedObject(self, &imageDataURLString_Button);
}

#pragma mark ==================================================
#pragma mark ==设置图片 setImageWithURL
#pragma mark ==================================================
/*无状态*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder{
    
    [self setImageWithURL:url
            requestONWifi:requestONWifi
         placeholderImage:placeholder
                 forState:KKControlStateNone
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
                 forState:KKControlStateNone
        showActivityStyle:aStyle
                completed:nil];
}

/*状态*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
               forState:(KKControlState)state{
    
    [self setImageWithURL:url
            requestONWifi:requestONWifi
         placeholderImage:placeholder
                 forState:state
        showActivityStyle:KKActivityIndicatorViewStyleNone
                completed:nil];
}

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
               forState:(KKControlState)state
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle{
    
    [self setImageWithURL:url
            requestONWifi:requestONWifi
         placeholderImage:placeholder
                 forState:KKControlStateNone
        showActivityStyle:aStyle
                completed:nil];
}

/*GCD块*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
              completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self setImageWithURL:url
            requestONWifi:requestONWifi
         placeholderImage:placeholder
                 forState:KKControlStateNone
        showActivityStyle:KKActivityIndicatorViewStyleNone
                completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
              completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self setImageWithURL:url
            requestONWifi:requestONWifi
         placeholderImage:placeholder
                 forState:KKControlStateNone
        showActivityStyle:KKActivityIndicatorViewStyleNone
                completed:completedBlock];
}

/*GCD块+状态*/
- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
               forState:(KKControlState)state
              completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self setImageWithURL:url
            requestONWifi:requestONWifi
         placeholderImage:placeholder
                 forState:state
        showActivityStyle:KKActivityIndicatorViewStyleNone
                completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url
          requestONWifi:(BOOL)requestONWifi
       placeholderImage:(UIImage *)placeholder
               forState:(KKControlState)state
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
              completed:(KKImageLoadCompletedBlock)completedBlock{
    
    if ([KKFileCacheManager isExistCacheData:[url absoluteString]]) {
        NSData *data = [KKFileCacheManager readCacheData:[url absoluteString]];
        if ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showGIFSubView:data];
            });
        }
        else{

            if (state==KKControlStateNone) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                    [self setImage:[UIImage imageWithData:data] forState:UIControlStateHighlighted];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:[UIImage imageWithData:data] forState:(UIControlState)state];
                });
            }
        }
        
        if (completedBlock) {
            completedBlock(data,nil,NO);
        }
    }
    else{
        if (state==KKControlStateNone) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:placeholder forState:UIControlStateNormal];
                [self setImage:placeholder forState:UIControlStateHighlighted];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:placeholder forState:(UIControlState)state];
            });
        }
        
        
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
        
            //是最后一个请求
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
                            if ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
                                [self showGIFSubView:data];
                            }
                            else{
                                if (state==KKControlStateNone) {
                                    [self setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                                    [self setImage:[UIImage imageWithData:data] forState:UIControlStateHighlighted];
                                }
                                else{
                                    [self setImage:[UIImage imageWithData:data] forState:(UIControlState)state];
                                }
                            }

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
                                completedBlock(data,nil,YES);
                            }

                        });

                    }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //移除转圈圈
                        [self removeActivityIndicatorView];
                        
                        //返回块
                        if (completedBlock) {
                            completedBlock(data,nil,YES);
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
#pragma mark ==设置图片 setBackgroundImageWithURL
#pragma mark ==================================================
/*无状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder{
    [self setBackgroundImageWithURL:url
                      requestONWifi:requestONWifi
                   placeholderImage:placeholder
                           forState:KKControlStateNone
                  showActivityStyle:KKActivityIndicatorViewStyleNone
                          completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                showActivityStyle:(KKActivityIndicatorViewStyle)aStyle{
    
    [self setBackgroundImageWithURL:url
                      requestONWifi:requestONWifi
                   placeholderImage:placeholder
                           forState:KKControlStateNone
                  showActivityStyle:aStyle
                          completed:nil];
}


/*状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                         forState:(KKControlState)state{
    [self setBackgroundImageWithURL:url
                      requestONWifi:requestONWifi
                   placeholderImage:placeholder
                           forState:state
                  showActivityStyle:KKActivityIndicatorViewStyleNone
                          completed:nil];
}

- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                         forState:(KKControlState)state
                showActivityStyle:(KKActivityIndicatorViewStyle)aStyle{
    
    [self setBackgroundImageWithURL:url
                      requestONWifi:requestONWifi
                   placeholderImage:placeholder
                           forState:state
                  showActivityStyle:aStyle
                          completed:nil];
    
}

/*GCD块*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                        completed:(KKImageLoadCompletedBlock)completedBlock{
    [self setBackgroundImageWithURL:url
                      requestONWifi:requestONWifi
                   placeholderImage:placeholder
                           forState:KKControlStateNone
                  showActivityStyle:KKActivityIndicatorViewStyleNone
                          completed:completedBlock];
}

- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                        completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self setBackgroundImageWithURL:url
                      requestONWifi:requestONWifi
                   placeholderImage:placeholder
                           forState:KKControlStateNone
                  showActivityStyle:aStyle
                          completed:completedBlock];
}

/*GCD块+状态*/
- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                         forState:(KKControlState)state
                        completed:(KKImageLoadCompletedBlock)completedBlock{
    [self setBackgroundImageWithURL:url
                      requestONWifi:requestONWifi
                   placeholderImage:placeholder
                           forState:state
                  showActivityStyle:KKActivityIndicatorViewStyleNone
                          completed:completedBlock];
}

- (void)setBackgroundImageWithURL:(NSURL *)url
                    requestONWifi:(BOOL)requestONWifi
                 placeholderImage:(UIImage *)placeholder
                         forState:(KKControlState)state
                showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                        completed:(KKImageLoadCompletedBlock)completedBlock{
    
    if ([KKFileCacheManager isExistCacheData:[url absoluteString]]) {
        NSData *data = [KKFileCacheManager readCacheData:[url absoluteString]];
        if ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showGIFSubView:data];
            });
        }
        else{
            if (state==KKControlStateNone) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                    [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateHighlighted];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setBackgroundImage:[UIImage imageWithData:data] forState:(UIControlState)state];
                });
            }
        }
        
        if (completedBlock) {
            completedBlock(data,nil,NO);
        }
    }
    else{
        if (state==KKControlStateNone) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBackgroundImage:placeholder forState:UIControlStateNormal];
                [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setBackgroundImage:placeholder forState:(UIControlState)state];
            });
        }
        
        
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
                            if ([[UIImage contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
                                [self showGIFSubView:data];
                            }
                            else{
                                if (state==KKControlStateNone) {
                                    [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                                    [self setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateHighlighted];
                                }
                                else{
                                    [self setBackgroundImage:[UIImage imageWithData:data] forState:(UIControlState)state];
                                }
                            }
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
                                completedBlock(data,nil,YES);
                            }

                        });
                    }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //移除转圈圈
                        [self removeActivityIndicatorView];
                        
                        //返回块
                        if (completedBlock) {
                            completedBlock(data,nil,YES);
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
- (void)showGIFSubView:(NSData*)data{
    UIImageView *imageView = (UIImageView*)[self viewWithTag:ButtonGifImageViewTag];
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.tag = ButtonGifImageViewTag;
        [self addSubview:imageView];
    }
    [imageView showImageData:data inFrame:imageView.frame];
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
            activeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
            activeView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
