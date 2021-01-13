//
//  UITableView+KKEmptyNoticeView.h
//  YouJia
//
//  Created by liubo on 2018/6/30.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKTool.h"

@protocol UITableViewEmptyNoticeViewDelegate;

@interface UITableView (KKEmptyNoticeView)

//图标
@property (nonatomic , strong) UIImage* emptyDataIconImage;
//图标和文字下面的按钮
@property (nonatomic , strong) KKButton* emptyDataButton;
//文字
@property (nonatomic , copy)   NSString* emptyDataText;
//对齐方式
@property (nonatomic , assign) KKEmptyNoticeViewAlignment emptyDataTextAlignment;
//偏移量
@property (nonatomic , assign) CGFloat emptyDataOffsetY;
//代理
@property (nonatomic , weak) id<UITableViewEmptyNoticeViewDelegate> emptyDataViewDelegate;


@end

#pragma mark ==================================================
#pragma mark == UITableViewEmptyNoticeViewDelegate
#pragma mark ==================================================
@protocol UITableViewEmptyNoticeViewDelegate <NSObject>
@optional

- (void)tableViewEmptyNoticeView_emptyDataIconImageClicked;

- (void)tableViewEmptyNoticeView_emptyDataTextClicked;

- (void)tableViewEmptyNoticeView_emptyDataButtonClicked:(KKButton*)aButton;

@end

