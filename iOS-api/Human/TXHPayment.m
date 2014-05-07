#import "TXHPayment.h"
#import "TXHDefines.h"

#import "TXHAddress.h"
#import "TXHCard.h"
#import "TXHGateway.h"

static NSString * const kAmountKey               = @"amount";
static NSString * const kAuthorizationKey        = @"authorization";
static NSString * const kAVSResultKey            = @"avs_result";
static NSString * const kCurrencyKey             = @"currency";
static NSString * const kPostalMatchKey          = @"postal_match";
static NSString * const kSecurityCodeResultKey   = @"security_code_result";
static NSString * const kStreetMatchKey          = @"street_match";
static NSString * const kTypeKey                 = @"type";
static NSString * const kAddressKey              = @"address";
static NSString * const kCardKey                 = @"card";
static NSString * const kGatewayKey              = @"gateway";
static NSString * const kVerificationMethodKey   = @"verification_method";
static NSString * const kInputTypeKey            = @"input_type";
static NSString * const kGatewayAuthorizationKey = @"authorization";
static NSString * const kReferenceKey            = @"reference";
static NSString * const kCardSchemeKey           = @"scheme";


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

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    dictionary[kTypeKey]               = self.type;
    dictionary[kGatewayKey]            = self.gateway.gatewayId;
    dictionary[kVerificationMethodKey] = self.verificationMethod;
    dictionary[kInputTypeKey]          = self.inputType;
    dictionary[kAuthorizationKey]      = self.authorization;
    dictionary[kReferenceKey]          = self.reference;
    dictionary[kCardKey]               = @{kCardSchemeKey : self.card.scheme};
    
    return dictionary;
}


@end
