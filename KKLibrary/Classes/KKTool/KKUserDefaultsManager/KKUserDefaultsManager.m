//
//  KKUserDefaultsManager.m
//  ChervonIot
//
//  Created by edward lannister on 2022/06/22.
//  Copyright © 2022 ts. All rights reserved.
//

#import "KKUserDefaultsManager.h"
#import "KKCategory.h"
#import "KKLog.h"

NSAttributedStringKey const KKUserDefaultsManagerDefaultIdentiiferKey  = @"KKUserDefaultsManager";

@implementation KKUserDefaultsManager

#pragma mark ==================================================
#pragma mark == Basic
#pragma mark ==================================================
+ (void)setObject:(id _Nullable)anObject forKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier{
    
    if ([NSString kk_isStringEmpty:aKey] || !anObject) {
        return;
    }
    
    if ([anObject isKindOfClass:[NSString class]]) {
        [KKUserDefaultsManager private_saveObject:(NSString*)anObject forKey:aKey userDefaultsForKey:aIdentifier];
    }
    else if ([anObject isKindOfClass:[NSNumber class]]) {
        [KKUserDefaultsManager private_saveObject:(NSNumber*)anObject forKey:aKey userDefaultsForKey:aIdentifier];
    }
    else if ([anObject isKindOfClass:[NSDictionary class]]) {
        NSString *jsonString = [(NSDictionary*)anObject kk_translateToJSONString];
        if ([NSString kk_isStringNotEmpty:jsonString]) {
            [KKUserDefaultsManager private_saveObject:jsonString forKey:aKey userDefaultsForKey:aIdentifier];
        } else {
            KKLogErrorFormat(@"KKUserDefaultsManager not support：%@",anObject);
            return;
        }
    }
    else if ([anObject isKindOfClass:[NSArray class]]){
        NSString *jsonString = [(NSArray*)anObject kk_translateToJSONString];
        if ([NSString kk_isStringNotEmpty:jsonString]) {
            [KKUserDefaultsManager private_saveObject:jsonString forKey:aKey userDefaultsForKey:aIdentifier];
        } else {
            KKLogErrorFormat(@"KKUserDefaultsManager not support：%@",anObject);
            return;
        }
    }
    else{
        return;
    }
}

+ (void)removeObjectForKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier{
    [KKUserDefaultsManager private_removeObjectForKey:aKey userDefaultsForKey:aIdentifier];
}

