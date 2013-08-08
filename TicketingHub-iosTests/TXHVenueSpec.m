//
//  TXHVenueSpec.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 08/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "TXHVenue.h"

SpecBegin(TXHVenue)

__block NSDictionary *_parameters;

before(^{
    _parameters = @{@"city": @"c",
                    @"country": @"GB",
                    @"currency": @"GBP",
                    @"email": [NSNull null],
                    @"establishment_type": [NSNull null],
                    @"id": @99,
                    @"latitude": @55.378050999999999,
                    @"longitude": @(-3.4359730000000002),
                    @"name": @"My Venue 1",
                    @"permissions": @[@"salesman" ,@"doorman"],
                    @"postcode": @"e",
                    @"region": @"d",
                    @"street_1": @"a",
                    @"street_2": @"b",
                    @"stripe_publishable_key": @"pk_live_g4RfHyJIdBz7Bs2efWP9dHlW",
                    @"telephone": [NSNull null],
                    @"time_zone": @"Europe/London",
                    @"website": [NSNull null]};
});

describe(@"creation from a dictionary", ^{
    __block TXHVenue *_venue;

    before(^{
        _venue = [TXHVenue createWithDictionary:_parameters];
    });

    after(^{
        _venue = nil;
    });

    it(@"should correctly set up properties", ^{
        expect(_venue).toNot.beNil();
        expect(_venue.city).to.equal(_parameters[@"city"]);
        expect(_venue.country).to.equal(_parameters[@"country"]);
        expect(_venue.email).to.beNil();
        expect(_venue.establishmentType).to.beNil();
        expect(_venue.venueId).to.equal(_parameters[@"id"]);
        expect(_venue.venueName).to.equal(_parameters[@"name"]);
        expect(_venue.postcode).to.equal(_parameters[@"postcode"]);
        expect(_venue.region).to.equal(_parameters[@"region"]);
        expect(_venue.street1).to.equal(_parameters[@"street_1"]);
        expect(_venue.street2).to.equal(_parameters[@"street_2"]);
        expect(_venue.stripePublishableKey).to.equal(_parameters[@"stripe_publishable_key"]);
        expect(_venue.telephone).to.beNil();
        expect(_venue.timeZoneName).to.equal(_parameters[@"time_zone"]);
        expect(_venue.website).to.beNil();
        expect([_venue valueForKey:@"latitude"]).to.equal([_parameters[@"latitude"] doubleValue]);
        expect([_venue valueForKey:@"longitude"]).to.equal([_parameters[@"longitude"] doubleValue]);
    });

    it(@"should translate longituted and latitude to a location", ^{
        CLLocationCoordinate2D expectedLocationCoordinates = CLLocationCoordinate2DMake([_parameters[@"latitude"] doubleValue], [_parameters[@"longitude"] doubleValue]);
        expect(_venue.locationCoordinates).to.equal(expectedLocationCoordinates);
    });

});


SpecEnd
