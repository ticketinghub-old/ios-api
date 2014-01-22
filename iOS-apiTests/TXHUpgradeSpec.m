//
//  TXHUpgradeSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 05/12/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Expecta.h"
#import "Specta.h"

#import "TXHUpgrade.h"

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
            expect(upgrade.bit).to.equal(_upgradeDict[@"bit"]);
            expect(upgrade.upgradeDescription).to.equal(_upgradeDict[@"description"]);
            expect(upgrade.upgradeId).to.equal(_upgradeDict[@"id"]);
            expect(upgrade.name).to.equal(_upgradeDict[@"name"]);
            expect(upgrade.price).to.equal(_upgradeDict[@"price"]);
        });

        it(@"can be created directly", ^{
            TXHUpgrade *upgrade = [TXHUpgrade createWithDictionary:_upgradeDict inManagedObjectContext:_moc];
            expect(upgrade).toNot.beNil();
            expect(upgrade).toNot.beNil();
            expect(upgrade.bit).to.equal(_upgradeDict[@"bit"]);
            expect(upgrade.upgradeDescription).to.equal(_upgradeDict[@"description"]);
            expect(upgrade.upgradeId).to.equal(_upgradeDict[@"id"]);
            expect(upgrade.name).to.equal(_upgradeDict[@"name"]);
            expect(upgrade.price).to.equal(_upgradeDict[@"price"]);
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

SpecEnd
