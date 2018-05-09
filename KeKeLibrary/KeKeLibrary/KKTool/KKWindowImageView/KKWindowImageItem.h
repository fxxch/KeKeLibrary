//
//  KKWindowImageItem.h
//  ProjectK
//
//  Created by liubo on 14-8-22.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKWindowImageItemDelegate;

@interface KKWindowImageItem : UIView<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *myImageView;
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,strong)UIImage  *imageDefault;
@property (nonatomic,copy)NSString *image_URLString;

@property (nonatomic,assign)id<KKWindowImageItemDelegate> delegate;

- (void)reloaWithImageURLString:(NSString*)aImageURLString
               placeholderImage:(UIImage*)aPlaceholderImage;

@end


@protocol KKWindowImageItemDelegate <NSObject>

- (void)KKWindowImageItem:(KKWindowImageItem*)itemView isGIF:(BOOL)isGIF;

- (void)KKWindowImageItemSingleTap:(KKWindowImageItem*)itemView;

- (void)KKWindowImageItemLongPressed:(KKWindowImageItem*)itemView;

@end
