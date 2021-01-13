//
//  UITextView+KKCategory.m
//  BM
//
//  Created by sjyt on 2019/12/26.
//  Copyright © 2019 bm. All rights reserved.
//

#import "UITextView+KKCategory.h"
#import <objc/runtime.h>
#import "NSString+KKCategory.h"


@implementation UITextView (KKCategory)

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
