//
//  WindowModalViewItem.h
//  GouUseCore
//
//  Created by beartech on 2018/1/19.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KKWindowModalViewItem : NSObject

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
