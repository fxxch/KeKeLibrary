//
//  NSObject+KKModalConvert.m
//  IOSStudy
//
//  Created by liubo on 2019/12/1.
//  Copyright © 2019 KKLibrary. All rights reserved.
//

#import "NSObject+KKModalConvert.h"
#import <objc/runtime.h>
#import "KKLog.h"

NSAttributedStringKey const KKClassType_NSDictionary  =   @"NSDictionary";
NSAttributedStringKey const KKClassType_NSArray       =   @"NSArray";
NSAttributedStringKey const KKClassType_NSString      =   @"NSString";
NSAttributedStringKey const KKClassType_CustomObject  =   @"CustomObject";
NSAttributedStringKey const KKClassType_Basic         =   @"基础数据类型";
NSAttributedStringKey const KKClassType_Other         =   @"其它";

@implementation NSObject (KKModalConvert)


#pragma mark ==================================================
#pragma mark == NSObject ==> NSDictionary
#pragma mark ==================================================
+ (NSDictionary*)objectToDictionary:(id)obj{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for (NSInteger i=0; i<propsCount; i++) {
        objc_property_t prop = props[i];
 
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [obj valueForKey:propName];//kvc读值
        if(value != nil)
        {
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
            if (value) {
                [dic setObject:value forKey:propName];
            }
        }
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]])
    {
        return obj;
    }
    else if ([obj isKindOfClass:[NSNull class]]){
        return nil;
    }
    else if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for (NSInteger i=0; i<objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    else if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    else{
        if ([obj isKindOfClass:[UIResponder class]]) {
            return nil;
        }
        else{
            NSDictionary *dic = [self objectToDictionary:obj];
            if (dic && dic.count>0) {
                return dic;
            }
            else{
                return nil;
            }
        }
    }
}

#pragma mark ==================================================
#pragma mark == NSDictionary ==> NSObject
#pragma mark ==================================================
+ (instancetype)initFromDictionary:(NSDictionary *)dic{
    id myObj = [[self alloc] init];
    
    unsigned int outCount;
    
    //获取类中的所有成员属性
    objc_property_t *arrPropertys = class_copyPropertyList([self class], &outCount);
    
    for (NSInteger i = 0; i < outCount; i ++) {
        objc_property_t property = arrPropertys[i];
        
        //获取属性名字符串
        //model中的属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
                
        
        id propertyValue = dic[propertyName];
//        if (propertyValue == nil) {
//            //KKLogDebugFormat(@"属性名:%@ 无值", KKValidString(propertyName));
//            continue;
//        }

        //获取属性是什么类型的
        NSDictionary *dicPropertyType = [self propertyTypeFromProperty:property];
        NSString *propertyClassType = [dicPropertyType objectForKey:@"classType"];
        NSString *propertyType = [dicPropertyType objectForKey:@"type"];
        //KKLogDebugFormat(@"属性名:%@ 类型:%@", KKValidString(propertyName),KKValidString(propertyClassType));
        if ([propertyType isEqualToString:KKClassType_NSDictionary]) {
            //NSDictionary类型
            NSDictionary *propertyValueDic = [dic objectForKey:propertyName];
            if (propertyValue != nil) {
                [myObj setValue:propertyValueDic forKey:propertyName];
            } else {
                [myObj setValue:[NSDictionary dictionary] forKey:propertyName];
            }
        }
        else if ([propertyType isEqualToString:KKClassType_NSArray]) {
            //NSArray类型
            NSArray *propertyValueArray = [dic objectForKey:propertyName];
            if (propertyValue != nil) {
                [myObj setValue:propertyValueArray forKey:propertyName];
            } else {
                [myObj setValue:[NSArray array] forKey:propertyName];
            }
        }
        else if ([propertyType isEqualToString:KKClassType_NSString]) {
            //NSArray类型
            NSString *propertyValueString = [dic objectForKey:propertyName];
            if (propertyValue != nil) {
                [myObj setValue:propertyValueString forKey:propertyName];
            } else {
                [myObj setValue:@"" forKey:propertyName];
            }
        }
        else if ([propertyType isEqualToString:KKClassType_CustomObject]) {
            //自定义类型
            NSDictionary *propertyValueDic = [dic objectForKey:propertyName];
            propertyValue = [NSClassFromString(propertyClassType) initFromDictionary:propertyValueDic];
            if (propertyValue != nil) {
                [myObj setValue:propertyValue forKey:propertyName];
            }
        }
        else if ([propertyType isEqualToString:KKClassType_Basic]) {
            if (propertyValue != nil) {
                [myObj setValue:propertyValue forKey:propertyName];
            } else {
                [myObj setValue:0 forKey:propertyName];
            }
        }
        else {
            //其他类型 KKClassType_Other
            KKLogErrorFormat(@"%@,其他类型，暂无法解析",KKValidString(propertyName));
        }
    }
    
    free(arrPropertys);
    
    return myObj;
}

