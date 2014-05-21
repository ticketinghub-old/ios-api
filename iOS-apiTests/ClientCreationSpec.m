//
//  ClientCreationSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 06/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import CoreData;

#import "TXHTicketingHubClient.h"

#define EXP_SHORTHAND
#import "Specta.h"
#import "Expecta.h"
#import "OHHTTPStubs.h"

#import "AFNetworking.h"

// Expose internal properties of TXHTicketingHubClient

@interface TXHTicketingHubClient (TXHTesting)

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

SpecBegin(ClientCreation)

__block TXHTicketingHubClient *_client;

beforeEach(^{
    _client = [[TXHTicketingHubClient alloc] initWithStoreURL:nil andBaseServerURL:nil];
});

afterEach(^{
    _client = nil;
});

describe(@"when creating a client", ^{
    it(@"has an internal session manager object", ^{
        expect(_client.sessionManager).toNot.beNil();
        expect(_client.sessionManager).to.beKindOf([AFHTTPSessionManager class]);
    });

    it(@"has correctly configured base URLs for the session managers", ^{
        expect(_client.sessionManager.baseURL).to.equal([NSURL URLWithString:@"https://api.ticketinghub.com/"]);
    });

    it(@"has AFJSONRequestSerializers for the session managers", ^{
        expect(_client.sessionManager.requestSerializer).to.beKindOf([AFJSONRequestSerializer class]);
    });

    it(@"has AFJSONResponseSerializers for the session managers", ^{
        expect(_client.sessionManager.responseSerializer).to.beKindOf([AFJSONResponseSerializer class]);
    });

});



SpecEnd
