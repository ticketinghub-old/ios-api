//
//  NSDateFormatter+TicketingHubFormat.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 25/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "NSDateFormatter+TicketingHubFormat.h"

@implementation NSDateFormatter (TicketingHubFormat)

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ";
        _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];

    });
    return _dateFormatter;
}

+ (NSString *)txh_stringFromDate:(NSDate *)date
{
    return [[self dateFormatter] stringFromDate:date];
}

+ (NSDate *)txh_dateFromString:(NSString *)dateString
{
    return [[self dateFormatter] dateFromString:dateString];
}

@end
