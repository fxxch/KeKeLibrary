//
//  KKWebBrowserPOPView.m
//  YouJia
//
//  Created by liubo on 2018/6/26.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKWebBrowserPOPView.h"
#import "KKWebBrowserPOPViewCell.h"
#import "NSDictionary+KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKLocalizationManager.h"
#import "KKCategory.h"

//整个view的高
#define KKWebPopView_ViewHeight   180
//view的背景颜色
#define KKWebPopView_BackColor [UIColor colorWithRed:0.86 green:0.87 blue:0.9 alpha:1]
//取消按钮的文字颜色
#define KKWebPopView_CancelBtnColor [UIColor colorWithRed:0.01 green:0.01 blue:0.02 alpha:1]
//取消按钮的字体大小
#define KKWebPopView_CancelBtnFont [UIFont systemFontOfSize:16]

@interface KKWebBrowserPOPView ()
<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
KKWebBrowserPOPViewCellDelegate>

@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) UICollectionView * popCollectionView;
@property (nonatomic,strong) UIButton *backgroundButton;
@property (nonatomic,strong) UIView *containView;

@end

@implementation KKWebBrowserPOPView


/**
 *  KKWebPopView初始化
 *
 *  @param buttonsArray 数据数组，元素类型为NSDictionary
 *         字典包含数据：imageName、title
 *
 *  @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSMutableArray *)buttonsArray{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = [[NSMutableArray alloc] init];
        [self.dataSource addObjectsFromArray:buttonsArray];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundButton = [[UIButton alloc] initWithFrame:self.bounds];
    [self.backgroundButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [self.backgroundButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backgroundButton];
    
    self.containView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - KKWebPopView_ViewHeight, self.bounds.size.width, KKWebPopView_ViewHeight)];
    self.containView.userInteractionEnabled = YES;
    self.containView.backgroundColor = KKWebPopView_BackColor;
    [self addSubview:self.containView];
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.popCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120) collectionViewLayout:flowLayout];
    self.popCollectionView.dataSource = self;
    self.popCollectionView.delegate = self;
    self.popCollectionView.showsVerticalScrollIndicator = NO;
    self.popCollectionView.showsHorizontalScrollIndicator = NO;
    [self.popCollectionView registerClass:[KKWebBrowserPOPViewCell class] forCellWithReuseIdentifier:@"KKWebBrowserPOPViewCell"];
    self.popCollectionView.backgroundColor = [UIColor clearColor];
    [self.containView addSubview:self.popCollectionView];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.containView.frame.size.height-50, self.containView.frame.size.width, 50)];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = KKWebPopView_CancelBtnFont;
    [button setTitle:KKLibLocalizable_Common_Cancel forState:UIControlStateNormal];
    [button setTitleColor:KKWebPopView_CancelBtnColor forState:UIControlStateNormal];
    [self.containView addSubview:button];
}

/**
 *  展示添加图层 回调返回点击数据
 *
 */
- (void)show{
    self.containView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, KKWebPopView_ViewHeight);
    
    [UIView animateWithDuration:0.2f animations:^{
        self.containView.frame = CGRectMake(0, self.bounds.size.height - KKWebPopView_ViewHeight, self.bounds.size.width, KKWebPopView_ViewHeight);
    }];
}

/**
 *  展示添加图层
 *
 *
 */
+ (KKWebBrowserPOPView*)showWithArray:(NSMutableArray *)aInformationArray
                             delegate:(id<KKWebBrowserPOPViewDelegate>)aDelegate{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    KKWebBrowserPOPView *view = [[KKWebBrowserPOPView alloc] initWithFrame:window.bounds buttonArray:aInformationArray];
    view.delegate = aDelegate;
    [window addSubview:view];
    
    [view show];
    
    return view;
}


- (void)dismiss{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animate{
    if (!animate) {
        [self removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.containView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, KKWebPopView_ViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


#pragma mark ==================================================
#pragma mark == UICollectionViewDataSource
#pragma mark ==================================================
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KKWebBrowserPOPViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KKWebBrowserPOPViewCell" forIndexPath:indexPath];
    NSString * imageName = [self.dataSource[indexPath.row] validStringForKey:KKWebPopView_ImageName];
    NSString * title = [self.dataSource[indexPath.row] validStringForKey:KKWebPopView_Title];
    
    cell.delegate = self;
    cell.index = indexPath.row;
    
    UIImage *image = [NSBundle imageInBundle:@"KKWebBrowser.bundle" imageName:imageName];
    [cell.imageView setImage:image forState:UIControlStateNormal];
    
    cell.titleLabel.text = title;
    
    return cell;
}

#pragma mark ==================================================
#pragma mark == UICollectionViewDelegateFlowLayout
#pragma mark ==================================================
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 80);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 10, 10);
}

#pragma mark ==================================================
#pragma mark == UICollectionViewDelegate
#pragma mark ==================================================
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self dismiss:YES];
}

#pragma mark ==================================================
#pragma mark == KKWebBrowserPOPViewCellDelegate
#pragma mark ==================================================
- (void)KKWebBrowserPOPViewCell_DidClickedButton:(NSInteger)index{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKWebBrowserPOPView:didSelectIndex:)]) {
        [self.delegate KKWebBrowserPOPView:self didSelectIndex:index];
    }
    
    [self dismiss:YES];
}


@end
