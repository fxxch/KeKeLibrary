//
//  UIColor+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIColor+KKCategory.h"

@implementation UIColor (KKCategory)

/**
 将UIColor转换成十六进制的颜色值
 
 @param color 颜色
 @return 结果
 */
+ (nonnull NSString *)kk_hexStringFromColor:(nullable UIColor *)color{
    
    const CGFloat* rgba = CGColorGetComponents(color.CGColor);
    
    int rgbaCount = (int)CGColorGetNumberOfComponents(color.CGColor);
    
    CGFloat r, g, b,alpha;
    
    if (rgbaCount >3) {
        
        r = rgba[0];
        
        g = rgba[1];
        
        b = rgba[2];
        
        alpha = rgba[3];
        
        alpha = alpha;   //avoid warning
        
    }else{
        
        r = rgba[0];
        
        g = rgba[1];
        
        b = rgba[2];
        
    }
    
    
    
    // Convert to hex string between 0x00 and 0xFF
    
    return [NSString stringWithFormat:@"%02X%02X%02X",(int)(r * 255), (int)(g * 255), (int)(b * 255)];
    
}

/**
 将十六进制的颜色值转换成UIColor
 
 @param hexString 十六进制颜色
 @return 结果
 */
+ (nonnull UIColor *)kk_colorWithHexString:(nonnull NSString *)hexString {
    
    return [UIColor kk_colorWithHexString:hexString alpha:1];

}

/**
 将十六进制的颜色值转换成UIColor
 
 @param hexString 十六进制颜色
 @param alphaValue 透明度
 @return 结果
 */
+ (nonnull UIColor *)kk_colorWithHexString:(nonnull NSString *)hexString alpha:(CGFloat)alphaValue{
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    alpha = alphaValue;
    
    switch ([colorString length]) {
            
        case 3: // #RGB
            
            red   = [self kk_colorComponentFrom: colorString start: 0 length: 1];
            
            green = [self kk_colorComponentFrom: colorString start: 1 length: 1];
            
            blue  = [self kk_colorComponentFrom: colorString start: 2 length: 1];
            
            break;
            
        case 4: // #RGBA
                        
            red   = [self kk_colorComponentFrom: colorString start: 0 length: 1];
            
            green = [self kk_colorComponentFrom: colorString start: 1 length: 1];
            
            blue  = [self kk_colorComponentFrom: colorString start: 2 length: 1];
            
            alpha = [self kk_colorComponentFrom: colorString start: 3 length: 1];

            break;
            
        case 6: // #RRGGBB
            
            red   = [self kk_colorComponentFrom: colorString start: 0 length: 2];
            
            green = [self kk_colorComponentFrom: colorString start: 2 length: 2];
            
            blue  = [self kk_colorComponentFrom: colorString start: 4 length: 2];
            
            break;
            
        case 8: // #RRGGBBAA
                        
            red   = [self kk_colorComponentFrom: colorString start: 0 length: 2];
            
            green = [self kk_colorComponentFrom: colorString start: 2 length: 2];
            
            blue  = [self kk_colorComponentFrom: colorString start: 4 length: 2];
            
            alpha = [self kk_colorComponentFrom: colorString start: 6 length: 2];

            break;
            
        default:
            
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            
            break;
            
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    
}

+ (CGFloat)kk_colorComponentFrom: (nullable NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
    
}


/**
 从UIColor里面获取RGB值
 
 @param color color
 @return 结果
 */
+ (nonnull NSArray *)kk_RGBAValue:(nonnull UIColor*)color{
    CGColorRef colorRef = [color CGColor];
    int numComponents = (int)CGColorGetNumberOfComponents(colorRef);
    NSMutableArray *arrary = [NSMutableArray array];
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        CGFloat R = components[0];
        CGFloat G = components[1];
        CGFloat B = components[2];
        CGFloat A = components[3];
        
        [arrary addObject:[NSNumber numberWithFloat:R]];
        [arrary addObject:[NSNumber numberWithFloat:G]];
        [arrary addObject:[NSNumber numberWithFloat:B]];
        [arrary addObject:[NSNumber numberWithFloat:A]];
    }
    
    return arrary;
}

/**
 通过RGBA值创建color

 @param rValue rValue（0-255）
 @param gValue gValue（0-255）
 @param bValue bValue（0-255）
 @param alpha alpha（0-1）
 @return return 结果
 */
+ (nonnull UIColor *)kk_colorWithR:(CGFloat)rValue
                                 G:(CGFloat)gValue
                                 B:(CGFloat)bValue
                             alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:(rValue/255.0f) green:(gValue/255.0f) blue:(bValue/255.0f) alpha:alpha];
}


/**
 随机生成颜色
 @return 结果
 */
+ (nonnull UIColor *)kk_RandomColorRGB{
    
    CGFloat r_Value = arc4random_uniform(256);
    CGFloat g_Value = arc4random_uniform(256);
    CGFloat b_Value = arc4random_uniform(256);
    CGFloat a_Value = 255.0;
    
    return [UIColor colorWithRed:(r_Value)/255.0 green:(g_Value)/255.0 blue:(b_Value)/255.0 alpha:(a_Value)/255.0];
}

/**
 随机生成颜色
 @return 结果
 */
+ (nonnull UIColor *)kk_RandomColorRGBA{
    
    CGFloat r_Value = arc4random_uniform(256);
    CGFloat g_Value = arc4random_uniform(256);
    CGFloat b_Value = arc4random_uniform(256);
    CGFloat a_Value = arc4random_uniform(256);
    
    return [UIColor colorWithRed:(r_Value)/255.0 green:(g_Value)/255.0 blue:(b_Value)/255.0 alpha:(a_Value)/255.0];
}


@end
