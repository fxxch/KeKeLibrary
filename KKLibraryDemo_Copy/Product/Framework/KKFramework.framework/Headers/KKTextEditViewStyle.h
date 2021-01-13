//
//  KKTextEditViewStyle.h
//  BM
//
//  Created by sjyt on 2020/5/28.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TextEditType){
    TextEditType_TextFeild=0,//
    TextEditType_TextView=1,//
};

@interface KKTextEditViewStyle : NSObject

//编辑框的类型（TextEditType_TextFeild、TextEditType_TextView）
@property (nonatomic , assign) TextEditType type;

@property (nonatomic , copy) NSString *_Nullable placeHoleder;//提示文字
@property (nonatomic , copy) NSString *_Nullable title;//导航条标题
@property (nonatomic , copy) NSString *_Nullable subTitle;//提示文字
@property (nonatomic , copy) NSString *_Nullable inText;//初始化文字（默认填充在编辑框里面的文字）

@property (nonatomic , assign) NSInteger maxLenth;//最大输入长度限制（>0有效，否则就是不限制输入长度）
@property (nonatomic , assign) BOOL engCharacterHalfLenth;//计算文字长度的时候英文是否算半个字符
//是否允许换行（这个只针对TextEditType_TextView有效，TextEditType_TextFeild本身就不能换行）
@property (nonatomic , assign) BOOL isSingleLine;
@property (nonatomic , assign) BOOL isNumber;//是否只能允许数字整数输入（如果是，则会弹出数字键盘）
@property (nonatomic , assign) BOOL hideLimitedText;//是否展示“还剩xx个字”

@property (nonatomic , copy) NSString *_Nullable keyIdentifier;//标识符（代理返回的时候会返回这个字段，以便代理好做识别处理）
@property (nonatomic , strong) id tagInformation;

@end

NS_ASSUME_NONNULL_END
