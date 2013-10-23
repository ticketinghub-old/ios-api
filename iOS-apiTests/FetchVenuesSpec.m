//
//  FetchVenuesSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 01/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"
#import "OHHTTPStubs.h"

SpecBegin(Fetch_Venues)

__block TXHTicketingHubClient *_client;

describe(@"when fetching venues for a specific user", ^{
    before(^{
        _client = [TXHTicketingHubClient sharedClient];
    });

    afterEach(^{
        [OHHTTPStubs removeAllStubs];
    });

    context(@"with the correct user name and password", ^{

        context(@"where venues are available", ^{
            beforeAll(^{
                NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.lastPathComponent isEqualToString:@"venues"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"VenuesSuccess.json", [NSBundle bundleForClass:[self class]]) statusCode:200 headers:httpHeaders];
                }];
            });

            it(@"returns an array of venues, an no error object", ^AsyncBlock{
                [_client fetchVenuesWithUsername:@"username" password:@"password" completion:^(id responseObject, NSError *error) {
                    expect(responseObject).to.beTruthy();
                    expect(error).to.beNil();
                    done();
                }];
            });

        });

        context(@"where there are no venues available", ^{

            beforeAll(^{
                NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.lastPathComponent isEqualToString:@"venues"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"VenuesEmpty.json", nil) statusCode:200 headers:httpHeaders];
                }];
            });

            it(@"returns nil with TXHAPIErrorNoVenues error object", ^AsyncBlock{
                [_client fetchVenuesWithUsername:@"username" password:@"password" completion:^(id responseObject, NSError *error) {
                    expect(responseObject).to.beNil();
                    expect(error).toNot.beNil();
                    expect(error.domain).to.equal(TXHAPIErrorDomain);
                    expect(error.code).to.equal(TXHAPIErrorNoVenues);
                    expect([error localizedDescription]).toNot.beNil();
                    done();
                }];
            });

        });
    });
});

SpecEnd
