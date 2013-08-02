//
//  TXHTicketingHubClient_tests.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 01/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Tests for the general interface of the TXHTicketingHubClient class

#import <XCTest/XCTest.h>

#import "TXHTicketingHubClient.h"

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
    XCTAssertEqualObjects(self.client, newClient, @"There should only be one instance of the client");
}

@end
