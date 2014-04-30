//
//  ClientAvailabilitySpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 29/01/2014.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Expecta.h"
#import "Specta.h"
#import "OHHTTPStubs.h"

#import "TXHTicketingHubClient.h"

#import "TXHAvailability.h"
#import "TXHProduct.h"
#import "TestsHelper.h"

SpecBegin(ClientAvailability)

__block TXHTicketingHubClient *_client;
__block TXHProduct *_product;
__block NSDictionary *_standardHTTPHeaders;

before(^{
    _client = [[TXHTicketingHubClient alloc] initWithStoreURL:nil andBaseServerURL:nil];

    NSDictionary *dictionary = @{@"id": @"123",
                                 @"name": @"Product Name"};
    _product = [TXHProduct createWithDictionary:dictionary inManagedObjectContext:_client.managedObjectContext];
    [_client.managedObjectContext save:NULL];
    _standardHTTPHeaders = @{@"Content-Type" : @"application/json"};
});

after(^{
    _standardHTTPHeaders = nil;
    _product = nil;
    _client = nil;
});

describe(@"updating availabilities for a product", ^{
    context(@"with a new product and getting availabilities for a range", ^{
        __block __weak id<OHHTTPStubsDescriptor> _availibilityStub;

        context(@"where there are availabilities", ^{
            before(^{
                _availibilityStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.lastPathComponent isEqualToString:@"availability"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"AvailabilityDecember2013.json", nil) statusCode:200 headers:_standardHTTPHeaders];
                }];

                _availibilityStub.name = @"AvailabilityDecember2013.json";
            });

            after(^{
                [OHHTTPStubs removeStub:_availibilityStub];
            });

            it(@"should create the basic availabilities", ^{
                
            });
        });

        context(@"where there are no availabilities", ^{
            //
        });
    });
});

SpecEnd
