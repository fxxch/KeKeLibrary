//
//  ViewController.m
//  TestDemo
//
//  Created by 刘波 on 2020/11/24.
//

#import "RootViewController.h"
#import "TestViewController.h"
#import <KeKeLibrary/KeKeLibrary.h>

@interface RootViewController ()

@property (nonatomic , assign) NSInteger count;

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

}

- (void)showAction {
//    KKAlertView *alert = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:@"哈哈哈" delegate:self buttonTitles:@"OK",nil];
//    [alert show];
//    NSLog(@"");

    TestViewController *vc = [[TestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showActionAAAa {
    NSLog(@"");
//    if (self.count==0) {
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_Gray blackBackground:NO text:@""];
//    }
//    else if (self.count==1){
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_Green blackBackground:NO text:@""];
//    }
//    else if (self.count==2){
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_White blackBackground:NO text:@""];
//    }
//    else if (self.count==3){
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_IndicatorWhite blackBackground:NO text:@""];
//    }
//    else if (self.count==4){
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_IndicatorGray blackBackground:NO text:@""];
//    }
//    else if (self.count==5) {
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_Gray blackBackground:YES text:@""];
//    }
//    else if (self.count==6){
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_Green blackBackground:YES text:@""];
//    }
//    else if (self.count==7){
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_White blackBackground:YES text:@""];
//    }
//    else if (self.count==8){
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_IndicatorWhite blackBackground:YES text:@""];
//    }
//    else if (self.count==9){
//        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_IndicatorGray blackBackground:YES text:@""];
//    }
//    else{
//        self.count=0;
//        return;
//    }
//    
//    self.count++;
//    [self performSelector:@selector(hideWaitingView) withObject:nil afterDelay:3.0];

    [self showActionBBBBB:__PRETTY_FUNCTION__ line:__LINE__];
    
    KKLogEmpty(@"empty");
    KKLogVerbose(@"Verbose");
    KKLogVerboseFormat(@"Verbose %@",@"Format");
    
    KKLogDebug(@"Debug");
    KKLogDebugFormat(@"Debug %@",@"Format");

    
    KKLogInfo(@"Info");
    KKLogInfoFormat(@"Info %@",@"Format");

    KKLogWarning(@"Warning");
    KKLogWarningFormat(@"Warning %@",@"Format");

    KKLogError(@"Error");
    KKLogErrorFormat(@"Error %@",@"Format");

}

- (void)showActionBBBBB:(const char [37])fuction line:(int)aLine{
//    NSLog((@"%s [Line %d] "), fuction, aLine);
}

- (void)hideWaitingView{
    [KKWaitingView hideForView:[UIWindow currentKeyWindow]];
}


@end
