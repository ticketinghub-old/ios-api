//
//  TXHTierSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 05/12/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Expecta.h"
#import "Specta.h"

#import "TXHTier.h"

#import "TestsHelper.h"

SpecBegin(TXHTier)

__block NSManagedObjectContext *_moc;
__block TXHTier *_tier;

beforeEach(^{
    _moc = [TestsHelper managedObjectContextForTests];
});

afterEach(^{
    _moc = nil;
    _tier = nil;
});

describe(@"creating a new object", ^{
    context(@"when it doesn't already exist", ^{
        __block NSDictionary *_dict;

        before(^{
            
        });

        it(@"creates the object", ^{

        });
    });

    context(@"when it does already exist", ^{
        __block NSDictionary *_dict;

        before(^{

        });

        it(@"updates the existing object", ^{

        });
    });

    context(@"when the object exists and there are different upgrades", ^{
        __block NSDictionary *_dict;

        before(^{

        });

        it(@"correctly updates the object and merges the changes", ^{

        });
    });
});



SpecEnd
