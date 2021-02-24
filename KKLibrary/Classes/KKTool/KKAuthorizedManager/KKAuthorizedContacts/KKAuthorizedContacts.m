//
//  KKAuthorizedContacts.m
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedContacts.h"

@implementation KKAuthorizedContacts

+ (KKAuthorizedContacts *)defaultManager{
    static KKAuthorizedContacts *KKAuthorizedContacts_default = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKAuthorizedContacts_default = [[self alloc] init];
    });
    return KKAuthorizedContacts_default;
}

#pragma mark ==================================================
#pragma mark == 通讯录
#pragma mark ==================================================
/*
 检查是否授权【通讯录】
 #import <Contacts/CNContact.h>
 @param showAlert 如果没有授权，是否显示提示框
 @param appName 应用名称，不传的话，从CFBundleDisplayName读取
 */
- (BOOL)isAddressBookAuthorized_ShowAlert:(BOOL)showAlert
                               andAPPName:(nullable NSString *)appName{
        
    CNAuthorizationStatus author = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    //用户尚未做出授权选择
    if (author == CNAuthorizationStatusNotDetermined) {
        
        __block BOOL accessGranted = NO;
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        // 初始化并创建通讯录对象，记得释放内存
        CNContactStore *addressBook = [[CNContactStore alloc]init];
        [addressBook requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        return accessGranted;
    }
    //用户已经授权同意——同意访问
    else if (author == CNAuthorizationStatusAuthorized) {
        return YES;
    }
    else {
        if (showAlert) {
            [KKAuthorizedContacts.defaultManager showAuthorizedFailedWithType:KKAuthorizedType_AddressBook
                                                                     appName:appName];
        }
        return NO;
    }
}

@end
