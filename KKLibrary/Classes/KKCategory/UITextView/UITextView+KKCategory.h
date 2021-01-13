//
//  UITextView+KKCategory.h
//  BM
//
//  Created by sjyt on 2019/12/26.
//  Copyright © 2019 bm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (KKCategory)

- (void)checkLimitMaxLenth:(int)length isEnglishHalf:(BOOL)isEnglishHalf;

@end

NS_ASSUME_NONNULL_END
