//
//  UIBezierPath+KKCategory.h
//  BM
//
//  Created by liubo on 2019/11/19.
//  Copyright © 2019 bm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (KKCategory)

+ (UIBezierPath *)chatBoxRightShape:(CGRect)originalFrame;

+ (UIBezierPath *)chatBoxLeftShape:(CGRect)originalFrame;

@end

NS_ASSUME_NONNULL_END
