#import "_TXHUser.h"

@interface TXHUser : _TXHUser {}

/** The full name for the user.
 
 If one can't be created, the login email is used instead.
 */
@property (copy, readonly, nonatomic) NSString *fullName;

/** Create or update an User object.

 @param dictionary An NSDictionary of key values to create or update the obejct with
 @param moc A managed object context in which to create or update an Upgrade object

 @return a TXHUpgrade object or nil if dict is an empty dictionary.
 */
+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

/** Updates a User object with values from a dictionary


 @param dictionary A dictionary of key values. The keys are the raw keys from the API.
 
 @return an updated User object
 */
- (id)updateWithDictionary:(NSDictionary *)dictionary;
@end
