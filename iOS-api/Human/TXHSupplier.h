    #import "_TXHSupplier.h"

@interface TXHSupplier : _TXHSupplier {}

/** Convenience constructor
 @param dictionary A dictionary of key values for the object. These are the raw values from the API.
 @param moc The managed object context in which the object is created.

 @return An object of type TXHSupplier.
 */
+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
