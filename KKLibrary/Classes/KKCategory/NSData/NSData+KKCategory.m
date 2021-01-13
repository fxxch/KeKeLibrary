//
//  NSData+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSData+KKCategory.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIScreen+KKCategory.h"
#import "UIImage+KKCategory.h"

static char encodingTable[64] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

@implementation NSData (KKCategory)

- (nonnull NSString *)md5 {
    if (!self) {
        return nil;
    }
    void *cData = malloc([self length]);
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    [self getBytes:cData length:[self length]];
    CC_MD5(cData, (CC_LONG)[self length], result);
    
    NSMutableString *outString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [outString appendFormat:@"%02x", result[i]];
    }
    return outString;
}

- (nonnull NSString *)base64Encoded {
    const unsigned char    *bytes = [self bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
    unsigned long ixtext = 0;
    unsigned long lentext = [self length];
    long ctremaining = 0;
    unsigned char inbuf[3], outbuf[4];
    unsigned short i = 0;
    unsigned short charsonline = 0, ctcopy = 0;
    unsigned long ix = 0;
    
    while(YES) {
        ctremaining = lentext - ixtext;
        if( ctremaining <= 0 ) break;
        
        for( i = 0; i < 3; i++ ) {
            ix = ixtext + i;
            if( ix < lentext ) inbuf[i] = bytes[ix];
            else inbuf [i] = 0;
        }
        
        outbuf [0] = (inbuf [0] & 0xFC) >> 2;
        outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
        outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
        outbuf [3] = inbuf [2] & 0x3F;
        ctcopy = 4;
        
        switch( ctremaining ) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for( i = 0; i < ctcopy; i++ ) {
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
        }
        
        for( i = ctcopy; i < 4; i++ ) {
            [result appendString:@"="];
        }
        
        ixtext += 3;
        charsonline += 4;
    }
    
    return [NSString stringWithString:result];
}

- (nonnull NSData *)base64Decoded {
    const unsigned char    *bytes = [self bytes];
    NSMutableData *result = [NSMutableData dataWithCapacity:[self length]];
    
    unsigned long ixtext = 0;
    unsigned long lentext = [self length];
    unsigned char ch = 0;
    unsigned char inbuf[4] = {0, 0, 0, 0};
    unsigned char outbuf[3] = {0, 0, 0};
    short i = 0, ixinbuf = 0;
    BOOL flignore = NO;
    BOOL flendtext = NO;
    
    while( YES ) {
        if( ixtext >= lentext ) break;
        ch = bytes[ixtext++];
        flignore = NO;
        
        if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
        else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
        else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
        else if( ch == '+' ) ch = 62;
        else if( ch == '=' ) flendtext = YES;
        else if( ch == '/' ) ch = 63;
        else flignore = YES;
        
        if( ! flignore ) {
            short ctcharsinbuf = 3;
            BOOL flbreak = NO;
            
            if( flendtext ) {
                if( ! ixinbuf ) break;
                if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
                else ctcharsinbuf = 2;
                ixinbuf = 3;
                flbreak = YES;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if( ixinbuf == 4 ) {
                ixinbuf = 0;
                outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
                outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
                outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
                
                for( i = 0; i < ctcharsinbuf; i++ )
                    [result appendBytes:&outbuf[i] length:1];
            }
            
            if( flbreak )  break;
        }
    }
    return [NSData dataWithData:result];
}

/**
 将图片压缩到指定大小 imageArray UIImage数组，imageDataSize 图片数据大小(单位KB)，比如100KB
 
 @param imageArray 需要转换的图片数组
 @param imageDataSize 需要压缩到图片数据大小(单位KB)，比如100KB
 @param completedOneBlock 处理完成一张的回调
 @param completedAllBlock 处理完成所有的回调
 ☆☆☆☆☆ 注意，外面传进来的imageArray中的Image一定不要用[UIImage imageWithContentsOfFile:aFileFullPath]的方式，否则会出问题
 */
+ (void)convertImage:(nullable NSArray*)imageArray
          toDataSize:(CGFloat)imageDataSize
        oneCompleted:(KKImageConvertImageOneCompletedBlock _Nullable)completedOneBlock
   allCompletedBlock:(KKImageConvertImageAllCompletedBlock _Nullable)completedAllBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        CGFloat maxLength = imageDataSize*1024;
        
        
        for (NSInteger m=0; m<[imageArray count]; m++) {
            
            // Compress by quality
            UIImage *originalImage_in = [imageArray objectAtIndex:m];
            CGFloat compression = 1;
            NSData *data = UIImageJPEGRepresentation(originalImage_in, compression);
            if (data.length < maxLength){
                //主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    completedOneBlock(data,m);
                });
            }
            else{
                
                CGFloat max = 1;
                CGFloat min = 0;
                for (int k = 0; k < 6; ++k) {
                    compression = (max + min) / 2;
                    data = UIImageJPEGRepresentation(originalImage_in, compression);
                    if (data.length < maxLength * 0.9) {
                        min = compression;
                    } else if (data.length > maxLength) {
                        max = compression;
                    } else {
                        break;
                    }
                }
                if (data.length < maxLength){
                    //主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completedOneBlock(data,m);
                    });
                    continue;
                }
                
                
                UIImage *resultImage = [UIImage imageWithData:data];
                // Compress by size
                NSUInteger lastDataLength = 0;
                while (data.length > maxLength && data.length != lastDataLength) {
                    lastDataLength = data.length;
                    CGFloat ratio = (CGFloat)maxLength / data.length;
                    CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                             (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
                    UIGraphicsBeginImageContext(size);
                    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
                    resultImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    data = UIImageJPEGRepresentation(resultImage, compression);
                }
                //主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    completedOneBlock(data,m);
                });
                
            }
            
            
        }
        
        //主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completedAllBlock) {
                completedAllBlock();
            }
        });
        
    });
    
}

@end
