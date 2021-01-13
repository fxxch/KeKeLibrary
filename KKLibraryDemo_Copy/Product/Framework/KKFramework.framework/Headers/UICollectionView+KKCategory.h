//
//  UICollectionView+KKCategory.h
//  YouJia
//
//  Created by 李忠辉 on 2018/7/26.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (KKCategory)

+ (UICollectionView *_Nullable)createNewViewWithFrame:(CGRect)frame
                                           Flowlayout:(UICollectionViewLayout *_Nullable)vLayout
                                             delegate:(_Nonnull id<UICollectionViewDelegate>)delegate
                                           datasource:(_Nonnull id<UICollectionViewDataSource>)datasource;

//+ (UICollectionView *)createNewViewWithFlowlayout:(UICollectionViewLayout *)vLayout
//                                         delegate:(_Nonnull id<UICollectionViewDelegate>)delegate
//                                       datasource:(_Nonnull id<UICollectionViewDataSource>)datasource;
@end
