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
#import "TXHUpgrade.h"

@interface TXHTier ()

+ (TXHTier *)createWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc;

@end

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

        beforeEach(^{
            _dict = [TestsHelper objectFromJSONFile:@"TierWithUpgrades"];
            _tier = [TXHTier createWithDictionary:_dict inManagedObjectContext:_moc];
        });

        it(@"creates the object", ^{
            expect(_tier).toNot.beFalsy();
            expect(_tier.tierDescription).to.equal(_dict[@"description"]);
            expect(_tier.tierId).to.equal(_dict[@"id"]);
            expect(_tier.discount).to.equal(_dict[@"discount"]);
            expect(_tier.limit).to.equal(_dict[@"limit"]);
            expect(_tier.name).to.equal(_dict[@"name"]);
            expect(_tier.price).to.equal(_dict[@"price"]);
            expect(_tier.size).to.equal(_dict[@"size"]);
            expect(_tier.upgrades).to.haveCountOf(1);
        });
    });

    context(@"when it does already exist", ^{
        __block NSDictionary *_dict;

        before(^{
            _dict = [TestsHelper objectFromJSONFile:@"TierWithUpgrades"];
            _tier = [TXHTier createWithDictionary:_dict inManagedObjectContext:_moc];
        });

        it(@"can be retrieved by it's tierID", ^{
            TXHTier *tier = [TXHTier tierWithID:_tier.tierId inManagedObjectContext:_moc];
            expect(tier).to.equal(_tier);
        });

        it(@"updates changes the existing object", ^{
            NSMutableDictionary *newDict = [_dict mutableCopy];
            newDict[@"price"] = @(3450);

            TXHTier *tier = [TXHTier updateWithDictionaryCreateIfNeeded:newDict inManagedObjectContext:_moc];

            expect(tier.tierId).to.equal(_tier.tierId);
            expect(tier.price).to.equal(newDict[@"price"]);

        });

        it(@"creates new objects for the upgrades, deleting the old objects", ^{
            NSString *uuid = [[NSUUID UUID] UUIDString];
            NSMutableDictionary *newDict = [_dict mutableCopy];
            NSMutableDictionary *newUpgradeDict = [newDict[@"upgrades"][0] mutableCopy];
            newUpgradeDict[@"id"] = uuid;
            newDict[@"upgrades"] = @[newUpgradeDict];

            TXHUpgrade *currentUpgrade = [_tier.upgrades anyObject]; // There should only be one in the test case.

            // Update the current object with teh new dictionary
            [TXHTier updateWithDictionaryCreateIfNeeded:newDict inManagedObjectContext:_moc];

            TXHUpgrade *newUpgrade = [_tier.upgrades anyObject];

            expect(_tier.upgrades).to.haveCountOf(1);
            expect(newUpgrade.upgradeId).toNot.equal(currentUpgrade.upgradeId);
            expect(currentUpgrade.isDeleted).to.beTruthy();
        });
    });
});



SpecEnd
