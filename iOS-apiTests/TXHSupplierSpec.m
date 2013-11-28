//
//  TXHSupplierSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 21/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

@import CoreData;
#import "CoreDataTestsHelper.h"

#import "TXHSupplier.h"
#import "TXHProduct.h"

SpecBegin(TXHSupplier)

describe(@"createWithDictionary:inManagedObjectContext:", ^{
    __block NSDictionary *_supplierDictionary;
    __block NSManagedObjectContext *_moc;

    beforeAll(^{
        NSBundle *testsBundle = [NSBundle bundleForClass:[self class]];
        NSURL *fileURL = [testsBundle URLForResource:@"Supplier" withExtension:@"json"];
        NSData *responseData = [NSData dataWithContentsOfURL:fileURL];
        _supplierDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    });

    before(^{
        _moc = [CoreDataTestsHelper managedObjectContextForTests];
    });
    
    after(^{
        _moc = nil;
    });

    context(@"With a valid dictionary", ^{
        it(@"should create a valid object with products", ^{
            TXHSupplier *supplier = [TXHSupplier createWithDictionary:_supplierDictionary inManagedObjectContext:_moc];
            expect(supplier).toNot.beNil();
            expect(supplier.accessToken).to.equal(@"accessToken1");
            expect(supplier.refreshToken).to.equal(@"refreshToken1");
            expect(supplier.country).to.equal(@"GB");
            expect(supplier.currency).to.equal(@"GBP");
            expect(supplier.timeZoneName).to.equal(@"Europe/London");
            expect(supplier.products).to.haveCountOf(2);

            NSManagedObjectModel *model = [[_moc persistentStoreCoordinator] managedObjectModel];
            NSArray *entityNames = [[model entitiesByName] allKeys];

            expect(entityNames).toNot.beNil();
            expect(entityNames).to.haveCountOf(3);

        });
    });

    context(@"with an empty array of products", ^{
        __block NSMutableDictionary *_noProductsSupplierDictionary;
        before(^{
            _noProductsSupplierDictionary = [_supplierDictionary mutableCopy];
            _noProductsSupplierDictionary[@"products"] = @[];
        });

        it(@"doesn't have any related products", ^{
            TXHSupplier *supplier = [TXHSupplier createWithDictionary:_noProductsSupplierDictionary inManagedObjectContext:_moc];
            expect(supplier.products).to.haveCountOf(0);
        });
    });
});

SpecEnd