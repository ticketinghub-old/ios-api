#import "TXHAvailability.h"

#import "NSDictionary+JCSKeyMapping.h"
#import "TXHProduct.h"

@interface TXHAvailability ()

// Private interface goes here.

@end


@implementation TXHAvailability

#pragma mark - Public
+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict forProductID:(NSManagedObjectID *)productId inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(dict, @"The dict paramater cannot be nil");
    NSAssert(productId, @"The productID parameter cannot be nill");
    NSAssert(moc, @"The managed object context cannot be nil");

    NSString *dateString = dict[@"dateString"];
    NSString *timeString = dict[@"time"];
    TXHProduct *product = (TXHProduct *)[moc existingObjectWithID:productId error:NULL];

    TXHAvailability *availability = [self availabilityForDate:dateString andTime:timeString forProduct:product inManagedObjectContext:moc];
    if (!availability) {
        availability = [TXHAvailability insertInManagedObjectContext:moc];
    }

    [availability updateWithDictionary:dict];
    availability.product = product; // Set up the relationship

    return availability;
}

- (id)updateWithDictionary:(NSDictionary *)dictionary {
    NSAssert(dictionary, @"The dictionary parameter cannot be nil");

    NSDictionary *userDictionary = [dictionary jcsRemapKeysWithMapping:[[self class] mappingDictionary] removingNullValues:YES];

    [self setValuesForKeysWithDictionary:userDictionary];

    return self;
}

#pragma mark - Private

/** Returns a TXHAvailability object for a product on a particular date and time
 @param date A string for the date in the format YYYY-MM-DD
 @param time A string for the time in the format HH:MM
 @param product A TXHProduct object in the managed object context
 @param moc The managed object context in which to search
 @returns A TXHAvailability object if one exists for these parameters, on nil.
 */
+ (instancetype)availabilityForDate:(NSString *)date andTime:(NSString *)time forProduct:(TXHProduct *)product inManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull)) {
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

@end
