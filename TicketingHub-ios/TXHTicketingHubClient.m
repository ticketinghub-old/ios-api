//
//  TXHTicketingHubClient.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 01/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

#import "AFNetworking.h"
#import "TXHOption.h"
#import "TXHSeason.h"
#import "TXHUser.h"
#import "TXHVariation.h"
#import "TXHVenue.h"
#import "_TXHNetworkClient.h"
#import "_TXHNetworkOAuthClient.h"

@interface TXHTicketingHubClient ()

@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *refreshToken;
@property (copy, nonatomic) NSString *clientId;
@property (copy, nonatomic) NSString *clientSecret;
@property (readonly, nonatomic) _TXHNetworkOAuthClient *oauthClient;
@property (readonly, nonatomic) _TXHNetworkClient *networkClient;
@property (readonly, nonatomic) AFNetworkActivityIndicatorManager *activityIndicatorManager;

@end

@implementation TXHTicketingHubClient

@synthesize oauthClient = _oauthClient;
@synthesize networkClient = _networkClient;
@synthesize activityIndicatorManager = _activityIndicatorManager;

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

    _oauthClient = [_TXHNetworkOAuthClient sharedOAuthClient];
    _networkClient = [_TXHNetworkClient sharedNetworkClient];
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

- (void)configureWithUsername:(NSString *)username password:(NSString *)password clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret completion:(void(^)(id JSON, NSError *error))completionBlock {
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

            if (completionBlock) {
                completionBlock(nil, nil);
            }

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *responseObject) {
            self.token = nil;
            self.refreshToken = nil;
            self.clientId = nil;
            self.clientSecret = nil;

            if (completionBlock) {
                completionBlock(responseObject, error);
            }
        }];
        
        [requestOperation start];
}

- (void)userInformationWithCompletion:(void (^)(TXHUser *user, NSError *error))completionBlock {
    NSParameterAssert(completionBlock); // No point running this if you aren't going to handle the response

    void(^localCompletionBlock)(NSArray *responseArray, NSError *error) = ^(NSArray *responseArray, NSError *error){
        if (error) {
            completionBlock(nil, error);
            return;
        }

        TXHUser *user = [TXHUser createWithDictionary:responseArray[0]];
        completionBlock(user, nil);
    };

    [self genericGetRequestWithEndpoint:kUserEndpoint parameters:nil completion:localCompletionBlock];
}

- (void)venuesWithCompletion:(void (^)(NSArray *, NSError *))completionBlock {
    NSParameterAssert(completionBlock);

    void(^localCompletionBlock)(NSArray *responseArray, NSError *error) = ^(NSArray *responseArray, NSError *error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }

        NSMutableArray *venues = [NSMutableArray arrayWithCapacity:[responseArray count]];

        [responseArray enumerateObjectsUsingBlock:^(NSDictionary *venueDictionary, NSUInteger idx, BOOL *stop) {
            TXHVenue *venue = [TXHVenue createWithDictionary:venueDictionary];
            [venues addObject:venue];
        }];

        completionBlock(venues, nil);
    };

    [self genericGetRequestWithEndpoint:kVenuesEndpoint parameters:nil completion:localCompletionBlock];
}

- (void)seasonsForVenueId:(NSUInteger)venueId withCompletion:(void (^)(NSArray *, NSError *))completionBlock {
    NSParameterAssert(completionBlock);
    
    NSString *endpoint = [NSString stringWithFormat:@"%@/%d/%@", kVenuesEndpoint, venueId, kSeasonsEndpoint];

    void(^localCompletionBlock)(NSArray *responseArray, NSError *error) = ^(NSArray *responseArray, NSError *error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }

        NSMutableArray *seasons = [NSMutableArray arrayWithCapacity:[responseArray count]];

        [responseArray enumerateObjectsUsingBlock:^(NSDictionary *seasonDictionary, NSUInteger idx, BOOL *stop) {
            TXHVenue *venue = [TXHVenue createWithDictionary:seasonDictionary];
            [seasons addObject:venue];
        }];

        completionBlock(seasons, nil);
    };

    [self genericGetRequestWithEndpoint:endpoint parameters:nil completion:localCompletionBlock];
}

- (void)variationsForVenueId:(NSUInteger)venueId withCompletion:(void (^)(NSArray *, NSError *))completionBlock {
    NSParameterAssert(completionBlock);
    
    NSString *endpoint = [NSString stringWithFormat:@"%@/%d/%@", kVenuesEndpoint, venueId, kVariationsEndpoint];

    void(^localCompletionBlock)(NSArray *responseArray, NSError *error) = ^(NSArray *responseArray, NSError *error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }

        NSMutableArray *variations = [NSMutableArray arrayWithCapacity:[responseArray count]];

        [responseArray enumerateObjectsUsingBlock:^(NSDictionary *variationDictionary, NSUInteger idx, BOOL *stop) {
            TXHVariation *variation = [TXHVariation createWithDictionary:variationDictionary];
            [variations addObject:variation];
        }];

        completionBlock(variations, nil);
    };

    [self genericGetRequestWithEndpoint:endpoint parameters:nil completion:localCompletionBlock];

}

- (void)availabilityForVenueId:(NSUInteger)venueId from:(NSString *)fromDateString to:(NSString *)toDateString withCompletion:(void (^)(NSDictionary *, NSError *))completionBlock {
    NSParameterAssert(completionBlock);

    NSString *endpoint = [NSString stringWithFormat:@"%@/%d/%@", kVenuesEndpoint, venueId, kAvailabilityEndpoint];
    NSDictionary *parameters = @{@"from" : fromDateString, @"to" : toDateString};

    void(^localCompletionBlock)(NSArray *responseArray, NSError *error) = ^(NSArray *responseArray, NSError *error) {
        if (error) {
            completionBlock(nil, error);
            return;
        }

        completionBlock(responseArray[0], nil);
    };

    [self genericGetRequestWithEndpoint:endpoint parameters:parameters completion:localCompletionBlock];
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
- (void)refreshAccessTokenSuccess:(void(^)(void))successBlock failure:(void(^)(NSError *error))failureBlock {
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

// private methods for get requests
- (void)genericGetRequestWithEndpoint:(NSString *)endPoint parameters:(NSDictionary *)parameters completion:(void(^)(NSArray *array, NSError *error))completionBlock {
    NSMutableURLRequest *genericRequest = [self.networkClient requestWithMethod:@"GET" path:endPoint parameters:parameters];

    AFJSONRequestOperation *genericRequestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:genericRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseObject = @[responseObject];
        }

        if (completionBlock) {
            completionBlock(responseObject, nil);
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            responseObject = @[responseObject];
        }

        if (completionBlock) {
            completionBlock(responseObject, error);
        }

    }];

    [genericRequestOperation start];
}

@end
