//
//  TXHPartialResponsInfo.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 27/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPartialResponsInfo.h"

@interface TXHPartialResponsInfo ()

@property (nonatomic, assign, readwrite) BOOL hasMore;

@property (nonatomic, strong, readwrite) NSString *range;

@end

@implementation TXHPartialResponsInfo

// TODO: REFCTOR!!!!!

- (instancetype)initWithNSURLResponse:(NSURLResponse *)response
{
    if (!(self = [super init]))
        return nil;
    
    if ([(NSHTTPURLResponse *)response statusCode] == 200)
    {
        return self;
    }
    
    NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
    
    NSString *acceptRanges = headers[@"Accept-Ranges"];
    NSString *contentRange = headers[@"Content-Range"];
    
    NSArray *rangeComponents = [contentRange componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -/"]];
    
    if ([rangeComponents count] != 4)
        return nil;
    
    NSInteger startRange = [rangeComponents[1] integerValue];
    NSInteger endRange   = [rangeComponents[2] integerValue];
    NSInteger total      = [rangeComponents[3] integerValue];
    
    self.hasMore = total > endRange;
    
    if (!self.hasMore)
        return self;
    
    NSInteger nextStartRange = endRange + 1;
    NSInteger nextEndRange   = nextStartRange + (endRange - startRange);
    nextEndRange = nextEndRange <= total ? nextEndRange : total;
    
    self.range = [NSString stringWithFormat:@"%@=%d-%d",acceptRanges, nextStartRange, nextEndRange];
    
    return self;
}

@end
