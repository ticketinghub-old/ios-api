//
//  _TXHAppSessionManager.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "_TXHAppSessionManager.h"

#import "TXHAPIError.h"
#import "TXHVenue.h"

// Static declaration of endpoints
static NSString * const kVenuesAPIBaseURL = @"https://mpos.th-apps.com/";
static NSString * const kVenuesEndpoint = @"venues";

@implementation _TXHAppSessionManager

- (id)init {
    if (!(self = [super initWithBaseURL:[NSURL URLWithString:kVenuesAPIBaseURL]])) {
        return nil; // Bail!
    }

    self.requestSerializer = [AFJSONRequestSerializer serializer];

    return self;
}

#pragma mark - Public

- (void)setDefaultAcceptLanguage:(NSString *)identifier {
    [self.requestSerializer setValue:identifier forHTTPHeaderField:@"Accept-Language"];
}

- (void)fetchVenuesWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSArray *, NSError *))completion {
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];

    [self GET:kVenuesEndpoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![responseObject count]) {
            responseObject = nil;
            NSString *localisedDescription = NSLocalizedString(@"No venues available for this user", @"");
            NSError *error = [NSError errorWithDomain:TXHAPIErrorDomain code:TXHAPIErrorNoVenues userInfo:@{NSLocalizedDescriptionKey: localisedDescription}];
            completion(nil, error);
        } else {
            NSMutableArray *venues = [[NSMutableArray alloc] initWithCapacity:[responseObject count]];

            for (NSDictionary *venueDictionary in responseObject) {
                TXHVenue *venue = [TXHVenue createWithDictionary:venueDictionary];
                if (venue) {
                    [venues addObject:venue];
                }
            }

            completion(venues, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

@end
