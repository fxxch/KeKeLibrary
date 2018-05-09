//
//  KKWaitingView.h
//  GouUseCore
//
//  Created by liubo on 2017/8/9.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKView.h"

/**
 *  Cell类型
 */
typedef NS_ENUM(NSInteger, KKWaitingViewType){
    
    KKWaitingViewType_White = 0,//白色
    
    KKWaitingViewType_Gray = 1,//灰色
    
    KKWaitingViewType_Green = 2,//绿色
};


@interface KKWaitingView : KKView

- (instancetype)initWithFrame:(CGRect)frame
                         type:(KKWaitingViewType)aType
              blackBackground:(BOOL)aBlackBackground
                         text:(NSString*)aText;


- (void)startAnimating;

- (void)stopAnimating;

+ (KKWaitingView*)showInView:(UIView*)aView
                    withType:(KKWaitingViewType)aType
             blackBackground:(BOOL)aBlackBackground
                        text:(NSString*)aText;

+ (void)hideForView:(UIView*)aView;

+ (void)hideForView:(UIView*)aView animation:(BOOL)animation;

@end
