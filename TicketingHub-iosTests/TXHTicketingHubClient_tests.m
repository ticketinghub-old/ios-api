//
//  TXHTicketingHubClient_tests.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 01/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Tests for the general interface of the TXHTicketingHubClient class

#import <XCTest/XCTest.h>

#import "AFNetworking.h"
#import "TXHTicketingHubClient.h"
#import "_TXHNetworkClient.h"
#import "_TXHNetworkOAuthClient.h"

@interface TXHTicketingHubClient (PrivateMethodes)

- (_TXHNetworkOAuthClient *)oauthClient;
- (_TXHNetworkClient *)networkClient;

@end

@interface TXHTicketingHubClient_tests : XCTestCase

@property TXHTicketingHubClient *client;

@end

@implementation TXHTicketingHubClient_tests

- (void)setUp {
    self.client = [TXHTicketingHubClient sharedClient];
}

- (void)tearDown {
}

- (void)testClientIsASingleton {
    XCTAssert(self.client, @"We should be able to create the client");
    TXHTicketingHubClient *newClient = [TXHTicketingHubClient sharedClient];
    XCTAssertTrue(self.client == newClient, @"There should only be one instance of the client");
}

- (void)testInitialisedNetworkClient {
    _TXHNetworkClient *networkClient = [self.client networkClient];

    XCTAssertNotNil(networkClient, @"There should be a network client");
    XCTAssertNotNil([(AFHTTPClient *)networkClient defaultValueForHeader:@"Accept-Language"], @"There should be a default language header");
    XCTAssertEqualObjects([(AFHTTPClient *)networkClient defaultValueForHeader:@"Accept"], @"application/json", @"Accept header should be application/json");
}

- (void)testInitialisedOAuthClient {
    _TXHNetworkOAuthClient *oauthClient = [self.client oauthClient];

    XCTAssertNotNil([(AFHTTPClient *)oauthClient defaultValueForHeader:@"Accept-Language"], @"There should be a default language header");
    XCTAssertEqualObjects([(AFHTTPClient *)oauthClient defaultValueForHeader:@"Accept"], @"application/json", @"Accept header should be application/json");
}

@end
