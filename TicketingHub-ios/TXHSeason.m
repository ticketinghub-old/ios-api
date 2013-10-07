//
//  TXHSeason.m
//  TicketingHub-ios
//
//  Created by Abizer Nasir on 12/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSeason.h"

#import "TXHOption.h"
#import "NSDictionary+JCSKeyMapping.h"

@interface TXHSeason ()

@property (strong, readwrite, nonatomic) NSString *startsOnDateString;
@property (strong, readwrite, nonatomic) NSString *endsOnDateString;
@property (copy, readwrite, nonatomic) NSArray *seasonalOptions;

@end

@implementation TXHSeason

#pragma mark - Convenience Constructor

+ (id)createWithDictionary:(NSDictionary *)dictionary {
    TXHSeason *season = [[self alloc] init];

    if (!season) {
        return nil; // Bail!
    }

    NSDictionary *mappedDictionary = [dictionary jcsRemapKeysWithMapping:[self mappingDictionary] removingNullValues:YES];

    [season setValuesForKeysWithDictionary:mappedDictionary];

    return season;
}

#pragma mark - Superclass overrides

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"options"]) {
        // Tease apart the options array, create the correct object
        
        NSMutableArray *seasonalOptions = [NSMutableArray arrayWithCapacity:[value count]];

        for (NSDictionary *seasonalOptionDictionary in (NSArray *)value) {
            TXHOption *seasonalOption = [TXHOption createWithDictionary:seasonalOptionDictionary];
            [seasonalOptions addObject:seasonalOption];
        }

        self.seasonalOptions = seasonalOptions;

    } else {
        // Don't crash, just log the attempt
        NSLog(@"Trying to set value: %@, for undefined key: %@", value, key);
    }

}

#pragma mark - Private methods

// Maps the parameters from the input dictionary to the property names of the class
+ (NSDictionary *)mappingDictionary {
    static NSDictionary *dictionary = nil;

    if (!dictionary) {
        dictionary = @{@"starts_on" : @"startsOnDateString", @"ends_on" : @"endsOnDateString"};
    }

    return dictionary;
}


@end
