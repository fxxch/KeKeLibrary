//
//  UIImageView+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIImageView+KKCategory.h"
#import "UIImage+KKCategory.h"

@implementation UIImageView (KKCategory)

/**
 显示图片数据
 
 @param imageData imageData
 */
- (void)showImageData:(nullable NSData*)imageData{
    if ([[UIImage contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF]) {
        NSMutableArray *frames = nil;
        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        double total = 0;
        CGFloat width = 0;
        CGFloat height = 0;
        
        NSTimeInterval gifAnimationDuration;
        if (src) {
            size_t l = CGImageSourceGetCount(src);
            if (l >= 1){
                frames = [NSMutableArray arrayWithCapacity: l];
                for (size_t i = 0; i < l; i++) {
                    CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
                    NSDictionary *dict = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, 0, NULL));
                    if (dict){
                        width = [[dict objectForKey: (NSString*)kCGImagePropertyPixelWidth] floatValue];
                        height = [[dict objectForKey: (NSString*)kCGImagePropertyPixelHeight] floatValue];
                        NSDictionary *tmpdict = [dict objectForKey: (NSString*)kCGImagePropertyGIFDictionary];
                        total += [[tmpdict objectForKey: (NSString*)kCGImagePropertyGIFDelayTime] doubleValue] * 100;
                    }
                    if (img) {
                        [frames addObject: [UIImage imageWithCGImage: img]];
                        CGImageRelease(img);
                    }
                }
                gifAnimationDuration = total / 100;
                
                CGRect oldFrame = self.frame;
                self.image = nil;
                self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, height);
                self.center = CGPointMake(oldFrame.origin.x+width/2.0, height/2.0);
                self.animationImages = frames;
                self.animationDuration = gifAnimationDuration;
                [self startAnimating];
            }
            
            CFRelease(src);
        }
    }
    else{
        self.animationImages = nil;
        self.animationDuration = 0;
        [self stopAnimating];
        self.image = [UIImage imageWithData:imageData];
    }
}

- (void)setNeedsLayout{
    [super setNeedsLayout];
    if (self.animationImages &&
        [self.animationImages count]>0 &&
        [self isAnimating]==NO) {
        [self startAnimating];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

/**
 显示图片数据
 
 @param imageData 图片数据
 @param rect 显示区域
 */
- (void)showImageData:(nullable NSData*)imageData
              inFrame:(CGRect)rect{
    
    if ([[UIImage contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF]) {
        NSMutableArray *frames = nil;
        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        
        //        NSDictionary *gifProperties = [[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
        //                                                     forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
        //        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_filePath], (CFDictionaryRef)gifProperties);
        //        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)imageData, (CFDictionaryRef)gifProperties);
        
        double total = 0;
        //        CGFloat width = 0;
        //        CGFloat height = 0;
        
        NSTimeInterval gifAnimationDuration;
        if (src) {
            size_t l = CGImageSourceGetCount(src);
            if (l >= 1){
                frames = [NSMutableArray arrayWithCapacity: l];
                for (size_t i = 0; i < l; i++) {
                    CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
                    NSDictionary *dict = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, 0, NULL));
                    if (dict){
                        //                        width = [[dict objectForKey: (NSString*)kCGImagePropertyPixelWidth] floatValue];
                        //                        height = [[dict objectForKey: (NSString*)kCGImagePropertyPixelHeight] floatValue];
                        NSDictionary *tmpdict = [dict objectForKey: (NSString*)kCGImagePropertyGIFDictionary];
                        total += [[tmpdict objectForKey: (NSString*)kCGImagePropertyGIFDelayTime] doubleValue] * 100;
                    }
                    if (img) {
                        [frames addObject: [UIImage imageWithCGImage: img]];
                        CGImageRelease(img);
                    }
                }
                gifAnimationDuration = total / 100;
                
                //                CGFloat rectHeight = rect.size.height;
                //                self.frame = CGRectMake(rect.origin.x, rect.origin.y, (rectHeight/height)*width, rectHeight);
                //                self.center = CGPointMake(rect.origin.x+(rectHeight/height)*width/2.0, rectHeight/2.0);
                self.image = nil;
                
                self.frame = rect;
                self.animationImages = frames;
                self.animationDuration = gifAnimationDuration;
                [self startAnimating];
            }
            CFRelease(src);
        }
    }
    else{
        self.animationImages = nil;
        self.animationDuration = 0;
        [self stopAnimating];
        
        self.frame = rect;
        self.image = [UIImage imageWithData:imageData];
    }
}

@end
