//
//  ViewController.m
//  TestDemo
//
//  Created by 刘波 on 2020/11/24.
//

#import "RootViewController.h"
#import "KKLibraryDemoTestViewController.h"
#import "DocomoTestViewController.h"

#define TSRandom(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:255.0/255.0]
#define TSRandomColor TSRandom(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface RootViewController ()

@property (nonatomic , strong) UIScrollView *mainScrollView;

@property (nonatomic , assign) NSInteger count;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight-KKStatusBarAndNavBarHeight)];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.mainScrollView];
    
    CGFloat offsetY = 0;

    offsetY = 30;
//    offsetY = [self initButtonTest_KKAlertView:offsetY];
//    offsetY = [self initButtonTest_KKRefreshHeader:offsetY];
//    offsetY = [self initButtonTest_KKWaitingView:offsetY];
//    offsetY = [self initButtonTest_KKLog:offsetY];
    offsetY = [self initButtonTest_DocomoSchemeTest:offsetY];
    offsetY = [self initButtonTest_DocomoDownLoadURLTest:offsetY];

    offsetY = offsetY + 30;
    self.mainScrollView.contentSize = CGSizeMake(KKScreenWidth, offsetY);
}

#pragma mark ==================================================
#pragma mark == KKAlertView
#pragma mark ==================================================
- (CGFloat)initButtonTest_KKAlertView:(CGFloat)offset{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, offset, KKScreenWidth-30, 40);
    button.backgroundColor = TSRandomColor;
    [button setTitle:@"KKAlertView" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test_KKAlertView) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:button];
    [button setCornerRadius:20];
    return offset+button.height+30;
}

- (void)test_KKAlertView{
    KKAlertView *alert = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:@"哈哈哈" delegate:self buttonTitles:@"OK",nil];
    [alert show];
}

#pragma mark ==================================================
#pragma mark == KKRefreshHeader
#pragma mark ==================================================
- (CGFloat)initButtonTest_KKRefreshHeader:(CGFloat)offset{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, offset, KKScreenWidth-30, 40);
    button.backgroundColor = TSRandomColor;
    [button setTitle:@"KKRefreshHeader" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test_KKRefreshHeader) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:button];
    [button setCornerRadius:20];
    return offset+button.height+30;
}

- (void)test_KKRefreshHeader{
    KKLibraryDemoTestViewController *vc = [[KKLibraryDemoTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==================================================
#pragma mark == KKWaitingView
#pragma mark ==================================================
- (CGFloat)initButtonTest_KKWaitingView:(CGFloat)offset{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, offset, KKScreenWidth-30, 40);
    button.backgroundColor = TSRandomColor;
    [button setTitle:@"KKWaitingView" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test_KKWaitingView) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:button];
    [button setCornerRadius:20];
    return offset+button.height+30;
}

- (void)test_KKWaitingView{
    if (self.count==0) {
        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_Gray blackBackground:NO text:@""];
    }
    else if (self.count==1){
        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_Green blackBackground:NO text:@""];
    }
    else if (self.count==2){
        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_White blackBackground:NO text:@""];
    }
    else if (self.count==3) {
        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_Gray blackBackground:YES text:@""];
    }
    else if (self.count==4){
        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_Green blackBackground:YES text:@""];
    }
    else if (self.count==5){
        [KKWaitingView showInView:[UIWindow currentKeyWindow] withType:KKWaitingViewType_White blackBackground:YES text:@""];
    }
    else{
        self.count=0;
        return;
    }
    
    self.count++;
    [self performSelector:@selector(hideWaitingView) withObject:nil afterDelay:3.0];
}

- (void)hideWaitingView{
    [KKWaitingView hideForView:[UIWindow currentKeyWindow]];
}

#pragma mark ==================================================
#pragma mark == KKLog
#pragma mark ==================================================
- (CGFloat)initButtonTest_KKLog:(CGFloat)offset{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, offset, KKScreenWidth-30, 40);
    button.backgroundColor = TSRandomColor;
    [button setTitle:@"KKLog" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test_KKLog) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:button];
    [button setCornerRadius:20];
    return offset+button.height+30;
}

- (void)test_KKLog{
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

#pragma mark ==================================================
#pragma mark == DocomoSchemeTest
#pragma mark ==================================================
- (CGFloat)initButtonTest_DocomoSchemeTest:(CGFloat)offset{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, offset, KKScreenWidth-30, 40);
    button.backgroundColor = TSRandomColor;
    [button setTitle:@"DocomoSchemeTest" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test_DocomoSchemeTest) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:button];
    [button setCornerRadius:20];
    return offset+button.height+30;
}

- (void)test_DocomoSchemeTest{
    DocomoTestViewController *vc = [[DocomoTestViewController alloc] initWithType:DocomoTestType_Scheme];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==================================================
#pragma mark == DocomoDownLoadURLTest
#pragma mark ==================================================
- (CGFloat)initButtonTest_DocomoDownLoadURLTest:(CGFloat)offset{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, offset, KKScreenWidth-30, 40);
    button.backgroundColor = TSRandomColor;
    [button setTitle:@"DocomoDownLoadURLTest" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test_DocomoDownLoadURLTest) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:button];
    [button setCornerRadius:20];
    return offset+button.height+30;
}

- (void)test_DocomoDownLoadURLTest{
    DocomoTestViewController *vc = [[DocomoTestViewController alloc] initWithType:DocomoTestType_Download];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
