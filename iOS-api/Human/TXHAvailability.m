#import "TXHAvailability.h"
#import "TXHDefines.h"

#import "TXHProduct.h"
#import "TXHTier.h"

@interface TXHAvailability ()

// Private interface goes here.

@end


@implementation TXHAvailability

#pragma mark - Public

+ (instancetype)updateForDateCreateIfNeeded:(NSString *)date withDictionary:(NSDictionary *)dictionary productId:(NSManagedObjectID *)productId inManagedObjectContext:(NSManagedObjectContext *)moc {
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

+ (void)deleteForDateIfExists:(NSString *)date productId:(NSManagedObjectID *)productId fromManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(date);
    NSParameterAssert(productId);
    NSParameterAssert(moc);

    TXHProduct *product = (TXHProduct *)[moc existingObjectWithID:productId error:NULL];

    TXHAvailability *availability = [[self class] avalabilityForDate:date product:product inManagedObjectContext:moc];

    if (!availability) {
        return;
    }

    [moc deleteObject:availability];
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

+ (instancetype)avalabilityForDate:(NSString *)date product:(TXHProduct *)product inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(date);
    NSParameterAssert(product);
    NSParameterAssert(moc);

    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
        formattedPredicate = [NSPredicate predicateWithFormat:@"dateString == $DATE_STRING AND product == $PRODUCT"];
    }

    NSDictionary *variables = @{@"DATE_STRING" : date,
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

/** Updates the object with values from the dictionary
 @param dictionary A dictionary of key values to update with. These are raw values, the keys are substituted to those of the actual properties internally.

 @return an updated TXHAvailability object, or nil if the dictionary was nil.
 */
- (id)updateWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return nil;
    }

    self.duration   = dictionary[@"duration"] != [NSNull null] ? dictionary[@"duration"] : nil;
    self.limit      = dictionary[@"limit"] != [NSNull null] ? dictionary [@"limit"] : nil;
    self.timeString = dictionary[@"time"] != [NSNull null] ? dictionary[@"time"] : nil;

    [self removeTiers:self.tiers];
    if (dictionary[@"tiers"]) {
        for (NSDictionary *tiersDict in dictionary[@"tiers"]) {
            TXHTier *tier = [TXHTier updateWithDictionaryCreateIfNeeded:tiersDict inManagedObjectContext:self.managedObjectContext];
            [tier addAvailabilitiesObject:self];
        }
    }

    return self;
}

@end
