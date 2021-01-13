//
//  UIScreen+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KKApplicationFrame          ([[UIScreen mainScreen] KK_ApplicationFrame])
#define KKApplicationSize           ([[UIScreen mainScreen] KK_ApplicationSize])
#define KKApplicationWidth          ([[UIScreen mainScreen] KK_ApplicationWidth])
#define KKApplicationHeight         ([[UIScreen mainScreen] KK_ApplicationHeight])
#define KKScreenWidth               ([[UIScreen mainScreen] KK_ScreenWidth])
#define KKScreenHeight              ([[UIScreen mainScreen] KK_ScreenHeight])
#define KKStatusBarHeight           ([[UIScreen mainScreen] KK_StatusBarHeight])
#define KKNavigationBarHeight       ([[UIScreen mainScreen] KK_NavigationBarHeight])
#define KKStatusBarAndNavBarHeight  ([[UIScreen mainScreen] KK_StatusBarAndNavBarHeight])
#define KKSafeAreaBottomHeight      ([[UIScreen mainScreen] KK_SafeAreaBottomHeight])

@interface UIScreen (KKCategory)

- (CGSize)KKAutoResize_ForOldWidth:(CGFloat)aWidth
                         oldHeight:(CGFloat)aHeight;

/* width  元素宽度（设计师设计的）
 height 元素宽度（设计师设计的）
 newWidth 希望展示的宽度
 */
- (CGSize)KKAutoResize_ForOldWidth:(CGFloat)aWidth
                         oldHeight:(CGFloat)aHeight
                          newWidth:(CGFloat)bWidth;

- (CGFloat)KK_ScreenWidth;

- (CGFloat)KK_ScreenHeight;

- (CGFloat)KK_ApplicationWidth;

- (CGFloat)KK_ApplicationHeight;

- (CGRect)KK_ApplicationFrame;

- (CGSize)KK_ApplicationSize;

- (CGFloat)KK_StatusBarHeight;

- (CGFloat)KK_NavigationBarHeight;

- (CGFloat)KK_StatusBarAndNavBarHeight;

- (CGFloat)KK_SafeAreaBottomHeight;

- (void)createiPhoneXFooterForView:(nullable UIView*)aView;

- (void)createiPhoneXFooterForView:(nullable UIView*)aView withBackGroudColor:(nullable UIColor *)backColor;

@end
