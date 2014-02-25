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

#import "TXHProduct.h"
#import "TXHTicket.h"

#import "TestsHelper.h"

SpecBegin(TXHTicket)

__block NSManagedObjectContext *_moc;
__block NSDictionary *_ticketDict;

beforeAll(^{
    _ticketDict = [TestsHelper objectFromJSONFile:@"Ticket"];
});

afterAll(^{
    _ticketDict = nil;
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
            TXHTicket *ticket = [TXHTicket createWithDictionary:_ticketDict inManagedObjectContext:_moc];
            expect(ticket).toNot.beNil();
            expect(ticket.ticketId).to.equal(@"bfec2ad1-0e05-4846-a044-e6bbf769bb75");
            expect(ticket.validFrom).to.equal(@"2012-01-01T09:00:00+00:00");
            expect(ticket.expiresAt).to.equal(@"2012-01-01T11:00:00+00:00");
            expect(ticket.price).to.equal(@1100);
            expect(ticket.code).to.beNil();
            expect(ticket.voucher).to.beNil();
            expect(ticket.customer).to.beNil();
            expect(ticket.product.productId).to.equal(@"64be7660-ee1d-4230-b36d-39fa752b0ae2");
//            expect(ticket.).to.equal(_ticketDict[]);

//            expect(ticket.reference).to.equal(_orderDict[kReferenceKey]);
//            expect(order.currency).to.equal(_orderDict[kCurrencyKey]);
//            expect(order.total).to.equal(_orderDict[kTotalKey]);
//            expect(order.postage).to.equal(_orderDict[kPostageKey]);
//            expect(order.tax).to.equal(_orderDict[kTaxKey]);
//            expect(order.taxName).to.equal(_orderDict[kTaxNameKey]);
//            expect(order.delivery).to.equal(_orderDict[kDeliveryKey]);
            
        });
        
    });
});

SpecEnd
