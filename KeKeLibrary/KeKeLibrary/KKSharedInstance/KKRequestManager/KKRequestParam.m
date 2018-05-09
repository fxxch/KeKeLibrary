//
//  KKRequestParam.m
//  TEST
//
//  Created by liubo on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKRequestParam.h"
#import <objc/runtime.h>
#import "KKCategory.h"

@implementation KKRequestParam

- (id)init {
    if (self = [super init]) {
        self.method = HTTPMethod_POST;
        self.timeout = 60.0f;
    }
    return self;
}

#pragma ==================================================
#pragma == 添加参数
#pragma ==================================================
- (void)addRequestHeader:(NSString *)key withValue:(id)value{
    if (self.requestHeaderDic == nil) {
        self.requestHeaderDic = [[NSMutableDictionary alloc] init];
    }
    
    if (value == nil) {
        value = @"";
    }
    
    if (value != nil && key != nil) {
        [self.requestHeaderDic setObject:value forKey:key];
    }
}

- (void)addFile:(NSString *)filePath forKey:(NSString *)fileKey{
    if (self.postFilesPathDic == nil) {
        self.postFilesPathDic = [[NSMutableDictionary alloc] init];
    }

    if (filePath && (![filePath isEqualToString:@""])) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            if (fileKey && (![fileKey isEqualToString:@""])) {
                [self.postFilesPathDic setObject:filePath forKey:fileKey];
            }
            else{
#ifdef DEBUG
                NSLog(@"网络上传文件，Key有误");
#endif
                return;
            }
        }
        else{
#ifdef DEBUG
            NSLog(@"网络上传文件 文件不存在：%@",filePath);
#endif
            return;
        }
    }
}

- (void)addParam:(NSString *)key withValue:(id)value{
    if (self.postParamDic == nil) {
        self.postParamDic = [[NSMutableDictionary alloc] init];
    }
    
    if (value == nil) {
        return;
    }
    
    if (value != nil && key != nil) {
        [self.postParamDic setObject:value forKey:key];
    }
}

- (void)addParams:(NSDictionary *)aParamsDictionary{
    
    if ([NSDictionary isDictionaryEmpty:aParamsDictionary]) {
        return;
    }
    
    if (self.postParamDic == nil) {
        self.postParamDic = [[NSMutableDictionary alloc] init];
    }
    
    [self.postParamDic setValuesForKeysWithDictionary:aParamsDictionary];
}

//请求的body数据
- (void)addPostData:(NSData *)data forKey:(NSString *)aKey{
    if (self.postDataDic == nil) {
        self.postDataDic = [[NSMutableDictionary alloc] init];
    }
    
    if (data && aKey) {
        [self.postDataDic setObject:data forKey:aKey];
    }
}

//请求的body数据
- (void)addPostData:(NSData *)data{
    if (self.postData == nil) {
        self.postData = [[NSMutableData alloc] init];
    }
    
    if (data) {
        [self.postData appendData:data];
    }
}


#pragma ==================================================
#pragma == 将self的所有property拼接成Get方式请求的字符串
#pragma ==================================================
- (NSString *)paramStringOfGet{
    
    NSDictionary *returnDictionary = [self paramOfPost];
    
    NSString *paramString = @"?";
    if (returnDictionary != nil) {
        NSInteger length = [[returnDictionary allKeys] count];
        
        NSString    *key;
        id          value;
        NSString    *separate = @"&";
        
        for (int i=0; i<length; i++) {
            key = [[returnDictionary allKeys] objectAtIndex:i];
            
            if ([key isEqualToString:@"urlString"]
                || [key isEqualToString:@"identifier"]
                || [key isEqualToString:@"method"]
                || [key isEqualToString:@"timeout"]
                || [key isEqualToString:@"encryptPassword"]) {
                continue;
            }

            
            value = [returnDictionary valueForKey:key];
            if (i == length-1) {
                separate = @"";
            }
            
            if (paramString && key && [key length]>0 && separate) {
                if (value && [value isKindOfClass:[NSString class]] && [value length]>0) {
                    paramString = [NSString stringWithFormat:@"%@%@=%@%@", paramString, key, value, separate];
                }
                else if (value && [value isKindOfClass:[NSNumber class]]){
                    paramString = [NSString stringWithFormat:@"%@%@=%@%@", paramString, key, [(NSNumber*)value stringValue], separate];
                }
                else{
                    
                }
            }
        }
    }
    
    if ([paramString hasSuffix:@"&"]) {
        paramString = [paramString substringToIndex:[paramString length]-1];
    }
    
    if ([paramString isEqualToString:@"?"]) {
        return @"";
    }
    
    return paramString;
}

