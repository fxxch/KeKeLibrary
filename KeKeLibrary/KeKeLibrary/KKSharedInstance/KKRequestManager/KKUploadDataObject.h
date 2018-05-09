//
//  KKUploadDataObject.h
//  TEST
//
//  Created by liubo on 13-3-28.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    KKUploadDataTypeImagePNG,
    KKUploadDataTypeImageJPG,
    KKUploadDataTypeOther
} KKUploadDataType;


@interface KKUploadDataObject : NSObject

@property(nonatomic,assign)KKUploadDataType type;
@property(nonatomic,strong)NSData *data;
@property(nonatomic,copy)NSString *fileName;
@property(nonatomic,copy)NSString *key;

@end
