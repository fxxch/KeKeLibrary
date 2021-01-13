//
//  KKWindowMenuView.h
//  BM
//
//  Created by liubo on 2019/11/22.
//  Copyright © 2019 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKWindowMenuItem.h"


NS_ASSUME_NONNULL_BEGIN

@protocol KKWindowMenuViewDelegate;

@interface KKWindowMenuView : UIView

@property (nonatomic,strong)NSDictionary *information;

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
+ (KKWindowMenuView*)showFromView:(UIView*)aView
                        withItems:(NSArray<KKWindowMenuItem*>*)aItemArray
                        delegate:(id<KKWindowMenuViewDelegate>)aDelegate;

@end


#pragma mark - KKWindowMenuViewDelegate
@protocol KKWindowMenuViewDelegate <NSObject>
@optional

- (void)KKWindowMenuView_willShow:(KKWindowMenuView*)aView;

- (void)KKWindowMenuView_willHide:(KKWindowMenuView*)aView;

- (void)KKWindowMenuView:(KKWindowMenuView*)aView
            clickedIndex:(NSInteger)buttonIndex
                    item:(KKWindowMenuItem*)aItem;


@end

NS_ASSUME_NONNULL_END
