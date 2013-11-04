//
//  ClientCreationSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 06/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

#import "_TXHAPISessionManager.h"
#import "_TXHAppSessionManager.h"

// Expose internal properties of TXHTicketingHubClient

@interface TXHTicketingHubClient (TXHTesting)

@property (strong, nonatomic) _TXHAPISessionManager *sessionManager;
@property (strong, nonatomic) _TXHAppSessionManager *appSessionManager;

@end

SpecBegin(ClientCreation)

__block TXHTicketingHubClient *_client;

beforeEach(^{
    _client = [TXHTicketingHubClient new];
});

afterEach(^{
    _client = nil;
});

describe(@"when creating a client", ^{
    it(@"has correctly configured base URLs for the session managers", ^{
        expect(_client.sessionManager.baseURL).to.equal([NSURL URLWithString:@"https://api.ticketinghub.com/"]);
        expect(_client.appSessionManager.baseURL).to.equal([NSURL URLWithString:@"https://mpos.th-apps.com/"]);
    });

    it(@"has AFJSONRequestSerializers for the session managers", ^{
        expect(_client.sessionManager.requestSerializer).to.beKindOf([AFJSONRequestSerializer class]);
        expect(_client.appSessionManager.requestSerializer).to.beKindOf([AFJSONRequestSerializer class]);
    });

    it(@"has AFJSONResponseSerializers for the session managers", ^{
        expect(_client.sessionManager.responseSerializer).to.beKindOf([AFJSONResponseSerializer class]);
        expect(_client.appSessionManager.responseSerializer).to.beKindOf([AFJSONResponseSerializer class]);
    });
});

describe(@"setDefaultAcceptLanguage", ^{
    before(^{
        [_client setDefaultAcceptLanguage:@"el_GR"];
    });

    it(@"passes the language setting to the session managers", ^{
        NSString *sessionManagerAcceptLanguage = _client.sessionManager.requestSerializer.HTTPRequestHeaders[@"Accept-Language"];
        NSString *appSessionManagerAcceptLanguage = _client.appSessionManager.requestSerializer.HTTPRequestHeaders[@"Accept-Language"];

        expect(sessionManagerAcceptLanguage).to.equal(@"el_GR");
        expect(appSessionManagerAcceptLanguage).to.equal(@"el_GR");
    });
});


SpecEnd