//获取属性的类型
- (NSDictionary *)propertyTypeFromProperty:(objc_property_t)property{
    //获取属性的类型, 类似 T@"NSString",C,N,V_name    T@"UserModel",&,N,V_user
    NSString *propertyAttrs = @(property_getAttributes(property));
    
    NSMutableDictionary *dicPropertyType = [NSMutableDictionary dictionary];
    
    //截取类型
    NSRange commaRange = [propertyAttrs rangeOfString:@","];
    NSString *propertyType = [propertyAttrs substringWithRange:NSMakeRange(1, commaRange.location - 1)];
    //KKLogDebugFormat(@"=====属性类型:%@, %@", KKValidString(propertyAttrs), KKValidString(propertyType));
    
    if ([propertyType hasPrefix:@"@"] && propertyType.length > 2) {

        //对象类型
        NSString *propertyClassType = [propertyType substringWithRange:NSMakeRange(2, propertyType.length - 3)];
        if ([propertyClassType isEqualToString:@"NSString"]) {
            [dicPropertyType setObject:propertyClassType forKey:@"classType"];
            [dicPropertyType setObject:KKClassType_NSString forKey:@"type"];
        }
        else  if ([propertyClassType isEqualToString:@"NSArray"] ||
                  [propertyClassType isEqualToString:@"NSMutableArray"] ) {
            [dicPropertyType setObject:propertyClassType forKey:@"classType"];
            [dicPropertyType setObject:KKClassType_NSArray forKey:@"type"];
        }
        else  if ([propertyClassType isEqualToString:@"NSDictionary"] ||
                  [propertyClassType isEqualToString:@"NSMutableDictionary"] ) {
            [dicPropertyType setObject:propertyClassType forKey:@"classType"];
            [dicPropertyType setObject:KKClassType_NSDictionary forKey:@"type"];
        }
        else{
            [dicPropertyType setObject:propertyClassType forKey:@"classType"];
            [dicPropertyType setObject:KKClassType_CustomObject forKey:@"type"];
        }
    }
    else if ([propertyType isEqualToString:@"i"] ||
             [propertyType isEqualToString:@"I"] ) {
        //int类型
        [dicPropertyType setObject:@"int" forKey:@"classType"];
        [dicPropertyType setObject:KKClassType_Basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"s"] ||
             [propertyType isEqualToString:@"S"]) {
        //short类型
        [dicPropertyType setObject:@"short" forKey:@"classType"];
        [dicPropertyType setObject:KKClassType_Basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"l"] |
             [propertyType isEqualToString:@"L"]) {
        //long类型
        [dicPropertyType setObject:@"long" forKey:@"classType"];
        [dicPropertyType setObject:KKClassType_Basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"q"] |
             [propertyType isEqualToString:@"Q"]) {
        //long long类型
        [dicPropertyType setObject:@"long long" forKey:@"classType"];
        [dicPropertyType setObject:KKClassType_Basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"f"]) {
        //float类型
        [dicPropertyType setObject:@"float" forKey:@"classType"];
        [dicPropertyType setObject:KKClassType_Basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"d"]) {
        //double类型
        [dicPropertyType setObject:@"double" forKey:@"classType"];
        [dicPropertyType setObject:KKClassType_Basic forKey:@"type"];
    }
    else if ([propertyType isEqualToString:@"B"]) {
        //BOOL类型
        [dicPropertyType setObject:@"BOOL" forKey:@"classType"];
        [dicPropertyType setObject:KKClassType_Basic forKey:@"type"];
    }
    else {
        [dicPropertyType setObject:KKClassType_Other forKey:@"type"];
    }
    return dicPropertyType;
}

@end
