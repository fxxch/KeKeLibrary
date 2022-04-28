//
//  UITableView+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UITableView+KKCategory.h"
#import "UIDevice+KKCategory.h"

@implementation UITableView (KKCategory)

/**
 设置背景图片
 
 @param image image
 */
- (void)kk_setBackgroundImage:(nullable UIImage *)image {
    static NSUInteger BACKGROUND_IMAGE_VIEW_TAG = 91798;
    UIImageView *imageView = (UIImageView *)[self viewWithTag:BACKGROUND_IMAGE_VIEW_TAG];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setTag:BACKGROUND_IMAGE_VIEW_TAG];
        [self setBackgroundView:imageView];
    }
    [imageView setImage:image];
}


/**
 设置背景颜色
 
 @param color color
 */
- (void)kk_setBackgroundColor:(nullable UIColor *)color {
    static NSUInteger BACKGROUND_VIEW_TAG = 91799;
    UIView *backgroundView = [self viewWithTag:BACKGROUND_VIEW_TAG];
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [backgroundView setTag:BACKGROUND_VIEW_TAG];
        [self setBackgroundView:backgroundView];
    }
    [backgroundView setBackgroundColor:color];
}


/**
 设置行分割线
 
 @param image image
 */
- (void)kk_setSeparatorImage:(nullable UIImage *)image {
    UIColor *separatorColor = [UIColor colorWithPatternImage:image];
    [self setSeparatorColor:separatorColor];
}


/**
 当前行所处的位置
 
 @param indexPath indexPath
 @return KKTableViewCellPositionType
 */
- (KKTableViewCellPositionType)kk_tableViewCellPositionTypeForIndexPath:(nonnull NSIndexPath*)indexPath{
    
    KKTableViewCellPositionType position;
    if (indexPath.row==0) {
        //0行 总共0行
        if (indexPath.row==[self numberOfRowsInSection:indexPath.section]-1) {
            position = KKTableViewCellPositionType_Single;
        }
        else{
            position = KKTableViewCellPositionType_Min;
        }
    }
    else{
        //中间行
        if (indexPath.row!=[self numberOfRowsInSection:indexPath.section]-1) {
            position = KKTableViewCellPositionType_Middle;
        }
        //最后行
        else{
            position = KKTableViewCellPositionType_Max;
        }
    }
    return position;
}


/**
 快速创建TableView
 
 @param frame frame
 @param style style
 @param delegate delegate
 @param datasource datasource
 @return UITableView
 */
+ (instancetype)kk_initWithFrame:(CGRect)frame
                           style:(UITableViewStyle)style
                        delegate:(id<UITableViewDelegate>)delegate
                      datasource:(id<UITableViewDataSource>)datasource{
    
    UITableView *table = [[UITableView alloc]initWithFrame:frame style:style];
    table.backgroundColor = [UIColor clearColor];
    table.backgroundView.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.sectionIndexBackgroundColor = [UIColor clearColor];
    table.sectionIndexColor = [UIColor blackColor];
    table.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    table.backgroundView = nil;
    table.delegate = delegate;
    table.dataSource = datasource;
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    table.showsVerticalScrollIndicator = NO;
    table.clipsToBounds = YES;
    if ([UIDevice kk_isSystemVersionBigerThan:@"11.0"]) {
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    
    if (@available(iOS 15.0, *)) {
        table.sectionHeaderTopPadding = 0;
    }
    
    return table;
}

@end
