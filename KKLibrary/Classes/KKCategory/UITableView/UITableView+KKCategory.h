//
//  UITableView+KKCategory.h
//  KKLibray
//
//  Created by liubo on 2018/5/5.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TableViewCellPositionType){
    TableViewCellPositionType_Single=0,//第0行(共1行)
    TableViewCellPositionType_Min=1,//第0行(共非1行)
    TableViewCellPositionType_Middle=2,//中间行(共非1行)
    TableViewCellPositionType_Max=3,//最后行(共非1行)
};

@interface UITableView (KKCategory)

/**
 设置背景图片
 
 @param image image
 */
- (void)kk_setBackgroundImage:(nullable UIImage *)image;

/**
 设置背景颜色
 
 @param color color
 */
- (void)kk_setBackgroundColor:(nullable UIColor *)color;

/**
 设置行分割线
 
 @param image image
 */
- (void)kk_setSeparatorImage:(nullable UIImage *)image;

/**
 当前行所处的位置
 
 @param indexPath indexPath
 @return TableViewCellPositionType
 */
- (TableViewCellPositionType)kk_tableViewCellPositionTypeForIndexPath:(nonnull NSIndexPath*)indexPath;

/**
 快速创建TableView
 
 @param frame frame
 @param style style
 @param delegate delegate
 @param datasource datasource
 @return UITableView
 */
+ (instancetype _Nonnull )kk_initWithFrame:(CGRect)frame
                           style:(UITableViewStyle)style
                                  delegate:(_Nonnull id <UITableViewDelegate>)delegate
                                datasource:(_Nonnull id<UITableViewDataSource>)datasource;

@end
