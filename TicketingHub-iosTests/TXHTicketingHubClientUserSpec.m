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

SpecBegin(TXHTicketingHubClient_User)

__block TXHTicketingHubClient *_client;

beforeEach(^{
    _client = [TXHTicketingHubClient sharedClient];
});

afterEach(^{
    [OHHTTPStubs removeAllRequestHandlers];
});


SpecEnd
