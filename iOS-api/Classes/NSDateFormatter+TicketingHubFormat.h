//
//  NSDateFormatter+TicketingHubFormat.h
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 25/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (TicketingHubFormat)

+ (NSString *)txh_stringFromDate:(NSDate *)date;
+ (NSDate *)txh_dateFromString:(NSString *)dateString;

@end
