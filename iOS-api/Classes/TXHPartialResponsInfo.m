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
@property (nonatomic, assign, readwrite) NSInteger total;
@property (nonatomic, assign, readwrite) NSInteger limit;
@property (nonatomic, assign, readwrite) NSInteger offset;

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
    
    NSString *totalString  = headers[@"X-Row-Count"];
    NSString *limitString  = headers[@"X-Limit"];
    NSString *offsetString = headers[@"X-Offset"];
    
    
    NSInteger limit  = [limitString integerValue];
    NSInteger offset = [offsetString integerValue];
    NSInteger total  = [totalString integerValue];
    
    self.total = total;
    self.hasMore = total > limit + offset;
    
    if (!self.hasMore)
        return self;
    
    NSInteger nextLimit  = limit;
    NSInteger nextOffset = offset + limit;
    
    self.limit  = nextLimit;
    self.offset = nextOffset;
    
    return self;
}

@end
