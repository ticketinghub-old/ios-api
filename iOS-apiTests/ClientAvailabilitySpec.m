//
//  ClientAvailabilitySpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 29/01/2014.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Expecta.h"
#import "Specta.h"

#import "TXHTicketingHubClient.h"

#import "TXHAvailability.h"
#import "TXHProduct.h"
#import "TestsHelper.h"

SpecBegin(ClientAvailability)

__block TXHTicketingHubClient *_client;
__block TXHProduct *_product;

before(^{
    _client = [[TXHTicketingHubClient alloc] initWithStoreURL:nil];

    NSDictionary *dictionary = @{@"id": @"123",
                                 @"name": @"Product Name"};
    _product = [TXHProduct createWithDictionary:dictionary inManagedObjectContext:_client.managedObjectContext];
    [_client.managedObjectContext save:NULL];
});

after(^{
    _product = nil;
    _client = nil;
});

describe(@"updating availabilities for a product", ^{
    context(@"with a new product and getting availabilities for a range", ^{
        context(@"where there are availabilities", ^{
            //
        });

        context(@"where there are no availabilities", ^{
            //
        });
    });
});

SpecEnd
