//
//  TXHTicketingHubClientUserSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "OHHTTPStubs.h"
#import "TXHTicketingHubClient.h"
#import "TXHUser.h"

SpecBegin(TXHTicketingHubClient_User)

__block TXHTicketingHubClient *_client;

beforeEach(^{
    _client = [TXHTicketingHubClient sharedClient];
});

afterEach(^{
    [OHHTTPStubs removeAllRequestHandlers];
});

describe(@"Get the current user", ^{
    context(@"with a successful request", ^{
        before(^{
            NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.lastPathComponent isEqualToString:@"user"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFile:@"user.json" statusCode:200 responseTime:0.0 headers:httpHeaders];
            }];
        });

        it(@"returns a TXHUser object configured with the response", ^AsyncBlock{
            [_client userInformationSuccess:^(TXHUser *returnedUser) {
                expect(returnedUser).toNot.beNil();
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
