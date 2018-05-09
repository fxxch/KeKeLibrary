//
//  KKEmoticonView.h
//  TTT
//
//  Created by liubo on 13-12-25.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPageScrollView.h"


#define KKEmojiViewHeight 216.0f
#define KKEmojiViewTabBarHeight 36.0f
#define KKEmojiViewPageControlHeight 20.0f

#define kEmoticonGroupTitle    @"id"
#define kEmoticonGroupShowName @"tag"
#define kEmoticonImageName     @"file"

@protocol KKEmojiViewDelegate;

@interface KKEmoticonViewCacheManager :NSObject

@property(nonatomic,strong)NSMutableDictionary    * emotionDataCache;
@property(nonatomic,strong)NSMutableArray *emotionsAll;

+ (KKEmoticonViewCacheManager *)defaultManager;

- (NSData*)readDataForKey:(NSString*)aKey;

- (void)saveData:(NSData*)aData forKey:(NSString*)aKey;

@end


@interface KKEmoticonView : UIView
<UIScrollViewDelegate,
UIGestureRecognizerDelegate,
KKPageScrollViewDelegate>
{
    
    __weak id<KKEmojiViewDelegate>  _delegate;
    Class delegateClass;
}

@property(nonatomic,weak)id<KKEmojiViewDelegate>  delegate;
@property(nonatomic,assign)id                       target;
@property(nonatomic,assign)NSUInteger               currentGroupIndex;
@property(nonatomic,assign)BOOL                     shouldShowSendButton;
@property(nonatomic,assign)UIButton               * selectedTabBarButton;

@property(nonatomic,strong)KKPageScrollView       * myPageView;
@property(nonatomic,strong)UIPageControl          * pageControl;
@property(nonatomic,strong)UIScrollView           * tabBarView;
@property(nonatomic,strong)NSMutableArray         * selectedItems;


+ (void)showWithTarget:(id)target delegate:(id<KKEmojiViewDelegate>)delegate;

+ (void)showWithTarget:(id)target delegate:(id<KKEmojiViewDelegate>)delegate showSendButton:(BOOL)showSendButton;

#pragma mark==================================================
#pragma mark== 表情
#pragma mark==================================================
+ (NSArray*)emotionPlistArray;

+ (NSData*)emotionData_OfGroupIndex:(NSInteger)index subIndex:(NSInteger)subIndex;

+ (NSData*)emotionData_OfTitle:(NSString*)aTitle;

+ (BOOL)isExistEmotionData_OfTitle:(NSString*)aTitle;

@end

@protocol KKEmojiViewDelegate <NSObject>

@optional
- (void)emoticonViewDidSelectedSend;

- (void)emoticonViewDidSelectedBackward;

- (void)emoticonViewDidDeleteLastEmotionItem:(NSString*)aItemTitle;

- (void)emoticonView:(KKEmoticonView *)view didSelectedItem:(NSDictionary *)item forSend:(BOOL)forSend;

- (void)emoticonView:(KKEmoticonView *)view didSelectedItem:(NSDictionary *)item;

@end
