//
//  TestViewController.m
//  Clover
//
//  Created by 刘波 on 2020/11/19.
//  Copyright © 2020 guiming.zheng. All rights reserved.
//

#import "TestViewController.h"
#import <KKFramework/KKFramework.h>

@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource,KKRefreshHeaderViewDelegate>

@property (nonatomic , strong) UITableView *table;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, KKStatusBarAndNavBarHeight, KKScreenWidth, KKScreenHeight-KKStatusBarAndNavBarHeight) style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor orangeColor];
    self.table.backgroundView.backgroundColor = [UIColor blueColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    [self.table showRefreshHeaderWithDelegate:self];
    
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Frameworks/KKFramework.framework" ofType:nil];
//    NSBundle *aBundle = [NSBundle kkLibraryBundle];
//    NSString *path = [aBundle pathForResource:@"KKLibraryDBManager.sqlite" ofType:nil];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        NSLog(@"YES");
//    }
//    else {
//        NSLog(@"NO");
//    }
    
//    NSLog(@"");
    
}

#pragma mark ==================================================
#pragma mark == KKRefreshHeaderViewDelegate
#pragma mark ==================================================
//触发刷新加载数据
- (void)KKRefreshHeaderView_BeginRefresh:(KKRefreshHeaderView*)view{
    [self performSelector:@selector(headerRefreshFinished) withObject:nil afterDelay:2.0];
}

- (void)headerRefreshFinished{
    [self.table stopRefreshHeader];
}



#pragma mark ==================================================
#pragma mark == UITableViewDelegate
#pragma mark ==================================================
/* heightForRow */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        return self.mHeight;
//    }
//    return 50;
//}

/* Header Height */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

/* Header View */
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

/* Footer Height */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

/* Footer View */
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

/* didSelectRow */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ==================================================
#pragma mark == UITableViewDataSource
#pragma mark ==================================================
/* numberOfSections */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

/* numberOfRowsInSection */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 30;
}

/* cellForRowAtIndexPath */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row];
    
    return cell;

}

@end
