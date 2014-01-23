#import "TXHAvailability.h"

#import "NSDictionary+JCSKeyMapping.h"
#import "TXHProduct.h"

@interface TXHAvailability ()

// Private interface goes here.

@end


@implementation TXHAvailability

#pragma mark - Public

+ (instancetype)updateForDateCreateIfNeeded:(NSString *)date withDictionary:(NSDictionary *)dictionary productId:(NSManagedObjectID *)productId nManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(date);
    NSParameterAssert(dictionary);
    NSParameterAssert(productId);
    NSParameterAssert(moc);

    NSString *timeString = dictionary[@"time"];
    TXHProduct *product = (TXHProduct *)[moc existingObjectWithID:productId error:NULL];

    TXHAvailability *availability = [self availabilityForDate:date andTime:timeString forProduct:product inManagedObjectContext:moc];
    if (!availability) {
        availability = [TXHAvailability insertInManagedObjectContext:moc];
        availability.dateString = date;
    }

    [availability updateWithDictionary:dictionary];
    availability.product = product; // Set up the relationship

    return availability;
}

#pragma mark - Private

/** Returns a TXHAvailability object for a product on a particular date and time
 
 @param date A string for the date in the format YYYY-MM-DD
 @param time A string for the time in the format HH:MM
 @param product A TXHProduct object in the managed object context
 @param moc The managed object context in which to search

 @return A TXHAvailability object if one exists for these parameters, or nil.
 */
+ (instancetype)availabilityForDate:(NSString *)date andTime:(NSString *)time forProduct:(TXHProduct *)product inManagedObjectContext:(NSManagedObjectContext *)moc {
    if (!date || !time || !product || !moc) {
        // Returns nil if any of the parameters are nil
        return nil;
    }
    
    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
        formattedPredicate = [NSPredicate predicateWithFormat:@"dateString == $DATE_STRING AND timeString == $TIME_STRING AND product == $PRODUCT"];
    }

    NSDictionary *variables = @{@"DATE_STRING" : date,
                                @"TIME_STRING" : time,
                                @"PRODUCT" : product};

    NSPredicate *predicate = [formattedPredicate predicateWithSubstitutionVariables:variables];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:predicate];

    NSArray *availabilities = [moc executeFetchRequest:request error:NULL];

    if (!availabilities) {
        return nil;
    }

    return [availabilities firstObject];
}

+ (NSDictionary *)mappingDictionary {
    static NSDictionary *dict = nil;

    if (!dict) {
        dict = @{@"time" : @"timeString"};
    }

    return dict;
}

/** Updates the object with values from the dictionary
 @param dictionary A dictionary of key values to update with. These are raw values, the keys are substituted to those of the actual properties internally.

 @return an updated TXHAvailability object, or nil if the dictionary was nil.
 */
- (id)updateWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return nil;
    }

    NSDictionary *userDictionary = [dictionary jcsRemapKeysWithMapping:[[self class] mappingDictionary] removingNullValues:YES];

    [self setValuesForKeysWithDictionary:userDictionary];

    return self;
}

@end
