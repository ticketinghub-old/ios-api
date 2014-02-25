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
#import "NSDateFormatter+TicketingHubFormat.h"

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
            TXHOrder *order = [TXHOrder updateWithDictionaryOrCreateIfNeeded:_orderDict inManagedObjectContext:_moc];
            expect(order).toNot.beNil();
            expect(order.orderId).to.equal(@"7a79468b-490c-48d5-9553-4459fac6415f");
            expect(order.reference).to.equal(@"XXXXX");
            expect(order.currency).to.equal(@"GBP");
            expect(order.total).to.equal(@5300);
            expect(order.postage).to.equal(@0);
            expect(order.tax).to.equal(@1060);
            expect(order.taxName).to.equal(@"VAT");
            expect(order.delivery).to.equal(@"electronic");
            expect(order.address).to.beNil();
            expect(order.customer).to.beNil();
            expect(order.coupon).to.beNil();
            expect(order.payment).to.beNil();
            expect(order.expiresAt).to.equal([NSDateFormatter txh_dateFromString:@"2011-11-06T18:36:37+00:00"]);
            expect(order.createdAt).to.equal([NSDateFormatter txh_dateFromString:@"2011-11-06T18:26:37+00:00"]);
            expect(order.updatedAt).to.beNil();
            expect(order.confirmedAt).to.beNil();
            expect(order.cancelledAt).to.beNil();
            
        });
        
    });
});

SpecEnd
