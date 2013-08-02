//
//  TXHTicketingHubClient.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 01/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

#import "_TXHNetworkClient.h"
#import "_TXHNetworkOAuthClient.h"

@interface TXHTicketingHubClient ()

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *refreshToken;
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

- (id)init {
    if (!(self = [super init])) {
        return nil; // Bail!
    }

    _oauthClient = [_TXHNetworkOAuthClient sharedClient];
    _networkClient = [_TXHNetworkClient sharedClient];

    return self;
}

@end
