//
//  UIScrollView+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (KKCategory)

- (void)kk_scrollToTopWithAnimated:(BOOL)animated;

- (void)kk_scrollToBottomWithAnimated:(BOOL)animated;
- (void)kk_scrollToBottomWithAnimated:(BOOL)animated afterDelay:(CGFloat)delay;

@end
