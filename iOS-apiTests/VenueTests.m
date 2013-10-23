//
//  VenueTests.m
//  iOS-api
//
//  Created by Abizer Nasir on 25/10/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import XCTest;

#import "TXHVenue.h"

@interface VenueTests : XCTestCase

@property (strong, readonly, nonatomic) NSArray *responseObject;
@property (strong, readonly, nonatomic) NSDictionary *venueDictionary;

@end

@implementation VenueTests

- (void)setUp {
    [super setUp];

}

- (void)tearDown {

    [super tearDown];
}

- (void) testVenueCreationConvenienceMethod {
    TXHVenue *venue = [TXHVenue createWithDictionary:self.venueDictionary];
    XCTAssertNotNil(venue, @"Should be created from the dictionary");
    XCTAssertTrue(venue.venueId == 5, @"venueId should be 5 not %d", venue.venueId);
    XCTAssertEqualObjects(venue.venueName, @"My Second Venue", @"venueName should be 'My Second Venue' not %@", venue.venueName);
    XCTAssertEqualObjects(venue.currency, @"GBP", @"Currency should be set");
    XCTAssertEqualObjects(venue.timeZoneName, @"UTC", @"Time zone should be set");
    XCTAssertEqualObjects(venue.token, @"at~ETmbU67N2VI97PXx-_1gIw", @"Token should be set");

}

- (void) testVenueCreationWithEmptyResult {
    TXHVenue *venue = [TXHVenue createWithDictionary:self.emptyVenueDictionary];
    XCTAssertNil(venue, @"Should return a nil object");
}

#pragma mark - Helpers

- (NSArray *)responseObject {
    static NSArray *responseObject = nil;

    if (!responseObject) {
        NSBundle *testsBundle = [NSBundle bundleForClass:[self class]];
        NSURL *fileURL = [testsBundle URLForResource:@"VenuesSuccess" withExtension:@"json"];
        NSData *responseData = [NSData dataWithContentsOfURL:fileURL];
        responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    }

    return responseObject;
}

- (NSArray *)emptyResponseObject {
    static NSArray *responseObject = nil;

    if (!responseObject) {
        NSBundle *testsBundle = [NSBundle bundleForClass:[self class]];
        NSURL *fileURL = [testsBundle URLForResource:@"VenuesEmpty" withExtension:@"json"];
        NSData *responseData = [NSData dataWithContentsOfURL:fileURL];
        responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    }

    return responseObject;
}

- (NSDictionary *)venueDictionary {
    static NSDictionary *venueDictionary = nil;
    if (!venueDictionary) {
        venueDictionary = [self.responseObject firstObject];
    }

    return venueDictionary;
}

- (NSDictionary *)emptyVenueDictionary {
    static NSDictionary *venueDictionary = nil;
    if (!venueDictionary) {
        venueDictionary = [self.emptyResponseObject firstObject];
    }

    return venueDictionary;
}

@end
