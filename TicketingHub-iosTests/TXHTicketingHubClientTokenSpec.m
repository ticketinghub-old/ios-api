//
//  TXHTicketingHubClientTokenSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Test for getting and refreshing the access tokens

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "AFNetworking.h"
#import "OHHTTPStubs.h"
#import "TXHTicketingHubClient.h"
#import "_TXHNetworkClient.h"

@interface TXHTicketingHubClient (PrivateMethods)

// Expose non-public interface
- (NSString *)token;
- (NSString *)refreshToken;
- (NSString *)clientId;
- (NSString *)clientSecret;
- (_TXHNetworkClient *)networkClient;

@end

SpecBegin(TXHTicketingHubClient_Token)

__block TXHTicketingHubClient *_client;

beforeEach(^{
    _client = [TXHTicketingHubClient sharedClient];
});

afterEach(^{
    [OHHTTPStubs removeAllRequestHandlers];
});

describe(@"configuring the shared client with OAuth parameters", ^{
    // These are dummy parameters, the response is stubbed.
    NSString * const _username = @"username";
    NSString * const _password = @"password";
    NSString * const _clientId = @"abcdefg";
    NSString * const _clientSecret = @"hijklmn";

    afterEach(^{
        [OHHTTPStubs removeAllRequestHandlers];
    });

    context(@"with correct parameters", ^{

        beforeEach(^{
            NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                // Only deal with the token endpoint
                return [request.URL.lastPathComponent isEqualToString:@"token"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFile:@"tokenSuccess.json" statusCode:200 responseTime:0.0 headers:httpHeaders];
            }];
        });

        it(@"stores information that is need later", ^AsyncBlock{
            [_client configureWithUsername:_username password:_password clientId:_clientId clientSecret:_clientSecret success:^(NSURLRequest *request, NSHTTPURLResponse *response) {
                expect([_client token]).to.equal(@"bd0fbf8ee4da7472c382c28e7f7b9977cd6768dcadd7b9328a84a5bd5e7e9b5e");
                expect([_client refreshToken]).to.equal(@"0e6314d94b3eac772d571c8da04bdeb2d1cb3ace71487672bd54e83e968681a3");
                expect([_client clientId]).to.equal(_clientId);
                expect([_client clientSecret]).to.equal(_clientSecret);
                done();

            } error:^(NSHTTPURLResponse *response, NSError *error, id JSON) {
                expect(NO).will.beTruthy(); // We shouldn't call the error block in this case.
                done();
            }];

        });

        it(@"sets the authorisation header correctly with the access token", ^AsyncBlock{
            [_client configureWithUsername:_username password:_password clientId:_clientId clientSecret:_clientSecret success:^(NSURLRequest *request, NSHTTPURLResponse *response) {
                expect([[_client networkClient] defaultValueForHeader:@"Authorization"]).to.equal(@"Bearer bd0fbf8ee4da7472c382c28e7f7b9977cd6768dcadd7b9328a84a5bd5e7e9b5e");
                done();

            } error:^(NSHTTPURLResponse *response, NSError *error, id JSON) {
                expect(NO).will.beTruthy(); // We shouldn't call the error block in this case.
                done();
            }];
        });
    });

    context(@"with incorrect parameters", ^{
        beforeEach(^{
            NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                // Only deal with the token endpoint
                return [request.URL.lastPathComponent isEqualToString:@"token"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFile:@"tokenFailure.json" statusCode:401 responseTime:0.0 headers:httpHeaders];
            }];
        });

        it(@"calls the error block and doesn't set a token or refreshToken", ^AsyncBlock{
            [_client configureWithUsername:_username password:_password clientId:_clientId clientSecret:_clientSecret success:^(NSURLRequest *request, NSHTTPURLResponse *response) {
                expect(NO).to.beTruthy(); // We should not be calling the success block in this case
                done();

            } error:^(NSHTTPURLResponse *response, NSError *error, id JSON) {
                expect([_client token]).to.beNil();
                expect([_client refreshToken]).to.beNil();
                expect([_client clientId]).to.beNil();
                expect([_client clientSecret]).to.beNil();
                done();
            }];
        });
    });
});



SpecEnd
