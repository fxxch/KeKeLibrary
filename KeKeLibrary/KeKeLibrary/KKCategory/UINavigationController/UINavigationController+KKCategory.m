//
//  UINavigationController+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UINavigationController+KKCategory.h"
#import "KKViewController.h"

@implementation UINavigationController (KKCategory)

/**
 导航控制器在Push ViewController的时候，均用此方法
 @param aViewControllerName ViewController的名字
 @param aParms ViewController初始化需要的参数
 @return 返回ViewController
 */
- (nullable UIViewController*)pushViewController:(nullable NSString*)aViewControllerName
                                       withParms:(nullable NSDictionary*)aParms{
    
    Class mClass = NSClassFromString(aViewControllerName);
    if (mClass) {
        KKViewController *viewController = [(KKViewController*)[NSClassFromString(aViewControllerName) alloc] initWithParms:aParms];
        if (viewController) {
            [self pushViewController:viewController animated:YES];
            return viewController;
        }
        else{
            NSLog(@"%@实例化的时候，参数有误",aViewControllerName);
            return nil;
        }
    }
    else{
        NSLog(@"本地未实现类：aViewControllerName");
        return nil;
    }
}

@end
