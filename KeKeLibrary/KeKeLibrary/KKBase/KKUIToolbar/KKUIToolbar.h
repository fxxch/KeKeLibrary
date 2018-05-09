//
//  KKUIToolbar.h
//  KKLibray
//
//  Created by liubo on 2018/4/19.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  类型
 */
typedef NS_ENUM(NSInteger, KKUIToolbarStyle){
    
    KKUIToolbarStyle_None = 0,//没有上下键
    
    KKUIToolbarStyle_PreviousYES_NextNO = 1,//

    KKUIToolbarStyle_PreviousYES_NextYES = 2,//

    KKUIToolbarStyle_PreviousNO_NextYES = 3,//
};


@protocol KKUIToolbarDelegate;

@interface KKUIToolbar : UIToolbar

@property (nonatomic,weak)id<KKUIToolbarDelegate> toolBarDelegate;
@property (nonatomic,weak)id targetView;
@property (nonatomic,assign)KKUIToolbarStyle toolBarStyle;

+ (KKUIToolbar*)toolBarForStyle:(KKUIToolbarStyle)aStyle
                       delegate:(id<KKUIToolbarDelegate>)aDelegate
                     targetView:(id)aTargetView;

@end

@protocol KKUIToolbarDelegate <NSObject>

@optional

- (void)KKUIToolbar_PreviousButtonClicked:(KKUIToolbar*)aToolbar;

- (void)KKUIToolbar_NextButtonClicked:(KKUIToolbar*)aToolbar;

- (void)KKUIToolbar_DoneButtonClicked:(KKUIToolbar*)aToolbar;

@end
