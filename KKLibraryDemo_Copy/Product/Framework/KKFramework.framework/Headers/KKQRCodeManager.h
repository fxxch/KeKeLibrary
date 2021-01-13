//
//  KKQRCodeManager.h
//  BM
//
//  Created by sjyt on 2020/1/10.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KKQRCodeScanDelegate <NSObject>
@required
- (void)KKQRCodeScan_FinishedWithQRCodeValue:(NSString*_Nonnull)aQRCodeValue;

@optional
// 如果二维码扫描界面是present出来的，在dismiss的时候会响应此代理方法
- (void)KKQRCodeScan_ScannerDismissFinished;

@end


@interface KKQRCodeManager : NSObject

+ (KKQRCodeManager*_Nonnull)defaultManager;


/// 展示扫描二维码界面
/// @param aDelegate 回调代理
/// @param aNavigationController 从哪个导航控制器弹出（或Push）
/// @param aForPresent YES: 以present方式弹出 NO：Push方式
- (void)showScannerWithDelegate:(id<KKQRCodeScanDelegate> _Nonnull)aDelegate
       fromNavigationController:(UINavigationController* _Nonnull)aNavigationController
                     forPresent:(BOOL)aForPresent;

/* 扫描到数据之后会停止扫描，开始转圈圈，此时代理需要处理扫描到的结果
   如果处理失败，可以再次调用startScan方法继续扫描*/
- (void)startScan;

/* 扫描到数据之后会停止扫描，开始转圈圈，此时代理需要处理扫描到的结果
   如果处理成功，可以调用closeScanner方法关闭扫描界面*/
- (void)closeScanner;

/* 扫描到数据之后会停止扫描，开始转圈圈，此时代理需要处理扫描到的结果
 如果处理成功，需要自己做跳转业务，可以调用invalidate方法销毁*/
- (void)invalidate;

#pragma mark ==================================================
#pragma mark == 生成二维码
#pragma mark ==================================================
+ (UIImage*_Nonnull)makeQRCodeWithString:(NSString*_Nonnull)aMessageString centerImage:(UIImage*_Nullable)aCenterImage;

#pragma mark ==================================================
#pragma mark == 主题
#pragma mark ==================================================
+ (UIImage*_Nullable)themeImageForName:(NSString*_Nullable)aImageName;




@end
