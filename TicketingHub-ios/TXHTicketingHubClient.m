//
//  TXHTicketingHubClient.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 01/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

static NSString * const kTokenEndpoint = @"token";

#import "TXHTicketingHubClient.h"

#import "_TXHNetworkClient.h"
#import "_TXHNetworkOAuthClient.h"
#import "AFNetworking.h"

@interface TXHTicketingHubClient ()

@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *refreshToken;
@property (copy, nonatomic) NSString *clientId;
@property (copy, nonatomic) NSString *clientSecret;
@property (strong, readonly, nonatomic) _TXHNetworkOAuthClient *oauthClient;
@property (strong, readonly, nonatomic) _TXHNetworkClient *networkClient;

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

    return self;
}

#pragma mark - Public methods

- (void)setDefaultAcceptLanguage:(NSString *)identifier {
    // Just pass it on to the actual network clients
    [self.networkClient setDefaultHeader:@"Accept-Language" value:identifier];
    [self.oauthClient setDefaultHeader:@"Accept-Language" value:identifier];
}

- (void)configureWithUsername:(NSString *)username password:(NSString *)password clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response))successBlock error:(void(^)(NSHTTPURLResponse *response, NSError *error, id JSON))errorBlock {

    NSDictionary *parameters = @{@"username" : username,
                                 @"password" : password,
                                 @"client_id" : clientId,
                                 @"client_secret" : clientSecret,
                                 @"grant_type" : @"password"};

    NSMutableURLRequest *request = [self.oauthClient requestWithMethod:@"POST" path:kTokenEndpoint parameters:parameters];
    AFJSONRequestOperation *requestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary* responseObject) {
        if (successBlock) {
            self.token = responseObject[@"access_token"];
            self.refreshToken = responseObject[@"refresh_token"];
            self.clientId = clientId;
            self.clientSecret = clientSecret;
            successBlock(request, response);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSDictionary *responseObject) {
        if (errorBlock) {
            self.token = nil;
            self.refreshToken = nil;
            self.clientId = nil;
            self.clientSecret = nil;
            errorBlock(response, error, responseObject);
        }
    }];

    [requestOperation start];
}

- (void)userInformationSuccess:(void(^)(TXHUser *user))successBlock error:(void(^)(NSHTTPURLResponse *response, NSError *error, id JSON))errorBlock {

    
}

#pragma mark - custom accessors

- (void)setToken:(NSString *)token {
    _token = token;
    [self.networkClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", token]];
}


@end
