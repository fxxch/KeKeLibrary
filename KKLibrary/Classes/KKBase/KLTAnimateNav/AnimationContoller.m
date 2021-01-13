//
//  AnimationContoller.m
//  ChongZu
//
//  Created by 孔令涛 on 2016/10/9.
//  Copyright © 2016年 cz10000. All rights reserved.
//

#import "AnimationContoller.h"
#import "AnimationContollerScreenshot.h"

@interface AnimationContoller ()

@property(nonatomic,strong)NSMutableArray * screenShotArray;
/**
 所属的导航栏有没有TabBarController
 */
@property (nonatomic,assign)BOOL isTabbarExist;

@end

@implementation AnimationContoller

+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation NavigationController:(UINavigationController *)navigationController
{
    AnimationContoller * ac = [[AnimationContoller alloc]init];
    ac.navigationController = navigationController;
    ac.navigationOperation = operation;
    return ac;
}
+ (instancetype)AnimationControllerWithOperation:(UINavigationControllerOperation)operation
{
    AnimationContoller * ac = [[AnimationContoller alloc]init];
    ac.navigationOperation = operation;
    return ac;
}

- (void)setNavigationController:(UINavigationController *)navigationController
{
    _navigationController = navigationController;
    
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    //判断该导航栏是否有TabBarController
    if (self.navigationController.tabBarController == beyondVC) {
        _isTabbarExist = YES;
    }
    else
    {
        _isTabbarExist = NO;
    }
}

- (NSMutableArray *)screenShotArray
{
    if (_screenShotArray == nil) {
        _screenShotArray = [[NSMutableArray alloc]init];
    }
    return _screenShotArray;
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .4f;
}

#pragma mark ==================================================
#pragma mark == 外部移除截图
#pragma mark ==================================================
- (void)removeLastScreenShot{
    [self.screenShotArray removeLastObject];
}

- (void)removeAllScreenShot{
    [self.screenShotArray removeAllObjects];
}

#pragma mark ==================================================
#pragma mark == 截图处理
#pragma mark ==================================================
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //取出fromViewController,fromView和toViewController，toView
    UIViewController * fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect fromViewEndFrame = [transitionContext finalFrameForViewController:fromViewController];
    fromViewEndFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
    CGRect fromViewStartFrame = fromViewEndFrame;
    CGRect toViewEndFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect toViewStartFrame = toViewEndFrame;
    
    UIView * containerView = [transitionContext containerView];

    UIImageView * screentImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImage * screenImg = [self screenShot];
    screentImgView.image =screenImg;

    if (self.navigationOperation == UINavigationControllerOperationPush) {

        AnimationContollerScreenshot *object = [[AnimationContollerScreenshot alloc] init];
        object.viewController = fromViewController;
        object.image = screenImg;
        [self.screenShotArray addObject:object];
        
        //这句非常重要，没有这句，就无法正常Push和Pop出对应的界面
        [containerView addSubview:toView];
        
        toView.frame = toViewStartFrame;
        
        UIView * nextVC = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        //将截图添加到导航栏的View所属的window上
        [self.navigationController.view.window insertSubview:screentImgView atIndex:0];
        
        nextVC.layer.shadowColor = [UIColor blackColor].CGColor;
        nextVC.layer.shadowOffset = CGSizeMake(-0.8, 0);
        nextVC.layer.shadowOpacity = 0.6;
        
        self.navigationController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //toView.frame = toViewEndFrame;
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            screentImgView.center = CGPointMake(-[UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height / 2);
            //nextVC.center = CGPointMake(ScreenWidth/2, ScreenHeight / 2);
            
        } completion:^(BOOL finished) {
            
            [nextVC removeFromSuperview];
            [screentImgView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
    
    if (self.navigationOperation == UINavigationControllerOperationPop) {
        
        fromViewStartFrame.origin.x = 0;
        [containerView addSubview:toView];
        
        UIImageView * lastVcImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //若removeCount大于0  则说明Pop了不止一个控制器
        if (_removeCount > 0) {
            for (NSInteger i = 0; i < _removeCount; i ++) {
                if (i == _removeCount - 1) {
                    
                    [self DEBUG_PrintViewControllers];
                    [self DEBUG_PrintImages];

                    [self checkViewControllersAndImages];

                    //当删除到要跳转页面的截图时，不再删除，并将该截图作为ToVC的截图展示
                    [self reloadLastViewControllerImageView:lastVcImgView];
//                    AnimationContollerScreenshot *object = [self.screenShotArray lastObject];
//                    lastVcImgView.image = object.image;
                    _removeCount = 0;
                    break;
                }
                else
                {
                    [self.screenShotArray removeLastObject];
                }
                
            }
        }
        else
        {
            [self DEBUG_PrintViewControllers];
            [self DEBUG_PrintImages];

            [self checkViewControllersAndImages];

            [self reloadLastViewControllerImageView:lastVcImgView];
//            AnimationContollerScreenshot *object = [self.screenShotArray lastObject];
//            lastVcImgView.image = object.image;
        }

        screentImgView.layer.shadowColor = [UIColor blackColor].CGColor;
        screentImgView.layer.shadowOffset = CGSizeMake(-0.8, 0);
        screentImgView.layer.shadowOpacity = 0.6;
        [self.navigationController.view.window addSubview:lastVcImgView];
        [self.navigationController.view addSubview:screentImgView];
        
        // fromView.frame = fromViewStartFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            screentImgView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 3 / 2 , [UIScreen mainScreen].bounds.size.height / 2);
            lastVcImgView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            //fromView.frame = fromViewEndFrame;
            
        } completion:^(BOOL finished) {
            //[self.navigationController setNavigationBarHidden:NO];
            [lastVcImgView removeFromSuperview];
            [screentImgView removeFromSuperview];
            [self.screenShotArray removeLastObject];
            [transitionContext completeTransition:YES];
        }];
    }
}

