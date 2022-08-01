//
//  UIScreen+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UIScreen+KKCategory.h"
#import "UIDevice+KKCategory.h"
#import "UIWindow+KKCategory.h"

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

    if (@available(iOS 11.0,*)) {
        UIEdgeInsets edgeInsets = [UIWindow kk_currentKeyWindow].safeAreaInsets;
        return edgeInsets.bottom;
    }
    else{
        return 0;
    }
}

- (CGFloat)KK_StatusBarHeight{
    if (@available(iOS 13.0,*)) {
        CGFloat statusBarHeight = [UIWindow kk_currentKeyWindow].windowScene.statusBarManager.statusBarFrame.size.height;
        return statusBarHeight;
    }
    else{
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        return statusBarHeight;
    }
}

- (CGFloat)KK_NavigationBarHeight{
    return 44;
}

- (CGFloat)KK_StatusBarAndNavBarHeight{
    return KKNavigationBarHeight+KKStatusBarHeight;
}

- (void)kk_createiPhoneXFooterForView:(nullable UIView*)aView{
    [self kk_createiPhoneXFooterForView:aView withBackGroudColor:[UIColor whiteColor]];
}

- (void)kk_createiPhoneXFooterForView:(nullable UIView*)aView withBackGroudColor:(nullable UIColor *)backColor{
    
    //判断是否是iphoneX
    if ([[UIDevice currentDevice] kk_isiPhoneX]) {
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
