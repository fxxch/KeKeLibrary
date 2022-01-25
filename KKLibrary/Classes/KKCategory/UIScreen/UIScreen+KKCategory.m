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

- (CGSize)KKAutoResize_ForOldWidth:(CGFloat)aWidth
                         oldHeight:(CGFloat)aHeight{
    return [self KKAutoResize_ForOldWidth:aWidth oldHeight:aHeight newWidth:KKApplicationWidth];
}

- (CGSize)KKAutoResize_ForOldWidth:(CGFloat)aWidth
                         oldHeight:(CGFloat)aHeight
                          newWidth:(CGFloat)bWidth{
    
    CGFloat height = (bWidth*aHeight)/aWidth;
    
    return CGSizeMake(bWidth, height);
}

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
    CGFloat screenHeight = [self KK_ScreenHeight];
    CGFloat height = screenHeight - [self KK_StatusBarHeight] - [self KK_SafeAreaBottomHeight];
    return height;
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

- (CGFloat)KK_StatusBarHeight{
    if ([[UIDevice currentDevice] isiPhoneX]) {
        return 44.0f;
    }
    else{
        return 20.0f;
    }
}

- (CGFloat)KK_NavigationBarHeight{
    return 44;
}

- (CGFloat)KK_StatusBarAndNavBarHeight{
    return KKNavigationBarHeight+KKStatusBarHeight;
}

- (void)createiPhoneXFooterForView:(nullable UIView*)aView{
    [self createiPhoneXFooterForView:aView withBackGroudColor:[UIColor whiteColor]];
}

- (void)createiPhoneXFooterForView:(nullable UIView*)aView withBackGroudColor:(nullable UIColor *)backColor{
    
    //判断是否是iphoneX
    if ([[UIDevice currentDevice] isiPhoneX]) {
        [[aView viewWithTag:2018070299] removeFromSuperview];
        
        UIView *iPhoneXView = [[UIView alloc] initWithFrame:CGRectMake(0, aView.frame.size.height, aView.frame.size.width, KKSafeAreaBottomHeight)];
        iPhoneXView.backgroundColor = backColor;
        iPhoneXView.tag = 2018070299;
        //        iPhoneXView.backgroundColor = [UIColor redColor];
        iPhoneXView.userInteractionEnabled = NO;
        iPhoneXView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [aView addSubview:iPhoneXView];
    }
}

@end
