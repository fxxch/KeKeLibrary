//
//  ViewController.m
//  TestDemo
//
//  Created by 刘波 on 2020/11/24.
//

#import "RootViewController.h"
#import "KKLibraryDemoTestViewController.h"
#import "DocomoTestViewController.h"
#import "NetworkHelper.h"

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
    offsetY = [self initButtonTest_NetworkHelperTest:offsetY];

    offsetY = offsetY + 30;
    self.mainScrollView.contentSize = CGSizeMake(KKScreenWidth, offsetY);
}

#pragma mark ****************************************
#pragma mark 屏幕方向
#pragma mark ****************************************
//1.决定当前界面是否开启自动转屏，如果返回NO，后面两个方法也不会被调用，只是会支持默认的方向
- (BOOL)shouldAutorotate {
    return YES;
}

//2.返回支持的旋转方向（当前viewcontroller支持哪些转屏方向）
//iPad设备上，默认返回值UIInterfaceOrientationMaskAllButUpSideDwon
//iPad设备上，默认返回值是UIInterfaceOrientationMaskAll
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

//3.返回进入界面默认显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
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
    [self performSelector:@selector(hideWaitingView) withObject:nil afterDelay:5.0];
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
//    KKLogDebugFormat((@"%s [Line %d] "), fuction, aLine);
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

#pragma mark ==================================================
#pragma mark == NetworkHelperTest
#pragma mark ==================================================
-(CGFloat)initButtonTest_NetworkHelperTest:(CGFloat)offset{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, offset, KKScreenWidth-30, 40);
    button.backgroundColor = TSRandomColor;
    [button setTitle:@"NetworkHelperTest" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(test_NetworkHelperTest) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:button];
    [button setCornerRadius:20];
    return offset+button.height+30;
}

- (void)test_NetworkHelperTest{
    
    BOOL whetherConnectedNetwork = [NetworkHelper whetherConnectedNetwork];
    NSString *haveNet = nil;
    if (whetherConnectedNetwork) {
        haveNet = @"有网络";
        NSLog(@"有网络");
    }
    else{
        haveNet = @"无网络";
        NSLog(@"无网络");
    }
    
    NSString* getNetworkType = [NetworkHelper getNetworkType];
    NSLog(@"%@",getNetworkType);

    NSString* getSignalStrength = [NetworkHelper getSignalStrength];
    NSLog(@"%@",getSignalStrength);

    NSString* getSignalStrengthBar = [NetworkHelper getSignalStrengthBar];
    NSLog(@"%@",getSignalStrengthBar);

    NSString* getInternetfaceFormated = [[NetworkHelper defaultManager] getInternetfaceFormated];
    NSLog(@"%@",getInternetfaceFormated);

    NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n当前网速:%@\n",haveNet,getNetworkType,getSignalStrength,getSignalStrengthBar,getInternetfaceFormated];
    KKAlertView *alert = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"OK",nil];
    [alert show];

//    dbm是无线信号的强度单位。一般在 -90 ~ 0之间。
//    一般情况下：
//    -50~0之间信号强度很好，使用感知好。
//    -70~-50之间信号强度好。使用感知略差，但体验上无明显影响。
//    -70以下 信号就不是太好了，使用上感知就不好。
}

@end
