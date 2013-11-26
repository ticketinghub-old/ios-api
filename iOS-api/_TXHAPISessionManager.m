//
//  _TXHAPISessionManager.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//



#import "_TXHAPISessionManager.h"

#import "TXHAPIError.h"
#import "TXHSeason.h"

static NSString * const kAPIBaseURL = @"https://api.ticketinghub.com/";
static NSString * const kSuppliersEndPoint = @"suppliers";

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

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSArray *, NSError *))completion {
    NSAssert(username, @"username parameter cannot be nil");
    NSAssert(password, @"password parameter cannot be nil");
    NSAssert(completion, @"completion block cannot be nil");

    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    [self GET:kSuppliersEndPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // No need to check response object as it you cannot have a user without any suppliers
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

//- (void)fetchSeasonsForVenueToken:(NSString *)venueToken completion:(void (^)(NSArray *, NSError *))completion {
//    [self.requestSerializer setAuthorizationHeaderFieldWithToken:[NSString stringWithFormat:@"Bearer %@", venueToken]];
//
//    [self GET:kSeasonsEndPoint parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        if (![responseObject count]) {
//            responseObject = nil;
//            NSString *localisedDescription = NSLocalizedString(@"No seasons available for this venue", @"");
//            NSError *error = [NSError errorWithDomain:TXHAPIErrorDomain code:TXHAPIErrorNoSeasons userInfo:@{NSLocalizedDescriptionKey: localisedDescription}];
//            completion(nil, error);
//        } else {
//            NSMutableArray *seasons = [[NSMutableArray alloc] initWithCapacity:[responseObject count]];
//
//            for (NSDictionary *seasonDictionary in responseObject) {
//                TXHSeason *season = [TXHSeason createWithDictionary:seasonDictionary];
//                if (season) {
//                    [seasons addObject:season];
//                }
//            }
//
//            completion(seasons, nil);
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        completion(nil, error);
//    }];
//}

@end
