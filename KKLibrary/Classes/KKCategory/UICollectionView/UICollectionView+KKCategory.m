//
//  UICollectionView+KKCategory.m
//  YouJia
//
//  Created by 李忠辉 on 2018/7/26.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "UICollectionView+KKCategory.h"

@implementation UICollectionView (KKCategory)

+ (UICollectionView *)createNewViewWithFrame:(CGRect)frame
                                  Flowlayout:(UICollectionViewLayout *)vLayout
                                    delegate:(_Nonnull id<UICollectionViewDelegate>)delegate
                                  datasource:(_Nonnull id<UICollectionViewDataSource>)datasource{
    if (vLayout == nil) {
        vLayout = [[UICollectionViewFlowLayout alloc]init];
    }
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:vLayout];
//    [collectionView setCollectionViewLayout:vLayout];
    collectionView.delegate = delegate;
    collectionView.dataSource = datasource;
    return collectionView;
}

+ (UICollectionView *)createNewViewWithFlowlayout:(UICollectionViewLayout *)vLayout
                                         delegate:(_Nonnull id<UICollectionViewDelegate>)delegate
                                       datasource:(_Nonnull id<UICollectionViewDataSource>)datasource{
    if (vLayout == nil) {
        vLayout = [[UICollectionViewFlowLayout alloc]init];
    }
    
    UICollectionView *collectionView = [[UICollectionView alloc] init];
    [collectionView setCollectionViewLayout:vLayout];
    collectionView.delegate = delegate;
    collectionView.dataSource = datasource;
    return collectionView;
}

@end
