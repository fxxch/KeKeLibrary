//
//  ViewController.m
//  TestDemo
//
//  Created by 刘波 on 2020/11/24.
//

#import "RootViewController.h"
#import "TestViewController.h"
//#import <KKFramework/KKFramework.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 115, 80, 40);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Test" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(15, 315, 80, 40);
    button2.backgroundColor = [UIColor greenColor];
    [button2 setTitle:@"Test" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showActionAAAa) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];

    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (@available(iOS 13.0,*)) {
        statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;
    }
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0,*)) {
        edgeInsets = [UIApplication sharedApplication].windows.firstObject.safeAreaInsets;
    }
    NSLog(@"");
}

- (void)showAction {
//    KKAlertView *alert = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:@"哈哈哈" delegate:self buttonTitles:@"OK",nil];
//    [alert show];
//    NSLog(@"");
//
//    TestViewController *vc = [[TestViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showActionAAAa {
    NSLog(@"");
}


@end
