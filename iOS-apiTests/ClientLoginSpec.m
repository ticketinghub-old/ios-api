//
//  ClientLoginSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 22/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"

#define EXP_SHORTHAND
#import "Specta.h"
#import "Expecta.h"
#import "OHHTTPStubs.h"

#import "TXHProduct.h"
#import "TXHSupplier.h"
#import "TXHUser.h"

@import CoreData;

SpecBegin(TXHTicketingHubClient)

__block TXHTicketingHubClient *_client;

before(^{
    _client = [[TXHTicketingHubClient alloc] initWithStoreURL:nil andBaseServerURL:nil];
});

after(^{
    _client = nil;
});


describe(@"initial login", ^{
    __block NSFetchRequest *_suppliersRequest;

    before(^{
        _suppliersRequest = [NSFetchRequest fetchRequestWithEntityName:[TXHSupplier entityName]];
    });

    context(@"with a valid username and password", ^{
        __block __weak id<OHHTTPStubsDescriptor> _suppliersStub;

        before(^{
            NSDictionary *httpHeaders = @{@"Content-Type" : @"application/json"};

            _suppliersStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.lastPathComponent isEqualToString:@"suppliers"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"Suppliers.json", nil) statusCode:200 headers:httpHeaders];
            }];
            
            _suppliersStub.name = @"stub with suppliers";

        });

        after(^{
            [OHHTTPStubs removeStub:_suppliersStub];
        });

        it(@"creates the suppliers and related products and users", ^AsyncBlock{
            [_client fetchSuppliersForUsername:@"abc" password:@"cde" withCompletion:^(NSArray *suppliers, NSError *error) {
                expect(suppliers).to.haveCountOf(2);
                expect(suppliers[0]).to.beKindOf([TXHSupplier class]);
                for(TXHSupplier *supplier in suppliers) {
                    expect([supplier.products count]).to.beGreaterThan(0);
                    expect(supplier.user.email).to.equal(@"abc");
                }

                done();
            }];
        });

        it(@"uses the main moc for the objects in the block", ^AsyncBlock{
            [_client fetchSuppliersForUsername:@"abc" password:@"cde" withCompletion:^(NSArray *suppliers, NSError *error) {
                TXHSupplier *anySupplier = [suppliers firstObject];
                expect(anySupplier.managedObjectContext).to.equal([_client managedObjectContext]);
                done();
            }];
        });

    });
});



SpecEnd
