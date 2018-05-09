//
//  KKScrollVewRefresh.m
//  Demo
//
//  Created by liubo on 14-9-17.
//  Copyright (c) 2014年 liubo. All rights reserved.
//

#import "KKScrollVewRefresh.h"

@implementation KKScrollVewRefresh

@end


#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KKScrollVewRefreshExtension)

/*必须实现此方法 用法见附件一*/
- (void)scrollViewDidScroll{
    if (self.refreshHeader) {
        [self.refreshHeader refreshScrollViewDidScroll:self];
    }
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging refreshScrollViewDidScroll:self];
    }
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto refreshScrollViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDragging{
    if (self.refreshHeader) {
        [self.refreshHeader refreshScrollViewDidEndDragging:self];
    }
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging refreshScrollViewDidEndDragging:self];
    }
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto refreshScrollViewDidEndDragging:self];
    }
}

@end
