//
//  KKResourceManager.m
//  KKLibrary_Demo
//
//  Created by liubo on 14/12/1.
//  Copyright (c) 2014年 KeKeStudio. All rights reserved.
//

#import "KKResourceManager.h"
#import "KKLog.h"

////app名称
//NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
////app显示名称
//NSString *app_ShowName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];

@implementation KKResourceManager

#pragma mark ==================================================
#pragma mark == Private
#pragma mark ==================================================
+ (NSString*)loadThemeBundlePath_withBundleFileName:(NSString*)aBundleFileName{
    NSString *bundleName = aBundleFileName;
    if (bundleName==nil || bundleName.length==0) {
        KKLogErrorFormat(@"warning:【资源加载】失败！%@ bundle文件名不能为空",KKValidString(aBundleFileName));
        return nil;
    }
    if ([bundleName hasSuffix:@".bundle"]==NO) {
        bundleName = [bundleName stringByAppendingString:@".bundle"];
    }

    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *themeBundlePath = [NSString stringWithFormat:@"%@/%@",mainBundlePath,bundleName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:themeBundlePath]==NO) {
        KKLogErrorFormat(@"warning:【资源加载】失败！%@ 不存在",KKValidString(themeBundlePath));
        return nil;
    }
    return themeBundlePath;
}

+ (NSDictionary*)loadThemeInformation_withBundleFileName:(NSString*)aBundleFileName{

    NSString *themeBundlePath = [KKResourceManager loadThemeBundlePath_withBundleFileName:aBundleFileName];
    //NSString *bundleFileName = [themeBundlePath lastPathComponent];
    if (themeBundlePath) {
        NSString *themePlistPath = [NSString stringWithFormat:@"%@/theme.plist",themeBundlePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:themePlistPath]==NO) {
            KKLogErrorFormat(@"warning:【资源加载】失败！%@ 存在,但是里面的 theme.plist 不存在",KKValidString(themeBundlePath));
            return nil;
        }
        NSDictionary *themeInfo = [NSDictionary dictionaryWithContentsOfFile:themePlistPath];
        if (themeInfo==nil || [themeInfo isKindOfClass:[NSDictionary class]]==NO) {
            KKLogErrorFormat(@"warning:【资源加载】失败！%@ 存在,但是里面的 theme.plist 不是Dictionary对象",KKValidString(themeBundlePath));
            return nil;
        }
        else{
            return themeInfo;
        }
    }
    else {
        return nil;
    }
}

+ (NSString*)imagePathWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName{
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSDictionary *themeInformation = [KKResourceManager loadThemeInformation_withBundleFileName:aBundleFileName];
    NSString *themeBundlePath = [KKResourceManager loadThemeBundlePath_withBundleFileName:aBundleFileName];

    NSString *imageName = [themeInformation objectForKey:key];
    if (!imageName || [imageName isKindOfClass:[NSNumber class]]) {
        KKLogErrorFormat(@"warning:【资源加载】图片：%@，没有在theme.plist里面配置信息",KKValidString(key));
        return nil;
    }
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    
    NSString *imagePath1x = [NSString stringWithFormat:@"%@/%@", themeBundlePath,imageName];
    //添加@2x
    NSString *imagePath2x = [[imagePath1x stringByDeletingLastPathComponent]
                             stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@",
                                                             [[imagePath1x lastPathComponent] stringByDeletingPathExtension],
                                                             [imagePath1x pathExtension]]];
    
    //添加@2x
    NSString *imagePath3x = [[imagePath1x stringByDeletingLastPathComponent]
                             stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@3x.%@",
                                                             [[imagePath1x lastPathComponent] stringByDeletingPathExtension],
                                                             [imagePath1x pathExtension]]];
    
    NSString *imagePath = nil;
    //Retina屏
    if ([[UIScreen mainScreen] scale] == 2.0 ) {
        imagePath = imagePath2x;
    }
    else if ([[UIScreen mainScreen] scale] == 3.0 ) {
        imagePath = imagePath3x;
        if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            imagePath = imagePath2x;
        }
    }
    else{
        imagePath = imagePath1x;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (image && [image isKindOfClass:[UIImage class]]) {
            return imagePath;
        }
        else{
            KKLogErrorFormat(@"warning:【资源加载】图片：%@找到了路径：%@，但是并非图片资源",KKValidString(key),KKValidString(imagePath));
            return nil;
        }
    }
    else{
        KKLogErrorFormat(@"warning:【资源加载】图片：%@找不到路径%@",KKValidString(key),KKValidString(imagePath));
        return nil;
    }
}

+ (UIImage*)imageWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName{
    NSString *imagePath = [KKResourceManager imagePathWithKey:key inBundle:aBundleFileName];
    if (imagePath) {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        return image;
    } else {
        return nil;
    }
}

