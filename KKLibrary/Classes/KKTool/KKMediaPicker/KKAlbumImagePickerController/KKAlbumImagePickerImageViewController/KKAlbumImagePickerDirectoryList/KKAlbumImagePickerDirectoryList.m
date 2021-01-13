//
//  KKAlbumImagePickerDirectoryList.m
//  BM
//
//  Created by sjyt on 2020/3/23.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKAlbumImagePickerDirectoryList.h"
#import "KKCategory.h"
#import "KKLibraryDefine.h"

@interface KKAlbumImagePickerDirectoryList ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIButton *backgroundView;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UIView *tableBackView;
@property(nonatomic,strong)NSMutableArray<KKAlbumDirectoryModal*> *dataSource;

@end

@implementation KKAlbumImagePickerDirectoryList

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self name:NotificationName_KKAlbumManagerLoadSourceFinished object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = [[NSMutableArray alloc] init];
        [self observeNotification:NotificationName_KKAlbumManagerLoadSourceFinished selector:@selector(Notification_KKAlbumManagerLoadSourceFinished:)];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = [[UIButton alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    [self.backgroundView addTarget:self action:@selector(backgroundButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backgroundView];
    
    CGRect backFrame = CGRectMake(0, 0, self.backgroundView.width, 1);
    self.tableBackView = [[UIView alloc] initWithFrame:backFrame];
    self.tableBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tableBackView];
    self.tableBackView.userInteractionEnabled = NO;

    CGRect tableFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-100);
    self.table = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.backgroundView.backgroundColor = [UIColor clearColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.showsVerticalScrollIndicator = NO;
    [self addSubview:self.table];
    [self.table setCornerRadius:10];
    self.table.clipsToBounds = YES;
}

- (void)Notification_KKAlbumManagerLoadSourceFinished:(NSNotification*)notice{
    NSArray *aArray = notice.object;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:aArray];
    [self.table reloadData];
}

- (void)backgroundButtonClicked{
    [self beginHide];
}

- (void)beginHide{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImagePickerDirectoryList_WillHide:)]) {
        [self.delegate KKAlbumImagePickerDirectoryList_WillHide:self];
    }

    [UIView animateWithDuration:0.25 animations:^{
        self.table.frame = CGRectMake(0, (-1)*self.table.height, self.frame.size.width, self.table.height);
        self.tableBackView.frame = CGRectMake(0, (-1)*self.tableBackView.height, self.frame.size.width, self.tableBackView.height);
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)beginShow{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImagePickerDirectoryList_WillShow:)]) {
        [self.delegate KKAlbumImagePickerDirectoryList_WillShow:self];
    }
    [self resetFrame];
    self.hidden = NO;
    self.backgroundView.alpha = 0;
    self.table.frame = CGRectMake(0, (-1)*self.table.height, self.frame.size.width, self.table.height);
    self.tableBackView.frame = CGRectMake(0, (-1)*self.tableBackView.height, self.frame.size.width, self.tableBackView.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.table.frame = CGRectMake(0, 0, self.frame.size.width, self.table.height);
        self.tableBackView.frame = CGRectMake(0, 0, self.frame.size.width, self.tableBackView.height);
        self.backgroundView.alpha = 1.0;
    } completion:^(BOOL finished) {

    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.table) {
        if (scrollView.contentOffset.y<0) {
            CGFloat offsetY = scrollView.contentOffset.y*(-1);
            CGRect frame = CGRectMake(0, 0, self.frame.size.width, offsetY+10);
            self.tableBackView.frame = frame;
        } else {
            self.tableBackView.frame = CGRectMake(0, 0, self.frame.size.width, 20);
        }
    }
}

- (void)resetFrame{
    [self.table scrollToTopWithAnimated:NO];
    if (self.table.contentSize.height>=self.frame.size.height-100) {
        self.table.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-100);
    } else {
        self.table.frame = CGRectMake(0, 0, self.frame.size.width, self.table.contentSize.height);
    }
    self.tableBackView.frame = CGRectMake(0, 0, self.frame.size.width, 20);
}

#pragma mark ==================================================
#pragma mark == UITableViewDataSource
#pragma mark ==================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 90)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.tag = 1100;
        backView.contentMode = UIViewContentModeScaleAspectFill;
        [cell addSubview:backView];
        backView.clipsToBounds = YES;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = 1101;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:imageView];
        imageView.clipsToBounds = YES;
        
        UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, [[UIScreen mainScreen] bounds].size.width-90-25, 40)];
        mainLabel.font = [UIFont systemFontOfSize:16];
        mainLabel.tag = 1102;
        mainLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:mainLabel];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, [[UIScreen mainScreen] bounds].size.width-90-25, 30)];
        subLabel.font = [UIFont systemFontOfSize:16];
        subLabel.tag = 1103;
        subLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:subLabel];
    }
    
    UIView *backView = (UIView*)[cell viewWithTag:1100];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1101];
    UILabel *mainLabel = (UILabel*)[cell viewWithTag:1102];
    UILabel *subLabel = (UILabel*)[cell viewWithTag:1103];
    
    //封面
    KKAlbumDirectoryModal *directory = (KKAlbumDirectoryModal*)[self.dataSource objectAtIndex:indexPath.row];
    if (directory.coverImage) {
        imageView.image = directory.coverImage;
    }
    else{
        imageView.image = nil;
        
        KKWeakSelf(self);
        KKAlbumAssetModal *aPHAsset = [directory.assetsArray firstObject];
        __block NSInteger row = indexPath.row;
        [KKAlbumManager loadThumbnailImage_withPHAsset:aPHAsset.asset targetSize:imageView.frame.size resultBlock:^(UIImage * _Nullable aImage, NSDictionary * _Nullable info) {
           
            KKAlbumDirectoryModal *directory = (KKAlbumDirectoryModal*)[weakself.dataSource objectAtIndex:row];
            directory.coverImage = aImage;
            imageView.image = directory.coverImage;
        }];
    }
    
    //名称
    mainLabel.text = directory.title;
    
    //数量
    subLabel.text = [NSString stringWithFormat:@"%ld",(long)directory.count];
        
    if (indexPath.row==self.dataSource.count-1) {
        [backView setCornerRadius:10 type:KKCornerRadiusType_LeftBottom | KKCornerRadiusType_RightBottom];
    } else {
        [backView setCornerRadius:0 type:KKCornerRadiusType_LeftBottom | KKCornerRadiusType_RightBottom];
    }
    
    return cell;
}

#pragma mark ==================================================
#pragma mark == UITableViewDelegate
#pragma mark ==================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KKAlbumDirectoryModal *data = (KKAlbumDirectoryModal*)[self.dataSource objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKAlbumImagePickerDirectoryList:selectedDirectoryModal:)]) {
        [self.delegate KKAlbumImagePickerDirectoryList:self selectedDirectoryModal:data];
    }
    [self beginHide];
}

@end
