//
//  KKEmptyNoticeView.h
//  GouUseCore
//
//  Created by beartech on 2017/8/10.
//  Copyright © 2017年 gouuse. All rights reserved.
//

#import "KKView.h"

typedef NS_ENUM(NSInteger, KKEmptyNoticeViewAlignment){
    
    KKEmptyNoticeViewAlignment_Top = 1,//顶部对齐
    
    KKEmptyNoticeViewAlignment_Center = 2,//居中对齐
};

@protocol KKEmptyNoticeViewDelegate;

@interface KKEmptyNoticeView : KKView

@property (nonatomic,weak) id<KKEmptyNoticeViewDelegate> delegate;

+ (KKEmptyNoticeView*)showInView:(UIView*)aView
                       withImage:(UIImage*)aImage
                        delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate;

+ (KKEmptyNoticeView*)showInView:(UIView*)aView
                       withImage:(UIImage*)aImage
                            text:(NSString*)aText
                     buttonTitle:(NSString*)aButtonTitle
                       alignment:(KKEmptyNoticeViewAlignment)alignment
                        delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate;

+ (void)hideForView:(UIView*)aView;

@end


@protocol KKEmptyNoticeViewDelegate <NSObject>
@optional

- (void)KKEmptyNoticeView_ButtonClicked:(KKEmptyNoticeView*)aView;

- (void)KKEmptyNoticeView_ImageClicked:(KKEmptyNoticeView*)aView;

- (void)KKEmptyNoticeView_TextClicked:(KKEmptyNoticeView*)aView;

@end



@interface UITableView (UITableView_KKEmptyNoticeView)

- (void)showEmptyViewWithImage:(UIImage*)aImage
                      delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate;

- (void)showEmptyViewWithImage:(UIImage*)aImage
                          text:(NSString*)text
                   buttonTitle:(NSString*)aButtonTitle
                     alignment:(KKEmptyNoticeViewAlignment)alignment
                      delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate
                       offsetY:(CGFloat)offsetY;

- (void)hideEmptyViewWithBackgroundColor:(UIColor*)aColor;

@end

@interface UICollectionView (UICollectionView_KKEmptyNoticeView)

- (void)showEmptyViewWithImage:(UIImage*)aImage
                      delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate;

- (void)showEmptyViewWithImage:(UIImage*)aImage
                          text:(NSString*)text
                   buttonTitle:(NSString*)aButtonTitle
                     alignment:(KKEmptyNoticeViewAlignment)alignment
                      delegate:(id<KKEmptyNoticeViewDelegate>)aDelegate
                       offsetY:(CGFloat)offsetY;

- (void)hideEmptyViewWithBackgroundColor:(UIColor*)aColor;

@end
