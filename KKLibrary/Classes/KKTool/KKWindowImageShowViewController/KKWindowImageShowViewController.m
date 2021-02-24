//
//  KKWindowImageShowViewController.m
//  BM
//
//  Created by 刘波 on 2020/3/3.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKWindowImageShowViewController.h"
#import "KKNavigationController.h"
#import "KKCategory.h"
#import "KKLibraryLocalizationDefineKeys.h"
#import "KKLocalizationManager.h"
#import "KKAuthorizedAlbum.h"
#import "KKToastView.h"

@interface KKWindowImageShowViewController ()<KKWindowImageShowViewDelegate,KKWindowActionViewDelegate>

@property (nonatomic , strong) UIImageView *imageView;

@property (nonatomic , strong) NSArray *itemsArray;
@property (nonatomic , assign) NSInteger selectIndex;
@property (nonatomic , weak) UINavigationController *NavController;

@end

@implementation KKWindowImageShowViewController

+ (KKWindowImageShowViewController*_Nullable)showFromNavigationController:(UINavigationController*_Nullable)aNavController delegate:(id<KKWindowImageShowViewControllerDelegate> _Nullable)aDelegate items:(NSArray<KKWindowImageItem*>*_Nullable)aItemsArray selectedIndex:(NSInteger)aSelectedIndex{
    if ([aItemsArray count]<=0 ||
        aNavController == nil) {
        return nil;
    }
    
    KKWindowImageShowViewController *viewController = [[KKWindowImageShowViewController alloc] initWithNavigationController:aNavController items:aItemsArray selectedIndex:aSelectedIndex delegate:aDelegate];
    KKNavigationController *nav = [[KKNavigationController alloc] initWithRootViewController:viewController];
    [aNavController presentViewController:nav animated:NO completion:^{

    }];
    return viewController;
}

- (instancetype)initWithNavigationController:(UINavigationController*)aNavController items:(NSArray<KKWindowImageItem*>*_Nullable)aItemsArray selectedIndex:(NSInteger)aSelectedIndex{
    self = [super init];
    if (self) {
        self.NavController = aNavController;
        self.itemsArray = aItemsArray;
        self.selectIndex = aSelectedIndex;
    }
    return self;
}


- (instancetype)initWithNavigationController:(UINavigationController*)aNavController items:(NSArray<KKWindowImageItem*>*_Nullable)aItemsArray selectedIndex:(NSInteger)aSelectedIndex delegate:(id<KKWindowImageShowViewControllerDelegate> _Nullable)aDelegate{
    self = [super init];
    if (self) {
        self.NavController = aNavController;
        self.itemsArray = aItemsArray;
        self.selectIndex = aSelectedIndex;
        self.delegate = aDelegate;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];

    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight)];
    [self.view addSubview:self.imageView];
    self.imageView.image = [self.NavController.view snapshot];
}

- (void)show{
    if (self.itemsArray) {
        KKWindowImageShowView *windowImageView = [[KKWindowImageShowView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight) items:self.itemsArray selectedIndex:self.selectIndex];
        windowImageView.tag = 2020030301;
        windowImageView.delegate = self;
        windowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:windowImageView];

        [windowImageView show];

        self.itemsArray = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self show];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

#pragma mark ==================================================
#pragma mark == KKWindowImageShowViewDelegate
#pragma mark ==================================================
- (void)KKWindowImageShowView:(KKWindowImageShowView*_Nonnull)aView
          longPressedItemView:(KKWindowImageShowItemView*_Nonnull)aItemView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageShowViewController_ActionItemsForLongPressed)]) {
        NSArray *array = [self.delegate KKWindowImageShowViewController_ActionItemsForLongPressed];
        if ([NSArray isArrayNotEmpty:array]) {

            if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageShowViewController_CancelItemsForLongPressed)]) {
                KKWindowActionViewItem *itemCancel = [self.delegate KKWindowImageShowViewController_CancelItemsForLongPressed];
                if (itemCancel==nil) {
                    itemCancel = [[KKWindowActionViewItem alloc] initWithImage:nil title:KKLibLocalizable_Common_Cancel keyId:@"-2020030301"];
                }

                KKWindowActionView *aView = [KKWindowActionView showWithItems:array cancelItem:itemCancel delegate:self];
                aView.tagInfo = aItemView.myImageView.image;
            } else {

                KKWindowActionViewItem *itemCancel = [[KKWindowActionViewItem alloc] initWithImage:nil title:KKLibLocalizable_Common_Cancel keyId:@"-2020030301"];

                KKWindowActionView *aView = [KKWindowActionView showWithItems:array cancelItem:itemCancel delegate:self];
                aView.tagInfo = aItemView.myImageView.image;
            }
        }
    } else {
        [self showActionWithItemView:aItemView];
    }

}

- (void)showActionWithItemView:(KKWindowImageShowItemView*)aItemView{
    if (aItemView.currentIsGif==NO) {
        NSMutableArray *itemArray = [NSMutableArray array];

        KKWindowActionViewItem *item1 = [[KKWindowActionViewItem alloc] initWithImage:nil title:KKLibLocalizable_Common_SaveToAlbum keyId:@"-2020030302"];
        [itemArray addObject:item1];

        KKWindowActionViewItem *item3 = [[KKWindowActionViewItem alloc] initWithImage:nil title:KKLibLocalizable_Common_Cancel keyId:@"-2020030301"];

        KKWindowActionView *aView = [KKWindowActionView showWithItems:itemArray cancelItem:item3 delegate:self];
        aView.tagInfo = aItemView;
    }
}

#pragma mark ****************************************
#pragma mark KKWindowActionViewDelegate
#pragma mark ****************************************
- (void)KKWindowActionView:(KKWindowActionView*)aView
              clickedIndex:(NSInteger)buttonIndex
                      item:(KKWindowActionViewItem*)aItem{

    KKWindowImageShowItemView *itemView = (KKWindowImageShowItemView*)aView.tagInfo;
    if (itemView == nil ||
        ![itemView isKindOfClass:[KKWindowImageShowItemView class]]) {
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(KKWindowImageShowViewController:clickedOperation:froView:)]) {
        [self.delegate KKWindowImageShowViewController:self clickedOperation:aItem froView:itemView];
    } else {
        if ([aItem.keyId isEqualToString:@"-2020030302"]) {
            [self saveNowImage:itemView.myImageView.image];
        }
        else {

        }
    }
}

#pragma mark ==================================================
#pragma mark == 保存图片
#pragma mark ==================================================
- (void) saveNowImage:(UIImage*)aImage{
    BOOL authorized = [KKAuthorizedAlbum.defaultManager isAlbumAuthorized_ShowAlert:YES andAPPName:nil];
    if (authorized) {
        UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil){
        [KKToastView showInView:[UIWindow currentKeyWindow] text:KKLibLocalizable_Common_Success image:nil  alignment:KKToastViewAlignment_Center];
    }
    else{
        [KKToastView showInView:[UIWindow currentKeyWindow] text:KKLibLocalizable_Common_Failed image:nil  alignment:KKToastViewAlignment_Center];
    }
}



@end
