//
//  FetchVenuesSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 01/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

#import "OHHTTPStubs.h"
#import "TXHVenue.h"

SpecBegin(FetchVenues)

__block TXHTicketingHubClient *_client;

beforeAll(^{
    [OHHTTPStubs setEnabled:YES forSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        NSLog(@"\n\nStub activation for Request %@\nstub %@\nAll Stubs %@\n\n", request, stub, [OHHTTPStubs allStubs]);
    }];
    _client = [TXHTicketingHubClient new];
});

afterAll(^{
    _client = nil;
});

describe(@"when fetching venues for a specific user", ^{

    context(@"with the correct user name and password", ^{

        context(@"where venues are available", ^{
            __block __weak id<OHHTTPStubsDescriptor> _successStub;

            beforeAll(^{
                NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

                _successStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.lastPathComponent isEqualToString:@"venues"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"VenuesSuccess.json", nil) statusCode:200 headers:httpHeaders];
                }];
                _successStub.name = @"Success stub";
            });

            afterAll(^{
                [OHHTTPStubs removeStub:_successStub];
            });

            it(@"returns an array of venues, and no error object", ^AsyncBlock{
                [_client fetchVenuesWithUsername:@"username" password:@"password" completion:^(id responseObject, NSError *error) {
                    expect(responseObject).to.beTruthy();
                    expect(error).to.beNil();

                    expect(responseObject).to.beKindOf([NSArray class]);
                    expect(responseObject).to.haveCountOf(2);
                    expect([responseObject firstObject]).to.beKindOf([TXHVenue class]);
                    done();
                }];

            });


        });

        context(@"where there are no venues available", ^{
            __block __weak id<OHHTTPStubsDescriptor> _emptyStub;

            before(^{
                NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

                _emptyStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return [request.URL.lastPathComponent isEqualToString:@"venues"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"VenuesEmpty.json", nil) statusCode:200 headers:httpHeaders];
                }];
                _emptyStub.name = @"Empty stub";
            });

            after(^{
                [OHHTTPStubs removeStub:_emptyStub];
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
