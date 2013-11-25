//
//  TXHTicketingHubClientSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 22/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient.h"
#import "OHHTTPStubs.h"
#import "TXHProduct.h"
#import "TXHSupplier.h"

@import CoreData;

SpecBegin(TXHTicketingHubClient)

__block TXHTicketingHubClient *_client;

before(^{
    _client = [[TXHTicketingHubClient alloc] initWithStoreURL:nil];
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

        xit(@"creates the suppliers and related products entities", ^AsyncBlock{
            [_client fetchSuppliersForUsername:@"abc" password:@"cde" withCompletion:^(NSArray *suppliers, NSError *error) {
                

                done();
            }];
        });

    });
});



SpecEnd
