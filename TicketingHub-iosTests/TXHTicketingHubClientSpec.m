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

@end

SpecBegin(TXHTicketingHubClient)

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

SpecEnd
