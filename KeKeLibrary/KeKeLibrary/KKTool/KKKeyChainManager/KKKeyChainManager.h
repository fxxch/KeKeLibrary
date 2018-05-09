//
//  KKKeyChainManager.h
//  GouUseCore
//
//  Created by liubo on 2017/8/17.
//  Copyright © 2018年 KKLibray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KKKeyChainManager : NSObject

#pragma mark- ==================================================
#pragma mark UUID
#pragma mark==================================================
+ (NSString*)UUID;

#pragma mark- ==================================================
#pragma mark 读写方法
#pragma mark==================================================
+ (BOOL)saveOject:(id)object forKey:(NSString *)key;

+ (id)readObjectForKey:(NSString *)key;

+ (BOOL)removeObjectForKey:(NSString *)key;

@end
