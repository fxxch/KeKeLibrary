//
//  UIButton+KKWebCache.m
//  ProjectK
//
//  Created by liubo on 13-12-30.
//  Copyright (c) 2013年 Beartech. All rights reserved.
//

#import "UIButton+KKWebCache.h"
#import <objc/runtime.h>
#import "KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKFileCacheManager.h"
#import "KKLog.h"

#define ButtonGifImageViewTag 20131230

@implementation UIButton (KKWebCache)
@dynamic kk_imageDataURLString;

#pragma mark ==================================================
#pragma mark == 【黑魔法】方法替换
#pragma mark ==================================================
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL sys_SEL00 = @selector(setBackgroundImage:forState:);
        SEL my_SEL00 = @selector(kk_setBackgroundImage:forState:);
        
        Method sys_Method00   = class_getInstanceMethod(self, sys_SEL00);
        Method my_Method00    = class_getInstanceMethod(self, my_SEL00);
        
        BOOL didAddMethod00 = class_addMethod([self class],
                                              sys_SEL00,
                                              method_getImplementation(my_Method00),
                                              method_getTypeEncoding(my_Method00));
        
        if (didAddMethod00) {
            class_replaceMethod([self class],
                                my_SEL00,
                                method_getImplementation(sys_Method00),
                                method_getTypeEncoding(sys_Method00));
        }
        method_exchangeImplementations(sys_Method00, my_Method00);
        
        
        SEL sys_SEL = @selector(setImage:forState:);
        SEL my_SEL = @selector(kk_setImage:forState:);
        
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

- (void)kk_setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    
    objc_setAssociatedObject(self, @"kk_imageDataURLString", nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [[self viewWithTag:ButtonGifImageViewTag] removeFromSuperview];
    [self kk_setBackgroundImage:image forState:state];
}

- (void)kk_setImage:(UIImage *)image forState:(UIControlState)state{
    
    objc_setAssociatedObject(self, @"kk_imageDataURLString", nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [[self viewWithTag:ButtonGifImageViewTag] removeFromSuperview];
    [self kk_setImage:image forState:state];
}

#pragma mark ==================================================
#pragma mark ==扩展
#pragma mark ==================================================
- (void)setKk_imageDataURLString:(NSString *)kk_imageDataURLString{
    objc_setAssociatedObject(self, @"kk_imageDataURLString", kk_imageDataURLString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)kk_imageDataURLString{
    return objc_getAssociatedObject(self, @"kk_imageDataURLString");
}

#pragma mark ==================================================
#pragma mark ==设置图片 setImageWithURL
#pragma mark ==================================================
/*无状态*/
- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder{
    
    [self kk_setImageWithURL:url
            placeholderImage:placeholder
                    forState:KKControlStateNone
           showActivityStyle:KKActivityIndicatorViewStyleNone
                   completed:nil];
}

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle{
    
    [self kk_setImageWithURL:url
            placeholderImage:placeholder
                    forState:KKControlStateNone
           showActivityStyle:aStyle
                   completed:nil];
}

/*状态*/
- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  forState:(KKControlState)state{
    
    [self kk_setImageWithURL:url
            placeholderImage:placeholder
                    forState:state
           showActivityStyle:KKActivityIndicatorViewStyleNone
                   completed:nil];
}

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  forState:(KKControlState)state
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle{
    
    [self kk_setImageWithURL:url
            placeholderImage:placeholder
                    forState:KKControlStateNone
           showActivityStyle:aStyle
                   completed:nil];
}

/*GCD块*/
- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self kk_setImageWithURL:url
            placeholderImage:placeholder
                    forState:KKControlStateNone
           showActivityStyle:KKActivityIndicatorViewStyleNone
                   completed:completedBlock];
}

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                 completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self kk_setImageWithURL:url
            placeholderImage:placeholder
                    forState:KKControlStateNone
           showActivityStyle:KKActivityIndicatorViewStyleNone
                   completed:completedBlock];
}

/*GCD块+状态*/
- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  forState:(KKControlState)state
                 completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self kk_setImageWithURL:url
            placeholderImage:placeholder
                    forState:state
           showActivityStyle:KKActivityIndicatorViewStyleNone
                   completed:completedBlock];
}

