//
//  CALayer+KKCategory.h
//  YouJia
//
//  Created by liubo on 2018/11/12.
//  Copyright © 2018 gouuse. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface CALayer (KKCategory)

@property (nonatomic,assign) NSInteger kk_tag;

- (CALayer *)kk_layerWithTag:(NSInteger)tag;

@end
