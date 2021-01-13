//
//  KKLibraryLocalization.h
//  BM
//
//  Created by sjyt on 2020/1/2.
//  Copyright © 2020 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KKLibLocalForKey(key) [KKLibraryLocalization localStringForKey:key]

@interface KKLibraryLocalization : NSObject

@property (nonatomic , strong) NSMutableDictionary * _Nonnull keyListDictionary;

+ (KKLibraryLocalization*_Nonnull)defaultManager;

+ (NSString *_Nonnull)localStringForKey:(NSString *_Nullable)key;

@end
