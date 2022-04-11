//
//  NSCalendar+KKCategory.m
//  interphone
//
//  Created by edward lannister on 2022/04/11.
//  Copyright © 2022 ITAccess. All rights reserved.
//

#import "NSCalendar+KKCategory.h"

@implementation NSCalendar (KKCategory)

+ (NSCalendar*)kk_gregorianCalendar{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    return calendar;
}

@end
