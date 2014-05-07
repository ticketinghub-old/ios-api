#import "_TXHPayment.h"

extern NSString * const kAmountKey;
extern NSString * const kAuthorizationKey;
extern NSString * const kAVSResultKey;
extern NSString * const kCurrencyKey;
extern NSString * const kPostalMatchKey;
extern NSString * const kSecurityCodeResultKey;
extern NSString * const kStreetMatchKey;
extern NSString * const kTypeKey;
extern NSString * const kAddressKey;
extern NSString * const kCardKey;

@interface TXHPayment : _TXHPayment {}

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
