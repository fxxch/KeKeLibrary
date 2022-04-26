//
//  UILabel+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UILabel+KKCategory.h"
#import "NSString+KKCategory.h"
#import "UIFont+KKCategory.h"
#import "UIScreen+KKCategory.h"

@implementation UILabel (KKCategory)

#pragma mark ==================================================
#pragma mark ==设置样式
#pragma mark ==================================================
- (void)kk_setTextColor:(nullable UIColor *)textColor
               range:(NSRange)range{
    
    NSMutableAttributedString *text = nil;
    if (self.attributedText && self.attributedText.length>0) {
        text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    else{
        text = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    [text addAttribute: NSForegroundColorAttributeName
                 value: textColor
                 range: range];
    
    self.text = nil;
    [self setAttributedText: text];
}

- (void)kk_setFont:(nullable UIFont *)font
          range:(NSRange)range{

    NSMutableAttributedString *text = nil;
    if (self.attributedText && self.attributedText.length>0) {
        text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    else{
        text = [[NSMutableAttributedString alloc] initWithString:self.text];
    }

    [text addAttribute: NSFontAttributeName
                 value: font
                 range: range];
    
    self.text = nil;
    [self setAttributedText: text];
}

- (void)kk_setTextColor:(nullable UIColor *)textColor afterOccurenceOfString:(nullable NSString*)separator{
    
    NSRange range;
    if (self.attributedText && self.attributedText.length>0) {
        range = [self.attributedText.string rangeOfString:separator];
    }
    else{
        range = [self.text rangeOfString:separator];
    }
    
    if (range.location != NSNotFound)
    {
        range.location ++;
        range.length = self.text.length - range.location;
        [self kk_setTextColor:textColor range:range];
    }
}

- (void)kk_setFont:(nullable UIFont *)font afterOccurenceOfString:(nullable NSString*)separator{
    
    NSRange range;
    if (self.attributedText && self.attributedText.length>0) {
        range = [self.attributedText.string rangeOfString:separator];
    }
    else{
        range = [self.text rangeOfString:separator];
    }

    if (range.location != NSNotFound)
    {
        range.location ++;
        range.length = self.text.length - range.location;
        [self kk_setFont:font range:range];
    }
}

- (void)kk_setTextColor:(nullable UIColor *)textColor contentString:(nullable NSString *)string{
    if (!string.length) {
        return;
    }
    
    NSRange range;
    if (self.attributedText && self.attributedText.length>0) {
        range = [self.attributedText.string rangeOfString:string];
    }
    else{
        range = [self.text rangeOfString:string];
    }

    if (range.location != NSNotFound)
    {
        [self kk_setTextColor:textColor range:range];
    }
}

- (void)kk_setFont:(nullable UIFont *)font contentString:(nullable NSString *)contentString{
    if (!contentString.length) {
        return;
    }
    
    NSRange range_front;
    if (self.attributedText && self.attributedText.length>0) {
        range_front = [self.attributedText.string rangeOfString:contentString];
    }
    else{
        range_front = [self.text rangeOfString:contentString];
    }

    NSRange range_end;
    if (self.attributedText && self.attributedText.length>0) {
        range_end = [self.attributedText.string rangeOfString:contentString options:NSBackwardsSearch];
    }
    else{
        range_end = [self.text rangeOfString:contentString options:NSBackwardsSearch];
    }
    
    if (range_front.location != NSNotFound)
    {
        [self kk_setFont:font range:range_front];
    }
    
    if (range_end.location != NSNotFound)
    {
        [self kk_setFont:font range:range_end];
    }
}

- (void)kk_setUnderLine:(nullable UIColor *)underLineColor range:(NSRange)range{
    
    NSMutableAttributedString *text = nil;
    if (self.attributedText && self.attributedText.length>0) {
        text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    else{
        text = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    // 下划线
    NSMutableDictionary *attribtDic = [NSMutableDictionary dictionary];
    [attribtDic setObject:[NSNumber numberWithInteger:NSUnderlineStyleSingle] forKey:NSUnderlineStyleAttributeName];
    [attribtDic setObject:@"0" forKey:NSBaselineOffsetAttributeName];
    [attribtDic setObject:underLineColor forKey:NSUnderlineColorAttributeName];

    [text addAttributes:attribtDic range:range];
    
    self.text = nil;
    [self setAttributedText: text];
}

- (void)kk_setUnderLine:(nullable UIColor *)underLineColor contentString:(nullable NSString *)contentString{
    if (!contentString.length) {
        return;
    }
    
    if (!contentString.length) {
        return;
    }
    
    NSRange range;
    if (self.attributedText && self.attributedText.length>0) {
        range = [self.attributedText.string rangeOfString:contentString];
    }
    else{
        range = [self.text rangeOfString:contentString];
    }

    if (range.location != NSNotFound)
    {
        [self kk_setUnderLine:underLineColor range:range];
    }
}

- (void)kk_setCenterLine:(nullable UIColor *)centerLineColor range:(NSRange)range{
    
    NSMutableAttributedString *text = nil;
    if (self.attributedText && self.attributedText.length>0) {
        text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    }
    else{
        text = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    
    // 下划线
    NSMutableDictionary *attribtDic = [NSMutableDictionary dictionary];
    [attribtDic setObject:[NSNumber numberWithInteger:NSUnderlineStyleSingle] forKey:NSStrikethroughStyleAttributeName];
    [attribtDic setObject:centerLineColor forKey:NSUnderlineColorAttributeName];

    [attribtDic setObject:@"0" forKey:NSBaselineOffsetAttributeName];

    [text addAttributes:attribtDic range:range];
    
    self.text = nil;
    [self setAttributedText: text];
}

- (void)kk_setCenterLine:(nullable UIColor *)centerLineColor contentString:(nullable NSString *)contentString{
    if (!contentString.length) {
        return;
    }
    
    if (!contentString.length) {
        return;
    }
    
    NSRange range;
    if (self.attributedText && self.attributedText.length>0) {
        range = [self.attributedText.string rangeOfString:contentString];
    }
    else{
        range = [self.text rangeOfString:contentString];
    }
    
    if (range.location != NSNotFound)
    {
        [self kk_setCenterLine:centerLineColor range:range];
    }
}

#pragma mark ==================================================
#pragma mark ==创建UILabel
#pragma mark ==================================================
/**
 快速创建UILabel （行数默认一行，宽度默认屏幕宽度）
 
 @param textColor 字体颜色
 @param font 字体
 @param text 文字
 @return UILabel
 */
+ (nullable UILabel *)kk_initWithTextColor:(nullable UIColor *)textColor
                                      font:(UIFont*)font
                                      text:(nullable NSString *)text{
    
    return [UILabel kk_initWithTextColor:textColor
                                    font:font
                                    text:text
                                   lines:1
                                maxWidth:KKApplicationWidth];
}

/**
 快速创建UILabel （行数默认一行，宽度默认屏幕宽度）
 
 @param textColor 字体颜色
 @param fontSize 字体大小加粗
 @param text 文字
 @return UILabel
 */
+ (nullable UILabel *)kk_initWithTextColor:(nullable UIColor *)textColor
                                  fontSize:(NSInteger)fontSize
                                      text:(nullable NSString *)text{
    
    return [UILabel kk_initWithTextColor:textColor
                                    font:[UIFont systemFontOfSize:fontSize]
                                    text:text
                                   lines:1
                                maxWidth:KKApplicationWidth];
}

/**
 快速创建UILabel （行数默认一行，宽度默认屏幕宽度）
 
 @param textColor 字体颜色
 @param font 字体
 @param text 文字
 @param maxWidth 最大宽度
 @return UILabel
 */
+ (nullable UILabel *)kk_initWithTextColor:(nullable UIColor *)textColor
                                      font:(UIFont*)font
                                      text:(nullable NSString *)text
                                  maxWidth:(CGFloat)maxWidth{
    
    return [UILabel kk_initWithTextColor:textColor
                                    font:font
                                    text:text
                                   lines:1
                                maxWidth:maxWidth];
}

/**
 快速创建UILabel

 @param textColor 字体颜色
 @param font 字体
 @param text 文字
 @param lines 行数
 @param maxWidth 最大宽度
 @return UILabel
 */
+ (instancetype)kk_initWithTextColor:(nullable UIColor *)textColor
                                font:(nullable UIFont *)font
                                text:(nullable NSString *)text
                               lines:(NSInteger)lines
                            maxWidth:(CGFloat)maxWidth{

    CGSize size = CGSizeZero;
    if (lines==0) {
        size = [text kk_sizeWithFont:font maxSize:CGSizeMake(maxWidth, 10000)];
    }
    else{
        CGFloat height = [UIFont kk_heightForFont:font numberOfLines:lines];
        size = [text kk_sizeWithFont:font maxSize:CGSizeMake(maxWidth, height)];
    }
    
    UILabel * lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    lb.textColor = textColor?textColor:[UIColor blackColor];
    lb.numberOfLines = lines;
    lb.textAlignment = NSTextAlignmentLeft;
    lb.font = font;
    lb.text = text;
    lb.backgroundColor = [UIColor clearColor];
    return lb;
}

@end
