//
//  KKSoundVibrateManager.h
//  BM
//
//  Created by 刘波 on 2020/2/26.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKSoundVibrateManager : NSObject

+ (KKSoundVibrateManager*_Nonnull)defaultManager;

#pragma mark ==================================================
#pragma mark == 播放声音与振动【公共方法】
#pragma mark ==================================================
/* 播放收到新消息的提示音【正在与消息发送者聊天中】 */
- (void)playReceiveMessageWhenChating;

/* 播放收到新消息的提示音【未与消息发送者聊天中】 */
- (void)playReceiveMessageWhenNotChating;

/* 播放发送消息成功的提示音 */
- (void)playSendMessageSuccessSound;

/* 手机振动 */
- (void)playVibrate;

@end

NS_ASSUME_NONNULL_END
