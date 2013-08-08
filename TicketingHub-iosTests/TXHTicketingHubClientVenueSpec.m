//
//  TXHTicketingHubClientVenueSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 08/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "OHHTTPStubs.h"
#import "TXHTicketingHubClient.h"
#import "TXHVenue.h"

SpecBegin(SPEC_NAME)

__block TXHTicketingHubClient *_client;

beforeEach(^{
    _client = [TXHTicketingHubClient sharedClient];
});

afterEach(^{
    [OHHTTPStubs removeAllRequestHandlers];
});

describe(@"venues for current user", ^{
    context(@"with a successful request", ^{
        before(^{
            NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.lastPathComponent isEqualToString:@"venues"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFile:@"venuesSuccess.json" statusCode:200 responseTime:0.0 headers:httpHeaders];
            }];
        });

        it(@"returns an array of venues", ^AsyncBlock{
            [_client venuesWithSuccess:^(NSArray *venues) {
                expect([venues isKindOfClass:[NSArray class]]).to.beTruthy();
                expect([venues count]).to.equal(2);
                done();

            } failure:^(NSHTTPURLResponse *response, NSError *error, id JSON) {
                expect(NO).to.beTruthy(); // This is expected to fail as we should not get here
                done();
            }];
        });
    });

    context(@"with an unsuccessful request", ^{
        //
    });
});


SpecEnd
