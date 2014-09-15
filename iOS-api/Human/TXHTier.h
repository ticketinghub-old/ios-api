#import "_TXHTier.h"

@interface TXHTier : _TXHTier {}

/** Create or update a Tier object.

 This is created within the context of a creating an Availability, so not passing it here

 @param dict An NSDictionary of key values to create or update the object with.
 @param moc A managed object context in which to create or update an Upgrade object.

 @return a TXHTier object or nil if dict is an empty dictionary.
 */
+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc;

/** Gets a Tier object from its ID if it exists

 @param tierID An NSString for the Tier ID
 @param moc the managed object in which to search for the Tier object

 @return the TXHTier object with the given ID if it exists or nil.
 */
+ (instancetype)tierWithID:(NSString *)tierID inManagedObjectContext:(NSManagedObjectContext *)moc;


/** Gets a Tier object from its internal_ID if it exists
 
 @param internalTierID An NSString for the Tier ID (created from XORing hashes of: id, discount, limit, upgrades objects)
 @param moc the managed object in which to search for the Tier object
 
 @return the TXHTier object with the given ID if it exists or nil.
 */
+ (instancetype)tierWithInternalID:(NSString *)internalTierID inManagedObjectContext:(NSManagedObjectContext *)moc;

/** Delete all tiers for privided product
 @param moc the managed object in which to search for the Tier object
 */
+ (void)deleteTiersFromManagedObjectContext:(NSManagedObjectContext *)moc;


/** generets unique internal id for a Tier from providede dictionary representation
 As it turned ouu server id of a tier doesnt quareantie uniqness of a tier so we stoer internally a unique id based on id and properties that might be differnet for the same tierID
 
 @param dict dictionary representation of a tier
 
 @return Generated unig internal tier id constructed as <tierId><seqID><price><dicsount><limit><upgrades set hash>
 */
+ (NSString *)generateInternalIdFromDictionary:(NSDictionary *)dict;

@end
