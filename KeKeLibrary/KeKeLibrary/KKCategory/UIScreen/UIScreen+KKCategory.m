//
//  UIScreen+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIScreen+KKCategory.h"
#import "UIDevice+KKCategory.h"

@implementation UIScreen (KKCategory)

- (CGFloat)KK_ScreenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (CGFloat)KK_ScreenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}

- (CGFloat)KK_ApplicationWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (CGFloat)KK_ApplicationHeight{
    //判断是否是iphoneX
    if ([[UIDevice currentDevice] isiPhoneX]) {
        return ([[UIScreen mainScreen] bounds].size.height-44)-KKSafeAreaBottomHeight;
    }
    else{
        return ([[UIScreen mainScreen] bounds].size.height-20);
    }
}

- (CGRect)KK_ApplicationFrame{
    
    return CGRectMake(0,
                      0,
                      [[UIScreen mainScreen] KK_ApplicationWidth],
                      [[UIScreen mainScreen] KK_ApplicationHeight]);
}

- (CGSize)KK_ApplicationSize{
    
    return CGSizeMake([[UIScreen mainScreen] KK_ApplicationWidth],
                      [[UIScreen mainScreen] KK_ApplicationHeight]);
}

- (CGFloat)KK_SafeAreaBottomHeight{
    if ([[UIDevice currentDevice] isiPhoneX]) {
        return 34.0f;
    }
    else{
        return 0;
    }
}


- (void)createiPhoneXFooterForView:(nullable UIView*)aView{
    [self createiPhoneXFooterForView:aView withBackGroudColor:[UIColor whiteColor]];
}

- (void)createiPhoneXFooterForView:(nullable UIView*)aView withBackGroudColor:(nullable UIColor *)backColor{
    
    //判断是否是iphoneX
    if ([[UIDevice currentDevice] isiPhoneX]) {
        UIView *iPhoneXView = [[UIView alloc] initWithFrame:CGRectMake(0, aView.frame.size.height, aView.frame.size.width, KKSafeAreaBottomHeight)];
        iPhoneXView.backgroundColor = backColor;
    //        iPhoneXView.backgroundColor = [UIColor redColor];
        iPhoneXView.userInteractionEnabled = NO;
        iPhoneXView.autoresizingMask = UIViewContentModeTop;
        [aView addSubview:iPhoneXView];
    }
}

@end
