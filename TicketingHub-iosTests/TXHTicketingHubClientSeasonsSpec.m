//
//  TXHTicketingHubClientSeasonsSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 15/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "OHHTTPStubs.h"
#import "TXHOption.h"
#import "TXHSeason.h"
#import "TXHTicketingHubClient.h"

SpecBegin(TXHTicketingHubClient_Seasons)

__block TXHTicketingHubClient *_client;

beforeEach(^{
    _client = [TXHTicketingHubClient sharedClient];
});

afterEach(^{
    [OHHTTPStubs removeAllRequestHandlers];
});


describe(@"Getting seasons for a venue", ^{
    context(@"with a successful request", ^{
        before(^{
            NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.lastPathComponent isEqualToString:@"seasons"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFile:@"seasonsForVenue99.json" statusCode:200 responseTime:0.0 headers:httpHeaders];
            }];
        });

        it(@"returns an array of seasons", ^AsyncBlock{
            [_client seasonsForVenueId:99 withCompletion:^(NSArray *seasons, NSError *error) {
                expect(error).to.beNil();
                expect([seasons count]).to.beGreaterThan(0);
                done();
            }];
        });
    });

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

    context(@"without a completion block", ^{
        it(@"raises an exception", ^{
            expect(^{
                [_client seasonsForVenueId:99 withCompletion:nil];
            }).to.raiseAny();
        });
    });

#pragma clang diagnostic pop

    context(@"with an unsuccessful request", ^{
        // 
    });

});


SpecEnd
