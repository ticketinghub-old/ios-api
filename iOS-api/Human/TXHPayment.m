#import "TXHPayment.h"
#import "TXHDefines.h"

#import "TXHAddress.h"
#import "TXHCard.h"

NSString * const kAmountKey             = @"amount";
NSString * const kAuthorizationKey      = @"authorization";
NSString * const kAVSResultKey          = @"avs_result";
NSString * const kCurrencyKey           = @"currency";
NSString * const kPostalMatchKey        = @"postal_match";
NSString * const kSecurityCodeResultKey = @"security_code_result";
NSString * const kStreetMatchKey        = @"street_match";
NSString * const kTypeKey               = @"type";
NSString * const kAddressKey            = @"address";
NSString * const kCardKey               = @"card";

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
    payment.address = [TXHAddress createWithDictionary:addresDictionary inManagedObjectContext:moc];
    
    NSDictionary *cardDictionary = dictionary[kCardKey];
    payment.card = [TXHCard createWithDictionary:cardDictionary inManagedObjectContext:moc];
    
    return payment;
}

@end
