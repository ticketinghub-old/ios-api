#import "_TXHOrder.h"

extern NSString * const kIdKey;
extern NSString * const kReferenceKey;
extern NSString * const kCurrencyKey;
extern NSString * const kTotalKey;
extern NSString * const kPostageKey;
extern NSString * const kTaxKey;
extern NSString * const kTaxNameKey;
extern NSString * const kDeliveryKey;
extern NSString * const kAddressKey;
extern NSString * const kCustomerKey;
extern NSString * const kCouponKey;
extern NSString * const kPaymentKey;
extern NSString * const kTicketsKey;

@interface TXHOrder : _TXHOrder {}

/** Convenience constructor
 @param dictionary A dictionary of key values for the object. These are the raw values from the API.
 @param moc The managed object context in which the object is created.
 
 @return An object of type TXHOrder.
 */
+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