- (void)kk_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  forState:(KKControlState)state
         showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                 completed:(KKImageLoadCompletedBlock)completedBlock{
    
    if (state==KKControlStateNone) {
        [self setImage:placeholder forState:UIControlStateNormal];
        [self setImage:placeholder forState:UIControlStateHighlighted];
    }
    else{
        [self setImage:placeholder forState:(UIControlState)state];
    }
    
    /* 清除 */
    if (url==nil) {
        if (completedBlock) {
            completedBlock(nil,nil,NO);
        }
        
        self.kk_imageDataURLString = nil;
        
        if (placeholder==nil) [self kk_addPlaceHolderView];
        
        return;
    }
    else{
        //加载本地
        if ([KKFileCacheManager isExistCacheData:[url absoluteString]]) {
            [self kk_setImageWithURL_ForLocal:url forState:state completed:completedBlock];
        }
        //加载网络
        else{
            [self kk_setImageWithURL_ForRemote:url
                              placeholderImage:placeholder
                                      forState:state
                             showActivityStyle:aStyle
                                     completed:completedBlock];
        }
    }
}

/* 加载本地图片 */
- (void)kk_setImageWithURL_ForLocal:(NSURL *)url
                           forState:(KKControlState)state
                          completed:(KKImageLoadCompletedBlock)completedBlock{

    //KKLogInfoFormat(@"UIButton+KKWebCache加载本地缓存图片:  %@",KKValidString(url.absoluteString));

    [self kk_removePlaceHolderView];

    NSData *data = [KKFileCacheManager readCacheData:[url absoluteString]];
    if ([[UIImage kk_contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
        [self kk_showGIFSubView:data];
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
    
    if (completedBlock) {
        completedBlock(data,nil,NO);
    }
    
    self.kk_imageDataURLString = nil;
}

/* 加载网络图片 */
- (void)kk_setImageWithURL_ForRemote:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                            forState:(KKControlState)state
                   showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                           completed:(KKImageLoadCompletedBlock)completedBlock{

    //KKLogInfoFormat(@"UIButton+KKWebCache加载远程图片:  %@",KKValidString(url.absoluteString));

    self.kk_imageDataURLString = [url absoluteString];
    
    if ([NSString kk_isStringEmpty:[url absoluteString]]) {
        
        if (completedBlock) {
            completedBlock(nil,nil,NO);
        }
        
        self.kk_imageDataURLString = nil;

        if (placeholder==nil) [self kk_addPlaceHolderView];
        return;
    }
    
    if (placeholder==nil) [self kk_addPlaceHolderView];
    
    [self kk_addActivityIndicatorView:aStyle];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        KKWeakSelf(self);
        
        NSURLRequest *reque = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:reque completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {

            //是最后一个请求
            if ([[response.URL absoluteString] isEqualToString:self.kk_imageDataURLString]) {

                NSData *imageData = [KKWebCache saveWebImage:location response:response identifier:weakself.kk_imageDataURLString];

                if (imageData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //刷新界面
                        if ([[UIImage kk_contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF]) {
                            [weakself kk_showGIFSubView:imageData];
                        }
                        else{
                            if (state==KKControlStateNone) {
                                [weakself setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                [weakself setImage:[UIImage imageWithData:imageData] forState:UIControlStateHighlighted];
                            }
                            else{
                                [weakself setImage:[UIImage imageWithData:imageData] forState:(UIControlState)state];
                            }
                        }
                        
                        
                        //返回块
                        if (completedBlock) {
                            completedBlock(imageData,nil,YES);
                        }
                        
                        weakself.kk_imageDataURLString = nil;

                        
                        //移除转圈圈
                        [weakself kk_removeActivityIndicatorView];
                        [weakself kk_removePlaceHolderView];
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //返回块
                        if (completedBlock) {
                            completedBlock(nil,error,YES);
                        }
                        
                        weakself.kk_imageDataURLString = nil;

                        //移除转圈圈
                        [weakself kk_removeActivityIndicatorView];
                    });
                }
                
            }
            
            
        }];
        
        //开始任务
        [task resume];
        
    });
}

#pragma mark ==================================================
#pragma mark ==设置图片 setBackgroundImageWithURL
#pragma mark ==================================================
/*无状态*/
- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder{
    [self kk_setBackgroundImageWithURL:url
                      placeholderImage:placeholder
                              forState:KKControlStateNone
                     showActivityStyle:KKActivityIndicatorViewStyleNone
                             completed:nil];
}

- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                   showActivityStyle:(KKActivityIndicatorViewStyle)aStyle{
    
    [self kk_setBackgroundImageWithURL:url
                      placeholderImage:placeholder
                              forState:KKControlStateNone
                     showActivityStyle:aStyle
                             completed:nil];
}


/*状态*/
- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                            forState:(KKControlState)state{
    [self kk_setBackgroundImageWithURL:url
                      placeholderImage:placeholder
                              forState:state
                     showActivityStyle:KKActivityIndicatorViewStyleNone
                             completed:nil];
}

- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                            forState:(KKControlState)state
                   showActivityStyle:(KKActivityIndicatorViewStyle)aStyle{
    
    [self kk_setBackgroundImageWithURL:url
                      placeholderImage:placeholder
                              forState:state
                     showActivityStyle:aStyle
                             completed:nil];
    
}

/*GCD块*/
- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                           completed:(KKImageLoadCompletedBlock)completedBlock{
    [self kk_setBackgroundImageWithURL:url
                      placeholderImage:placeholder
                              forState:KKControlStateNone
                     showActivityStyle:KKActivityIndicatorViewStyleNone
                             completed:completedBlock];
}

- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                   showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                           completed:(KKImageLoadCompletedBlock)completedBlock{
    
    [self kk_setBackgroundImageWithURL:url
                      placeholderImage:placeholder
                              forState:KKControlStateNone
                     showActivityStyle:aStyle
                             completed:completedBlock];
}

/*GCD块+状态*/
- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                            forState:(KKControlState)state
                           completed:(KKImageLoadCompletedBlock)completedBlock{
    [self kk_setBackgroundImageWithURL:url
                      placeholderImage:placeholder
                              forState:state
                     showActivityStyle:KKActivityIndicatorViewStyleNone
                             completed:completedBlock];
}

- (void)kk_setBackgroundImageWithURL:(NSURL *)url
                    placeholderImage:(UIImage *)placeholder
                            forState:(KKControlState)state
                   showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                           completed:(KKImageLoadCompletedBlock)completedBlock{
    
    if (state==KKControlStateNone) {
        [self setBackgroundImage:placeholder forState:UIControlStateNormal];
        [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];
    }
    else{
        [self setBackgroundImage:placeholder forState:(UIControlState)state];
    }
    
    /* 清除 */
    if (url==nil) {
        
        if (completedBlock) {
            completedBlock(nil,nil,NO);
        }
        
        self.kk_imageDataURLString = nil;
        
        if (placeholder==nil) [self kk_addPlaceHolderView];
        
        return;
    }
    
    /* 存在缓存数据 */
    [self kk_removePlaceHolderView];
    if ([KKFileCacheManager isExistCacheData:[url absoluteString]]) {
        [self kk_setBackgroundImageWithURL_ForLocal:url forState:state completed:completedBlock];
    }
    else{
        [self kk_setBackgroundImageWithURL_ForRemote:url
                                    placeholderImage:placeholder
                                            forState:state
                                   showActivityStyle:aStyle
                                           completed:completedBlock];
    }
}

