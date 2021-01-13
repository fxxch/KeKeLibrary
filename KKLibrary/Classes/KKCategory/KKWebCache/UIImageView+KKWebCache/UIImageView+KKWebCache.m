//
//  UIImageView+KKWebCache.m
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import "UIImageView+KKWebCache.h"
#import <objc/runtime.h>
#import "UIImage+KKCategory.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"
#import "NSObject+KKCategory.h"
#import "KKFileCacheManager.h"
#import "KKLog.h"

@implementation UIImageView (KKWebCache)
@dynamic imageDataURLString;

#pragma mark ==================================================
#pragma mark == 【黑魔法】方法替换
#pragma mark ==================================================
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL sys_SEL = @selector(setImage:);
        SEL my_SEL = @selector(kk_setImage:);
        
        Method sys_Method   = class_getInstanceMethod(self, sys_SEL);
        Method my_Method    = class_getInstanceMethod(self, my_SEL);
        
        BOOL didAddMethod = class_addMethod([self class],
                                            sys_SEL,
                                            method_getImplementation(my_Method),
                                            method_getTypeEncoding(my_Method));
        
        if (didAddMethod) {
            class_replaceMethod([self class],
                                my_SEL,
                                method_getImplementation(sys_Method),
                                method_getTypeEncoding(sys_Method));
        }
        method_exchangeImplementations(sys_Method, my_Method);
        
    });
    
}

- (void)kk_setImage:(UIImage *)image{
    
    objc_setAssociatedObject(self, @"imageDataURLString_ImageView", nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self kk_setImage:image];
}

#pragma mark ==================================================
#pragma mark ==扩展
#pragma mark ==================================================
- (void)setImageDataURLString:(NSString *)imageDataURLString{
    objc_setAssociatedObject(self, @"imageDataURLString_ImageView", imageDataURLString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)imageDataURLString{
    return objc_getAssociatedObject(self, @"imageDataURLString_ImageView");
}

#pragma mark ==================================================
#pragma mark ==设置图片
#pragma mark ==================================================
/*普通*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
        showActivityStyle:KKActivityIndicatorViewStyleNone
                completed:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
        showActivityStyle:aStyle
                completed:nil];
}


/*GCD*/
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
              completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self setImageWithURL:url
         placeholderImage:placeholder
        showActivityStyle:KKActivityIndicatorViewStyleNone
                completed:completedBlock];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholder
      showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
              completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self setImage:placeholder];
    
    /* 清除 */
    if (url==nil) {
        if (completedBlock) {
            completedBlock(nil,nil,NO);
        }
        
        [self setImageDataURLString:nil];
        
        if (placeholder==nil) [self addPlaceHolderView];
        
        return;
    }
    else{
        //加载本地
        if ([KKFileCacheManager isExistCacheData:[url absoluteString]]) {
            [self setImageWithURL_ForLocal:url  completed:completedBlock];
        }
        //加载网络
        else{
            [self setImageWithURL_ForRemote:url
                           placeholderImage:placeholder
                          showActivityStyle:aStyle
                                  completed:completedBlock];
        }
    }
}

/* 加载本地图片 */
- (void)setImageWithURL_ForLocal:(NSURL *)url
                       completed:(KKImageLoadCompletedBlock)completedBlock{

//    KKLogInfoFormat(@"UIImageView+KKWebCache加载本地缓存图片:  %@",KKValidString(url.absoluteString));

    [self removePlaceHolderView];

    NSData *data = [KKFileCacheManager readCacheData:[url absoluteString]];
    [self showImageData:data inFrame:self.frame];
    
    if(completedBlock){
        completedBlock(data,nil,NO);
    }
    
    [self setImageDataURLString:nil];
}

/* 加载网络图片 */
- (void)setImageWithURL_ForRemote:(NSURL *)url
                 placeholderImage:(UIImage *)placeholder
                showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                        completed:(KKImageLoadCompletedBlock)completedBlock{

    KKLogInfoFormat(@"UIImageView+KKWebCache加载远程图片:  %@",KKValidString(url.absoluteString));

    [self setImageDataURLString:[url absoluteString]];
    
    if ([NSString isStringEmpty:[url absoluteString]]) {
        if (completedBlock) {
            completedBlock(nil,nil,NO);
        }
        
        [self setImageDataURLString:nil];
        
        if (placeholder==nil) [self addPlaceHolderView];
        
        return;
    }
    
    if (placeholder==nil) [self addPlaceHolderView];
    
    [self addActivityIndicatorView:aStyle];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        KKWeakSelf(self);
        NSURLRequest *reque = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:reque completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                        
            //是最后一个请求
            if ([[response.URL absoluteString] isEqualToString:[weakself imageDataURLString]]) {
                NSData *imageData = [KKWebCache saveWebImage:location response:response identifier:weakself.imageDataURLString];

                if (imageData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //刷新界面
                        [weakself showImageData:imageData inFrame:weakself.frame];
                        
                        //返回块
                        if (completedBlock) {
                            completedBlock(imageData,error,YES);
                        }
                        
                        [weakself setImageDataURLString:nil];
                        
                        //移除转圈圈
                        [weakself removeActivityIndicatorView];
                        [weakself removePlaceHolderView];
                    });
                }
                else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //返回块
                        if (completedBlock) {
                            completedBlock(nil,error,YES);
                        }
                        
                        [weakself setImageDataURLString:nil];
                        
                        //移除转圈圈
                        [weakself removeActivityIndicatorView];
                    });
                }
                
            }
            
        }];
        
        //开始任务
        [task resume];
        
    });
}

#pragma mark ==================================================
#pragma mark == 等待视图
#pragma mark ==================================================
- (void)addActivityIndicatorView:(KKActivityIndicatorViewStyle)aStyle{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
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
        
    });
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

#pragma mark ==================================================
#pragma mark == 占位视图
#pragma mark ==================================================
/**
 添加占位视图
 */
- (void)addPlaceHolderView{
    [self removePlaceHolderView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        imageView.tag = 2018063001;
        [self addSubview:imageView];
        [imageView sendToBack];
        
        UIImage *image = nil;
        
        @try {
            image = [NSObject defaultImage];
        } @catch (NSException *exception) {
            
        } @finally {
            if (image) {
                CGSize imageSize = image.size;
                
                if (image.size.width>imageView.frame.size.width ||
                    image.size.height>imageView.frame.size.height ) {
                    
                    imageSize = CGSizeMake(image.size.width/2.0, image.size.height/2.0);
                }
                
                UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((imageView.frame.size.width-imageSize.width)/2.0, (imageView.frame.size.height-imageSize.height)/2.0, imageSize.width, imageSize.height)];
                icon.image = image;
                [imageView addSubview:icon];
            }
        }
        
    });
}

/**
 移除占位视图
 */
- (void)removePlaceHolderView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self viewWithTag:2018063001] removeFromSuperview];
    });
}


@end



