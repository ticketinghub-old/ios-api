#import "_TXHOrder.h"

@interface TXHOrder : _TXHOrder {}


/** Creates or updates an order object with the provided dictionary
 
 @param dictionary A dictionary of key values for the object properties.
 @param moc The managed object that is used to search for and create the object.
 
 @return an object of type TXHOrder.
 
 */
+ (instancetype)updateWithDictionaryOrCreateIfNeeded:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@property (readonly, nonatomic) NSInteger attendedTickets;

@end