#pragma ==================================================
#pragma == 将self的所有property拼接成Post方式请求的字典
#pragma ==================================================
- (NSDictionary *)paramOfPost{
    
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionary];
    
    NSString *propertyName = nil;
    NSString *propertyValue = nil;
    
    NSArray *propertyList = [self attributeList];
    NSUInteger count = propertyList.count;
    
    for (int i=0; i<count; i++) {
        propertyName = [propertyList objectAtIndex:i];
        
        if ([propertyName isEqualToString:@"requestHeaderDic"]
            || [propertyName isEqualToString:@"postFilesPathDic"]
            || [propertyName isEqualToString:@"postParamDic"]
            || [propertyName isEqualToString:@"encryptPassword"]
            || [propertyName isEqualToString:@"urlString"]
            || [propertyName isEqualToString:@"identifier"]
            || [propertyName isEqualToString:@"method"]
            || [propertyName isEqualToString:@"timeout"]) {
            continue;
        }

        propertyValue =[self valueForKey:propertyName];
        
        if (propertyValue == nil) {
            propertyValue = @"";
        }
        if (propertyName && propertyValue) {
            
            //参数进行URLEncoded
//            NSString *encodeValue = [propertyValue URLEncodedString];
//            [returnDictionary setObject:encodeValue forKey:propertyName];
            
            //参数不进行URLEncoded
            [returnDictionary setObject:propertyValue forKey:propertyName];
        }
    }
    
    //参数进行URLEncoded
//    NSArray *keys = [self.postParamDic allKeys];
//    for (NSInteger i=0; i<[keys count]; i++) {
//        NSString *key = [keys objectAtIndex:i];
//        NSString *value = [self.postParamDic objectForKey:key];
//        NSString *encodeValue = [value URLEncodedString];
//
//        [returnDictionary setObject:encodeValue forKey:key];
//    }
    
    //参数不进行URLEncoded
    [returnDictionary setValuesForKeysWithDictionary:self.postParamDic];
    
    return returnDictionary;
}


#pragma ==================================================
#pragma == 获取当前类的属性列表
#pragma ==================================================
- (NSMutableArray *)attributeList {
    static NSMutableDictionary *classDictionary = nil;
    if (classDictionary == nil) {
        classDictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass(self.class);
    
    NSMutableArray *propertyList = [classDictionary objectForKey:className];
    
    if (propertyList != nil) {
        return propertyList;
    }
    
    propertyList = [[NSMutableArray alloc] init];
    
    id theClass = object_getClass(self);
    [self getPropertyList:theClass forList:&propertyList];
    
    [classDictionary setObject:propertyList forKey:className];
    
    return propertyList;
}

- (void)getPropertyList:(id)theClass forList:(NSMutableArray **)propertyList {
    id superClass = class_getSuperclass(theClass);
    unsigned int count, i;
    objc_property_t *properties = class_copyPropertyList(theClass, &count);
    for (i=0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        if (propertyName != nil) {
            [*propertyList addObject:propertyName];
            
            propertyName = nil;
        }
    }
    free(properties);
    
    if (superClass != [NSObject class]) {
        [self getPropertyList:superClass forList:propertyList];
    }
}

@end
