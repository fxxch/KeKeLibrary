//
//  KILocalizationManager.h
//  Kitalker
//
//  Created by liubo on 12-8-20.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN  NSString *const NotificationName_LocalizationDidChanged;

#define KILocalization(key) [KILocalizationManager localizationWithKey:key]

@interface KILocalizationManager : NSObject {
     NSArray *_localizationList;
}

+ (NSArray *)languages;

+ (NSString *)currentLanguage;

+ (void)changeLocalization:(NSString *)language;

+ (NSString *)localizationWithKey:(NSString *)key;

@end
