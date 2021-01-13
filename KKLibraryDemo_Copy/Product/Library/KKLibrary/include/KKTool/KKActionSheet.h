//
//  KKActionSheet.h
//  CEDongLi
//
//  Created by liubo on 15/11/13.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKActionSheetDelegate;

@interface KKActionSheet : UIWindow

@property (nonatomic,strong)NSDictionary *information;



/**
 初始化（其它标题传字符串队列）

 @param aTitle 主标题
 @param aSubTitle 副标题
 @param aDelegate 代理回调
 @param aCancelButtonTitle 取消按钮的标题
 @param aOtherButtonTitles 其他按钮的标题
 @return 返回一个实例
 */
- (instancetype)initWithTitle:(NSString *)aTitle
                     subTitle:(NSString*)aSubTitle
                     delegate:(id /**<KKActionSheetDelegate>*/)aDelegate
            cancelButtonTitle:(NSString *)aCancelButtonTitle
            otherButtonTitles:(NSString *)aOtherButtonTitles, ... ;


/**
 初始化（其它标题传字符串数组）

 @param aTitle 主标题
 @param aSubTitle 副标题
 @param aDelegate 代理回调
 @param aCancelButtonTitle 取消按钮的标题
 @param aOtherButtonTitlesArray 其他按钮的标题数组
 @return 返回一个实例

 */
- (instancetype)initWithTitle:(NSString *)aTitle
                     subTitle:(NSString*)aSubTitle
                     delegate:(id /**<KKActionSheetDelegate>*/)aDelegate
            cancelButtonTitle:(NSString *)aCancelButtonTitle
       otherButtonTitlesArray:(NSArray *)aOtherButtonTitlesArray;

- (void)show;

- (void)hide;

/**
 重载会重新布局titleLabel , subTitleLabel ,messageTextView,同时所有的button将会被移除，并重新添置新的。
 所以，如果要设置button的样式，请在reload之后设置button样式
 */
- (void)reload;

#pragma mark - 外部接口
- (UIButton*)buttonAtIndex:(NSInteger)aIndex;

- (UILabel*)titleLabel;

- (UILabel*)subTitleLabel;

@end


#pragma mark - KKActionSheetDelegate
@protocol KKActionSheetDelegate <NSObject>
@optional

- (void)KKActionSheet_backgroundClicked:(KKActionSheet*)aActionSheet;

- (void)KKActionSheet:(KKActionSheet*)aActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
