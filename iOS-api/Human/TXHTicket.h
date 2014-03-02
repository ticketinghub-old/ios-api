#import "_TXHTicket.h"


@interface TXHTicket : _TXHTicket {}

@property (readonly, nonatomic) NSNumber *totalPrice;

/** Creates or updates a ticket object with the provided dictionary
 
 @param dictionary A dictionary of key values for the object properties.
 @param moc The managed object that is used to search for and create the object.
 
 @return an object of type TXHTicket.
 
 */
+ (instancetype)updateWithDictionaryOrCreateIfNeeded:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;


@end
