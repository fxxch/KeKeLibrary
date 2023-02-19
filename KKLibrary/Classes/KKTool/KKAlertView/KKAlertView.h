    //
//  KKAlertView.h
//  CEDongLi
//
//  Created by liubo on 15/11/1.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKButton;
@protocol KKAlertViewDelegate;
@class KKAlertView;

typedef void(^KKAlertViewButtonClickedBlock)(KKAlertView * _Nullable alertView,NSInteger clickedButtonIndex);

@interface KKAlertView : UIWindow

@property (nonatomic,strong)NSDictionary *_Nullable information;

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
- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)aTitle
                     subTitle:(NSString *_Nullable)aSubTitle
                      message:(NSString *_Nullable)aMessage
                     delegate:(id /**<KKAlertViewDelegate>*/ _Nullable)aDelegate
                 buttonTitles:(NSString *_Nonnull)aButtonTitles, ...;

/**
 初始化（其它标题传字符串数组）
 
 @param aTitle 主标题
 @param aSubTitle 副标题
 @param aMessage 文字描述段落
 @param aDelegate 代理回调
 @param aButtonTitlesArray 其他按钮的标题
 @return 返回一个实例
 
 */
- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)aTitle
                     subTitle:(NSString *_Nullable)aSubTitle
                      message:(NSString *_Nullable)aMessage
                     delegate:(id /**<KKAlertViewDelegate>*/ _Nullable)aDelegate
            buttonTitlesArray:(NSArray  *_Nonnull)aButtonTitlesArray;

/**
 初始化（其它标题传字符串队列）
 
 @param aTitle 主标题
 @param aSubTitle 副标题
 @param aMessage 文字描述段落
 @param aBlock 回调
 @param aButtonTitles 其他按钮的标题
 @return 返回一个实例
 */
- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)aTitle
                               subTitle:(NSString *_Nullable)aSubTitle
                                message:(NSString *_Nullable)aMessage
                          finishedBlock:(KKAlertViewButtonClickedBlock _Nullable)aBlock
                           buttonTitles:(NSString *_Nullable)aButtonTitles, ...;

/**
 初始化（其它标题传字符串数组）
 
 @param aTitle 主标题
 @param aSubTitle 副标题
 @param aMessage 文字描述段落
 @param aBlock 回调
 @param aButtonTitlesArray 其他按钮的标题
 @return 返回一个实例
 
 */
- (instancetype _Nullable)initWithTitle:(NSString *_Nullable)aTitle
                               subTitle:(NSString *_Nullable)aSubTitle
                                message:(NSString *_Nullable)aMessage
                          finishedBlock:(KKAlertViewButtonClickedBlock _Nullable)aBlock
                      buttonTitlesArray:(NSArray *_Nullable)aButtonTitlesArray;

- (void)show;

- (void)hide;

/**
 重载会重新布局titleLabel , subTitleLabel ,messageTextView,同时所有的button将会被移除，并重新添置新的。
 所以，如果要设置button的样式，请在reload之后设置button样式
 */
- (void)reload;

#pragma mark - 外部接口
- (KKButton*_Nonnull)buttonAtIndex:(NSInteger)aIndex;

- (UILabel*_Nonnull)titleLabel;

- (UILabel*_Nonnull)subTitleLabel;

- (UITextView*_Nonnull)messageTextView;

@end


#pragma mark - KKAlertViewDelegate
@protocol KKAlertViewDelegate <NSObject>
@optional

- (void)KKAlertView_backgroundClicked:(KKAlertView*_Nonnull)aAlertView;

- (void)KKAlertView:(KKAlertView*_Nonnull)aAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex;

@end
