//
//  VenueSpec.m
//  iOS-api
//
//  Created by Abizer Nasir on 06/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHVenue.h"

SpecBegin(Venue)

__block NSDictionary *_venueDictionary;

beforeAll(^{
    NSBundle *testsBundle = [NSBundle bundleForClass:[self class]];
    NSURL *fileURL = [testsBundle URLForResource:@"VenuesSuccess" withExtension:@"json"];
    NSData *responseData = [NSData dataWithContentsOfURL:fileURL];
    _venueDictionary = [[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil] firstObject];
});

describe(@"when using the convenience constructor", ^{
    context(@"with a valid dictionary", ^{
        __block TXHVenue *_venue;

        beforeAll(^{
            _venue = [TXHVenue createWithDictionary:_venueDictionary];
        });

        it(@"returns a valid TXHVenue object", ^{
            expect(_venue).to.beTruthy();
            expect(_venue.venueId).to.equal(5);
            expect(_venue.venueName).to.equal(@"My Second Venue");
            expect(_venue.currency).to.equal(@"GBP");
            expect(_venue.timeZoneName).to.equal(@"UTC");
            expect(_venue.token).to.equal(@"at~ETmbU67N2VI97PXx-_1gIw");
        });
    });

    context(@"with an empty dictionary", ^{
        it(@"returns nil", ^{
            TXHVenue *venue = [TXHVenue createWithDictionary:@{}];
            expect(venue).to.beNil();
        });
    });

    context(@"with a nil dictionary", ^{
        it(@"returns nil", ^{
            TXHVenue *venue = [TXHVenue createWithDictionary:nil];
            expect(venue).to.beNil();
        });
    });
});


SpecEnd
