//
//  NSTimer+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSTimer+KKCategory.h"

@implementation NSTimer (KKCategory)

+ (NSTimer *_Nullable)kk_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                                  block:(void(^_Nullable)(void))block
                                                repeats:(BOOL)repeats{
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval
                                                   target:self
                                                 selector:@selector(kk_blockInvoke:)
                                                 userInfo:block
                                                  repeats:repeats];
    return timer;
}

+ (void)kk_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
