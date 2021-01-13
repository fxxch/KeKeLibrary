//
//  NSObject+KKModalConvert.h
//  IOSStudy
//
//  Created by liubo on 2019/12/1.
//  Copyright © 2019 KKLibrary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KKModalConvert)

#pragma mark ==================================================
#pragma mark == NSObject ==> NSDictionary
#pragma mark ==================================================
/// 将 NSObject 转换成 NSDictionary
/// 目前仅支持NSObject里面的属性为：
/// NSArray(NSMutableArray)、NSDictionary(NSMutableDictionary)、
/// NSString、NSNumber、以及基本数据类型（BOOL、NSInteger、float等）
/// @param obj 待转换的对象
+ (NSDictionary*)objectToDictionary:(id)obj;

#pragma mark ==================================================
#pragma mark == NSDictionary ==> NSObject
#pragma mark ==================================================
/// 将 NSDictionary 转换成 NSObject
/// 目前仅支持NSObject里面的属性为：
/// NSArray(NSMutableArray)、NSDictionary(NSMutableDictionary)、
/// NSString、NSNumber、以及基本数据类型（BOOL、NSInteger、float等）
/// @param dic 待转换的对象的数据来源
+ (instancetype)initFromDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
