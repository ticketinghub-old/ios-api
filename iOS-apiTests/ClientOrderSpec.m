//
//  ClientOrderSpec.m
//  iOS-api
//
//  Created by Bartek Hugo Trzcinski on 25/02/2014.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

@import CoreData;

#import "TXHTicketingHubClient.h"

#define EXP_SHORTHAND
#import "Specta.h"
#import "Expecta.h"
#import "OHHTTPStubs.h"
#import "TestsHelper.h"
#import "AFNetworking.h"

#import "TXHOrder.h"
#import "TXHProduct.h"
#import "TXHAvailability.h"
#import "TXHTicket.h"
#import "TXHTier.h"

// Expose internal properties of TXHTicketingHubClient

@interface TXHTicketingHubClient (TXHTesting)

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

SpecBegin(ClientOrder)

__block TXHTicketingHubClient *_client;
__block NSManagedObjectContext *_moc;

beforeEach(^{
    _client = [[TXHTicketingHubClient alloc] initWithStoreURL:nil];
    _moc = [TestsHelper managedObjectContextForTests];

});

afterEach(^{
    _client = nil;
    _moc = nil;
});

describe(@"initial login", ^{
    
    context(@"valid payload", ^{
        __block __weak id<OHHTTPStubsDescriptor> _suppliersStub;

        __block __weak TXHProduct *_product;
        __block __weak TXHAvailability *_availability;
        
        before(^{
            NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};
            
            _suppliersStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.lastPathComponent isEqualToString:@"orders"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"Order.json", nil) statusCode:200 headers:httpHeaders];
            }];
            
            _suppliersStub.name = @"stub with order";
            
            NSDictionary *productDictionary = @{@"id": @"123",
                                   @"name": @"Product Name"};

            NSDictionary *availabilityDictionary = [[TestsHelper objectFromJSONFile:@"AvailabilityOptionsFirstForDate"] firstObject];

            _product = [TXHProduct createWithDictionary:productDictionary inManagedObjectContext:_moc];
            _availability = [TXHAvailability updateForDateCreateIfNeeded:@"2013-12-29" withDictionary:availabilityDictionary productId:_product.objectID inManagedObjectContext:_moc];
            
        });
        
        after(^{
            [OHHTTPStubs removeStub:_suppliersStub];
        });
        
        it(@"creates the order", ^AsyncBlock{
            
            NSDictionary *quantities = @{@"t" : @1};
            
            [_client reserveTicketsWithTierQuantities:quantities availability:_availability coupon:nil completion:^(TXHOrder *order, NSError *error) {
                
                expect(order).to.notTo.beNil();
                expect(order).to.beKindOf([TXHOrder class]);
                expect(order.orderId).to.equal(@"7a79468b-490c-48d5-9553-4459fac6415f");
                expect(order.tickets).to.haveCountOf(1);
                expect([[(TXHTicket *)[order.tickets anyObject] tier] tierId]).to.equal(@"5913b1d7-7127-4bfe-bae5-7fbaa9cd65dc");
                
                done();

            }];
            
        });
        
//        it(@"uses the main moc for the objects in the block", ^AsyncBlock{
//            [_client fetchSuppliersForUsername:@"abc" password:@"cde" withCompletion:^(NSArray *suppliers, NSError *error) {
//                TXHSupplier *anySupplier = [suppliers firstObject];
//                expect(anySupplier.managedObjectContext).to.equal([_client managedObjectContext]);
//                done();
//            }];
//        });
        
    });
});


SpecEnd
