//
//  NSTimer+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSTimer (KKCategory)

/*************************************************************
 * 解决NSTimer在repeats为YES下的循环引用问题
 * 1、声明 @property (nonatomic,strong)NSTimer  *myTimer;
 *
 *        @synthesize myTimer;
 * 2、初始化
 __block typeof(self) weakSelf = self;
 myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 block:^{
 [weakSelf changeAD];
 } repeats:NO];
 * 3、如果 repeats:为NO  - (void)dealloc{} 里面不做任何处理
 * 4、如果 repeats:为YES - (void)dealloc{} 里面需要做如下处理
 
 - (void)dealloc{
 [myTimer invalidate];
 [super dealloc];
 }
 *
 *
 *
 *************************************************************/
+ (NSTimer *_Nullable)kk_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                                  block:(void(^_Nullable)(void))block
                                                repeats:(BOOL)repeats;

@end
