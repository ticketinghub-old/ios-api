#import "_TXHUpgrade.h"

@interface TXHUpgrade : _TXHUpgrade {}

/** Create or update an Upgrade object.
 
 This is created within the context of a creating an Availability and a Tier, so not passing them here

 @param dict An NSDictionary of key values to create or update the obejct with
 @param moc A managed object context in which to create or update an Upgrade object

 @return a TXHUpgrade object or nil if dict is an empty dictionary.
 */
+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc;

/** Gets an upgrade object from it's ID if it exists

 @param upgradeID An NSString for upgrade ID
 @param moc The managed object context in which to search for the object.
 
 @return the TXHUpgrade object with the given ID if it exists or nil.
 */
+ (instancetype)upgradeWithID:(NSString *)upgradeID inManagedObjectContext:(NSManagedObjectContext *)moc;

/** Gets an upgrade object from it's internal ID if it exists
 
 @param internalUpgradeID An NSString for internal upgrade ID
 @param moc The managed object context in which to search for the object.
 
 @return the TXHUpgrade object with the given internal ID if it exists or nil.
 */
+ (instancetype)upgradeWithInternalID:(NSString *)internalUpgradeID inManagedObjectContext:(NSManagedObjectContext *)moc;

/** Create a TXHUpgrade object from a dictionary
 
 @param dict A dictionary of key values. The keys are the raw keys from the API.
 @param moc A managed object context in which to create the object
 
 @return A TXHUpgrade object or nil if the dictionary is empty.
 */
+ (instancetype)createWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc;

/** Update with values from a dictionary
 
 @param dict A dictionary of key values. The keys are the raw keys from the API.
 */
- (void)updateWithDictionary:(NSDictionary *)dict;

/** generets unique internal id for an upgrade from providede dictionary representation
 As it turned out server id of n update doesnt quareantie uniqness of an audate so we store internally a unique id based on id and properties that might be differnet for the same upgradeID
 
 @param dict dictionary representation of a tier
 
 @return Generated unig internal upgrade id constructed as <upgradeID><price>
 */
+ (NSString *)generateInternalIdFromDictionary:(NSDictionary *)dict;
@end
