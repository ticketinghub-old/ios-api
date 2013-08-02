//
//  _TXHNetworkClient.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 02/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  An AFHTTPClient subclass that performs the actual communication with the TicktetingHub server

static NSString * const kTicketingHubAPIURL = @"https://api.ticketinghub.com/";

#import "_TXHNetworkClient.h"

#import "AFNetworking.h"

@implementation _TXHNetworkClient

+ (instancetype)sharedClient {
    static _TXHNetworkClient *client = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc] initWithBaseURL:[NSURL URLWithString:kTicketingHubAPIURL]];
    });

    return client;
}

- (id)initWithBaseURL:(NSURL *)url {
    if (!(self = [super initWithBaseURL:[NSURL URLWithString:kTicketingHubAPIURL]])) {
        return nil; // Bail!
    }

    // Expect responses to be JSON
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setDefaultHeader:@"Accept-Language" value:[[NSLocale preferredLanguages] firstObject]];

    // The body is JSON formatted.
    self.parameterEncoding = AFJSONParameterEncoding;

    return self;
}

@end
