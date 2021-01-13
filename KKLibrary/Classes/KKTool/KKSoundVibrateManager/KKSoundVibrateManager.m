//
//  KKSoundVibrateManager.m
//  BM
//
//  Created by 刘波 on 2020/2/26.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKSoundVibrateManager.h"
#import "NSBundle+KKCategory.h"

#define KKSoundVibrateManager_TimestampWait (2.0)

@interface KKSoundVibrateManager ()

@property (nonatomic,assign)SystemSoundID messageInSound_NotChating;
@property (nonatomic,assign)SystemSoundID messageInSound_Chating;
@property (nonatomic,assign)SystemSoundID messageOutSound_SendSuccess;

@property (nonatomic,assign)long long lastPlayingAudioTimestamp;
@property (nonatomic,assign)long long lastPlayingVibrateTimestamp;
@property (nonatomic,assign) BOOL applicationDidEnterBackground;


@end


@implementation KKSoundVibrateManager

+ (KKSoundVibrateManager *)defaultManager{
    static KKSoundVibrateManager *KKSoundVibrateManager_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKSoundVibrateManager_default = [[self alloc] init];
    });
    return KKSoundVibrateManager_default;
}

- (instancetype)init{
    self = [super init];
    if (self) {

        //接收新消息 声音(聊天中)
        NSString *soundPath_inChating = [[NSBundle kkLibraryBundle] pathForResource:@"message_in_inchat"
                                                                        ofType:@"caf"];
        NSURL *soundURL_inChating = [NSURL fileURLWithPath:soundPath_inChating];
        OSStatus err_inChating = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL_inChating,
                                                                  &_messageInSound_Chating);
        if (err_inChating != kAudioServicesNoError)
            NSLog(@"Could not load %@, error code: %d", soundURL_inChating, (int)err_inChating);


        //接收新消息 声音(不在聊天中)
        NSString *soundPath_inNotChating = [[NSBundle kkLibraryBundle] pathForResource:@"message_in_notchat"
                                                                           ofType:@"caf"];
        NSURL *soundURL_inNotChating = [NSURL fileURLWithPath:soundPath_inNotChating];
        OSStatus err_inNotChating = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL_inNotChating,
                                                                     &_messageInSound_NotChating);
        if (err_inNotChating != kAudioServicesNoError)
            NSLog(@"Could not load %@, error code: %d", soundURL_inNotChating, (int)err_inNotChating);

        //发送新消息 声音
        NSString *soundPath_sendSuccess = [[NSBundle kkLibraryBundle] pathForResource:@"message_out"
                                                                           ofType:@"caf"];
        NSURL *soundURL_sendSuccess = [NSURL fileURLWithPath:soundPath_sendSuccess];
        OSStatus err_sendSuccess = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL_sendSuccess,
                                                                     &_messageOutSound_SendSuccess);
        if (err_inNotChating != kAudioServicesNoError)
            NSLog(@"Could not load %@, error code: %d", soundURL_sendSuccess, (int)err_sendSuccess);


        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)ApplicationDidEnterBackgroundNotification:(NSNotification*)aNotice{
    _applicationDidEnterBackground = YES;
}

- (void)ApplicationDidBecomeActiveNotification:(NSNotification*)aNotice{
    _applicationDidEnterBackground = NO;
}

#pragma mark ==================================================
#pragma mark == 播放声音与振动【私有方法】
#pragma mark ==================================================
- (void)private_playReceiveMessageWhenChating{
    if (_applicationDidEnterBackground) {
        return;
    }
    //播放声音
    AudioServicesPlaySystemSound(_messageInSound_Chating);
}

- (void)private_playReceiveMessageWhenNotChating{
    if (_applicationDidEnterBackground) {
        return;
    }

    long long timestamp = (long long)[[NSDate date] timeIntervalSince1970];
    if (timestamp-_lastPlayingAudioTimestamp<KKSoundVibrateManager_TimestampWait) {
        return;
    }
    _lastPlayingAudioTimestamp = timestamp;

    //播放声音
    AudioServicesPlaySystemSound(_messageInSound_NotChating);
}

- (void)private_playSendMessageSuccessSound{
    if (_applicationDidEnterBackground) {
        return;
    }
    //播放声音
    AudioServicesPlaySystemSound(_messageOutSound_SendSuccess);
}

- (void)private_playVibrate{
    if (_applicationDidEnterBackground) {
        return;
    }

    long long timestamp = (long long)[[NSDate date] timeIntervalSince1970];
    if (timestamp-_lastPlayingVibrateTimestamp<KKSoundVibrateManager_TimestampWait) {
        return;
    }
    _lastPlayingVibrateTimestamp = timestamp;

    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark ==================================================
#pragma mark == 播放声音与振动【公共方法】
#pragma mark ==================================================
/* 播放收到新消息的提示音【正在与消息发送者聊天中】 */
- (void)playReceiveMessageWhenChating{
    [self private_playReceiveMessageWhenChating];
}

/* 播放收到新消息的提示音【未与消息发送者聊天中】 */
- (void)playReceiveMessageWhenNotChating{
    [self private_playReceiveMessageWhenNotChating];
}

/* 播放发送消息成功的提示音 */
- (void)playSendMessageSuccessSound{
    [self private_playSendMessageSuccessSound];
}

/* 手机振动 */
- (void)playVibrate{
    [self private_playVibrate];
}

@end
