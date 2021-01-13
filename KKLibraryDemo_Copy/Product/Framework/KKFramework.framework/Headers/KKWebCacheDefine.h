//
//  KKWebCacheDefine.h
//  BM
//
//  Created by 刘波 on 2020/3/1.
//  Copyright © 2020 bm. All rights reserved.
//

#ifndef KKWebCacheDefine_h
#define KKWebCacheDefine_h

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

typedef NS_ENUM(NSInteger, KKActivityIndicatorViewStyle) {
    KKActivityIndicatorViewStyleWhiteLarge = UIActivityIndicatorViewStyleWhiteLarge,
    KKActivityIndicatorViewStyleWhite  = UIActivityIndicatorViewStyleWhite,
    KKActivityIndicatorViewStyleGray = UIActivityIndicatorViewStyleGray,
    KKActivityIndicatorViewStyleNone = NSNotFound,
};

#pragma clang diagnostic pop


typedef NS_OPTIONS(NSUInteger, KKControlState) {
    KKControlStateNormal      = UIControlStateNormal,
    KKControlStateHighlighted = UIControlStateHighlighted,
    KKControlStateDisabled    = UIControlStateDisabled,
    KKControlStateSelected    = UIControlStateSelected,
    KKControlStateApplication = UIControlStateApplication,
    KKControlStateReserved    = UIControlStateReserved,
    KKControlStateNone        = NSNotFound
};

typedef void(^KKImageLoadCompletedBlock)(NSData *imageData, NSError *error,BOOL isFromRequest);

#endif /* KKWebCacheDefine_h */
