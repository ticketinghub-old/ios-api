//
//  _TXHNetworkOAuthClient.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

static NSString * const kTicktetingHubOAuthURL = @"https://api.ticketinghub.com/oauth/";

#import "_TXHNetworkOAuthClient.h"
#import "AFNetworking.h"

@implementation _TXHNetworkOAuthClient

+ (instancetype)sharedClient {
    static _TXHNetworkOAuthClient *client = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc] initWithBaseURL:[NSURL URLWithString:kTicktetingHubOAuthURL]];
    });

    return client;
}

- (id)initWithBaseURL:(NSURL *)url {
    if (!(self = [super initWithBaseURL:url])) {
        return nil;
    }

    // Expect responses to be JSON
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];


    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Accept-Language" value:[[NSLocale preferredLanguages] firstObject]];

    // The body is JSON formatted.
    [self setParameterEncoding:AFJSONParameterEncoding];

    // a 401 has a specific meaning


    return self;
}

@end
