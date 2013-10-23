//
//  TXHTicketingHubClient.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

@implementation TXHTicketingHubClient

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

//    _oauthClient = [_TXHNetworkOAuthClient sharedOAuthClient];
//    _networkClient = [_TXHNetworkClient sharedNetworkClient];
//    _activityIndicatorManager = [AFNetworkActivityIndicatorManager sharedManager];
//    _activityIndicatorManager.enabled = NO;

    return self;
}

@end
