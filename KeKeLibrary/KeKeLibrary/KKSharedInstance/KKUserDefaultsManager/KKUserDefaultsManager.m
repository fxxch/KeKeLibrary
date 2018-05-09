//
//  KKUserDefaultsManager.m
//  ProjectK
//
//  Created by liubo on 14-1-10.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "KKUserDefaultsManager.h"

#define KKUserDefaultsInformationKey @"KKUserDefaultsInformationKey"

@implementation KKUserDefaultsManager

//+ (KKUserDefaultsManager *)defaultManager {
//    static KKUserDefaultsManager *defaultManager = nil;
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        defaultManager = [[self alloc] init];
//    });
//    return defaultManager;
//}

+ (void)registerObject:(id)anObject forKey:(id)aKey identifier:(NSString*)aIdentifier{
    if (!aKey || !anObject) {
        return;
    }
    
    NSString *userDefaultsInformationKey = @"";
    if (aIdentifier && [aIdentifier isKindOfClass:[NSString class]] && [aIdentifier length]>0) {
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@_%@",KKUserDefaultsInformationKey,aIdentifier];
    }
    else{
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@",KKUserDefaultsInformationKey];
    }
    
    //读取UserDefaults信息
    NSMutableDictionary *KKUserDefaultsInformation = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsInformationKey]];
    if ([KKUserDefaultsInformation objectForKey:aKey]) {
        return;
    }
    else{
        if ([anObject isKindOfClass:[NSDictionary class]]) {
            [KKUserDefaultsInformation setObject:[NSMutableDictionary dictionaryWithDictionary:anObject] forKey:aKey];
        }
        else if ([anObject isKindOfClass:[NSArray class]]){
            [KKUserDefaultsInformation setObject:[NSMutableArray arrayWithArray:anObject] forKey:aKey];
        }
        else{
            [KKUserDefaultsInformation setObject:anObject forKey:aKey];
        }
        
        //存储UserDefaults信息
        [[NSUserDefaults standardUserDefaults] setObject:KKUserDefaultsInformation forKey:userDefaultsInformationKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)setObject:(id)anObject forKey:(id)aKey identifier:(NSString*)aIdentifier{
    
    if (!aKey || !anObject) {
        return;
    }
    
    NSString *userDefaultsInformationKey = @"";
    if (aIdentifier && [aIdentifier isKindOfClass:[NSString class]] && [aIdentifier length]>0) {
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@_%@",KKUserDefaultsInformationKey,aIdentifier];
    }
    else{
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@",KKUserDefaultsInformationKey];
    }

    //读取UserDefaults信息
    NSMutableDictionary *KKUserDefaultsInformation = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsInformationKey]];
    if ([anObject isKindOfClass:[NSDictionary class]]) {
        [KKUserDefaultsInformation setObject:[NSMutableDictionary dictionaryWithDictionary:anObject] forKey:aKey];
    }
    else if ([anObject isKindOfClass:[NSArray class]]){
        [KKUserDefaultsInformation setObject:[NSMutableArray arrayWithArray:anObject] forKey:aKey];
    }
    else{
        [KKUserDefaultsInformation setObject:anObject forKey:aKey];
    }
    
    //存储UserDefaults信息
    [[NSUserDefaults standardUserDefaults] setObject:KKUserDefaultsInformation forKey:userDefaultsInformationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeObjectForKey:(NSString *)aKey identifier:(NSString*)aIdentifier{
    
    if (!aKey) {
        return;
    }

    NSString *userDefaultsInformationKey = @"";
    if (aIdentifier && [aIdentifier isKindOfClass:[NSString class]] && [aIdentifier length]>0) {
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@_%@",KKUserDefaultsInformationKey,aIdentifier];
    }
    else{
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@",KKUserDefaultsInformationKey];
    }

    //读取UserDefaults信息
    NSMutableDictionary *KKUserDefaultsInformation = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsInformationKey]];
    [KKUserDefaultsInformation removeObjectForKey:aKey];
    
    //存储UserDefaults信息
    [[NSUserDefaults standardUserDefaults] setObject:KKUserDefaultsInformation forKey:userDefaultsInformationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(id)aKey identifier:(NSString*)aIdentifier{
    
    if (!aKey) {
        return nil;
    }
    
    NSString *userDefaultsInformationKey = @"";
    if (aIdentifier && [aIdentifier isKindOfClass:[NSString class]] && [aIdentifier length]>0) {
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@_%@",KKUserDefaultsInformationKey,aIdentifier];
    }
    else{
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@",KKUserDefaultsInformationKey];
    }
    
    //读取UserDefaults信息
    NSMutableDictionary *KKUserDefaultsInformation = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsInformationKey]];
    
    id anObject = [KKUserDefaultsInformation objectForKey:aKey];
    if ([anObject isKindOfClass:[NSDictionary class]]) {
        return [NSMutableDictionary dictionaryWithDictionary:anObject];
    }
    else if ([anObject isKindOfClass:[NSArray class]]){
        return [NSMutableArray arrayWithArray:anObject];
    }
    else{
        return [KKUserDefaultsInformation objectForKey:aKey];
    }
}

+ (void)clearKKUserDefaultsManagerWithIdentifier:(NSString*)aIdentifier{
    
    NSString *userDefaultsInformationKey = @"";
    if (aIdentifier && [aIdentifier isKindOfClass:[NSString class]] && [aIdentifier length]>0) {
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@_%@",KKUserDefaultsInformationKey,aIdentifier];
    }
    else{
        //用户信息的Key
        userDefaultsInformationKey = [NSString stringWithFormat:@"%@",KKUserDefaultsInformationKey];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userDefaultsInformationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearNSUserDefaults{
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
}

+ (void)arrayAddObject:(id)anObject
                forKey:(id)aKey
            identifier:(NSString*)aIdentifier
{
    NSMutableArray *aArray = [NSMutableArray array];
    NSArray *arrayold = [KKUserDefaultsManager objectForKey:aKey identifier:aIdentifier];
    if (arrayold) {
        [aArray addObjectsFromArray:arrayold];
    }
    [aArray addObject:anObject];
    [KKUserDefaultsManager setObject:aArray forKey:aKey identifier:aIdentifier];
}

+ (void)arrayInsertObject:(id)anObject
                  atIndex:(NSInteger)aIndex
                   forKey:(id)aKey
               identifier:(NSString*)aIdentifier
{
    
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
                    forKey:(id)aKey
                identifier:(NSString*)aIdentifier
{
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


@end
