//
//  TXHTierSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 05/12/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTier.h"

#define EXP_SHORTHAND
#import "Expecta.h"
#import "Specta.h"

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
            expect(_tier.tierDescription).to.equal(@"18 or over");
            expect(_tier.tierId).to.equal(@"d4d9efc1-a6d7-4b3f-8023-5bd36d96a3bb");
            expect(_tier.discount).to.equal(@0);
            expect(_tier.limit).to.equal(@10);
            expect(_tier.name).to.equal(@"Adult");
            expect(_tier.price).to.equal(@1000);
            expect(_tier.size).to.equal(@1);
            expect(_tier.seqId).to.equal(@0);
            expect(_tier.upgrades).to.haveCountOf(1);
            
            expect(_tier.internalTierId).to.equal(@"d4d9efc1-a6d7-4b3f-8023-5bd36d96a3bb110000101");
            
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

describe(@"generating internal id", ^{
    
    __block NSDictionary *_dict;
    __block NSString *originalHash;
    __block NSMutableDictionary *_dictToChange;
    
    before(^{
        _dict = [TestsHelper objectFromJSONFile:@"TierWithUpgrades"];
        originalHash = [TXHTier generateInternalIdFromDictionary:_dict];
    });
    
    beforeEach(^{
        _dictToChange = [[TestsHelper objectFromJSONFile:@"TierWithUpgrades"] mutableCopy];

    });
    
    context(@"for the same dictionary", ^{
        it(@"generates the same hashes", ^{
            NSString *hash_2 = [TXHTier generateInternalIdFromDictionary:_dict];
            expect(originalHash).to.equal(hash_2);
        });
    });
    
    context(@"for equal but differne dictionaries", ^{
        it(@"generates the same hashes", ^{
            NSString *hash_2 = [TXHTier generateInternalIdFromDictionary:[_dict copy]];
            expect(originalHash).to.equal(hash_2);
        });
    });
    
    context(@"for not equal dictionaries - differnet price", ^{
        it(@"generates differnet hashes", ^{
            
            expect(_dict[@"price"]).to.equal(@1000);
            _dictToChange[@"price"] = @1001;
            
            NSString *hash_2 = [TXHTier generateInternalIdFromDictionary:_dictToChange];
            expect(originalHash).notTo.equal(hash_2);
        });
    });
    
    context(@"for not equal dictionaries - differnet seq_id", ^{
        it(@"generates differnet hashes", ^{
            
            _dictToChange[@"seq_id"] = @2;
            expect(_dict[@"seq_id"]).to.equal(@1);
            
            NSString *hash_2 = [TXHTier generateInternalIdFromDictionary:_dictToChange];
            expect(originalHash).notTo.equal(hash_2);
        });
    });

    context(@"for not equal dictionaries - differnet dicsount", ^{
        it(@"generates differnet hashes", ^{
            
            expect(_dict[@"discount"]).to.equal(@0);
            _dictToChange[@"discount"] = @1;

            NSString *hash_2 = [TXHTier generateInternalIdFromDictionary:_dictToChange];
            expect(originalHash).notTo.equal(hash_2);
        });
    });
    
    context(@"for not equal dictionaries - differnet limit", ^{
        it(@"generates differnet hashes", ^{
            
            _dictToChange[@"limit"] = @11;
            expect(_dict[@"limit"]).to.equal(@10);
            
            NSString *hash_2 = [TXHTier generateInternalIdFromDictionary:_dictToChange];
            expect(originalHash).notTo.equal(hash_2);
        });
    });
    
    context(@"for not equal dictionaries - differnet upgrades", ^{
        it(@"generates differnet hashes", ^{
            
            NSDictionary *tierDictWithUpgrades = [TestsHelper objectFromJSONFile:@"TierWithUpgrades"];
            NSDictionary *tierDictWithoutUpgrades = [TestsHelper objectFromJSONFile:@"TierWithoutUpgrades"];
            
            NSString *hash_1 = [TXHTier generateInternalIdFromDictionary:tierDictWithUpgrades];
            NSString *hash_2 = [TXHTier generateInternalIdFromDictionary:tierDictWithoutUpgrades];
            expect(hash_1).notTo.equal(hash_2);
        });
    });

});

SpecEnd
