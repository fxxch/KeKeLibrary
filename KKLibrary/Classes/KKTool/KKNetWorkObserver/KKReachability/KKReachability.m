/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Basic demonstration of how to use the SystemConfiguration Reachablity APIs.
 */

#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>

#import <CoreFoundation/CoreFoundation.h>

#import "KKReachability.h"

#pragma mark IPv6 Support
//KKReachability fully support IPv6.  For full details, see ReadMe.md.


NSString *kKKReachabilityChangedNotification = @"kNetworkKKReachabilityChangedNotification";


#pragma mark - Supporting functions

#define kk_kShouldPrintKKReachabilityFlags 1

static void PrintKKReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment)
{
#if kk_kShouldPrintKKReachabilityFlags

    NSLog(@"KKReachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN)				? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',

          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
          comment
          );
#endif
}


static void KKReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
	NSCAssert(info != NULL, @"info was NULL in KKReachabilityCallback");
	NSCAssert([(__bridge NSObject*) info isKindOfClass: [KKReachability class]], @"info was wrong class in KKReachabilityCallback");

    KKReachability* noteObject = (__bridge KKReachability *)info;
    // Post a notification to notify the client that the network KKReachability changed.
    [[NSNotificationCenter defaultCenter] postNotificationName: kKKReachabilityChangedNotification object: noteObject];
}


#pragma mark - KKReachability implementation

@implementation KKReachability
{
	SCNetworkReachabilityRef _kkreachabilityRef;
}

+ (instancetype)kkreachabilityWithHostName:(NSString *)hostName
{
	KKReachability* returnValue = NULL;
	SCNetworkReachabilityRef kkreachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	if (kkreachability != NULL)
	{
		returnValue= [[self alloc] init];
		if (returnValue != NULL)
		{
			returnValue->_kkreachabilityRef = kkreachability;
		}
        else {
            CFRelease(kkreachability);
        }
	}
	return returnValue;
}


+ (instancetype)kkreachabilityWithAddress:(const struct sockaddr *)hostAddress
{
	SCNetworkReachabilityRef kkreachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, hostAddress);

	KKReachability* returnValue = NULL;

	if (kkreachability != NULL)
	{
		returnValue = [[self alloc] init];
		if (returnValue != NULL)
		{
			returnValue->_kkreachabilityRef = kkreachability;
		}
        else {
            CFRelease(kkreachability);
        }
	}
	return returnValue;
}


+ (instancetype)kkreachabilityForInternetConnection
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
    
    return [self kkreachabilityWithAddress: (const struct sockaddr *) &zeroAddress];
}

#pragma mark kkreachabilityForLocalWiFi
//kkreachabilityForLocalWiFi has been removed from the sample.  See ReadMe.md for more information.
//+ (instancetype)kkreachabilityForLocalWiFi



#pragma mark - Start and stop notifier

- (BOOL)startNotifier
{
	BOOL returnValue = NO;
	SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};

	if (SCNetworkReachabilitySetCallback(_kkreachabilityRef, KKReachabilityCallback, &context))
	{
		if (SCNetworkReachabilityScheduleWithRunLoop(_kkreachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
		{
			returnValue = YES;
		}
	}
    
	return returnValue;
}


- (void)stopNotifier
{
	if (_kkreachabilityRef != NULL)
	{
		SCNetworkReachabilityUnscheduleFromRunLoop(_kkreachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}


- (void)dealloc
{
	[self stopNotifier];
	if (_kkreachabilityRef != NULL)
	{
		CFRelease(_kkreachabilityRef);
	}
}


#pragma mark - Network Flag Handling

- (KKNetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
	PrintKKReachabilityFlags(flags, "networkStatusForFlags");
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
	{
		// The target host is not reachable.
		return KKNotReachable;
	}

    KKNetworkStatus returnValue = KKNotReachable;

	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
	{
		/*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
		returnValue = KKReachableViaWiFi;
	}

	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
	{
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */

        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = KKReachableViaWiFi;
        }
    }

	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
	{
		/*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
		returnValue = KKReachableViaWWAN;
	}
    
	return returnValue;
}


- (BOOL)connectionRequired
{
	NSAssert(_kkreachabilityRef != NULL, @"connectionRequired called with NULL kkreachabilityRef");
	SCNetworkReachabilityFlags flags;

	if (SCNetworkReachabilityGetFlags(_kkreachabilityRef, &flags))
	{
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
	}

    return NO;
}


- (KKNetworkStatus)currentKKReachabilityStatus
{
	NSAssert(_kkreachabilityRef != NULL, @"currentNetworkStatus called with NULL SCNetworkKKReachabilityRef");
	KKNetworkStatus returnValue = KKNotReachable;
	SCNetworkReachabilityFlags flags;
    
	if (SCNetworkReachabilityGetFlags(_kkreachabilityRef, &flags))
	{
        returnValue = [self networkStatusForFlags:flags];
	}
    
	return returnValue;
}


@end
