//
//  KKTimer.h
//  ChervonIot
//
//  Created by edward lannister on 2022/09/30.
//  Copyright © 2022 ts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  KKTimerType
 */
typedef NS_ENUM(NSInteger,KKTimerType) {
    
    KKTimerType_Ascending = 0,/* 计时器升序 */
    
    KKTimerType_Descending = 1,/* 计时器降序（倒计时） */
};

typedef void(^KKTimerBlock)(KKTimerType type, NSTimeInterval currentTimeInterval, NSTimeInterval allTimeInterval);

@interface KKTimer : NSObject


/// 计时器开始
/// - Parameters:
///   - aType: 计时器类型
///   - aTimeInterval: 时长
///   - aStartBlock: 开始
///   - aLoopBlock: 计时中……
///   - aEndBlock: 计时结束
- (void)startWithType:(KKTimerType)aType
         timeInterval:(NSTimeInterval)aTimeInterval
           startBlock:(KKTimerBlock)aStartBlock
            loopBlock:(KKTimerBlock)aLoopBlock
             endBlock:(KKTimerBlock)aEndBlock;

/// 停止计时
- (void)stop;

@end
