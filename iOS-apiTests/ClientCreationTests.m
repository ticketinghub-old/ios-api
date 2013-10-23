//
//  ClientCreationTests.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import XCTest;

#import "TXHTicketingHubClient.h"

@interface ClientCreationTests : XCTestCase

@property (strong, nonatomic) TXHTicketingHubClient *client;

@end

@implementation ClientCreationTests


- (void)setUp {
    [super setUp];
    self.client = [TXHTicketingHubClient sharedClient];
}

- (void)tearDown {
    self.client = nil;
    [super tearDown];
}

- (void) testSingletonCreation {
    TXHTicketingHubClient *secondClient = [TXHTicketingHubClient sharedClient];
    XCTAssertTrue(secondClient == self.client, @"There should only be one client instance");
}



@end
