//
//  KKWindowActionView.h
//  KKLibray
//
//  Created by liubo on 2018/4/24.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKWindowActionViewItem.h"



@protocol KKWindowActionViewDelegate;

@interface KKWindowActionView : UIWindow

@property (nonatomic,strong)NSDictionary *_Nullable information;

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================

/**
 展示一个从底部Modal出来的视图
 
 @param aItemArray KKWindowActionViewItem数组
 @param aItem KKWindowActionViewItem 取消按钮
 @param aDelegate 代理
 @return KKWindowActionView
 */
+ (KKWindowActionView*_Nonnull)showWithItems:(NSArray<KKWindowActionViewItem*>*_Nonnull)aItemArray
                          cancelItem:(KKWindowActionViewItem*_Nonnull)aItem
                            delegate:(id<KKWindowActionViewDelegate>_Nullable)aDelegate;

@end


#pragma mark - KKWindowActionViewDelegate
@protocol KKWindowActionViewDelegate <NSObject>
@optional

- (void)KKWindowActionView_backgroundClicked:(KKWindowActionView*_Nonnull)aView;

- (void)KKWindowActionView:(KKWindowActionView*_Nonnull)aView
              clickedIndex:(NSInteger)buttonIndex
                      item:(KKWindowActionViewItem*_Nonnull)aItem;

@end



