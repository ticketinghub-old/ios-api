//
//  NSString+date.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 24/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "NSString+date.h"

@implementation NSString (date)

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *_dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
        _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    });
    return _dateFormatter;
}

- (NSDate *)dateRepresentation
{
    return [[[self class] dateFormatter] dateFromString:self];
}

@end