- (UIImage *)screenShot
{
    // 将要被截图的view,即窗口的根控制器的view(必须不含状态栏,默认ios7中控制器是包含了状态栏的)
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    // 背景图片 总的大小
    CGSize size = beyondVC.view.frame.size;
    // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    // 要裁剪的矩形范围
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
    
    //判读是导航栏是否有上层的Tabbar  决定截图的对象
    if (_isTabbarExist) {
        [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
    }
    else
    {
        [self.navigationController.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    }
    // 从上下文中,取出UIImage
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
    UIGraphicsEndImageContext();
    
    // 返回截取好的图片
    return snapshot;
}


- (void)DEBUG_PrintImages{
//    NSLog(@"==========AnimationContoller========== ");
//    for (NSInteger i=0; i<[self.screenShotArray count]; i++) {
//        AnimationContollerScreenshot *object = [self.screenShotArray objectAtIndex:i];
//        NSLog(@"%@",NSStringFromClass([object.viewController class]));
//    }
//    NSLog(@"==========AnimationContoller========== ");
}

- (void)DEBUG_PrintViewControllers{
//    NSLog(@"===KLTNavigationController:VCALL:%@",self.navigationController.viewControllers);
}


- (void)reloadLastViewControllerImageView:(UIImageView*)aImageView{
    AnimationContollerScreenshot *object = [self.screenShotArray lastObject];
    if (object) {
        if (object.viewController) {
            aImageView.image = object.image;
        }
        else{
            [self.screenShotArray removeObject:object];
            [self reloadLastViewControllerImageView:aImageView];
        }
    }
}

/**
 校验导航控制器的截图图片与堆栈里面的ViewController是否对应
 */
- (void)checkViewControllersAndImages{
    
    NSMutableArray *newImageObjectsArray = [NSMutableArray array];
    
    NSArray *allViewControllers = self.navigationController.viewControllers;
    for (NSInteger i=0; i<[allViewControllers count]; i++) {
        UIViewController *viewController = [allViewControllers objectAtIndex:i];
        AnimationContollerScreenshot *object = [self screenshotObjectForViewController:viewController];
        if (object) {
            [newImageObjectsArray addObject:object];
        }
    }
    
    [self.screenShotArray removeAllObjects];
    [self.screenShotArray addObjectsFromArray:newImageObjectsArray];
}

- (AnimationContollerScreenshot*)screenshotObjectForViewController:(UIViewController*)aViewController{
    
    AnimationContollerScreenshot *screenshot = nil;
    
    for (NSInteger i=0; i<[self.screenShotArray count]; i++) {
        AnimationContollerScreenshot *object = [self.screenShotArray objectAtIndex:i];
        if (object.viewController==aViewController) {
            screenshot = object;
            break;
        }
    }
    
    if (screenshot) {
        return screenshot;
    }
    else{
        return [self screenShotForViewController:aViewController];
    }
}

// 使用上下文截图,并使用指定的区域裁剪,模板代码
- (AnimationContollerScreenshot*)screenShotForViewController:(UIViewController*)beyondVC{
    
    //2014-10-20 刘波
    UIGraphicsBeginImageContextWithOptions(beyondVC.view.frame.size, YES, 0);
    [beyondVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 添加截取好的图片到图片数组
    if (snapshot) {
        AnimationContollerScreenshot *object = [[AnimationContollerScreenshot alloc] init];
        object.image = snapshot;
        object.viewController = beyondVC;
        return object;
    }
    else{
        return nil;
    }

    
//    // 背景图片 总的大小
//    CGSize size = beyondVC.view.frame.size;
//    // 开启上下文,使用参数之后,截出来的是原图（YES  0.0 质量高）
//    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
//    // 要裁剪的矩形范围
//    CGRect rect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    //注：iOS7以后renderInContext：由drawViewHierarchyInRect：afterScreenUpdates：替代
//    [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:YES];
//    // 从上下文中,取出UIImage
//    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
//
//    // 千万记得,结束上下文(移除栈顶的基于当前位图的图形上下文)
//    UIGraphicsEndImageContext();
//
//    // 添加截取好的图片到图片数组
//    if (snapshot) {
//        AnimationContollerScreenshot *object = [[AnimationContollerScreenshot alloc] init];
//        object.image = snapshot;
//        object.viewController = beyondVC;
//        return object;
//    }
//    else{
//        return nil;
//    }
}


@end
