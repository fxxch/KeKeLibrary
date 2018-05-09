//
//  UITableView+KKCategory.m
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "UITableView+KKCategory.h"

@implementation UITableView (KKCategory)

/**
 设置背景图片
 
 @param image image
 */
- (void)setBackgroundImage:(nullable UIImage *)image {
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
- (void)setBackgroundColor:(nullable UIColor *)color {
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
- (void)setSeparatorImage:(nullable UIImage *)image {
    UIColor *separatorColor = [UIColor colorWithPatternImage:image];
    [self setSeparatorColor:separatorColor];
}


/**
 当前行所处的位置
 
 @param indexPath indexPath
 @return TableViewCellPositionType
 */
- (TableViewCellPositionType)tableViewCellPositionTypeForIndexPath:(nonnull NSIndexPath*)indexPath{
    
    TableViewCellPositionType position;
    if (indexPath.row==0) {
        //0行 总共0行
        if (indexPath.row==[self numberOfRowsInSection:indexPath.section]-1) {
            position = TableViewCellPositionType_Single;
        }
        else{
            position = TableViewCellPositionType_Min;
        }
    }
    else{
        //中间行
        if (indexPath.row!=[self numberOfRowsInSection:indexPath.section]-1) {
            position = TableViewCellPositionType_Middle;
        }
        //最后行
        else{
            position = TableViewCellPositionType_Max;
        }
    }
    return position;
}

@end