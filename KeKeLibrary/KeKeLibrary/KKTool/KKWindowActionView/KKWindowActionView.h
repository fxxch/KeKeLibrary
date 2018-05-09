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

@property (nonatomic,strong)NSDictionary *information;

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================

/**
 展示一个从底部Modal出来的视图
 
 @param aItemArray KKWindowActionViewItem数组
 @param aDelegate 代理
 @return KKWindowActionView
 */
+ (KKWindowActionView*)showWithItems:(NSArray<KKWindowActionViewItem*>*)aItemArray
                            delegate:(id<KKWindowActionViewDelegate>)aDelegate;

@end


#pragma mark - KKWindowActionViewDelegate
@protocol KKWindowActionViewDelegate <NSObject>
@optional

- (void)KKWindowActionView_backgroundClicked:(KKWindowActionView*)aView;

- (void)KKWindowActionView:(KKWindowActionView*)aView
              clickedIndex:(NSInteger)buttonIndex
                      item:(KKWindowActionViewItem*)aItem;

@end



