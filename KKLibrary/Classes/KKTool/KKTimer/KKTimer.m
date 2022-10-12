//
//  KKTimer.m
//  ChervonIot
//
//  Created by edward lannister on 2022/09/30.
//  Copyright © 2022 ts. All rights reserved.
//

#import "KKTimer.h"
#include <sys/sysctl.h>
#import "NSTimer+KKCategory.h"

@interface KKTimer ()

@property (nonatomic , assign) BOOL isBackground;
@property (nonatomic , assign) NSTimeInterval backgroundStartTimeInterval;

@property (nonatomic , strong) NSTimer *myTimer;
@property (nonatomic , assign) NSTimeInterval currentTimestampCount;
@property (nonatomic , assign) NSTimeInterval allTimestampCount;
@property (nonatomic , assign) KKTimerType type;

@property (nonatomic , copy) KKTimerStartBlock startBlock;
@property (nonatomic , copy) KKTimerLoopBlock loopBlock;
@property (nonatomic , copy) KKTimerEndBlock endBlock;
@property (nonatomic , assign) BOOL isEndBlockProcessed;

@end

@implementation KKTimer

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [self stopTimer];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(Notification_UIApplicationDidBecomeActiveNotification:)
                                                   name:UIApplicationDidBecomeActiveNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(Notification_UIApplicationDidEnterBackgroundNotification:)
                                                   name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)startWithType:(KKTimerType)aType
         timeInterval:(NSTimeInterval)aTimeInterval
           startBlock:(KKTimerStartBlock)aStartBlock
            loopBlock:(KKTimerLoopBlock)aLoopBlock
             endBlock:(KKTimerEndBlock)aEndBlock{

    [self private_stopByTimeout:NO];

    self.isEndBlockProcessed = NO;
    self.type = aType;
    self.allTimestampCount = aTimeInterval;
    if (self.type==KKTimerType_Descending){
        self.currentTimestampCount = aTimeInterval;
    }
    else{
        self.currentTimestampCount = 0;
    }
    self.startBlock = aStartBlock;
    self.loopBlock = aLoopBlock;
    self.endBlock = aEndBlock;
    
    [self startTimer];
}

- (void)stop{
    [self private_stopByTimeout:NO];
}

- (void)private_stopByTimeout:(BOOL)timeout{
    if (self.isEndBlockProcessed==NO){
        self.isEndBlockProcessed = YES;
        if (self.endBlock){
            self.endBlock(self.type, self.currentTimestampCount, self.allTimestampCount, timeout);
        }
        [self stopTimer];
        [self clear];
    }
}

#pragma mark ==================================================
#pragma mark == Timer
#pragma mark ==================================================
- (void)startTimer{
    [self stopTimer];

    if (self.startBlock){
        self.startBlock(self.type, self.currentTimestampCount, self.allTimestampCount);
    }
    
    __weak typeof(self) weakself = self;
    self.myTimer = [NSTimer kk_scheduledTimerWithTimeInterval:1.0 block:^{
        [weakself timerLoop];
    } repeats:YES];
}

- (void)timerLoop{
    if (self.isBackground){
        return;
    }
    [self timerLoopProcess:1];
}

- (void)timerLoopProcess:(NSTimeInterval)time{
    if (self.type==KKTimerType_Descending){
        self.currentTimestampCount = self.currentTimestampCount - time;
        if (self.currentTimestampCount<=0) {
            [self private_stopByTimeout:YES];
        }
        else{
            if (self.loopBlock){
                self.loopBlock(self.type, self.currentTimestampCount, self.allTimestampCount);
            }
        }
    }
    else{
        self.currentTimestampCount = self.currentTimestampCount + time;
        if (self.currentTimestampCount>self.allTimestampCount) {
            [self private_stopByTimeout:YES];
        }
        else{
            if (self.loopBlock){
                self.loopBlock(self.type, self.currentTimestampCount, self.allTimestampCount);
            }
        }
    }
}

- (void)stopTimer{
    if (self.myTimer) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}


- (void)clear{
    self.currentTimestampCount = 0;
    self.allTimestampCount = 0;
    self.startBlock = nil;
    self.loopBlock = nil;
    self.endBlock = nil;
}

#pragma mark ==================================================
#pragma mark == 其他处理
#pragma mark ==================================================
- (void)Notification_UIApplicationDidEnterBackgroundNotification:(NSNotification*)notice{
    self.isBackground = YES;
    if (self.myTimer){
        self.backgroundStartTimeInterval = [self systemRuningSecondsSinceBoot];
    }
}

- (void)Notification_UIApplicationDidBecomeActiveNotification:(NSNotification*)notice{
    self.isBackground = NO;
    if (self.myTimer) {
        NSTimeInterval time = [self systemRuningSecondsSinceBoot] - self.backgroundStartTimeInterval;
        [self timerLoopProcess:time];
    }
}

- (NSTimeInterval)systemRuningSecondsSinceBoot{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    struct timeval now;
    struct timezone tz;
    gettimeofday(&now, &tz);
    double uptime = -1;
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        uptime = now.tv_sec - boottime.tv_sec;
        uptime += (double)(now.tv_usec - boottime.tv_usec) / 1000000.0;
    }
    return uptime;
}

@end
