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
static NSString * const kSignatureKey            = @"signature";



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
    
    if (self.gateway)
        dictionary[kGatewayKey]            = self.gateway.gatewayId;
    if (self.type)
        dictionary[kTypeKey]               = self.type;
    if (self.verificationMethod)
        dictionary[kVerificationMethodKey] = self.verificationMethod;
    if (self.inputType)
        dictionary[kInputTypeKey]          = self.inputType;
    if (self.authorization)
        dictionary[kAuthorizationKey]      = self.authorization;
    if (self.reference)
        dictionary[kReferenceKey]          = self.reference;
    if (self.self.card.scheme)
        dictionary[kCardKey]               = @{kCardSchemeKey : self.card.scheme};
    if (self.signature)
        dictionary[kSignatureKey]          = self.signature;
    if (self.card)
        dictionary[kCardKey]               = [self.card dictionaryRepresentation];'
    
    return dictionary;
}


@end
