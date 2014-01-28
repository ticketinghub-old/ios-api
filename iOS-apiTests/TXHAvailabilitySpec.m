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

#import "TestsHelper.h"
#import "TXHProduct.h"

SpecBegin(TXHAvailability)

__block NSManagedObjectContext *_moc;
__block TXHProduct *_product;

beforeEach(^{
    _moc = [TestsHelper managedObjectContextForTests];
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
                                        @"duration" : @"2H"};
        });

        afterEach(^{
            _availabilityDictionary = nil;
        });

        it(@"creates a basic availability object", ^{
            TXHAvailability *availability = [TXHAvailability updateForDateCreateIfNeeded:@"2013-12-29" withDictionary:_availabilityDictionary productId:_product.objectID inManagedObjectContext:_moc];
            expect(availability).toNot.beNil();
            expect(availability.dateString).to.equal(@"2013-12-29");
            expect(availability.timeString).to.equal(@"09:00");
            expect(availability.duration).to.equal(@"2H");
        });
    });

    context(@"With an existing availability for a date and time", ^{
        __block NSDictionary *_newDict;

        beforeEach(^{
            NSDictionary *dict = @{@"time" : @"09:00",
                                   @"duration" : @"2H"};
            [TXHAvailability updateForDateCreateIfNeeded:@"2013-12-29" withDictionary:dict productId:_product.objectID inManagedObjectContext:_moc];

            NSMutableDictionary *newDict = [dict mutableCopy];
            newDict[@"duration"] = @"3H";

            _newDict = [newDict copy];
        });

        afterEach(^{
            _newDict = nil;
        });

        it(@"updates the existing object with new values", ^{
            TXHAvailability *availability = [TXHAvailability updateForDateCreateIfNeeded:@"2013-12-29" withDictionary:_newDict productId:_product.objectID inManagedObjectContext:_moc];
            expect(availability).toNot.beNil();
            expect(availability.dateString).to.equal(@"2013-12-29");
            expect(availability.timeString).to.equal(@"09:00");
            expect(availability.duration).to.equal(@"3H");

        });

        it(@"can delete the object", ^{
            [TXHAvailability deleteForDateIfExists:@"2013-12-29" productId:_product.objectID fromManagedObjectContext:_moc];
            [_moc save:NULL];
            expect(_product.availabilities).to.haveCountOf(0);
        });
    });

    context(@"With an existing availability for a date, but adding a new one for a different time", ^{
        __block NSDictionary *_newDict;

        beforeEach(^{
            NSDictionary *dict = @{@"time" : @"09:00",
                                   @"duration" : @"2H"};
            [TXHAvailability updateForDateCreateIfNeeded:@"2013-12-29" withDictionary:dict productId:_product.objectID inManagedObjectContext:_moc];

            NSMutableDictionary *newDict = [dict mutableCopy];
            newDict[@"duration"] = @"3H";
            newDict[@"time"] = @"10:00";

            _newDict = [newDict copy];
        });

        afterEach(^{
            _newDict = nil;
        });

        it(@"updates the existing object with new values", ^{
            TXHAvailability *availability = [TXHAvailability updateForDateCreateIfNeeded:@"2013-12-29" withDictionary:_newDict productId:_product.objectID inManagedObjectContext:_moc];
            expect(availability).toNot.beNil();
            expect(availability.dateString).to.equal(@"2013-12-29");
            expect(availability.timeString).to.equal(@"10:00");
            expect(availability.duration).to.equal(@"3H");
            expect(_product.availabilities).to.haveCountOf(2);
            
        });
    });

    context(@"given a availability dictionary with tiers for a given date", ^{
        __block NSDictionary *_availabilityDictionary;
        beforeEach(^{
            _availabilityDictionary = [[TestsHelper objectFromJSONFile:@"AvailabilityOptionsFirstForDate"] firstObject];
        });

        it(@"Creates a full availability object with two tiers", ^{
            TXHAvailability *availability = [TXHAvailability updateForDateCreateIfNeeded:@"2013-12-29" withDictionary:_availabilityDictionary productId:_product.objectID inManagedObjectContext:_moc];
            expect(availability).toNot.beFalsy();
            expect(availability.tiers).to.haveCountOf(2);

        });

    });
});



SpecEnd
