#import "_TXHTicket.h"


@interface TXHTicket : _TXHTicket {}

@property (readonly, nonatomic) NSNumber *totalPrice;

/** Convenience constructor
 @param dictionary A dictionary of key values for the object. These are the raw values from the API.
 @param moc The managed object context in which the object is created.
 
 @return An object of type TXHOrder.
 */
+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;


/** Creates or updates a ticket object with the provided dictionary
 
 @param dictionary A dictionary of key values for the object properties.
 @param moc The managed object that is used to search for and create the object.
 
 @return an object of type TXHTicket.
 
 */
+ (instancetype)updateWithDictionaryOrCreateIfNeeded:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;


@end
