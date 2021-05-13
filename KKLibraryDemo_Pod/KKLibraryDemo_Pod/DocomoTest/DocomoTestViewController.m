//
//  DocomoTestViewController.m
//  KKLibraryDemo_Pod
//
//  Created by edward lannister on 2021/3/18.
//

#import "DocomoTestViewController.h"

@interface DocomoTestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *table;
@property (nonatomic , strong) NSMutableArray *dataSourceYES;
@property (nonatomic , strong) NSMutableArray *dataSourceNO;
@property (nonatomic , copy) NSString *subKey;
@property (nonatomic , assign) DocomoTestType myType;

@end

@implementation DocomoTestViewController

- (instancetype)initWithType:(DocomoTestType)aType
{
    self = [super init];
    if (self) {
        self.myType = aType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self showNavigationDefaultBackButton_ForNavPopBack];
    
    if (self.myType==DocomoTestType_Scheme) {
        self.title = @"Docomo_SchemeTest";
        self.subKey = @"scheme";
    }
    else{
        self.title = @"Docomo_DownLoadURLTest";
        self.subKey = @"download_url";
    }
    [self initData];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight-KKStatusBarAndNavBarHeight) style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.backgroundView.backgroundColor = [UIColor clearColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
}

- (void)initData{
    self.dataSourceYES = [[NSMutableArray alloc] init];
    self.dataSourceNO = [[NSMutableArray alloc] init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Docomo_SF.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    for (NSInteger i=0; i<[array count]; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSMutableDictionary *dicN = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dicN setObject:[NSString stringWithInteger:i+1] forKey:@"index"];
        
//        NSString *name = [dic validStringForKey:@"name"];
//        NSString *show_default = [dic validStringForKey:@"show_default"];
        NSString *scheme = [dic validStringForKey:@"scheme"];
//        NSString *download_url = [dic validStringForKey:@"download_url"];
        NSURL *url = [NSURL URLWithString:scheme];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            KKLogDebugFormat(@"schema can open : 【YES】 %@",scheme);
            [self.dataSourceYES addObject:dicN];
        }
        else{
            KKLogDebugFormat(@"schema can open : 【NO】 %@",scheme);
            [self.dataSourceNO addObject:dicN];
        }
    }
    
}

#pragma mark ==================================================
#pragma mark == UITableViewDelegate
#pragma mark ==================================================
/* heightForRow */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    static CGFloat cellHeight = 0;
    if (cellHeight>1) {
        return cellHeight;
    }
        
    UILabel *mainLabel = [UILabel kk_initWithTextColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:16] text:@"哈哈"];
    UILabel *subLabel = [UILabel kk_initWithTextColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] text:@"哈哈"];

    cellHeight = 10 + mainLabel.height + 10 + subLabel.height + 10;
    
    return cellHeight;
}

/* Header Height */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

/* Header View */
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, 50)];
    UILabel *mainLabel = [UILabel kk_initWithTextColor:[UIColor blueColor] font:[UIFont boldSystemFontOfSize:20] text:@"哈哈"];
    mainLabel.frame = CGRectMake(15, (50-mainLabel.height)/2.0, KKScreenWidth-30, mainLabel.height);
    [headerView addSubview:mainLabel];
    if (section==0) {
        mainLabel.text = [NSString stringWithFormat:@"Scheme可以打开【%ld/%ld】",(long)self.dataSourceYES.count,(long)(self.dataSourceYES.count+self.dataSourceNO.count)];
        mainLabel.textColor = [UIColor blueColor];
    }
    else{
        mainLabel.text = [NSString stringWithFormat:@"Scheme打不开【%ld/%ld】",(long)self.dataSourceNO.count,(long)(self.dataSourceYES.count+self.dataSourceNO.count)];
        mainLabel.textColor = [UIColor redColor];
    }
    headerView.backgroundColor = [UIColor colorWithHexString:@"#46EBD5"];
    return headerView;
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
    NSDictionary *dic = nil;
    if (indexPath.section==0) {
        dic = [self.dataSourceYES objectAtIndex:indexPath.row];
        NSMutableDictionary *dicN = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([dic boolValueForKey:@"clicked"]) {
            [dicN setObject:@"0" forKey:@"clicked"];
        }
        else{
            [dicN setObject:@"1" forKey:@"clicked"];
        }
        
        [self.dataSourceYES replaceObjectAtIndex:indexPath.row withObject:dicN];
        [self.table reloadData];
    }
    else{
        dic = [self.dataSourceNO objectAtIndex:indexPath.row];
        NSMutableDictionary *dicN = [NSMutableDictionary dictionaryWithDictionary:dic];
        if ([dic boolValueForKey:@"clicked"]) {
            [dicN setObject:@"0" forKey:@"clicked"];
        }
        else{
            [dicN setObject:@"1" forKey:@"clicked"];
        }
        [self.dataSourceNO replaceObjectAtIndex:indexPath.row withObject:dicN];
        [self.table reloadData];
    }
    
    NSString *subString = [dic validStringForKey:self.subKey];
    NSURL *url = [NSURL URLWithString:subString];
    if (url) {
        NSDictionary *options = [NSDictionary dictionary];
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
            KKLogDebugFormat(@"%@",success?@"YES":@"NO");
        }];
    }
    else{
        [KKToastView showInView:[UIWindow currentKeyWindow] text:@"URL无效" image:nil alignment:KKToastViewAlignment_Center];
    }

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
        return self.dataSourceYES.count;
    }
    return self.dataSourceNO.count;
}

/* cellForRowAtIndexPath */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UILabel *mainLabel = [UILabel kk_initWithTextColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:16] text:@"哈哈"];
        mainLabel.frame = CGRectMake(15, 10, KKScreenWidth-30, mainLabel.height);
        mainLabel.tag = 1111;
        [cell addSubview:mainLabel];
        
        UILabel *subLabel = [UILabel kk_initWithTextColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] text:@"哈哈"];
        subLabel.frame = CGRectMake(30, mainLabel.bottom + 10, KKScreenWidth-45, subLabel.height);
        subLabel.tag = 2222;
        [cell addSubview:subLabel];
    }
    
    UILabel *mainLabel = [cell viewWithTag:1111];
    UILabel *subLabel = [cell viewWithTag:2222];

    NSDictionary *dic = nil;
    if (indexPath.section==0) {
        dic = [self.dataSourceYES objectAtIndex:indexPath.row];
    }
    else{
        dic = [self.dataSourceNO objectAtIndex:indexPath.row];
    }
    
    NSString *mainString = [dic validStringForKey:@"name"];
    NSString *subString = [dic validStringForKey:self.subKey];
    NSString *show_default = [dic validStringForKey:@"show_default"];
    NSString *index = [dic validStringForKey:@"index"];
    BOOL clicked = [dic boolValueForKey:@"clicked"];

    if ([show_default integerValue]>0) {
        mainLabel.text = [NSString stringWithFormat:@"(%ld)❤️ %@",(long)indexPath.row+1,mainString];
    }
    else{
        mainLabel.text = [NSString stringWithFormat:@"(%ld)%@",(long)indexPath.row+1,mainString];
    }
    subLabel.text =  [NSString stringWithFormat:@"【%@】%@",index,subString];
    if (clicked) {
        [cell setBackgroundViewColor:[UIColor colorWithHexString:@"#F8671D"]];
    }
    else{
        [cell setBackgroundViewColor:[UIColor whiteColor]];
    }
    
    return cell;

}
@end

