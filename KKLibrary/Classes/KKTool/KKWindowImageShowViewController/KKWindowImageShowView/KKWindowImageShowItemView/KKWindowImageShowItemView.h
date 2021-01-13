//
//  KKWindowImageShowItemView.h
//  BM
//
//  Created by 刘波 on 2020/3/3.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKWindowImageItem.h"

@protocol KKWindowImageShowItemViewDelegate;

@interface KKWindowImageShowItemView : UIView<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *_Nonnull myImageView;
@property (nonatomic,strong)UIScrollView *_Nonnull myScrollView;
@property (nonatomic,strong)KKWindowImageItem  *_Nonnull itemInfo;
@property (nonatomic,assign)BOOL  currentIsGif;

@property (nonatomic,assign)id<KKWindowImageShowItemViewDelegate> _Nullable delegate;

- (void)reloaWithItem:(KKWindowImageItem*_Nonnull)aItem;

@end


@protocol KKWindowImageShowItemViewDelegate <NSObject>

- (void)KKWindowImageShowItemViewSingleTap:(KKWindowImageShowItemView*_Nonnull)itemView;

- (void)KKWindowImageShowItemViewLongPressed:(KKWindowImageShowItemView*_Nonnull)itemView;

@end
