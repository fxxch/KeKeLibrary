//
//  KKWindowImageItem.m
//  ProjectK
//
//  Created by liubo on 14-8-22.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "KKWindowImageItem.h"
#import "UIButton+KKWebCache.h"
#import "UIImageView+KKWebCache.h"
#import "KKSharedInstance.h"
#import "KeKeLibraryDefine.h"
#import "KKCategory.h"

@implementation KKWindowImageItem

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 初始化界面
#pragma mark ==================================================
- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    
    self.myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.myScrollView.backgroundColor = [UIColor clearColor];
    self.myScrollView.bounces = YES;
    self.myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    self.myScrollView.minimumZoomScale = 1.0;
    self.myScrollView.maximumZoomScale = 5.0;
    self.myScrollView.delegate = self;

    self.myImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.myImageView.clipsToBounds = YES;
    self.myImageView.backgroundColor = [UIColor clearColor];
    self.myImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ;
    [self.myScrollView addSubview:self.myImageView];
    [self addSubview:self.myScrollView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tapGestureRecognizer.delegate = self;
    [self.myScrollView addGestureRecognizer:tapGestureRecognizer];
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressGesture.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    [longPressGesture setDelegate:self];
    [self.myScrollView addGestureRecognizer:longPressGesture];
}

- (void)reloaWithImageURLString:(NSString*)aImageURLString
               placeholderImage:(UIImage*)aPlaceholderImage{
    
    self.imageDefault = aPlaceholderImage;
    
    self.image_URLString = aImageURLString;
    
    if (aImageURLString) {
        if ([[[aImageURLString lastPathComponent] lowercaseString] hasSuffix:@"gif"]) {
            NSString *tempString = [aImageURLString stringByReplacingOccurrencesOfString:[aImageURLString lastPathComponent] withString:@""];
            self.image_URLString = [tempString stringByAppendingString:[aImageURLString lastPathComponent]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageItem:isGIF:)]) {
                [self.delegate KKWindowImageItem:self isGIF:YES];
            }
        }
        else{
            self.image_URLString = aImageURLString;
            if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageItem:isGIF:)]) {
                [self.delegate KKWindowImageItem:self isGIF:NO];
            }
        }
        
        if (aPlaceholderImage) {
            NSURL *iamgeURL = nil;
            if ([[aImageURLString lowercaseString] hasPrefix:@"http"]) {
                iamgeURL = [NSURL URLWithString:aImageURLString];
                
                KKWeakSelf(self);

                [self.myImageView setImageWithURL:iamgeURL requestONWifi:NO placeholderImage:aPlaceholderImage showActivityStyle:KKActivityIndicatorViewStyleWhiteLarge completed:^(NSData *imageData, NSError *error, BOOL isFromRequest) {
                    
                    weakself.myScrollView.minimumZoomScale = 1.0;
                    weakself.myScrollView.maximumZoomScale = 5.0;
                    
                    if (isFromRequest) {
                        [UIView animateWithDuration:0.3 animations:^{
                            weakself.myImageView.frame = weakself.bounds;
                        } completion:^(BOOL finished) {
                            [weakself.myImageView showImageData:imageData inFrame:weakself.bounds];
                        }];
                    }
                    else{
                        weakself.myImageView.frame = weakself.bounds;
                        [weakself.myImageView showImageData:imageData inFrame:weakself.bounds];
                    }
                }];
            }
            else{
                NSData *imageData = [NSData dataWithContentsOfFile:aImageURLString];
                self.myImageView.frame = self.bounds;
                [self.myImageView showImageData:imageData inFrame:self.bounds];
            }
        }
        else{
//            myImageView.frame = CGRectMake((self.frame.size.width-5)/2.0, (self.frame.size.height-5)/2.0, 5, 5);
            self.myImageView.frame = self.bounds;
            self.myImageView.image = nil;
            
            self.myScrollView.minimumZoomScale = 1.0;
            self.myScrollView.maximumZoomScale = 1.0;
            
            NSURL *iamgeURL = nil;
            if ([[aImageURLString lowercaseString] hasPrefix:@"http"]) {
                iamgeURL = [NSURL URLWithString:aImageURLString];
                KKWeakSelf(self);
                [self.myImageView setImageWithURL:iamgeURL requestONWifi:NO placeholderImage:aPlaceholderImage showActivityStyle:KKActivityIndicatorViewStyleWhiteLarge completed:^(NSData *imageData, NSError *error, BOOL isFromRequest) {
                    
                    weakself.myScrollView.minimumZoomScale = 1.0;
                    weakself.myScrollView.maximumZoomScale = 5.0;
                    
                    if (isFromRequest) {
                        [UIView animateWithDuration:0.3 animations:^{
                            weakself.myImageView.frame = weakself.bounds;
                        } completion:^(BOOL finished) {
                            [weakself.myImageView showImageData:imageData inFrame:weakself.bounds];
                        }];
                    }
                    else{
                        weakself.myImageView.frame = weakself.bounds;
                        [weakself.myImageView showImageData:imageData inFrame:weakself.bounds];
                    }
                }];
            }
            else{
                NSData *imageData = [NSData dataWithContentsOfFile:aImageURLString];

                self.myImageView.frame = self.bounds;
                [self.myImageView showImageData:imageData inFrame:self.bounds];
            }
        }
    }
    else{        
        self.myImageView.frame = self.bounds;
        self.myScrollView.minimumZoomScale = 1.0;
        self.myScrollView.maximumZoomScale = 5.0;
        self.myImageView.image = aPlaceholderImage;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageItem:isGIF:)]) {
            [self.delegate KKWindowImageItem:self isGIF:NO];
        }
    }
}

//单击
-(void) singleTap:(UITapGestureRecognizer*) tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageItemSingleTap:)]) {
        [self.delegate KKWindowImageItemSingleTap:self];
    }
}

//长按
-(void) longPressed:(UITapGestureRecognizer*) tap {
    if (tap.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageItemLongPressed:)]) {
            [self.delegate KKWindowImageItemLongPressed:self];
        }        
    }
}


#pragma mark ==================================================
#pragma mark == 缩放
#pragma mark ==================================================
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.myImageView;//返回ScrollView上添加的需要缩放的视图
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}


@end
