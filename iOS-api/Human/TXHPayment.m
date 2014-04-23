#import "TXHPayment.h"

#import "TXHAddress.h"
#import "TXHCard.h"

static NSString * const kAmountKey             = @"amount";
static NSString * const kAuthorizationKey      = @"authorization";
static NSString * const kAVSResultKey          = @"avs_result";
static NSString * const kCurrencyKey           = @"currency";
static NSString * const kPostalMatchKey        = @"postal_match";
static NSString * const kSecurityCodeResultKey = @"security_code_result";
static NSString * const kStreetMatchKey        = @"street_match";
static NSString * const kTypeKey               = @"type";
static NSString * const kAddressKey            = @"address";
static NSString * const kCardKey               = @"card";

@interface TXHPayment ()

@end


@implementation TXHPayment

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{    
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHPayment *payment = [[self class] insertInManagedObjectContext:moc];
    
    payment.amount             = dictionary[kAmountKey];
    payment.authorization      = dictionary[kAuthorizationKey];
    payment.avsResult          = dictionary[kAVSResultKey];
    payment.currency           = dictionary[kCurrencyKey];
    payment.postalMatch        = dictionary[kPostalMatchKey];
    payment.securityCodeResult = dictionary[kSecurityCodeResultKey];
    payment.streetMatch        = dictionary[kStreetMatchKey];
    payment.type               = dictionary[kTypeKey];

    NSDictionary *addresDictionary = dictionary[kAddressKey];
    payment.address = addresDictionary;
    
    NSDictionary *cardDictionary = dictionary[kCardKey];
    payment.card = cardDictionary;
    
    return payment;
}

@end
