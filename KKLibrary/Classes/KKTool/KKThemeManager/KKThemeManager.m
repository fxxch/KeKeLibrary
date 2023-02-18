//
//  KKThemeManager.m
//  KKLibrary_Demo
//
//  Created by liubo on 14/12/1.
//  Copyright (c) 2014年 KeKeStudio. All rights reserved.
//

#import "KKThemeManager.h"

NSNotificationName const NotificationName_KKThemeChanged = @"NotificationName_KKThemeChanged";

////app名称
//NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
////app显示名称
//NSString *app_ShowName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];

@implementation KKThemeManager

+ (KKThemeManager *)sharedInstance {
    static KKThemeManager *KKThemeManager_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKThemeManager_sharedInstance = [[self alloc] init];
    });
    return KKThemeManager_sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _currentThemeName = DefaultThemeBundleName;
    }
    return self;
}

- (void)setCurrentThemeName:(NSString *)currentThemeName{
    NSDictionary *information = [KKThemeManager loadThemeInformation_withBundleFileName:currentThemeName];
    if (information) {
        _currentThemeName = currentThemeName;
        [NSNotificationCenter.defaultCenter postNotificationName:NotificationName_KKThemeChanged object:nil];
    }
}

@end
