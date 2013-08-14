//
//  TXHTicketingHubClient.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 01/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

#import "AFNetworking.h"
#import "TXHSeason.h"
#import "TXHSeasonalOption.h"
#import "TXHUser.h"
#import "TXHVenue.h"
#import "_TXHNetworkClient.h"
#import "_TXHNetworkOAuthClient.h"

@interface TXHTicketingHubClient ()

@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *refreshToken;
@property (copy, nonatomic) NSString *clientId;
@property (copy, nonatomic) NSString *clientSecret;
@property (strong, readonly, nonatomic) _TXHNetworkOAuthClient *oauthClient;
@property (strong, readonly, nonatomic) _TXHNetworkClient *networkClient;
@property (strong, readonly, nonatomic) AFNetworkActivityIndicatorManager *activityIndicatorManager;

@end

@implementation TXHTicketingHubClient

#pragma mark - Class methods

+ (instancetype)sharedClient {
    static TXHTicketingHubClient *client = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc] init];
    });

    return client;
}

#pragma mark - Set up and tear down

- (id)init {
    if (!(self = [super init])) {
        return nil; // Bail!
    }

    _oauthClient = [_TXHNetworkOAuthClient sharedClient];
    _networkClient = [_TXHNetworkClient sharedClient];
    _activityIndicatorManager = [AFNetworkActivityIndicatorManager sharedManager];
    _activityIndicatorManager.enabled = NO;

    return self;
}

#pragma mark - Public methods

- (void)setDefaultAcceptLanguage:(NSString *)identifier {
    // Just pass it on to the actual network clients
    [self.networkClient setDefaultHeader:@"Accept-Language" value:identifier];
    [self.oauthClient setDefaultHeader:@"Accept-Language" value:identifier];
}

- (void)configureWithUsername:(NSString *)username password:(NSString *)password clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response))successBlock failure:(void(^)(NSHTTPURLResponse *response, NSError *error, id JSON))failureBlock {

    NSDictionary *parameters = @{@"username" : username,
                                 @"password" : password,
                                 @"client_id" : clientId,
                                 @"client_secret" : clientSecret,
                                 @"grant_type" : @"password"};

    NSMutableURLRequest *tokenRequest = [self.oauthClient requestWithMethod:@"POST" path:kOAuthTokenEndpoint parameters:parameters];
    AFJSONRequestOperation *requestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:tokenRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* responseObject) {
        self.token = responseObject[@"access_token"];
        self.refreshToken = responseObject[@"refresh_token"];
        self.clientId = clientId;
        self.clientSecret = clientSecret;

        if (successBlock) {
            successBlock(request, response);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *responseObject) {
        self.token = nil;
        self.refreshToken = nil;
        self.clientId = nil;
        self.clientSecret = nil;

        if (failureBlock) {
            failureBlock(response, error, responseObject);
        }
    }];

    [requestOperation start];
}

- (void)userInformationSuccess:(void(^)(TXHUser *user))successBlock failure:(void(^)(NSHTTPURLResponse *response, NSError *error, id JSON))failureBlock {
    NSMutableURLRequest *userRequest = [self.networkClient requestWithMethod:@"GET" path:kUserEndpoint parameters:nil];

    AFJSONRequestOperation *userRequestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:userRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *responseDictionary) {
        TXHUser *returnedUser = [TXHUser createWithDictionary:responseDictionary];

        if (successBlock) {
            successBlock(returnedUser);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Do something here
        if (failureBlock) {
            failureBlock(response, error, JSON);
        }

    }];

    [userRequestOperation start];
    
}

- (void)venuesWithSuccess:(void (^)(NSArray *))successBlock failure:(void (^)(NSHTTPURLResponse *response, NSError *error, id JSON))failureBlock {
    NSMutableURLRequest *venuesRequest = [self.networkClient requestWithMethod:@"GET" path:kVenuesEndpoint parameters:nil];

    AFJSONRequestOperation *venuesRequestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:venuesRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSArray *responseArray) {
        NSMutableArray *venues = [NSMutableArray arrayWithCapacity:[responseArray count]];

        [responseArray enumerateObjectsUsingBlock:^(NSDictionary *venueDictionary, NSUInteger idx, BOOL *stop) {
            TXHVenue *venue = [TXHVenue createWithDictionary:venueDictionary];
            [venues addObject:venue];
        }];

        if (successBlock) {
            successBlock([venues copy]);
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // Do something here
        if (failureBlock) {
            failureBlock(response, error, JSON);
        }
    }];

    [venuesRequestOperation start];
}

- (void)seasonsForVenueId:(NSUInteger)venueId withSuccess:(void (^)(NSArray *))successBlock failure:(void (^)(NSHTTPURLResponse *, NSError *, id))failureBlock {
    
}

- (void)variationsForVenueId:(NSUInteger)venueID withSuccess:(void (^)(NSArray *))successBlock failure:(void (^)(NSHTTPURLResponse *, NSError *, id))failureBlock {
    
}

#pragma mark - custom accessors

- (void)setToken:(NSString *)token {
    _token = token;
    [self.networkClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", token]];
}

- (void)setShowActivityIndicatorAutomatically:(BOOL)showActivityIndicatorAutomatically {
    _showActivityIndicatorAutomatically = showActivityIndicatorAutomatically;
    self.activityIndicatorManager.enabled = showActivityIndicatorAutomatically;
}

#pragma mark - Private methods

// Part of the private API as it isn't something that the the consumer of the library needs to do.
// The success and failure blocks are simple, as this is a private method it knows more about what needs to be done.
- (void)refreshAccessTokenSucess:(void(^)(void))successBlock failure:(void(^)(NSError *error))failureBlock {
    // Make two attempts to use the refresh token to get a new access token, and if that fails, return an error

    // The success block is the same in both cases, but there are two failure blocks, the first fires the request again, the second bails.
    void(^internalSuccessBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* responseObject) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* responseObject) {
        self.token = responseObject[@"access_token"];
        self.refreshToken = responseObject[@"refresh_token"];

        if (successBlock) {
            successBlock();
        }
    };

    void(^secondInternalFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *responseObject) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *responseObject) {
        self.token = nil;
        self.refreshToken = nil;

        if (failureBlock) {
            failureBlock(error);
        }
    };

    void(^firstInternalFailureBlock)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *responseObject) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *responseObject) {
        // second attempt
        AFJSONRequestOperation *secondRequestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:internalSuccessBlock failure:secondInternalFailureBlock];

        [secondRequestOperation start];

    };

    NSDictionary *parameters = @{@"grant_type" : @"refresh_token",
                                 @"client_id" : self.clientId,
                                 @"client_secret" : self.clientSecret,
                                 @"refresh_token" : self.refreshToken};

    NSMutableURLRequest *refreshTokenRequest = [self.oauthClient requestWithMethod:@"POST" path:kOAuthTokenEndpoint parameters:parameters];

    AFJSONRequestOperation *firstRequestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:refreshTokenRequest success:internalSuccessBlock failure:firstInternalFailureBlock];

    [firstRequestOperation start];

}

@end
