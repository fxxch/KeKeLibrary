//
//  KKThemeManager.m
//  KKLibrary_Demo
//
//  Created by liubo on 14/12/1.
//  Copyright (c) 2014年 KeKeStudio. All rights reserved.
//

#import "KKThemeManager.h"
#import "KKLog.h"

NSNotificationName const NotificationName_ThemeHasChanged = @"NotificationName_ThemeHasChanged";

@interface KKThemeManager ()


@end


@implementation KKThemeManager


+ (KKThemeManager *)sharedInstance {
    static KKThemeManager *KKThemeManager_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKThemeManager_sharedInstance = [[self alloc] init];
    });
    return KKThemeManager_sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.themeInformation = [[NSMutableDictionary alloc]init];
        [self initTheme];
    }
    return self;
}

- (void)initTheme{
    
    //app名称
    NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    
    NSString *themePath = [NSString stringWithFormat:@"%@/%@.bundle/theme.plist",
                   [[NSBundle mainBundle] bundlePath],
                                  app_Name];
    
    self.currentThemeName = nil;
    self.currentThemeName = app_Name;

    
    if (![[NSFileManager defaultManager] fileExistsAtPath:themePath]) {
        themePath = [NSString stringWithFormat:@"%@/%@.bundle/theme.plist",
                     [[NSBundle mainBundle] bundlePath],
                     DefaultThemeBundleName];
        self.currentThemeName = nil;
        self.currentThemeName = DefaultThemeBundleName;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:themePath]) {
        NSDictionary *themeInfo = [NSDictionary dictionaryWithContentsOfFile:themePath];
        if (themeInfo && [themeInfo isKindOfClass:[NSDictionary class]]) {
            [self.themeInformation removeAllObjects];
            [self.themeInformation setValuesForKeysWithDictionary:themeInfo];
            return;
        }
        else{
            [self.themeInformation removeAllObjects];
            KKLogErrorFormat(@"warning:【主题加载】失败！%@.bundle 存在,但是里面的theme.plist不是Dictionary对象",KKValidString(app_Name));
            return;
        }
    }
    
    
    //app显示名称
    NSString *app_ShowName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    themePath = [NSString stringWithFormat:@"%@/%@.bundle/theme.plist",
                           [[NSBundle mainBundle] bundlePath],
                           app_ShowName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:themePath]) {
        NSDictionary *themeInfo = [NSDictionary dictionaryWithContentsOfFile:themePath];
        if (themeInfo && [themeInfo isKindOfClass:[NSDictionary class]]) {
            [self.themeInformation removeAllObjects];
            [self.themeInformation setValuesForKeysWithDictionary:themeInfo];
            self.currentThemeName = app_ShowName;
            return;
        }
        else{
            [self.themeInformation removeAllObjects];
            KKLogErrorFormat(@"warning:【主题加载】失败！%@.bundle 存在,但是里面的theme.plist不是Dictionary对象",KKValidString(app_ShowName));
            return;
        }
    }
    
    //默认主题
    NSString *defaultThemeName = @"DefaultTheme";
    themePath = [NSString stringWithFormat:@"%@/%@.bundle/theme.plist",
                 [[NSBundle mainBundle] bundlePath],
                 defaultThemeName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:themePath]) {
        NSDictionary *themeInfo = [NSDictionary dictionaryWithContentsOfFile:themePath];
        if (themeInfo && [themeInfo isKindOfClass:[NSDictionary class]]) {
            [self.themeInformation removeAllObjects];
            [self.themeInformation setValuesForKeysWithDictionary:themeInfo];
            self.currentThemeName = defaultThemeName;
            return;
        }
        else{
            [self.themeInformation removeAllObjects];
            KKLogErrorFormat(@"warning:【主题加载】失败！%@.bundle 存在,但是里面的theme.plist不是Dictionary对象",KKValidString(defaultThemeName));
            return;
        }
    }
    
    KKLogWarningFormat(@"warning:主题加载失败！%@.bundle/theme.plist、%@.bundle/theme.plist 、%@.bundle/theme.plist 没有一个存在",KKValidString(app_Name),KKValidString(app_ShowName),KKValidString(defaultThemeName));
}

- (void)reloadThemeWithThemeBundleName:(NSString*)themeBundleName{
    
    NSString *themePath = [NSString stringWithFormat:@"%@/%@.bundle/theme.plist",
                           [[NSBundle mainBundle] bundlePath],
                           themeBundleName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:themePath]) {
        NSDictionary *themeInfo = [NSDictionary dictionaryWithContentsOfFile:themePath];
        if (themeInfo && [themeInfo isKindOfClass:[NSDictionary class]]) {
            [self.themeInformation removeAllObjects];
            [self.themeInformation setValuesForKeysWithDictionary:themeInfo];
            self.currentThemeName = nil;
            self.currentThemeName = themeBundleName;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_ThemeHasChanged object:nil];
            return;
        }
        else{
            KKLogErrorFormat(@"warning:主题加载失败！%@.bundle 不存在",KKValidString(themeBundleName));
            return;
        }
    }
    
}


