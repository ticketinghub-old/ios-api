//
//  TXHTicketingHubAvailabilitySpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 21/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "OHHTTPStubs.h"
#import "TXHTicketingHubClient.h"

SpecBegin(TXHTicketingHubAvailabilitySpec)

__block TXHTicketingHubClient *_client;

beforeEach(^{
    _client = [TXHTicketingHubClient sharedClient];
});

afterEach(^{
    [OHHTTPStubs removeAllRequestHandlers];
});

describe(@"Availability for for a venue", ^{
    context(@"with a successful request", ^{
        before(^{
            NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.lastPathComponent isEqualToString:@"availability"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFile:@"availabilityForVenue99.json" statusCode:200 responseTime:0.0 headers:httpHeaders];
            }];
        });

        it(@"returns a dictionary contaning list of unavailable dates", ^AsyncBlock{
            [_client availabilityForVenueId:99 from:@"2013-07-01" to:@"2013-12-12" withCompletion:^(NSDictionary *unavailableDates, NSError *error) {
                expect(error).to.beNil();
                expect([unavailableDates count]).to.equal(2);
                expect([unavailableDates[@"unavailable"] count]).to.equal(148);
                expect([unavailableDates[@"sold_out"] count]).to.equal(1);
                done();
            }];
        });
    });

    context(@"without a completion block", ^{
        // Not testing the date parameters, as that is covered by the server.
        it(@"throws an exception", ^{
            expect(^{
                [_client availabilityForVenueId:99 from:@"2013-07-01" to:@"2013-12-12" withCompletion:nil];
            }).to.raiseAny();
        });
    });
    
});



SpecEnd
