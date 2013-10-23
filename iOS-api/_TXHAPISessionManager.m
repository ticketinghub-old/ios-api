//
//  _TXHAPISessionManager.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "_TXHAPISessionManager.h"

static NSString * const kAPIBaseURL = @"https://api.ticketinghub.com/";

@implementation _TXHAPISessionManager

#pragma mark - Set up and tear down

- (id)init {
    if (!(self = [super initWithBaseURL:[NSURL URLWithString:kAPIBaseURL]])) {
        return nil; // Bail!
    }

    self.requestSerializer = [AFJSONRequestSerializer serializer];

    return self;
}

#pragma mark - Public

- (void)setDefaultAcceptLanguage:(NSString *)identifier {
    [self.requestSerializer setValue:identifier forHTTPHeaderField:@"Accept-Language"];
}

@end
