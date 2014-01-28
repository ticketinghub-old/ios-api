#import "_TXHAvailability.h"

@interface TXHAvailability : _TXHAvailability {}

/** Creates or updates an availability object for a date with the provided dictionary
 
 If the object does not already exist for this date (which is taken from the parameter) and the time (which is taken from the dictionary)

 @param date an ISO date string.
 @param dictionary A dictionary of key values for the object properties.
 @param productId the NSManagedObjectID for the product.
 @param moc The managed object that is used to search for and create the object.

 @return an object of type TXHAvailability.

 */
+ (instancetype)updateForDateCreateIfNeeded:(NSString *)date withDictionary:(NSDictionary *)dictionary productId:(NSManagedObjectID *)productId inManagedObjectContext:(NSManagedObjectContext *)moc;
@end
