//
//  KKWindowImageShowViewController.h
//  BM
//
//  Created by 刘波 on 2020/3/3.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKViewController.h"
#import "KKWindowImageShowView.h"
#import "KKWindowActionView.h"

@protocol KKWindowImageShowViewControllerDelegate;

@interface KKWindowImageShowViewController : KKViewController

@property (nonatomic , weak) id<KKWindowImageShowViewControllerDelegate> _Nullable delegate;

+ (KKWindowImageShowViewController*_Nullable)showFromNavigationController:(UINavigationController*_Nullable)aNavController delegate:(id<KKWindowImageShowViewControllerDelegate> _Nullable)aDelegate items:(NSArray<KKWindowImageItem*>*_Nullable)aItemsArray selectedIndex:(NSInteger)aSelectedIndex;

@end

#pragma mark ==================================================
#pragma mark == KKWindowImageShowViewControllerDelegate
#pragma mark ==================================================
@protocol KKWindowImageShowViewControllerDelegate <NSObject>
@optional

- (NSArray<KKWindowActionViewItem*>*_Nullable)KKWindowImageShowViewController_ActionItemsForLongPressed;

- (KKWindowActionViewItem*_Nullable)KKWindowImageShowViewController_CancelItemsForLongPressed;

- (void)KKWindowImageShowViewController:(KKWindowImageShowViewController*_Nonnull)aViewController
                       clickedOperation:(KKWindowActionViewItem*_Nonnull)aItem
                                froView:(KKWindowImageShowItemView*_Nonnull)aItemView;

@end

