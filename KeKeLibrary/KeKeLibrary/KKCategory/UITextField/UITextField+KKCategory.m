//
//  UITextField+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UITextField+KKCategory.h"
#import <objc/runtime.h>

@implementation UITextField (KKCategory)

/**
 设置占位符字体颜色
 
 @param color color
 */
- (void)setPlaceholderColor:(nullable UIColor *)color {
    if (color == nil) {
        color = [UIColor lightGrayColor];
    }
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
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
        backgroundColor = [UIColor redColor];
    }
    
    [label setFrame:CGRectMake(0, 0, width, CGRectGetHeight(self.bounds))];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setFont:font];
    [label setTextColor:textColor];
    [label setBackgroundColor:backgroundColor];
    [label setText:text];
    
    return label;
}

- (void)setMaxTextLenth:(int)length{
    objc_setAssociatedObject(self, @"kLimitTextFieldMaxLengthKey", [NSNumber numberWithInt:length], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(nullable id)sender{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, @"kLimitTextFieldMaxLengthKey");
    int length = [lengthNumber intValue];
    if(self.text.length > length){
        self.text = [self.text substringToIndex:length];
    }
}

@end
