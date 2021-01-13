//
//  KKPageControl.h
//  ProjectK
//
//  Created by liubo on 15/1/14.
//  Copyright (c) 2015年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  当前处于的聊天状态
 */
typedef NS_ENUM(NSInteger,KKPageControlAlignment) {
    
    KKPageControlAlignmentLeft=0,//没有聊天
    
    KKPageControlAlignmentCenter=1,//正在跟某人聊天界面
    
    KKPageControlAlignmentRight=2,//正在跟某个群组聊天界面
};


@interface KKPageControl : UIImageView

@property(nonatomic,assign)NSInteger numberOfPages;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)BOOL hidesForSinglePage;
@property(nonatomic,assign)CGFloat pointSeparateSpace;
@property(nonatomic,assign)KKPageControlAlignment alignment;

- (id)initWithFrame:(CGRect)frame activeImage:(UIImage*)aActiveImage inactiveImage:(UIImage*)aInactiveImage;

- (id)initWithFrame:(CGRect)frame activeColor:(UIColor*)aActiveColor inactiveColor:(UIColor*)aInactiveColor;

- (void)addTarget:(id)aTarget action:(SEL)aAction forControlEvents:(UIControlEvents)aControlEvents;

@end
