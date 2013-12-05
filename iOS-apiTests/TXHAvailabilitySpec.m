//
//  TXHAvailabilitySpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 05/12/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Expecta.h"
#import "Specta.h"

#import "TXHAvailability.h"

#import "CoreDataTestsHelper.h"
#import "TXHProduct.h"

SpecBegin(TXHAvailability)

__block NSManagedObjectContext *_moc;
__block TXHProduct *_product;

beforeEach(^{
    _moc = [CoreDataTestsHelper managedObjectContextForTests];
    NSDictionary *productDictionary = @{@"id": @"123",
                                        @"name": @"Product Name"};
    _product = [TXHProduct createWithDictionary:productDictionary inManagedObjectContext:_moc];
});

afterEach(^{
    _product = nil;
    _moc = nil;
});

describe(@"With a basic availability dictionary with no tiers", ^{
    __block NSDictionary *_availabilityDictionary;

    context(@"given a valid dictionary", ^{
        beforeEach(^{
            _availabilityDictionary = @{@"time" : @"09:00",
                                        @"dateString" : @"2013-12-29"};
        });

        afterEach(^{
            _availabilityDictionary = nil;
        });

        it(@"creates a basic availability object", ^{
            TXHAvailability *availability = [TXHAvailability updateWithDictionaryCreateIfNeeded:_availabilityDictionary forProductID:_product.objectID inManagedObjectContext:_moc];
            expect(availability).toNot.beNil();
            expect(availability.dateString).to.equal(@"2013-12-29");
            expect(availability.timeString).to.equal(@"09:00");
        });
    });

    context(@"given a availability dictionary with tiers but no upgrades", ^{
        
    });
});



SpecEnd
