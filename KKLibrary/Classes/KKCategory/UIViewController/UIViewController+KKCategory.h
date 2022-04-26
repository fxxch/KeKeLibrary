//
//  UIViewController+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KKCategory)

- (void)kk_fullPresentViewController:(UIViewController *_Nullable)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;

@end
