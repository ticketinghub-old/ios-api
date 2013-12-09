#import "_TXHUpgrade.h"

@interface TXHUpgrade : _TXHUpgrade {}

/** Create or update an Upgrade object.
 
 This is created within the context of a creating an Availability and a Tier, so not passing them here
 @param dict An NSDictionary of key values to create or update the obejct with
 @param moc A managed object context in which to create or update an Upgrade object
 @returns a TXHUpgrade object or nil if dict is an empty dictionary.
 */
+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));

/** Gets an upgrade object from it's ID if it exists
 @param upgradeID An NSString for upgrade ID
 @param moc The managed object context in which to search for the object.
 @returns the TXHUpgrade object with the given ID if it exists or nil.
 */
+ (instancetype)upgradeWithID:(NSString *)upgradeID inManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));

/** Create a TXHUpgrade object from a dictionary
 @param dict A dictionary of key values. The keys are the raw keys from the API.
 @param moc A managed object context in which to create the object
 @returns A TXHUpgrade object or nil if the dictionary is empty.
 */
+ (instancetype)createWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));

/** Update with values from a dictionary
 @param dict A dictionary of key values. The keys are the raw keys from the API.
 */
- (void)updateWithDictionary:(NSDictionary *)dict __attribute__((nonnull));
@end
