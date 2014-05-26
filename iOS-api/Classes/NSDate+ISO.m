//
//  NSDate+ISO.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 13/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "NSDate+ISO.h"

@implementation NSDate (ISO)

+ (NSDateFormatter *)isoDateFormatter {

    static NSDateFormatter *_isoDateFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _isoDateFormatter = [NSDateFormatter new];
        [_isoDateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    
    return _isoDateFormatter;
}

- (NSString *)isoDateString
{
    return [[[self class] isoDateFormatter] stringFromDate:self];
}


+ (NSDateFormatter *)isoTimeFormatter {
    
    static NSDateFormatter *_isoTimeFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _isoTimeFormatter = [NSDateFormatter new];
        [_isoTimeFormatter setDateFormat:@"HH:mm"];
    });
    
    return _isoTimeFormatter;
}

- (NSString *)isoTimeString
{
    return [[[self class] isoTimeFormatter] stringFromDate:self];
}


+ (NSDate *)dateFromISOString:(NSString *)isoString
{
    return [[self isoDateFormatter] dateFromString:isoString];
}

@end
