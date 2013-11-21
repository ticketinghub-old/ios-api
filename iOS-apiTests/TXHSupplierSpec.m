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

describe(@"createWithDictionary", ^{
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

        __block TXHProduct *_product1;
        __block TXHProduct *_product2;

        before(^{
            _product1 = [TXHProduct insertInManagedObjectContext:_moc];
            _product1.productId = @"45";
            _product1.name = @"Thorpe Park";

            _product2 = [TXHProduct insertInManagedObjectContext:_moc];
            _product2.productId = @"44";
            _product2.name = @"London Eye";

        });

        it(@"should create a valid object with products", ^{
            TXHSupplier *supplier = [TXHSupplier createWithDictionary:_supplierDictionary inManagedObjectContext:_moc];
            expect(supplier).toNot.beNil();
            expect(supplier.accessToken).to.equal(@"accessToken1");
            expect(supplier.refreshToken).to.equal(@"refreshToken1");
            expect(supplier.country).to.equal(@"GB");
            expect(supplier.currency).to.equal(@"GBP");
            expect(supplier.timeZoneName).to.equal(@"Europe/London");
        });

        it(@"should create valid products", ^{
            TXHSupplier *supplier = [TXHSupplier createWithDictionary:_supplierDictionary inManagedObjectContext:_moc];
            expect(supplier.products).to.haveCountOf(2);

            NSArray *products = [supplier.products allObjects];
            expect(products).to.contain(_product1);
            expect(products).to.contain(_product2);
        });
    });
});

SpecEnd