+ (id _Nullable)objectForKey:(NSString*_Nullable)aKey identifier:(NSString*_Nullable)aIdentifier{
    
    if ([NSString kk_isStringEmpty:aKey]) {
        return nil;
    }

    NSString *jsonString = [KKUserDefaultsManager private_getObjectForKey:aKey userDefaultsForKey:aIdentifier];
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

+ (void)clearUserDefaultsWithIdentifier:(NSString*_Nullable)aIdentifier{
    return [KKUserDefaultsManager private_deleteUserDefaultsForKey:aIdentifier];
}

#pragma mark ==================================================
#pragma mark == More <Array>
#pragma mark ==================================================
+ (void)clearAllUserDefaults{
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
}

+ (void)arrayAddObject:(id _Nullable)anObject
                forKey:(NSString*_Nullable)aKey
            identifier:(NSString*_Nullable)aIdentifier{
    if ([NSString kk_isStringEmpty:aKey] ||
        !anObject ) {
        return;
    }

    NSMutableArray *aArray = [NSMutableArray array];
    NSArray *arrayold = [KKUserDefaultsManager objectForKey:aKey identifier:aIdentifier];
    if (arrayold) {
        [aArray addObjectsFromArray:arrayold];
    }
    [aArray addObject:anObject];
    [KKUserDefaultsManager setObject:aArray forKey:aKey identifier:aIdentifier];
}

+ (void)arrayInsertObject:(id _Nullable)anObject
                  atIndex:(NSInteger)aIndex
                   forKey:(NSString*_Nullable)aKey
               identifier:(NSString*_Nullable)aIdentifier{
    if ([NSString kk_isStringEmpty:aKey] ||
        !anObject ||
        aIndex < 0 ) {
        return;
    }

    NSMutableArray *aArray = [NSMutableArray array];
    NSArray *arrayold = [KKUserDefaultsManager objectForKey:aKey identifier:aIdentifier];
    if (arrayold) {
        [aArray addObjectsFromArray:arrayold];
    }
    if (aIndex<[aArray count]) {
        [aArray insertObject:anObject atIndex:aIndex];
    }
    else{
        [aArray addObject:anObject];
    }
    
    [KKUserDefaultsManager setObject:aArray forKey:aKey identifier:aIdentifier];
}

+ (void)arrayRemoveAtIndex:(NSInteger)aIndex
                    forKey:(NSString*_Nullable)aKey
                identifier:(NSString*_Nullable)aIdentifier{
    if ([NSString kk_isStringEmpty:aKey] ||
        aIndex < 0) {
        return;
    }

    NSMutableArray *aArray = [NSMutableArray array];
    NSArray *arrayold = [KKUserDefaultsManager objectForKey:aKey identifier:aIdentifier];
    if (arrayold) {
        [aArray addObjectsFromArray:arrayold];
    }
    
    if (aIndex<[aArray count]) {
        [aArray removeObjectAtIndex:aIndex];
    }
    
    [KKUserDefaultsManager setObject:aArray forKey:aKey identifier:aIdentifier];
}

#pragma mark ==================================================
#pragma mark == UserDefaults < Private >
#pragma mark ==================================================
/* UserDefaults item */
+ (void)private_saveObject:(id)aValue forKey:(NSString*_Nullable)aKey userDefaultsForKey:(NSString*_Nullable)aUserDefaultsForKey{
    if ([NSString kk_isStringEmpty:aValue] || [NSString kk_isStringEmpty:aKey]) {
        return;
    }
    
    NSDictionary *dictionary = [KKUserDefaultsManager private_getUserDefaultsForKey:aUserDefaultsForKey];
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
    if ([NSMutableDictionary kk_isDictionaryNotEmpty:dictionary]) {
        [saveDic setValuesForKeysWithDictionary:dictionary];
    }
    [saveDic setObject:aValue forKey:aKey];
    [KKUserDefaultsManager private_saveUserDefaults:saveDic forKey:aUserDefaultsForKey];
}

+ (id)private_getObjectForKey:(NSString*_Nullable)aKey userDefaultsForKey:(NSString*_Nullable)aUserDefaultsForKey{
    if ([NSString kk_isStringEmpty:aKey]) {
        return nil;
    }

    NSDictionary *dictionary = [KKUserDefaultsManager private_getUserDefaultsForKey:aUserDefaultsForKey];
    return [dictionary objectForKey:aKey];
}

+ (void)private_removeObjectForKey:(NSString*_Nullable)aKey userDefaultsForKey:(NSString*_Nullable)aUserDefaultsForKey{
    if ([NSString kk_isStringEmpty:aKey]) {
        return;
    }
    
    NSDictionary *dictionary = [KKUserDefaultsManager private_getUserDefaultsForKey:aUserDefaultsForKey];
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
    if ([NSMutableDictionary kk_isDictionaryNotEmpty:dictionary]) {
        [saveDic setValuesForKeysWithDictionary:dictionary];
    }
    [saveDic removeObjectForKey:aKey];
    [KKUserDefaultsManager private_saveUserDefaults:saveDic forKey:aUserDefaultsForKey];
}

/* UserDefaults Group */
+ (void)private_saveUserDefaults:(NSDictionary*_Nullable)aDictionary forKey:(NSString*_Nullable)aKey{
    if ([NSDictionary kk_isDictionaryEmpty:aDictionary]) {
        return;
    }

    NSString *aUserDefaultsKey = aKey;
    if ([NSString kk_isStringEmpty:aUserDefaultsKey]) {
        aUserDefaultsKey = KKUserDefaultsManagerDefaultIdentiiferKey;
    }
    [[NSUserDefaults standardUserDefaults] setObject:aDictionary forKey:aUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary*_Nullable)private_getUserDefaultsForKey:(NSString*_Nullable)aKey{
    NSString *aUserDefaultsKey = aKey;
    if ([NSString kk_isStringEmpty:aUserDefaultsKey]) {
        aUserDefaultsKey = KKUserDefaultsManagerDefaultIdentiiferKey;
    }
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:aUserDefaultsKey];
    return dictionary;
}

+ (void)private_deleteUserDefaultsForKey:(NSString*_Nullable)aKey{
    NSString *aUserDefaultsKey = aKey;
    if ([NSString kk_isStringEmpty:aUserDefaultsKey]) {
        aUserDefaultsKey = KKUserDefaultsManagerDefaultIdentiiferKey;
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:aUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
