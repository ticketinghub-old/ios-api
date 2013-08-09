//
//  TXHVenue.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 07/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHVenue.h"

#import "NSDictionary+JCSKeyMapping.h"

@interface TXHVenue ()

@property (assign, readonly) CLLocationDegrees latitude;
@property (assign, readonly) CLLocationDegrees longitude;

@end

@implementation TXHVenue

#pragma mark - Set up and tear down

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary {
    TXHVenue *venue = [[self alloc] init];

    if (!venue) {
        return nil; // Bail!
    }

    NSDictionary *mappedDictionary = [dictionary jcsRemapKeysWithMapping:[self mappingDictionary] removingNullValues:YES];
    [venue setValuesForKeysWithDictionary:mappedDictionary];

    return venue;
}

#pragma mark - Superclass overrides

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // Convert edge cases

    if ([key isEqualToString:@"venueId"]) {
        _venueId = [value integerValue];
    } else {
        // Don't crash, just log the attempt
        NSLog(@"Trying to set value: %@, for undefined key: %@", value, key);
    }

}

- (NSString *)description {
    NSString *formatString = @"venueId: %d\n"
                             @"venueName: %@\n"
                             @"street1: %@\n"
                             @"street2: %@\n"
                             @"city: %@\n"
                             @"region: %@\n"
                             @"postcode: %@\n"
                             @"country: %@\n"
                             @"latitude: %f\n"
                             @"longitude: %f\n"
                             @"currency: %@\n"
                             @"timeZoneName: %@\n"
                             @"website: %@\n"
                             @"email: %@\n"
                             @"telephone: %@\n"
                             @"establishmentType: %@\n"
                             @"stripePublishableKey: %@\n"
                             @"permissions: %@\n";

    NSString *description = [NSString stringWithFormat:formatString,
                             self.venueId,
                             self.venueName,
                             self.street1,
                             self.street2,
                             self.city,
                             self.region,
                             self.postcode,
                             self.country,
                             self.latitude,
                             self.longitude,
                             self.currency,
                             self.timeZoneName,
                             self.website,
                             self.email,
                             self.telephone,
                             self.establishmentType,
                             self.stripePublishableKey,
                             self.permissions];

    return description;
}

#pragma mark custom accessors

- (CLLocationCoordinate2D)locationCoordinates {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

#pragma mark - Private methods

// Returns a dictionary that maps the input dictionary to the keys of this object
+ (NSDictionary *)mappingDictionary {
    static NSDictionary *mapping = nil;

    if (!mapping) {
        mapping = @{@"id" : @"venueId",
                    @"name" : @"venueName",
                    @"establishment_type" : @"establishmentType",
                    @"street_1" : @"street1",
                    @"street_2" : @"street2",
                    @"stripe_publishable_key" : @"stripePublishableKey",
                    @"time_zone" : @"timeZoneName"};
    }

    return mapping;
}

@end
