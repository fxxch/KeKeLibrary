//
//  UIGestureRecognizer+KKCategory.m
//  BM
//
//  Created by sjyt on 2020/1/18.
//  Copyright © 2020 bm. All rights reserved.
//

#import "UIGestureRecognizer+KKCategory.h"

@implementation UIGestureRecognizer (KKCategory)

- (void) cancel {
    self.enabled = NO;
    self.enabled = YES;
}

 
@end
