//
//  UIScrollView+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIScrollView+KKCategory.h"

@implementation UIScrollView (KKCategory)

- (void)scrollToTopWithAnimated:(BOOL)animated{
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}

- (void)scrollToBottomWithAnimated:(BOOL)animated{
        
    if (self.contentSize.height>self.bounds.size.height) {
        [self setContentOffset:CGPointMake(0, self.contentSize.height-self.bounds.size.height) animated:animated];
    }
    else{
        [self setContentOffset:CGPointMake(0, 0) animated:animated];
    }
    
//    [self performSelector:@selector(scrollToBottomWithAnimated_20151211:) withObject:[NSNumber numberWithBool:animated] afterDelay:0];
}

- (void)scrollToBottomWithAnimated_20151211:(NSNumber*)animated{
    if (self.contentSize.height>self.bounds.size.height) {
        [self setContentOffset:CGPointMake(0, self.contentSize.height-self.bounds.size.height) animated:[animated boolValue]];
    }
    else{
        [self setContentOffset:CGPointMake(0, 0) animated:[animated boolValue]];
    }
}

@end