/* 加载本地图片 */
- (void)kk_setBackgroundImageWithURL_ForLocal:(NSURL *)url
                                     forState:(KKControlState)state
                                    completed:(KKImageLoadCompletedBlock)completedBlock{

    //KKLogInfoFormat(@"UIButton+KKWebCache加载本地缓存图片:  %@",KKValidString(url.absoluteString));

    [self kk_removePlaceHolderView];

    NSData *data = [KKFileCacheManager readCacheData:[url absoluteString]];
    if ([[UIImage kk_contentTypeExtensionForImageData:data] isEqualToString:UIImageExtensionType_GIF]) {
        [self kk_showGIFSubView:data];
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
    
    if (completedBlock) {
        completedBlock(data,nil,NO);
    }
    
    self.kk_imageDataURLString = nil;
}

/* 加载网络图片 */
- (void)kk_setBackgroundImageWithURL_ForRemote:(NSURL *)url
                              placeholderImage:(UIImage *)placeholder
                                      forState:(KKControlState)state
                             showActivityStyle:(KKActivityIndicatorViewStyle)aStyle
                                     completed:(KKImageLoadCompletedBlock)completedBlock{

    //KKLogInfoFormat(@"UIButton+KKWebCache加载远程图片:  %@",KKValidString(url.absoluteString));

    if (state==KKControlStateNone) {
        [self setBackgroundImage:placeholder forState:UIControlStateNormal];
        [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];
    }
    else{
        [self setBackgroundImage:placeholder forState:(UIControlState)state];
    }
    
    if (placeholder==nil) [self kk_addPlaceHolderView];
        
    self.kk_imageDataURLString = [url absoluteString];
    
    if ([NSString kk_isStringEmpty:[url absoluteString]]) {
        
        if (completedBlock) {
            completedBlock(nil,nil,NO);
        }
        
        self.kk_imageDataURLString = nil;

        if (placeholder==nil) [self kk_addPlaceHolderView];
        
        return;
    }
    
    if (placeholder==nil) [self kk_addPlaceHolderView];
    
    [self kk_addActivityIndicatorView:aStyle];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        KKWeakSelf(self);
        NSURLRequest *reque = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:reque completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                        
            if ([[response.URL absoluteString] isEqualToString:self.kk_imageDataURLString]) {
                NSData *imageData = [KKWebCache saveWebImage:location response:response identifier:weakself.kk_imageDataURLString];

                if (imageData) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //刷新界面
                        if ([[UIImage kk_contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF]) {
                            [weakself kk_showGIFSubView:imageData];
                        }
                        else{
                            if (state==KKControlStateNone) {
                                [weakself setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                                [weakself setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateHighlighted];
                            }
                            else{
                                [weakself setBackgroundImage:[UIImage imageWithData:imageData] forState:(UIControlState)state];
                            }
                        }
                        
                        
                        //返回块
                        if (completedBlock) {
                            completedBlock(imageData,nil,YES);
                        }
                        
                        if (placeholder==nil) [self kk_addPlaceHolderView];
                        
                        //移除转圈圈
                        [weakself kk_removeActivityIndicatorView];
                        [weakself kk_removePlaceHolderView];
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //返回块
                        if (completedBlock) {
                            completedBlock(nil,error,YES);
                        }
                        
                        weakself.kk_imageDataURLString = nil;

                        //移除转圈圈
                        [weakself kk_removeActivityIndicatorView];
                    });
                    
                }
            }
        }];
        
        //开始任务
        [task resume];
        
    });
    
}

#pragma mark ==================================================
#pragma mark ==通用
#pragma mark ==================================================
- (void)kk_showGIFSubView:(NSData*)data{
    UIImageView *imageView = (UIImageView*)[self viewWithTag:ButtonGifImageViewTag];
    if (!imageView) {
        imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.tag = ButtonGifImageViewTag;
        [self addSubview:imageView];
    }
    [imageView kk_showImageData:data inFrame:imageView.frame];
}

#pragma mark ==================================================
#pragma mark == 等待视图
#pragma mark ==================================================
- (void)kk_addActivityIndicatorView:(KKActivityIndicatorViewStyle)aStyle{
    
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
        
    });
}

- (void)kk_removeActivityIndicatorView{
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
- (void)kk_addPlaceHolderView{
    
    [self kk_removePlaceHolderView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.backgroundColor = [UIColor kk_colorWithHexString:@"#F8F8F8"];
        imageView.tag = 2018063001;
        [self addSubview:imageView];
        [imageView kk_sendToBack];
        
//        UIImage *image = nil;
//        
//        @try {
//            image = [NSObject kk_defaultImage];
//        } @catch (NSException *exception) {
//            
//        } @finally {
//            if (image) {
//                
//                CGSize imageSize = image.size;
//                
//                if (image.size.width>imageView.frame.size.width ||
//                    image.size.height>imageView.frame.size.height ) {
//                    
//                    imageSize = CGSizeMake(image.size.width/2.0, image.size.height/2.0);
//                }
//                
//                UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((imageView.frame.size.width-imageSize.width)/2.0, (imageView.frame.size.height-imageSize.height)/2.0, imageSize.width, imageSize.height)];
//                icon.image = image;
//                [imageView addSubview:icon];
//            }
//        }
    });
}

/**
 移除占位视图
 */
- (void)kk_removePlaceHolderView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self viewWithTag:2018063001] removeFromSuperview];
    });
}

@end
