//
//  ClientAvailabilitySpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 29/01/2014.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Expecta.h"
#import "Specta.h"
#import "OHHTTPStubs.h"

#import "TXHOrder.h"

#import "TestsHelper.h"

SpecBegin(TXHOrder)

__block NSManagedObjectContext *_moc;
__block NSDictionary *_orderDict;

beforeAll(^{
    _orderDict = [TestsHelper objectFromJSONFile:@"Order"];
});

afterAll(^{
    _orderDict = nil;
});

beforeEach(^{
    _moc = [TestsHelper managedObjectContextForTests];
});

afterEach(^{
    _moc = nil;
});


describe(@"creating an order", ^{
    
    context(@"when it doesn't exist already", ^{

        it(@"can be created directly", ^{
            TXHOrder *order = [TXHOrder createWithDictionary:_orderDict inManagedObjectContext:_moc];
            expect(order).toNot.beNil();
            expect(order.orderId).to.equal(_orderDict[kIdKey]);
            expect(order.reference).to.equal(_orderDict[kReferenceKey]);
            expect(order.currency).to.equal(_orderDict[kCurrencyKey]);
            expect(order.total).to.equal(_orderDict[kTotalKey]);
            expect(order.postage).to.equal(_orderDict[kPostageKey]);
            expect(order.tax).to.equal(_orderDict[kTaxKey]);
            expect(order.taxName).to.equal(_orderDict[kTaxNameKey]);
            expect(order.delivery).to.equal(_orderDict[kDeliveryKey]);

        });
        
    });
});

SpecEnd
