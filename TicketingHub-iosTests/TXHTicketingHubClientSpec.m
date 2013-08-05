//
//  TXHTicketingHubClientSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 05/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "AFNetworking.h"
#import "OHHTTPStubs.h"
#import "TXHTicketingHubClient.h"
#import "_TXHNetworkClient.h"
#import "_TXHNetworkOAuthClient.h"

@interface TXHTicketingHubClient (PrivateMethods)

// Expose non-public interface
- (_TXHNetworkOAuthClient *)oauthClient;
- (_TXHNetworkClient *)networkClient;
- (NSString *)token;
- (NSString *)refreshToken;

@end

SpecBegin(TXHTicketingHubClientSpec)

__block TXHTicketingHubClient *_client;

beforeEach(^{
    _client = [TXHTicketingHubClient sharedClient];
});

describe(@"sharedClient", ^{

    __block _TXHNetworkClient *_networkClient;
    __block _TXHNetworkOAuthClient *_oauthClient;

    beforeEach(^{
        _networkClient = _client.networkClient;
        _oauthClient = _client.oauthClient;
    });

    it(@"can be created as a singleton", ^{
        expect(_client).to.beTruthy();
        TXHTicketingHubClient *secondClient = [TXHTicketingHubClient sharedClient];

        expect(secondClient).to.beIdenticalTo(_client);
    });

    it(@"has network clients with default HTTP headers", ^{
        expect(_networkClient).to.beTruthy();
        expect([_networkClient defaultValueForHeader:@"Accept"]).to.equal(@"application/json");
        expect([_networkClient defaultValueForHeader:@"Accept-Language"]).to.beTruthy();

        expect(_oauthClient).to.beTruthy();
        expect([_oauthClient defaultValueForHeader:@"Accept"]).to.equal(@"application/json");
        expect([_oauthClient defaultValueForHeader:@"Accept-Language"]).to.beTruthy();

    });

    it(@"passes language settings through to the network clients", ^{
        [_client setDefaultAcceptLanguage:@"el-GR"];
        expect([_networkClient defaultValueForHeader:@"Accept-Language"]).to.equal(@"el-GR");
        expect([_oauthClient defaultValueForHeader:@"Accept-Language"]).to.equal(@"el-GR");

    });

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

        it(@"stores the token and refresh token internally", ^AsyncBlock{
            [_client configureWithUsername:_username password:_password clientId:_clientId clientSecret:_clientSecret success:^(NSURLRequest *request, NSHTTPURLResponse *response) {
                expect([_client token]).to.equal(@"bd0fbf8ee4da7472c382c28e7f7b9977cd6768dcadd7b9328a84a5bd5e7e9b5e");
                expect([_client refreshToken]).to.equal(@"0e6314d94b3eac772d571c8da04bdeb2d1cb3ace71487672bd54e83e968681a3");
                done();

            } error:^(NSHTTPURLResponse *response, NSError *error, id JSON) {
                expect(@YES).will.beNil(); // We shouldn't call the error block in this case.
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
                done();
            }];
        });

    });
});


SpecEnd
