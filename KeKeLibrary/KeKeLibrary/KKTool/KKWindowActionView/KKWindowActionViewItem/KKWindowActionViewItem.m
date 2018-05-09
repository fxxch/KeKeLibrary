//
//  KKWindowActionViewItem.m
//  KKLibray
//
//  Created by liubo on 2018/4/24.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import "KKWindowActionViewItem.h"

@implementation KKWindowActionViewItem

- (instancetype)initWithImage:(UIImage*)aImage
                        title:(NSString*)aTitle
                        keyId:(NSString*)aKeyId
{
    return [self initWithImage:aImage
                         title:aTitle
                    titleColor:nil
                         keyId:aKeyId];
}

- (instancetype)initWithImage:(UIImage*)aImage
                        title:(NSString*)aTitle
                   titleColor:(UIColor*)aTitleColor
                        keyId:(NSString*)aKeyId{
    
    self = [super init];
    if (self) {
        self.image = aImage;
        self.title = aTitle;
        self.titleColor = aTitleColor;
        self.keyId = aKeyId;
    }
    
    return self;
}

@end
