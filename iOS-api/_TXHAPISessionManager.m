//
//  _TXHAPISessionManager.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "_TXHAPISessionManager.h"

#import "TXHAPIError.h"

static NSString * const kAPIBaseURL = @"https://api.ticketinghub.com/";
static NSString * const kSeasonsEndPoint = @"seasons";

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

- (void)fetchSeasonsForVenueToken:(NSString *)venueToken completion:(void (^)(NSArray *, NSError *))completion {
    [self.requestSerializer setAuthorizationHeaderFieldWithToken:[NSString stringWithFormat:@"Bearer %@", venueToken]];

    [self GET:kSeasonsEndPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![responseObject count]) {
            responseObject = nil;
            NSString *localisedDescription = NSLocalizedString(@"No seasons available for this venue", @"");
            NSError *error = [NSError errorWithDomain:TXHAPIErrorDomain code:TXHAPIErrorNoSeasons userInfo:@{NSLocalizedDescriptionKey: localisedDescription}];
            completion(nil, error);
        } else {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

@end
