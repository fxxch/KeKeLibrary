//
//  WindowModalView.h
//  GouUseCore
//
//  Created by beartech on 2018/1/5.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKWindowModalViewItem.h"

@protocol WindowModalViewDelegate;

@interface KKWindowModalView : UIWindow

@property (nonatomic,strong)NSDictionary *information;

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
/**
 展示一个从底部Modal出来的视图
 
 @param aItemArray WindowModalViewItem数组
 @param aDelegate 代理
 @return WindowModalView
 */
+ (KKWindowModalView*)showWithItems:(NSArray<KKWindowModalViewItem*>*)aItemArray
                         delegate:(id<WindowModalViewDelegate>)aDelegate;

@end


#pragma mark - WindowModalViewDelegate
@protocol WindowModalViewDelegate <NSObject>
@optional

- (void)WindowModalView_backgroundClicked:(KKWindowModalView*)aView;

- (void)WindowModalView:(KKWindowModalView*)aView
   clickedButtonAtIndex:(NSInteger)buttonIndex
                   item:(KKWindowModalViewItem*)aItem;

@end
