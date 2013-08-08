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

//    if ([key isEqualToString:@"latitude"] || [key isEqualToString:@"longitude"]) {
//        // do nothing, this gets converted to a CLLocation
//    } else if ([key isEqualToString:@"venueId"]) {
//        _venueId = [value integerValue];
//    } else {
//        // Don't crash, just log the attempt
//        NSLog(@"Trying to set value: %@, for undefined key: %@", value, key);
//    }

    if ([key isEqualToString:@"venueId"]) {
        _venueId = [value integerValue];
    } else {
        // Don't crash, just log the attempt
        NSLog(@"Trying to set value: %@, for undefined key: %@", value, key);
    }

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
