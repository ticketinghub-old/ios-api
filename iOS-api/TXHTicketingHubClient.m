//
//  TXHTicketingHubClient.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

#import "_TXHAPISessionManager.h"

// Static declaration of endpoints
static NSString * const
    kVenuesEndpoint = @"venues"
;

@interface TXHTicketingHubClient ()

@property (strong, nonatomic) _TXHAPISessionManager *sessionManager;

@end

@implementation TXHTicketingHubClient

#pragma mark - Set up and tear down

- (id)init {
    if (!(self = [super init])) {
        return nil; // Bail!
    }

    _sessionManager = [_TXHAPISessionManager new];
    [_sessionManager setDefaultAcceptLanguage:[[NSLocale preferredLanguages] firstObject]];

    return self;
}

#pragma mark - Public

- (void)setDefaultAcceptLanguage:(NSString *)identifier {
    [self.sessionManager setDefaultAcceptLanguage:identifier];

}

//- (void)fetchVenuesWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSArray *, NSError *))completion {
//    [self.appSessionManager fetchVenuesWithUsername:username password:password completion:completion];
//}
//
//- (void)fetchSeasonsForVenueToken:(NSString *)venueToken completion:(void (^)(NSArray *, NSError *))completion {
//    [self.sessionManager fetchSeasonsForVenueToken:venueToken completion:completion];
//}

@end
