//
//  FetchSeasonsSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 07/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND
#import "Specta.h"
#import "Expecta.h"
#import "OHHTTPStubs.h"

#import "TXHTicketingHubClient.h"
#import "TXHSeason.h"

SpecBegin(FetchSeasons)

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

describe(@"when fetching seasons for a venue", ^{
    context(@"With the correct token", ^{
        context(@"where seasons are available", ^{
            __block __weak id<OHHTTPStubsDescriptor> _successStub;

            beforeAll(^{
                NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

                _successStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                    return [request.URL.lastPathComponent isEqualToString:@"seasons"];
                } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"Seasons.json", nil) statusCode:200 headers:httpHeaders];
                }];
                _successStub.name = @"stub with seasons";
            });

            afterAll(^{
                [OHHTTPStubs removeStub:_successStub];
            });

            it(@"returns an array of seasons with no error", ^AsyncBlock{
                [_client fetchSeasonsForVenueToken:@"abcdefg" completion:^(NSArray *seasons, NSError *error) {
                    expect(seasons).to.beKindOf([NSArray class]);
                    expect(seasons).to.haveCountOf(2);
                    expect([seasons firstObject]).to.beKindOf([TXHSeason class]);
                    expect(error).to.beNil();

                    done();
                }];
            });
        });
    });
});

SpecEnd
