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
            [_client venuesWithCompletion:^(NSArray *venues, NSError *error) {
                expect(error).to.beNil();
                expect([venues isKindOfClass:[NSArray class]]).to.beTruthy();
                expect([venues count]).to.equal(2);
                done();
            }];
        });
    });

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

    context(@"without a completion block", ^{
        it(@"raises an exception", ^{
            expect(^{
                [_client venuesWithCompletion:nil];
            }).to.raiseAny();
        });
    });
    
#pragma clang diagnostic pop

    context(@"with an unsuccessful request", ^{
        //
    });
});


SpecEnd
