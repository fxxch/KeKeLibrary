//
//  CALayer+KKCategory.m
//  YouJia
//
//  Created by liubo on 2018/11/12.
//  Copyright © 2018 gouuse. All rights reserved.
//

#import "CALayer+KKCategory.h"

@implementation CALayer (KKCategory)
@dynamic tag;

- (NSInteger)tag{
    NSNumber *number = objc_getAssociatedObject(self, @"tag");
    return [number integerValue];
}

- (void)setTag:(NSInteger)tag{
    objc_setAssociatedObject(self, @"tag",[NSNumber numberWithInteger:tag], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (CALayer *)layerWithTag:(NSInteger)tag{
    
    CALayer *returnLayer = nil;
    
    for (CALayer *layer in [self sublayers]) {
        if (layer.tag==tag) {
            returnLayer =layer;
            break;
        }
    }

    return returnLayer;
}

@end
