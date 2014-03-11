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
#import "NSDateFormatter+TicketingHubFormat.h"

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
            TXHTicket *ticket = [TXHTicket updateWithDictionaryOrCreateIfNeeded:_ticketDict inManagedObjectContext:_moc];
            expect(ticket).toNot.beNil();
            expect(ticket.ticketId).to.equal(@"bfec2ad1-0e05-4846-a044-e6bbf769bb75");
            expect(ticket.validFrom).to.equal([NSDateFormatter txh_dateFromString:@"2012-01-01T09:00:00+00:00"]);
            expect(ticket.expiresAt).to.equal([NSDateFormatter txh_dateFromString:@"2012-01-01T11:00:00+00:00"]);
            expect(ticket.price).to.equal(@1100);
            expect(ticket.code).to.beNil();
            expect(ticket.voucher).to.beNil();
            expect(ticket.customer).to.beNil();
            expect(ticket.product.productId).to.equal(@"64be7660-ee1d-4230-b36d-39fa752b0ae2");
        });
        
    });
});


describe(@"decoding barcode", ^{
    
    context(@"when barcode is valid", ^{
        NSString *validBarcode = @"AUYAAAADBQAAAADQK7FSQI6xUjAtAhUAlBDjIswsYD36AWC5flPG0GcRY3sCFDQXcmr8ehIa8aBLUY9lUJmpN6bh";
        
        NSDictionary *decodedBarcode = [TXHTicket decodeBarcode:validBarcode];
        
        expect(decodedBarcode[kTXHBarcodeTypeKey]).to.equal(@(1));
        expect(decodedBarcode[kTXHBarcodeTicketSeqIdKey]).to.equal(@(70));
        expect(decodedBarcode[kTXHBarcodeProductSeqIdKey]).to.equal(@(3));
        expect(decodedBarcode[kTXHBarcodeTierSeqIdKey]).to.equal(@(5));
        expect(decodedBarcode[kTXHBarcodeBitmaskKey]).to.equal(@(0));
        expect(decodedBarcode[kTXHBarcodeValidFromTimestampKey]).to.equal(@(1387342800));
        expect(decodedBarcode[kTXHBarcodeExpiresAtTimestampKey]).to.equal(@(1387368000));
        expect(decodedBarcode[kTXHBarcodeSignatureKey]).notTo.beNil();
        
    });
    
    context(@"when barcode is invalid", ^{
        NSString *validBarcode = @"AUYAADQK7FSQI6xUjAtAhUAlBDjIswsYD36AWC5flPG0GcRY3sCFDQXcmr8ehIa8aBLUY9lUJmpN6bh";
        
        NSDictionary *decodedBarcode = [TXHTicket decodeBarcode:validBarcode];
        
        expect(decodedBarcode).to.beNil();
        
    });
});

SpecEnd
