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
- (void)setTextColor:(nullable UIColor *)textColor
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

- (void)setFont:(nullable UIFont *)font
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

- (void)setTextColor:(nullable UIColor *)textColor afterOccurenceOfString:(nullable NSString*)separator{
    
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
        [self setTextColor:textColor range:range];
    }
}

- (void)setFont:(nullable UIFont *)font afterOccurenceOfString:(nullable NSString*)separator
{
    
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
        [self setFont:font range:range];
    }
}

- (void)setTextColor:(nullable UIColor *)textColor contentString:(nullable NSString *)string
{
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
        [self setTextColor:textColor range:range];
    }
}

- (void)setFont:(nullable UIFont *)font contentString:(nullable NSString *)contentString
{
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
        [self setFont:font range:range_front];
    }
    
    if (range_end.location != NSNotFound)
    {
        [self setFont:font range:range_end];
    }
}

- (void)setUnderLine:(nullable UIColor *)underLineColor
               range:(NSRange)range{
    
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

- (void)setUnderLine:(nullable UIColor *)underLineColor contentString:(nullable NSString *)contentString{
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
        [self setUnderLine:underLineColor range:range];
    }
}

- (void)setCenterLine:(nullable UIColor *)centerLineColor
                range:(NSRange)range{
    
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

- (void)setCenterLine:(nullable UIColor *)centerLineColor contentString:(nullable NSString *)contentString{
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
        [self setCenterLine:centerLineColor range:range];
    }
}


//- (void)setLineHeightMargin:(CGFloat)margin
//{
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = margin;//行距
//    [style setLineBreakMode:NSLineBreakByTruncatingTail];
//    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,  self.text.length)];
//    [self setAttributedText: text];
//}

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
        size = [text sizeWithFont:font maxSize:CGSizeMake(maxWidth, 10000)];
    }
    else{
        CGFloat height = [UIFont heightForFont:font numberOfLines:lines];
        size = [text sizeWithFont:font maxSize:CGSizeMake(maxWidth, height)];
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

+ (UILabel *)createNewlabelWithColor:(UIColor *)color andFont:(UIFont *)font andTextAlignment:(NSTextAlignment)textAlign{
    
    return [UILabel createNewlabelWithColor:color andFont:font andTextAlignment:textAlign andLineNum:1];
}

+ (UILabel *)createNewlabelWithColor:(UIColor *)color andFont:(UIFont *)font andTextAlignment:(NSTextAlignment)textAlign andLineNum:(NSInteger)lineNum{
 
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.textAlignment = textAlign;
    label.font = font;
    label.numberOfLines = lineNum;
    return label;
}


@end
