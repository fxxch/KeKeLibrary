//
//  KKLibraryLocalization.m
//  BM
//
//  Created by sjyt on 2020/1/2.
//  Copyright © 2020 bm. All rights reserved.
//

#import "KKLibraryLocalization.h"
#import "KKLocalizationManager.h"
#import "KKCategory.h"
#import "KKLog.h"

@implementation KKLibraryLocalization

+ (KKLibraryLocalization *_Nonnull)defaultManager{
    static KKLibraryLocalization *KKLibraryLocalization_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKLibraryLocalization_default = [[self alloc] init];
    });
    return KKLibraryLocalization_default;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.keyListDictionary = [[NSMutableDictionary alloc] init];
        NSString *filePath = [[NSBundle kkLibraryBundle] pathForResource:@"KKLibraryLocalization.plist" ofType:nil];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if (plist && [plist isKindOfClass:[NSDictionary class]]) {
            [self.keyListDictionary setValuesForKeysWithDictionary:plist];
        }
    }
    return self;
}

+ (NSString *_Nonnull)localStringForKey:(NSString *_Nullable)key{
    return [[KKLibraryLocalization defaultManager] localStringForKey:key];
}

- (NSString *_Nonnull)localStringForKey:(NSString *_Nullable)key {
    NSString *localText = KKLocalization(key);
    //外部没有对KKLibraryLocalizationDefineKeys做本地化
    if (localText==nil || [localText isEqualToString:key]) {
        NSString *message = [NSString stringWithFormat:@"请注意：%@没有做国际化",key];
        KKLogWarning(message);
        NSString *returnString = [self.keyListDictionary validStringForKey:key];
        if ([NSString isStringNotEmpty:returnString]) {
            return returnString;
        } else {
            return @"";
        }
    } else {
        return localText;
    }
}

@end
