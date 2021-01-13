//
//  KKWindowActionViewItem.h
//  KKLibray
//
//  Created by liubo on 2018/4/24.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KKWindowActionViewItem : NSObject

@property (nonatomic,strong)UIImage *image;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)UIColor *titleColor;
@property (nonatomic,copy)NSString *keyId;

- (instancetype)initWithImage:(UIImage*)aImage
                        title:(NSString*)aTitle
                        keyId:(NSString*)aKeyId;

- (instancetype)initWithImage:(UIImage*)aImage
                        title:(NSString*)aTitle
                   titleColor:(UIColor*)aTitleColor
                        keyId:(NSString*)aKeyId;

@end
