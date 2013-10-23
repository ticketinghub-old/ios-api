//
//  TXHTicketingHubClient.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

#import "_TXHAPISessionManager.h"
#import "_TXHAppSessionManager.h"

// Static declaration of endpoints
static NSString * const
    kVenuesEndpoint = @"venues"
;

@interface TXHTicketingHubClient ()

@property (strong, nonatomic) _TXHAPISessionManager *sessionManager;
@property (strong, nonatomic) _TXHAppSessionManager *appSessionManager;

@end

@implementation TXHTicketingHubClient

#pragma mark - Set up and tear down

+ (instancetype)sharedClient {
    static TXHTicketingHubClient *client = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[[self class] alloc] init];
    });

    return client;
}

- (id)init {
    if (!(self = [super init])) {
        return nil; // Bail!
    }

    _sessionManager = [_TXHAPISessionManager new];
    [_sessionManager setDefaultAcceptLanguage:[[NSLocale preferredLanguages] firstObject]];

    _appSessionManager = [_TXHAppSessionManager new];
    [_appSessionManager setDefaultAcceptLanguage:[[NSLocale preferredLanguages] firstObject]];


    return self;
}

#pragma mark - Public

- (void)setDefaultAcceptLanguage:(NSString *)identifier {

    [self.sessionManager setDefaultAcceptLanguage:identifier];
    [self.appSessionManager setDefaultAcceptLanguage:identifier];
    
}

- (void)fetchVenuesWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(id responseObject, NSError *error))completion {
    [self.appSessionManager fetchVenuesWithUsername:username password:password completion:completion];
}



@end
