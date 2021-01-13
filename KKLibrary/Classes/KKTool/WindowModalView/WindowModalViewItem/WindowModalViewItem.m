//
//  WindowModalViewItem.m
//  GouUseCore
//
//  Created by beartech on 2018/1/19.
//  Copyright © 2018年 gouuse. All rights reserved.
//

#import "WindowModalViewItem.h"

@implementation WindowModalViewItem

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
