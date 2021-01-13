//
//  KKCameraImageShowItemView.h
//  HeiPa
//
//  Created by liubo on 2019/3/15.
//  Copyright © 2019 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KKCameraImageShowItemView;
#pragma mark ==================================================
#pragma mark == KKCameraImageShowItemViewDelegate
#pragma mark ==================================================
@protocol KKCameraImageShowItemViewDelegate <NSObject>
@optional

- (void)KKCameraImageShowItemViewSingleTap:(KKCameraImageShowItemView*)aItemView;

@end


static NSString *KKCameraImageShowItemView_ID = @"KKCameraImageShowItemView_ID";

@interface KKCameraImageShowItemView : UICollectionViewCell
<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic , weak) id<KKCameraImageShowItemViewDelegate> delegate;
@property (nonatomic , assign) NSInteger row;

- (void)setImage:(UIImage*)aImage;

@end
