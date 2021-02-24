//
//  KKAuthorizedBase.m
//  KKLibrary
//
//  Created by 刘波 on 2021/2/24.
//  Copyright © 2021 KKLibrary. All rights reserved.
//

#import "KKAuthorizedBase.h"

@implementation KKAuthorizedBase

#pragma mark ==================================================
#pragma mark == 授权失败弹窗
#pragma mark ==================================================
- (void)showAuthorizedFailedWithType:(KKAuthorizedType)aType appName:(NSString*)aAppName{
    
    //app名称
    __block NSString *app_Name = @"";
    app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    if ([NSString isStringEmpty:app_Name]) {
        app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    if ([NSString isStringEmpty:app_Name]) {
        app_Name = aAppName;
    }

    __block NSInteger AlertViewTag = 2017082200+aType;
    
    __block NSString *moreString = nil;
    switch (aType) {
        case KKAuthorizedType_AddressBook:{
            moreString = KKLibLocalizable_Authorized_AddressBook;
            break;
        }
        case KKAuthorizedType_Album:{
            moreString = KKLibLocalizable_Authorized_Album;
            break;
        }
        case KKAuthorizedType_Camera:{
            moreString = KKLibLocalizable_Authorized_Camera;
            break;
        }
        case KKAuthorizedType_Location:{
            moreString = KKLibLocalizable_Authorized_Location;
            break;
        }
        case KKAuthorizedType_Microphone:{
            moreString = KKLibLocalizable_Authorized_Microphone;
            break;
        }
        case KKAuthorizedType_Notification:{
            moreString = KKLibLocalizable_Authorized_Notification;
            break;
        }
        case KKAuthorizedType_Music:{
            moreString = KKLibLocalizable_Authorized_Music;
            break;
        }
        case KKAuthorizedType_CellularData:{
            moreString = KKLibLocalizable_Authorized_CellularData;
            break;
        }
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *message = [NSString stringWithFormat:@"%@ %@",app_Name,moreString];
        
        KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:KKLocalization(@"KKLibLocalizable.Authorized.title") subTitle:nil message:message delegate:self buttonTitles:KKLibLocalizable_Authorized_OK,KKLibLocalizable_Authorized_Go,nil];
        alertView.tag = AlertViewTag;
        [alertView show];
        
        KKButton *button = [alertView buttonAtIndex:0];
        [button setTitleColor:[UIColor colorWithHexString:@"#1296DB"] forState:UIControlStateNormal];
        KKButton *button1 = [alertView buttonAtIndex:1];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#1296DB"]forState:UIControlStateNormal];
    });
}

- (void)KKAlertView:(KKAlertView*_Nonnull)aAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex{
    if (aButtonIndex==1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (url) {
            [NSObject openURL:url];
        }
    }
}

@end
