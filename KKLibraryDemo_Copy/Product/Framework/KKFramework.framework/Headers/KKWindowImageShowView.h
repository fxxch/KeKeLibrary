//
//  KKWindowImageShowView.h
//  BM
//
//  Created by 刘波 on 2020/3/3.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKView.h"
#import "KKPageScrollView.h"
#import "UIButton+KKWebCache.h"
#import "UIImageView+KKWebCache.h"
#import "KKWindowImageItem.h"
#import "KKWindowImageShowItemView.h"

@protocol KKWindowImageShowViewDelegate;

@interface KKWindowImageShowView : UIView<KKPageScrollViewDelegate>

@property (nonatomic , strong) NSMutableArray<KKWindowImageItem*> *_Nonnull itemsArray;
@property (nonatomic , weak) id<KKWindowImageShowViewDelegate> _Nullable delegate;

@property (nonatomic,assign)NSInteger nowSelectedIndex;

- (id _Nullable)initWithFrame:(CGRect)frame
                        items:(NSArray<KKWindowImageItem*>*_Nullable)aItemsArray
                selectedIndex:(NSInteger)aSelectedIndex;

- (void)show;

#pragma mark ==================================================
#pragma mark == 【初始化】方式
#pragma mark ==================================================
+ (KKWindowImageShowView*_Nullable)showWithItems:(NSArray<KKWindowImageItem*>*_Nonnull)aItemsArray
                                   selectedIndex:(NSInteger)aSelectedIndex;

@end


#pragma mark ==================================================
#pragma mark == KKWindowImageShowViewDelegate
#pragma mark ==================================================
@protocol KKWindowImageShowViewDelegate <NSObject>
@optional

- (void)KKWindowImageShowView:(KKWindowImageShowView*_Nonnull)aView longPressedItemView:(KKWindowImageShowItemView*_Nonnull)aItemView;

@end

