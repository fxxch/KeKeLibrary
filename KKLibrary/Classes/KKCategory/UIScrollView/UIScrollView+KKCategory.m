//
//  UIScrollView+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIScrollView+KKCategory.h"

@implementation UIScrollView (KKCategory)

- (void)kk_scrollToTopWithAnimated:(BOOL)animated{
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}

- (void)kk_scrollToBottomWithAnimated:(BOOL)animated{
    [self performSelector:@selector(kk_scrollToBottomWithAnimated_20151211:) withObject:[NSNumber numberWithBool:animated]];
}

- (void)kk_scrollToBottomWithAnimated:(BOOL)animated afterDelay:(CGFloat)delay{
    [self performSelector:@selector(kk_scrollToBottomWithAnimated_20151211:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

- (void)kk_scrollToBottomWithAnimated_20151211:(NSNumber*)animated{
    
    CGFloat contentSizeHeight = 0;
    if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView*)self;
        contentSizeHeight =  collectionView.collectionViewLayout.collectionViewContentSize.height;
    } else {
        contentSizeHeight = self.contentSize.height;
    }
    
    if (contentSizeHeight>self.bounds.size.height) {
        [self setContentOffset:CGPointMake(0, contentSizeHeight-self.bounds.size.height) animated:[animated boolValue]];
    }
    else{
        [self setContentOffset:CGPointMake(0, 0) animated:[animated boolValue]];
    }
}

@end
