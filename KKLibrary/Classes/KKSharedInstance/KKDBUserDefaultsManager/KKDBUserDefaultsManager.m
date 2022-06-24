//
//  KKDBUserDefaultsManager.m
//  ProjectK
//
//  Created by liubo on 14-1-10.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "KKDBUserDefaultsManager.h"
#import "KKCategory.h"
#import "KKDBUserDefaultsManagerDB.h"
#import "KKLog.h"

#define KKUserDefaultsInformationKey @"KKUserDefaultsInformationKey"

@implementation KKDBUserDefaultsManager

#pragma mark ==================================================
#pragma mark == 基础方法
#pragma mark ==================================================
+ (BOOL)setObject:(id _Nullable)anObject forKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier{
    
    if ([NSString kk_isStringEmpty:aKey] || !anObject) {
        return NO;
    }

    if ([anObject isKindOfClass:[NSString class]]) {
        return [KKDBUserDefaultsManagerDB DBInsert_KKUserDefaults_WithUserIdentifier:aIdentifier key:aKey value:anObject];
    }
    else if ([anObject isKindOfClass:[NSNumber class]]) {
        NSString *jsonString = [(NSNumber*)anObject stringValue];
        if ([NSString kk_isStringNotEmpty:jsonString]) {
            return [KKDBUserDefaultsManagerDB DBInsert_KKUserDefaults_WithUserIdentifier:aIdentifier key:aKey value:jsonString];
        } else {
            KKLogErrorFormat(@"KKUserDefaults保存信息格式不支持：%@",anObject);
            return NO;
        }
    }
    else if ([anObject isKindOfClass:[NSDictionary class]]) {
        NSString *jsonString = [(NSDictionary*)anObject kk_translateToJSONString];
        if ([NSString kk_isStringNotEmpty:jsonString]) {
            return [KKDBUserDefaultsManagerDB DBInsert_KKUserDefaults_WithUserIdentifier:aIdentifier key:aKey value:jsonString];
        } else {
            KKLogErrorFormat(@"KKUserDefaults保存信息格式不支持：%@",anObject);
            return NO;
        }
    }
    else if ([anObject isKindOfClass:[NSArray class]]){
        NSString *jsonString = [(NSArray*)anObject kk_translateToJSONString];
        if ([NSString kk_isStringNotEmpty:jsonString]) {
            return [KKDBUserDefaultsManagerDB DBInsert_KKUserDefaults_WithUserIdentifier:aIdentifier key:aKey value:jsonString];
        } else {
            KKLogErrorFormat(@"KKUserDefaults保存信息格式不支持：%@",anObject);
            return NO;
        }
    }
    else{
        return NO;
    }
}

+ (BOOL)removeObjectForKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier{
    return [KKDBUserDefaultsManagerDB DBDelete_KKUserDefaults_WithUserIdentifier:aIdentifier
                                                                           key:aKey];
}

+ (id _Nullable)objectForKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier{
    
    if ([NSString kk_isStringEmpty:aKey]) {
        return nil;
    }

    NSString *jsonString = [KKDBUserDefaultsManagerDB DBQuery_KKUserDefaults_WithUserIdentifier:aIdentifier key:aKey];
    NSDictionary *dic = [NSDictionary kk_dictionaryFromJSONString:jsonString];
    if ([NSDictionary kk_isDictionaryNotEmpty:dic]) {
        return dic;
    }

    NSArray *arr = [NSArray kk_arrayFromJSONString:jsonString];
    if ([NSArray kk_isArrayNotEmpty:arr]) {
        return arr;
    }

    if ([NSString kk_isStringEmpty:jsonString]) {
        return nil;
    } else {
        return jsonString;
    }
}

+ (BOOL)clearKKDBUserDefaultsManagerWithIdentifier:(NSString*_Nullable)aIdentifier{
    if ([NSString kk_isStringEmpty:aIdentifier]) {
        return NO;
    }
    return [KKDBUserDefaultsManagerDB DBDelete_KKUserDefaults_WithUserIdentifier:aIdentifier];
}

#pragma mark ==================================================
#pragma mark == 扩展方法
#pragma mark ==================================================
+ (void)clearNSUserDefaults{
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
}

+ (void)arrayAddObject:(id _Nullable)anObject
                forKey:(NSString*_Nullable)aKey
            identifier:(NSString*_Nullable)aIdentifier
{
    if ([NSString kk_isStringEmpty:aKey] ||
        !anObject ) {
        return;
    }

    NSMutableArray *aArray = [NSMutableArray array];
    NSArray *arrayold = [KKDBUserDefaultsManager objectForKey:aKey identifier:aIdentifier];
    if (arrayold) {
        [aArray addObjectsFromArray:arrayold];
    }
    [aArray addObject:anObject];
    [KKDBUserDefaultsManager setObject:aArray forKey:aKey identifier:aIdentifier];
}

+ (void)arrayInsertObject:(id _Nullable)anObject
                  atIndex:(NSInteger)aIndex
                   forKey:(NSString*_Nullable)aKey
               identifier:(NSString*_Nullable)aIdentifier
{
    if ([NSString kk_isStringEmpty:aKey] ||
        !anObject ||
        aIndex < 0 ) {
        return;
    }

    NSMutableArray *aArray = [NSMutableArray array];
    NSArray *arrayold = [KKDBUserDefaultsManager objectForKey:aKey identifier:aIdentifier];
    if (arrayold) {
        [aArray addObjectsFromArray:arrayold];
    }
    if (aIndex<[aArray count]) {
        [aArray insertObject:anObject atIndex:aIndex];
    }
    else{
        [aArray addObject:anObject];
    }
    
    [KKDBUserDefaultsManager setObject:aArray forKey:aKey identifier:aIdentifier];
}

+ (void)arrayRemoveAtIndex:(NSInteger)aIndex
                    forKey:(NSString*_Nullable)aKey
                identifier:(NSString*_Nullable)aIdentifier
{
    if ([NSString kk_isStringEmpty:aKey] ||
        aIndex < 0) {
        return;
    }

    NSMutableArray *aArray = [NSMutableArray array];
    NSArray *arrayold = [KKDBUserDefaultsManager objectForKey:aKey identifier:aIdentifier];
    if (arrayold) {
        [aArray addObjectsFromArray:arrayold];
    }
    
    if (aIndex<[aArray count]) {
        [aArray removeObjectAtIndex:aIndex];
    }
    
    [KKDBUserDefaultsManager setObject:aArray forKey:aKey identifier:aIdentifier];
}


@end
