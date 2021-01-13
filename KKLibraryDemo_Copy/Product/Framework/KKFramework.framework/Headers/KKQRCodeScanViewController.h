//
//  KKQRCodeScanViewController.h
//  BM
//
//  Created by sjyt on 2020/1/10.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKViewController.h"

NS_ASSUME_NONNULL_BEGIN


@protocol KKQRCodeScanViewControllerDelagete <NSObject>

- (void)KKQRCodeScanViewController_FinishedWithQRCodeValue:(NSString*_Nonnull)aQRCodeValue;

- (void)KKQRCodeScanViewController_NavletfButtonClicked;


@end

@interface KKQRCodeScanViewController : KKViewController

@property (nonatomic , weak) id<KKQRCodeScanViewControllerDelagete> delegate;

- (void)startScan;

- (void)willPush;

@end

NS_ASSUME_NONNULL_END
