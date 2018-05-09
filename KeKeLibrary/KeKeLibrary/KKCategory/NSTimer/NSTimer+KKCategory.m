//
//  NSTimer+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "NSTimer+KKCategory.h"

@implementation NSTimer (KKCategory)

+ (NSTimer *_Nullable)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                               block:(void(^_Nullable)(void))block
                                             repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(blockInvoke:)
                                       userInfo:block
                                        repeats:repeats];
}

+ (void)blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}

@end
