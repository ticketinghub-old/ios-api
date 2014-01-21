#import "_TXHAvailability.h"

@interface TXHAvailability : _TXHAvailability {}

/** Convenience constructor.

 If the object exists it is updated with values from the dictionary, otherwise the object is created from the dictionary.
 @param dict A dictionary of key values for the object properties.
 @param productId the NSManagedObjectID for the product.
 @param moc The managed object that is used to search for and create the object.

 @return an object of type TXHAvailability.
 */
+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict forProductID:(NSManagedObjectID *)productId inManagedObjectContext:(NSManagedObjectContext *)moc;

/** Updates the object with values from the dictionary
 @param dictionary A dictionary of key values to update with. These are raw values, the keys are substituted to those of the actual properties internally.

 @return an updated TXHAvailability object, on nil if the dictionary was nil.
 */
- (id)updateWithDictionary:(NSDictionary *)dictionary;

@end
