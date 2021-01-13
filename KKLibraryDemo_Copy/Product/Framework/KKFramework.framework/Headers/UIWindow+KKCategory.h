//
//  UIWindow+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (KKCategory)

//获取当前屏幕显示的viewcontroller
- (nullable UIViewController *)currentTopViewController;

+ (UIWindow*_Nullable)currentKeyWindow;

@end
