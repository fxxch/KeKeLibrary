//
//  UINavigationController+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (KKCategory)

/**
 导航控制器在Push ViewController的时候，均用此方法
 @param aViewControllerName ViewController的名字
 @param aParms ViewController初始化需要的参数
 @return 返回ViewController
 */
- (nullable UIViewController*)pushViewController:(nullable NSString*)aViewControllerName
                                       withParms:(nullable NSDictionary*)aParms;

@end
