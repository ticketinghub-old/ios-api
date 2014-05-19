#import "TXHCard.h"
#import "TXHDefines.h"

static NSString * const kBrandKey        = @"brand";
static NSString * const kFingerprintKey  = @"fingerprint";
static NSString * const kFirstNameKey    = @"first_name";
static NSString * const kLastNameKey     = @"last_name";
static NSString * const kLast4Key        = @"last4";
static NSString * const kMaskKey         = @"mask";
static NSString * const kMontKey         = @"month";
static NSString * const kYearKey         = @"year";
static NSString * const kPaymentKey      = @"payment";
static NSString * const kSecurityCodeKey = @"security_code";
static NSString * const kNumberKey       = @"number";

static NSString * const kExpMonthKey     = @"exp_month";
static NSString * const kExpYearKey      = @"exp_year";
static NSString * const kCVCKey          = @"security_code";
static NSString * const kTrackDataKey    = @"track_data";


@interface TXHCard ()


@end


@implementation TXHCard

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc {
    
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHCard *card = [[self class] insertInManagedObjectContext:moc];
    
    card.brand        = dictionary[kBrandKey];
    card.fingerprint  = dictionary[kFingerprintKey];
    card.firstName    = dictionary[kFirstNameKey];
    card.lastName     = dictionary[kLastNameKey];
    card.last4        = dictionary[kLast4Key];
    card.mask         = dictionary[kMaskKey];
    card.month        = dictionary[kMontKey];
    card.year         = dictionary[kYearKey];
    card.payment      = dictionary[kPaymentKey];
    card.securityCode = dictionary[kSecurityCodeKey];
    card.number       = dictionary[kNumberKey];
    
    return card;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.number)
        dictionary[kNumberKey]    = self.number;
    if (self.month)
        dictionary[kExpMonthKey]  = self.month;
    if (self.year)
        dictionary[kExpYearKey]   = self.year;
    if (self.securityCode)
        dictionary[kCVCKey]       = self.securityCode;
    if (self.trackData)
        dictionary[kTrackDataKey] = self.trackData;

    return dictionary;
}

@end
