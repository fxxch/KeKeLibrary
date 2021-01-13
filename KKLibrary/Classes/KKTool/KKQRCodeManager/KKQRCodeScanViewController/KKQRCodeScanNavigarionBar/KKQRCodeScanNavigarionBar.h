//
//  KKQRCodeScanNavigarionBar.h
//  BM
//
//  Created by sjyt on 2020/1/10.
//  Copyright © 2020 bm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKQRCodeScanNavigarionBar : UIView

@property (nonatomic , strong) UIImageView *backgroundView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) KKButton *leftButton;
@property (nonatomic , strong) KKButton *rightButton;

@end

NS_ASSUME_NONNULL_END
