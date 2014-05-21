//
//  TXHUpgradeSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 05/12/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHUpgrade.h"

#define EXP_SHORTHAND
#import "Expecta.h"
#import "Specta.h"

#import "TestsHelper.h"

SpecBegin(TXHUpgrade)

__block NSManagedObjectContext *_moc;
__block NSDictionary *_upgradeDict;

beforeAll(^{
    _upgradeDict = [TestsHelper objectFromJSONFile:@"Upgrade"];
});

afterAll(^{
    _upgradeDict = nil;
});

beforeEach(^{
    _moc = [TestsHelper managedObjectContextForTests];
});

afterEach(^{
    _moc = nil;
});

describe(@"creating an upgrade", ^{
    context(@"when it doesn't exist already", ^{
        it(@"can be created after checking if it exists", ^{
            TXHUpgrade *upgrade = [TXHUpgrade updateWithDictionaryCreateIfNeeded:_upgradeDict inManagedObjectContext:_moc];
            expect(upgrade).toNot.beNil();
            expect(upgrade.bit).to.equal(@1);
            expect(upgrade.upgradeDescription).to.equal(@"test");
            expect(upgrade.upgradeId).to.equal(@"2ae6571b-f803-48c3-9ece-2bb5614dc3f9");
            expect(upgrade.name).to.equal(@"VIP Access");
            expect(upgrade.price).to.equal(@1000);
            expect(upgrade.internalUpgradeId).to.equal(@"2ae6571b-f803-48c3-9ece-2bb5614dc3f91000");
        });

        it(@"can be created directly", ^{
            TXHUpgrade *upgrade = [TXHUpgrade createWithDictionary:_upgradeDict inManagedObjectContext:_moc];
            expect(upgrade).toNot.beNil();
            expect(upgrade.bit).to.equal(@1);
            expect(upgrade.upgradeDescription).to.equal(@"test");
            expect(upgrade.upgradeId).to.equal(@"2ae6571b-f803-48c3-9ece-2bb5614dc3f9");
            expect(upgrade.name).to.equal(@"VIP Access");
            expect(upgrade.price).to.equal(@1000);
            expect(upgrade.internalUpgradeId).to.equal(@"2ae6571b-f803-48c3-9ece-2bb5614dc3f91000");
        });
    });

    context(@"when it already exists", ^{
        __block TXHUpgrade *_upgrade;

        beforeEach(^{
            _upgrade = [TXHUpgrade createWithDictionary:_upgradeDict inManagedObjectContext:_moc];
        });

        afterEach(^{
            _upgrade = nil;
        });

        it(@"returns the same object", ^{
            TXHUpgrade *newUpgrade = [TXHUpgrade updateWithDictionaryCreateIfNeeded:_upgradeDict inManagedObjectContext:_moc];
            expect(newUpgrade == _upgrade).to.beTruthy();
        });
    });

    context(@"when a different upgrade exists", ^{
        __block TXHUpgrade *_upgrade;
        __block NSDictionary *_anotherDict;

        beforeEach(^{
            _upgrade = [TXHUpgrade createWithDictionary:_upgradeDict inManagedObjectContext:_moc];
            NSMutableDictionary *mutableDict = [_upgradeDict mutableCopy];
            mutableDict[@"id"] = @"14";
            _anotherDict = [mutableDict copy];
        });

        afterEach(^{
            _upgrade = nil;
            _anotherDict = nil;
        });

        it(@"creates another upgrade object", ^{
            TXHUpgrade *anotherUpgrade = [TXHUpgrade updateWithDictionaryCreateIfNeeded:_anotherDict inManagedObjectContext:_moc];
            expect(anotherUpgrade == _upgrade).toNot.beTruthy();
        });
    });

    context(@"with an empty dictionary", ^{
        it(@"returns nil", ^{
            TXHUpgrade *upgrade = [TXHUpgrade updateWithDictionaryCreateIfNeeded:@{} inManagedObjectContext:_moc];
            expect(upgrade).to.beNil();
        });
    });
    
});

describe(@"generating internal id", ^{
   
    context(@"for source dictionary", ^{
        it(@"generates the same hashes", ^{
            NSString *hash_1 = @"2ae6571b-f803-48c3-9ece-2bb5614dc3f91000";
            NSString *hash_2 = [TXHUpgrade generateInternalIdFromDictionary:_upgradeDict];
            expect(hash_1).to.equal(hash_2);
        });
    });
    
    
    context(@"for the same dictionary", ^{
        it(@"generates the same hashes", ^{
            NSString *hash_1 = [TXHUpgrade generateInternalIdFromDictionary:_upgradeDict];
            NSString *hash_2 = [TXHUpgrade generateInternalIdFromDictionary:_upgradeDict];
            expect(hash_1).to.equal(hash_2);
        });
    });
    
    context(@"for equal but differne dictionaries", ^{
        it(@"generates the same hashes", ^{
            NSString *hash_1 = [TXHUpgrade generateInternalIdFromDictionary:_upgradeDict];
            NSString *hash_2 = [TXHUpgrade generateInternalIdFromDictionary:[_upgradeDict copy]];
            expect(hash_1).to.equal(hash_2);
        });
    });
    
    context(@"for not equal dictionaries - differnet price", ^{
        it(@"generates differnet hashes", ^{
            
            expect(_upgradeDict[@"price"]).to.equal(@1000);
            NSMutableDictionary *changedDic = [_upgradeDict mutableCopy];
            changedDic[@"price"] = @1001;
            
            NSString *hash_1 = [TXHUpgrade generateInternalIdFromDictionary:_upgradeDict];
            NSString *hash_2 = [TXHUpgrade generateInternalIdFromDictionary:changedDic];
            expect(hash_1).notTo.equal(hash_2);
        });
    });
    
});

SpecEnd
