//
//  KKAuthorizedBase.h
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKCategory.h"
#import "KKLibraryDefine.h"
#import "KKButton.h"
#import "KKAlertView.h"
#import "KKSharedInstance.h"
#import "KKLog.h"

/**
 *  KKAuthorizedType
 */
typedef NS_ENUM(NSInteger,KKAuthorizedType) {
    
    KKAuthorizedType_AddressBook = 1,/* 通讯录 */
    
    KKAuthorizedType_Album = 2,/* 手机相册 */

    KKAuthorizedType_Camera = 3,/* 手机相册 */

    KKAuthorizedType_Location = 4,/* 地理位置 */
    
    KKAuthorizedType_Microphone = 5,/* 麦克风 */

    KKAuthorizedType_Notification = 6,/* 通知中心 */
    
    KKAuthorizedType_Music = 7,/* 媒体库音乐 */
    
    KKAuthorizedType_CellularData = 8,/* 蜂窝移动网络 */
};

@interface KKAuthorizedBase : NSObject

- (void)showAuthorizedFailedWithType:(KKAuthorizedType)aType appName:(NSString*)aAppName;

@end
