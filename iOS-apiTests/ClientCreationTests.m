//
//  ClientCreationTests.m
//  iOS-api
//
//  Created by Abizer Nasir on 23/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import XCTest;

#import "TXHTicketingHubClient.h"

#import "_TXHAPISessionManager.h"
#import "_TXHAppSessionManager.h"

// Expose internal properties of TXHTicketingHubClient

@interface TXHTicketingHubClient (TXHTesting)

@property (strong, nonatomic) _TXHAPISessionManager *sessionManager;
@property (strong, nonatomic) _TXHAppSessionManager *appSessionManager;

@end

@interface ClientCreationTests : XCTestCase

@property (strong, nonatomic) TXHTicketingHubClient *client;

@end

@implementation ClientCreationTests

#pragma mark - Set up and tear down

- (void)setUp {
    [super setUp];
    self.client = [TXHTicketingHubClient sharedClient];
    [self.client setDefaultAcceptLanguage:[[NSLocale preferredLanguages] firstObject]];
}

- (void)tearDown {
    self.client = nil;
    [super tearDown];
}

#pragma mark - Tests

- (void) testSingletonCreation {
    TXHTicketingHubClient *secondClient = [TXHTicketingHubClient sharedClient];

    XCTAssertTrue(secondClient == self.client, @"There should only be one client instance");
    XCTAssertTrue(secondClient.sessionManager == self.client.sessionManager, @"There should only be one session manager");
    XCTAssertTrue(secondClient.appSessionManager == self.client.appSessionManager, @"There should only be one venues request manager");
}

- (void) testBaseURLs {
    XCTAssertEqualObjects([NSURL URLWithString:@"https://api.ticketinghub.com/"], [self sessionManager].baseURL, @"Correct Base URL has not been set");
    XCTAssertEqualObjects([NSURL URLWithString:@"https://mpos.th-apps.com/"], [self appSessionManager].baseURL, @"Correct Base URL has not been set");
}

- (void) testAPISessionManagerIsSetUpForJSON {
    id requestSerialiser = [self sessionManager].requestSerializer;
    id responseSerialiser = [self sessionManager].responseSerializer;

    XCTAssertTrue([requestSerialiser isKindOfClass:[AFJSONRequestSerializer class]], @"Should have an AFJSONRequestSerializer instead of an %@", NSStringFromClass([requestSerialiser class]));

    XCTAssertTrue([responseSerialiser isKindOfClass:[AFJSONResponseSerializer class]], @"Should have an AFJSONResponseSerializer instead of an %@", NSStringFromClass([responseSerialiser class]));
}

- (void) testVenuesRequestSessionManagerIsSetUpForJSON {
    id requestSerialiser = [self appSessionManager].requestSerializer;
    id responseSerialiser = [self appSessionManager].responseSerializer;

    XCTAssertTrue([requestSerialiser isKindOfClass:[AFJSONRequestSerializer class]], @"Should have an AFJSONRequestSerializer instead of an %@", NSStringFromClass([requestSerialiser class]));

    XCTAssertTrue([responseSerialiser isKindOfClass:[AFJSONResponseSerializer class]], @"Should have an AFJSONResponseSerializer instead of an %@", NSStringFromClass([responseSerialiser class]));
}

- (void) testAcceptLanguagePassedThroughToActualClients {
    [self.client setDefaultAcceptLanguage:@"el-GR"];

    NSString *apiSessionManagerAcceptLanguage = [self sessionManager].requestSerializer.HTTPRequestHeaders[@"Accept-Language"];
    NSString *venuesRequestManagerAcceptLanguage = [self appSessionManager].requestSerializer.HTTPRequestHeaders[@"Accept-Language"];

    XCTAssertEqual(apiSessionManagerAcceptLanguage, @"el-GR", @"Should be 'el-GR' not %@", apiSessionManagerAcceptLanguage);
    XCTAssertEqual(venuesRequestManagerAcceptLanguage, @"el-GR", @"Should be 'el-GR' not %@", venuesRequestManagerAcceptLanguage);

}

#pragma mark - Test helpers

- (_TXHAPISessionManager *)sessionManager {
    return self.client.sessionManager;
}

- (_TXHAppSessionManager *)appSessionManager {
    return self.client.appSessionManager;
}



@end
