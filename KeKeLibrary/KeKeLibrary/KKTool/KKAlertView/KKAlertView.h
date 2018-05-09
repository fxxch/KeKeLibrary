    //
//  KKAlertView.h
//  CEDongLi
//
//  Created by liubo on 15/11/1.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKAlertViewDelegate;

@interface KKAlertView : UIWindow

@property (nonatomic,strong)NSDictionary *information;

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
/**
 初始化（其它标题传字符串队列）
 
 @param aTitle 主标题
 @param aSubTitle 副标题
 @param aMessage 文字描述段落
 @param aDelegate 代理回调
 @param aButtonTitles 其他按钮的标题
 @return 返回一个实例
 */
- (instancetype)initWithTitle:(NSString *)aTitle
                     subTitle:(NSString*)aSubTitle
                      message:(NSString *)aMessage
                     delegate:(id /**<KKAlertViewDelegate>*/)aDelegate
                 buttonTitles:(NSString *)aButtonTitles, ...;

/**
 初始化（其它标题传字符串数组）
 
 @param aTitle 主标题
 @param aSubTitle 副标题
 @param aMessage 文字描述段落
 @param aDelegate 代理回调
 @param aButtonTitlesArray 其他按钮的标题
 @return 返回一个实例
 
 */
- (instancetype)initWithTitle:(NSString *)aTitle
                     subTitle:(NSString*)aSubTitle
                      message:(NSString *)aMessage
                     delegate:(id /**<KKAlertViewDelegate>*/)aDelegate
            buttonTitlesArray:(NSArray *)aButtonTitlesArray;

- (void)show;

/**
 重载会重新布局titleLabel , subTitleLabel ,messageTextView,同时所有的button将会被移除，并重新添置新的。
 所以，如果要设置button的样式，请在reload之后设置button样式
 */
- (void)reload;

#pragma mark - 外部接口
- (UIButton*)buttonAtIndex:(NSInteger)aIndex;

- (UILabel*)titleLabel;

- (UILabel*)subTitleLabel;

- (UITextView*)messageTextView;


/**
 弹出一个提示框，用户点击确定之后，NavigationController 就pop回到上一个页面
 @param aMessage 需要展示的提示文字
 @param aNavigationController 当前的导航控制器NavigationController
 */
+ (void)showKKAlertViewWithMessage:(NSString*)aMessage
               whenFinishedPopback:(UINavigationController*)aNavigationController;

@end


#pragma mark - KKAlertViewDelegate
@protocol KKAlertViewDelegate <NSObject>
@optional

- (void)KKAlertView_backgroundClicked:(KKAlertView*)aAlertView;

- (void)KKAlertView:(KKAlertView*)aAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex;

@end
