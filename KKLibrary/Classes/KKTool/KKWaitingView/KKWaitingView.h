//
//  KKWaitingView.h
//  GouUseCore
//
//  Created by liubo on 2017/8/9.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKView.h"

@interface KKWaitingView : KKView

@property (nonatomic,copy)NSString *text;

+ (KKWaitingView*)showInView:(UIView*)aView
                        text:(NSString*)aText;

+ (void)hideForView:(UIView*)aView;

+ (void)hideForView:(UIView*)aView animation:(BOOL)animation;

@end
