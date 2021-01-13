/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>


typedef enum : NSInteger {
	KKNotReachable = 0,
	KKReachableViaWiFi,
	KKReachableViaWWAN
} KKNetworkStatus;

#pragma mark IPv6 Support
//KKReachability fully support IPv6.  For full details, see ReadMe.md.


extern NSString *kKKReachabilityChangedNotification;


@interface KKReachability : NSObject

/*!
 * Use to check the kkreachability of a given host name.
 */
+ (instancetype)kkreachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the kkreachability of a given IP address.
 */
+ (instancetype)kkreachabilityWithAddress:(const struct sockaddr *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)kkreachabilityForInternetConnection;


#pragma mark kkreachabilityForLocalWiFi
//kkreachabilityForLocalWiFi has been removed from the sample.  See ReadMe.md for more information.
//+ (instancetype)kkreachabilityForLocalWiFi;

/*!
 * Start listening for kkreachability notifications on the current run loop.
 */
- (BOOL)startNotifier;
- (void)stopNotifier;

- (KKNetworkStatus)currentKKReachabilityStatus;

/*!
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
- (BOOL)connectionRequired;

@end


