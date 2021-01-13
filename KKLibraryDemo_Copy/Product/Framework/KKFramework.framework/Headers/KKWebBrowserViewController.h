//
//  KKWebBrowserViewController.h
//  YouJia
//
//  Created by liubo on 2018/6/26.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "KKViewController.h"
#import "KKCategory.h"
#import "KKTool.h"
#import "KKThemeManager.h"
#import "KKLocalizationManager.h"
#import "KKLibraryDefine.h"

UIKIT_EXTERN NSNotificationName const NotificationName_KKWebBrowserViewControllerClose;

@interface KKWebBrowserViewController : KKViewController

@property (nonatomic,copy)NSURL *myURL;

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (instancetype)initWithURL:(NSURL*)aURL;

- (instancetype)initWithURL:(NSURL*)aURL
         navigationBarTitle:(NSString*)aTitle;

- (instancetype)initWithURL:(NSURL*)aURL
         navigationBarTitle:(NSString*)aTitle
     needShowNavRightButton:(BOOL)aNeedShowNavRightButton;

@end
