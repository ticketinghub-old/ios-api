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

//@property (assign, nonatomic) CLLocationDegrees latitude;
//@property (assign, nonatomic) CLLocationDegrees longitude;

@end

@implementation TXHVenue

#pragma mark - Set up and tear down

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return nil;
    }

    TXHVenue *venue = [[self alloc] init];

    if (!venue) {
        return nil; // Bail!
    }

    NSDictionary *mappedDictionary = [[self class] mappedDictionaryFromDictionary:dictionary];
    NSDictionary *reMappedDictionary = [mappedDictionary jcsRemapKeysWithMapping:nil removingNullValues:YES];
    [venue setValuesForKeysWithDictionary:reMappedDictionary];

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
                             @"token: %@\n"
                             @"currency: %@\n"
                             @"timeZoneName: %@\n";

    NSString *description = [NSString stringWithFormat:formatString,
                             self.venueId,
                             self.venueName,
                             self.token,
                             self.currency,
                             self.timeZoneName];

    return description;
}

// Returns a dictionary with only the mapped key-values that are required to create the object
+ (NSDictionary *)mappedDictionaryFromDictionary:(NSDictionary *)dictionary {
    NSDictionary *mappedDictionary = @{@"venueId": @([dictionary[@"id"] integerValue]),
                                       @"venueName" : dictionary[@"name"],
                                       @"currency" : dictionary[@"currency"],
                                       @"timeZoneName" : dictionary[@"time_zone"][@"name"],
                                       @"token" : dictionary[@"token"][@"access_token"]};

    return mappedDictionary;
}

@end
