//
//  KKWindowMenuItem.m
//  BM
//
//  Created by liubo on 2019/11/22.
//  Copyright © 2019 bm. All rights reserved.
//

#import "KKWindowMenuItem.h"

@implementation KKWindowMenuItem

- (instancetype)initWithImage:(UIImage*)aImage
                        title:(NSString*)aTitle
                        keyId:(NSString*)aKeyId{
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
