//
//  TXHProductSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 22/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHProduct.h"
#import "TestsHelper.h"

#define EXP_SHORTHAND
#import "Specta.h"
#import "Expecta.h"

SpecBegin(TXHProduct)

describe(@"createWithDictionary:inManagedObjectContext", ^{
    __block NSManagedObjectContext *_moc;
    __block NSDictionary *_productDictionary;

    beforeAll(^{
        _productDictionary = @{@"id": @"123",
                               @"name": @"Product Name"};
    });

    before(^{
        _moc = [TestsHelper managedObjectContextForTests];
    });

    after(^{
        _moc = nil;
    });

    context(@"with a valid dictionary", ^{
        it(@"should create a valid object", ^{
            TXHProduct *product = [TXHProduct createWithDictionary:_productDictionary inManagedObjectContext:_moc];
            expect(product.name).to.equal(@"Product Name");
            expect(product.productId).to.equal(@"123");
        });
    });

    context(@"with an empty dictionary", ^{
        it(@"returns nil", ^{
            TXHProduct *product = [TXHProduct createWithDictionary:@{} inManagedObjectContext:_moc];
            expect(product).to.beNil();
        });
    });
});

SpecEnd