+ (NSString*)gifImagePathWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName{
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSDictionary *themeInformation = [KKResourceManager loadThemeInformation_withBundleFileName:aBundleFileName];
    NSString *themeBundlePath = [KKResourceManager loadThemeBundlePath_withBundleFileName:aBundleFileName];
    NSString *imageName = [themeInformation objectForKey:key];
    if (!imageName || [imageName isKindOfClass:[NSNumber class]]) {
        KKLogErrorFormat(@"warning:【资源加载】图片：%@，没有在theme.plist里面配置信息",KKValidString(key));
        return nil;
    }
    
    NSString *imagePath1x = [NSString stringWithFormat:@"%@/%@", themeBundlePath,imageName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath1x]) {
        return imagePath1x;
    }
    else{
        KKLogErrorFormat(@"warning:【资源加载】图片：%@找不到路径%@",KKValidString(key),KKValidString(imagePath1x));
        return nil;
    }
}

+ (UIFont*)fontWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName{
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSDictionary *themeInformation = [KKResourceManager loadThemeInformation_withBundleFileName:aBundleFileName];
    NSString *fontString = [themeInformation objectForKey:key];
    
    if ([fontString hasPrefix:@"&"]) {
        return [KKResourceManager fontWithKey:[fontString substringFromIndex:1] inBundle:aBundleFileName];
    }
    
    NSArray *fontList = [fontString componentsSeparatedByString:@","];
    
    if (fontList.count >= 2) {
        return [UIFont fontWithName:[fontList objectAtIndex:0]
                               size:[[fontList objectAtIndex:1] floatValue]];
    }
    else {
        fontString = [fontList objectAtIndex:0];
        
        if ([fontString floatValue] >= CGFLOAT_DEFINED) {
            return [UIFont systemFontOfSize:[fontString floatValue]];
        } else {
            return [UIFont fontWithName:fontString size:12.0f];
        }
    }
}

+ (UIColor*)colorWithKey:(NSString*)key inBundle:(NSString*)aBundleFileName{
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSDictionary *themeInformation = [KKResourceManager loadThemeInformation_withBundleFileName:aBundleFileName];
    NSString *colorString = [themeInformation objectForKey:key];
    
    if ([colorString hasPrefix:@"&"]) {
        return [KKResourceManager colorWithKey:[colorString substringFromIndex:1] inBundle:aBundleFileName];
    }
    
    
    if ([colorString hasPrefix:@"#"]) {
        return [KKResourceManager private_colorWithHex:colorString];
    }
    else {
        NSArray *colorList = [colorString componentsSeparatedByString:@","];
        
        if ([colorList count] > 3) {
            CGFloat r = [[colorList objectAtIndex:0] floatValue];
            CGFloat g = [[colorList objectAtIndex:1] floatValue];
            CGFloat b = [[colorList objectAtIndex:2] floatValue];
            CGFloat a = [[colorList objectAtIndex:3] floatValue];
            
            if (r>1.0f) {
                r= r/255.0f;
            }
            
            if (g>1.0f) {
                g= g/255.0f;
            }
            
            if (b>1.0f) {
                b= b/255.0f;
            }
            
            return [UIColor colorWithRed:r
                                    green:g
                                     blue:b
                                    alpha:a];
        }
        else {
            KKLogErrorFormat(@"warning:【资源加载】颜色：颜色值格式错误%@，格式应该是#FFFFFF或者R,G,B,A 例如134,135,136,1.0",KKValidString(key));
            return nil;
        }
    }
}

+ (UIColor*)private_colorWithHex: (NSString*)hexString {
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
            
        case 3: // #RGB
            
            alpha = 1.0f;
            
            red   = [KKResourceManager private_colorComponentFrom: colorString start: 0 length: 1];
            
            green = [KKResourceManager private_colorComponentFrom: colorString start: 1 length: 1];
            
            blue  = [KKResourceManager private_colorComponentFrom: colorString start: 2 length: 1];
            
            break;
            
        case 4: // #ARGB
            
            alpha = [KKResourceManager private_colorComponentFrom: colorString start: 0 length: 1];
            
            red   = [KKResourceManager private_colorComponentFrom: colorString start: 1 length: 1];
            
            green = [KKResourceManager private_colorComponentFrom: colorString start: 2 length: 1];
            
            blue  = [KKResourceManager private_colorComponentFrom: colorString start: 3 length: 1];
            
            break;
            
        case 6: // #RRGGBB
            
            alpha = 1.0f;
            
            red   = [KKResourceManager private_colorComponentFrom: colorString start: 0 length: 2];
            
            green = [KKResourceManager private_colorComponentFrom: colorString start: 2 length: 2];
            
            blue  = [KKResourceManager private_colorComponentFrom: colorString start: 4 length: 2];
            
            break;
            
        case 8: // #AARRGGBB
            
            alpha = [KKResourceManager private_colorComponentFrom: colorString start: 0 length: 2];
            
            red   = [KKResourceManager private_colorComponentFrom: colorString start: 2 length: 2];
            
            green = [KKResourceManager private_colorComponentFrom: colorString start: 4 length: 2];
            
            blue  = [KKResourceManager private_colorComponentFrom: colorString start: 6 length: 2];
            
            break;
            
        default:
            
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            
            break;
            
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    
}

+ (CGFloat)private_colorComponentFrom: (NSString*)string start: (NSUInteger)start length: (NSUInteger)length {
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
    
}



@end