+ (UIImage *)imageWithKey:(NSString *)key {
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSString *imageName = [[[KKThemeManager sharedInstance] themeInformation] objectForKey:key];
    if (!imageName || [imageName isKindOfClass:[NSNumber class]]) {
        KKLogErrorFormat(@"warning:【主题加载】图片：%@，没有在theme.plist里面配置信息",KKValidString(key));
        return nil;
    }
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    
    NSString *imagePath1x = [NSString stringWithFormat:@"%@/%@.bundle/%@",
                             [[NSBundle mainBundle] bundlePath],
                             [[KKThemeManager sharedInstance] currentThemeName],
                             imageName];
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
            return image;
        }
        else{
            KKLogErrorFormat(@"warning:【主题加载】图片：%@找到了路径：%@，但是并非图片资源",KKValidString(key),KKValidString(imagePath));
            return nil;
        }
    }
    else{
        KKLogErrorFormat(@"warning:【主题加载】图片：%@找不到路径%@",KKValidString(key),KKValidString(imagePath));
        return nil;
    }
}

+ (NSString *)imagePathWithKey:(NSString *)key {
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSString *imageName = [[[KKThemeManager sharedInstance] themeInformation] objectForKey:key];
    if (!imageName || [imageName isKindOfClass:[NSNumber class]]) {
        KKLogErrorFormat(@"warning:【主题加载】图片：%@，没有在theme.plist里面配置信息",KKValidString(key));
        return nil;
    }
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    
    NSString *imagePath1x = [NSString stringWithFormat:@"%@/%@.bundle/%@",
                             [[NSBundle mainBundle] bundlePath],
                             [[KKThemeManager sharedInstance] currentThemeName],
                             imageName];
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
            KKLogErrorFormat(@"warning:【主题加载】图片：%@找到了路径：%@，但是并非图片资源",KKValidString(key),KKValidString(imagePath));
            return nil;
        }
    }
    else{
        KKLogErrorFormat(@"warning:【主题加载】图片：%@找不到路径%@",KKValidString(key),KKValidString(imagePath));
        return nil;
    }
}

+ (NSString *)gifImagePathWithKey:(NSString *)key{
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSString *imageName = [[[KKThemeManager sharedInstance] themeInformation] objectForKey:key];
    if (!imageName || [imageName isKindOfClass:[NSNumber class]]) {
        KKLogErrorFormat(@"warning:【主题加载】图片：%@，没有在theme.plist里面配置信息",KKValidString(key));
        return nil;
    }
    
    NSString *imagePath1x = [NSString stringWithFormat:@"%@/%@.bundle/%@",
                             [[NSBundle mainBundle] bundlePath],
                             [[KKThemeManager sharedInstance] currentThemeName],
                             imageName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath1x]) {
        return imagePath1x;
    }
    else{
        KKLogErrorFormat(@"warning:【主题加载】图片：%@找不到路径%@",KKValidString(key),KKValidString(imagePath1x));
        return nil;
    }
}



+ (UIColor *)colorWithKey:(NSString *)key {
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSString *colorString = [[[KKThemeManager sharedInstance] themeInformation] objectForKey:key];
    
    if ([colorString hasPrefix:@"&"]) {
        return [KKThemeManager colorWithKey:[colorString substringFromIndex:1]];
    }
    
    
    if ([colorString hasPrefix:@"#"]) {
        return [KKThemeManager colorWithHex:colorString];
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
            KKLogErrorFormat(@"warning:【主题加载】颜色：颜色值格式错误%@，格式应该是#FFFFFF或者R,G,B,A 例如134,135,136,1.0",KKValidString(key));
            return nil;
        }
    }
}

+ (UIColor *) colorWithHex: (NSString *) hexString {
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
            
        case 3: // #RGB
            
            alpha = 1.0f;
            
            red   = [KKThemeManager colorComponentFrom: colorString start: 0 length: 1];
            
            green = [KKThemeManager colorComponentFrom: colorString start: 1 length: 1];
            
            blue  = [KKThemeManager colorComponentFrom: colorString start: 2 length: 1];
            
            break;
            
        case 4: // #ARGB
            
            alpha = [KKThemeManager colorComponentFrom: colorString start: 0 length: 1];
            
            red   = [KKThemeManager colorComponentFrom: colorString start: 1 length: 1];
            
            green = [KKThemeManager colorComponentFrom: colorString start: 2 length: 1];
            
            blue  = [KKThemeManager colorComponentFrom: colorString start: 3 length: 1];
            
            break;
            
        case 6: // #RRGGBB
            
            alpha = 1.0f;
            
            red   = [KKThemeManager colorComponentFrom: colorString start: 0 length: 2];
            
            green = [KKThemeManager colorComponentFrom: colorString start: 2 length: 2];
            
            blue  = [KKThemeManager colorComponentFrom: colorString start: 4 length: 2];
            
            break;
            
        case 8: // #AARRGGBB
            
            alpha = [KKThemeManager colorComponentFrom: colorString start: 0 length: 2];
            
            red   = [KKThemeManager colorComponentFrom: colorString start: 2 length: 2];
            
            green = [KKThemeManager colorComponentFrom: colorString start: 4 length: 2];
            
            blue  = [KKThemeManager colorComponentFrom: colorString start: 6 length: 2];
            
            break;
            
        default:
            
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            
            break;
            
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
    
}


+ (UIFont *)fontWithKey:(NSString *)key {
    if (key == nil || [[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return nil;
    }
    
    NSString *fontString = [[[KKThemeManager sharedInstance] themeInformation] objectForKey:key];
    
    if ([fontString hasPrefix:@"&"]) {
        return [KKThemeManager fontWithKey:[fontString substringFromIndex:1]];
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



@end
