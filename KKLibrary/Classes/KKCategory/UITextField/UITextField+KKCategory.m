//
//  UITextField+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UITextField+KKCategory.h"
#import <objc/runtime.h>
#import "NSString+KKCategory.h"
#import "UIDevice+KKCategory.h"

@implementation UITextField (KKCategory)

/**
 设置占位符字体颜色
 
 @param color color
 */
- (void)setPlaceholderColor:(nullable UIColor *)color {
    if (color == nil) {
        color = [UIColor lightGrayColor];
    }
    
    if ([UIDevice isSystemVersionBigerThan:@"13.0"]) {
        if ([NSString isStringNotEmpty:self.placeholder]) {
            NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
            
            NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         self.font,NSFontAttributeName,
                                         color,NSForegroundColorAttributeName,
                                         style,NSParagraphStyleAttributeName,
                                         nil];
            [AttributedString addAttributes:dictionary range:NSMakeRange(0, self.placeholder.length)];

            [self setAttributedPlaceholder:AttributedString];

        }
    }
    else{
        [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    }
}

/**
 设置背景图片
 
 @param image image
 */
- (void)setBackgroundImage:(nullable UIImage *)image {
    [self setBackgroundImage:image stretchWithX:0 stretchWithY:0];
}

/**
 设置背景图片
 
 @param image image
 @param x 起始位置x
 @param y 起始位置y
 
 */
- (void)setBackgroundImage:(nullable UIImage *)image stretchWithX:(NSInteger)x stretchWithY:(NSInteger)y{
    [self setBorderStyle:UITextBorderStyleNone];
    [self setBackground:[image stretchableImageWithLeftCapWidth:x topCapHeight:y]];
}


/**
 取消背景图片
 
 @param image image
 @param x 起始位置x
 @param y 起始位置y
 */
- (void)setDisabledBackgroundImage:(nullable UIImage *)image stretchWithX:(NSInteger)x stretchWithY:(NSInteger)y {
    [self setBorderStyle:UITextBorderStyleNone];
    [self setDisabledBackground:[image stretchableImageWithLeftCapWidth:x topCapHeight:y]];
}


/**
 设置左边Label
 
 @param text 文字
 @param textColor 文字颜色
 @param width 宽度
 */
- (void)setLeftLabelTitle:(nullable NSString *)text textColor:(nullable UIColor *)textColor width:(CGFloat)width {
    [self setLeftLabelTitle:text
                  textColor:textColor
                   textFont:nil
                      width:width
            backgroundColor:nil];
}

/**
 设置左边Label
 
 @param text 文字
 @param textColor 文字颜色
 @param font 文字字体
 @param width 宽度
 @param backgroundColor 背景颜色
 */
- (void)setLeftLabelTitle:(nullable NSString *)text
                textColor:(nullable UIColor *)textColor
                 textFont:(nullable UIFont *)font
                    width:(CGFloat)width
          backgroundColor:(UIColor *)backgroundColor {
    [self labelWithText:text
                 isLeft:YES
              textColor:textColor
               textFont:font
                  width:width
        backgroundColor:backgroundColor];
}

/**
 设置右边Label
 
 @param text 文字
 @param textColor 文字颜色
 @param font 文字字体
 @param width 宽度
 @param backgroundColor 背景颜色
 */
- (void)setRightLabelTitle:(nullable NSString *)text
                 textColor:(nullable UIColor *)textColor
                  textFont:(nullable UIFont *)font
                     width:(CGFloat)width
           backgroundColor:(UIColor *)backgroundColor {
    [self labelWithText:text
                 isLeft:NO
              textColor:textColor
               textFont:font
                  width:width
        backgroundColor:backgroundColor];
}

- (nonnull UILabel *)labelWithText:(nullable NSString *)text
                            isLeft:(BOOL)isLeft
                         textColor:(nullable UIColor *)textColor
                          textFont:(UIFont *)font
                             width:(CGFloat)width
                   backgroundColor:(nullable UIColor *)backgroundColor {
    
    static NSUInteger leftLabelTag = 0;
    static NSUInteger rightLabelTag = 0;
    if (leftLabelTag == 0) {
        leftLabelTag = [self hash]+1;
    }
    if (rightLabelTag == 0) {
        rightLabelTag = [self hash]+2;
    }
    
    NSUInteger tag = rightLabelTag;
    
    if (isLeft) {
        tag = leftLabelTag;
    }
    
    UILabel *label = (UILabel *)[self viewWithTag:tag];
    if (label == nil) {
        label = [[UILabel alloc] init];
        [label setTag:tag];
        if (isLeft) {
            [self setLeftViewMode:UITextFieldViewModeAlways];
            [self setLeftView:label];
        } else {
            [self setRightViewMode:UITextFieldViewModeAlways];
            [self setRightView:label];
        }
        
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth
         |UIViewAutoresizingFlexibleLeftMargin
         |UIViewAutoresizingFlexibleRightMargin];
        
    }
    
    if (font == nil) {
        font = self.font;
    }
    
    if (textColor == nil) {
        textColor = self.textColor;
    }
    
    if (backgroundColor == nil) {
        backgroundColor = [UIColor clearColor];
    }
    
    [label setFrame:CGRectMake(0, 0, width, CGRectGetHeight(self.bounds))];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setFont:font];
    [label setTextColor:textColor];
    [label setBackgroundColor:backgroundColor];
    [label setText:text];
    
    return label;
}

- (void)setMaxTextLenth:(int)length isEnglishHalf:(BOOL)isEnglishHalf{
    objc_setAssociatedObject(self, @"kLimitTextFieldMaxLengthKey", [NSNumber numberWithInt:length], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, @"kLimitTextFieldMaxLengthEnglishHalfKey", [NSNumber numberWithBool:isEnglishHalf], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(nullable id)sender{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, @"kLimitTextFieldMaxLengthKey");
    int maxLength = [lengthNumber intValue];
    if (maxLength<=0) return;

    NSNumber *isEnglishHalf = objc_getAssociatedObject(self, @"kLimitTextFieldMaxLengthEnglishHalfKey");
    BOOL englishHalf = [isEnglishHalf boolValue];

    [self checkLimitMaxLenth:maxLength isEnglishHalf:englishHalf];
}

- (void)checkLimitMaxLenth:(int)length isEnglishHalf:(BOOL)isEnglishHalf{
    int maxLength = length;
    if (maxLength<=0) return ;

    BOOL englishHalf = isEnglishHalf;
    UITextRange *selectedRange = [self markedTextRange];
    if ( [selectedRange isEmpty] || selectedRange==nil) {
        NSUInteger textLenth = 0;
        if (englishHalf) {
            textLenth = [self.text realLenth];
        }
        else{
            textLenth = [self.text length];
        }
        if ( textLenth > maxLength ) {
            if (englishHalf) {
                NSString *tempString = nil;
                for (NSInteger i=0; i<[self.text length]; i++) {
                    tempString = [self.text substringToIndex:i];
                    if ([tempString realLenth]>maxLength) {
                        tempString = [self.text substringToIndex:i-1];
                        break;
                    }
                }
                self.text = tempString;
            }
            else{
                self.text = [self.text substringToIndex:maxLength];
            }
        }
    }
}

@end
