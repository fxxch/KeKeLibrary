//
//  KKToastView.h
//  GouUseCore
//
//  Created by liubo on 2017/8/14.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKView.h"


typedef NS_ENUM(NSInteger, KKToastViewAlignment){
    
    KKToastViewAlignment_Top = 1,//顶部对齐
    
    KKToastViewAlignment_Center = 2,//居中对齐
    
    KKToastViewAlignment_Bottom = 3,//底部对齐
};

@interface KKToastView : KKView

+ (KKToastView*_Nullable)showInView:(UIView*_Nullable)aView
                      text:(NSString*_Nullable)aText
                     image:(UIImage*_Nullable)aImage
                 alignment:(KKToastViewAlignment)alignment;

+ (KKToastView*_Nullable)showInView:(UIView*_Nullable)aView
                      text:(NSString*_Nullable)aText
                     image:(UIImage*_Nullable)aImage
                 alignment:(KKToastViewAlignment)alignment
            hideAfterDelay:(NSTimeInterval)delay;

@end
