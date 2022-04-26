//
//  CALayer+KKCategory.m
//  YouJia
//
//  Created by liubo on 2018/11/12.
//  Copyright © 2018 gouuse. All rights reserved.
//

#import "CALayer+KKCategory.h"

@implementation CALayer (KKCategory)
@dynamic kk_tag;

- (NSInteger)kk_tag{
    NSNumber *number = objc_getAssociatedObject(self, @"kk_tag");
    return [number integerValue];
}

- (void)setKk_tag:(NSInteger)kk_tag{
    objc_setAssociatedObject(self, @"kk_tag",[NSNumber numberWithInteger:kk_tag], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (CALayer *)kk_layerWithTag:(NSInteger)tag{
    
    CALayer *returnLayer = nil;
    
    for (CALayer *layer in [self sublayers]) {
        if (layer.kk_tag==tag) {
            returnLayer =layer;
            break;
        }
    }

    return returnLayer;
}

@end
