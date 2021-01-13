//
//  KKWindowMenuItem.h
//  BM
//
//  Created by liubo on 2019/11/22.
//  Copyright © 2019 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KKWindowMenuItem : NSObject

@property (nonatomic,strong)UIImage *image;//暂未实现
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)UIColor *titleColor;//暂未实现
@property (nonatomic,copy)NSString *keyId;

- (instancetype)initWithImage:(UIImage*)aImage
                        title:(NSString*)aTitle
                        keyId:(NSString*)aKeyId;

- (instancetype)initWithImage:(UIImage*)aImage
                        title:(NSString*)aTitle
                   titleColor:(UIColor*)aTitleColor
                        keyId:(NSString*)aKeyId;

@end
