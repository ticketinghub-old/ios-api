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
static NSString * const kSchemeKey       = @"scheme";


@interface TXHCard ()


@end


@implementation TXHCard

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc {
    
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHCard *card = [[self class] insertInManagedObjectContext:moc];
    
    card.brand        = nilIfNSNull(dictionary[kBrandKey]);
    card.fingerprint  = nilIfNSNull(dictionary[kFingerprintKey]);
    card.firstName    = nilIfNSNull(dictionary[kFirstNameKey]);
    card.lastName     = nilIfNSNull(dictionary[kLastNameKey]);
    card.last4        = nilIfNSNull(dictionary[kLast4Key]);
    card.mask         = nilIfNSNull(dictionary[kMaskKey]);
    card.month        = nilIfNSNull(dictionary[kMontKey]);
    card.year         = nilIfNSNull(dictionary[kYearKey]);
    card.payment      = nilIfNSNull(dictionary[kPaymentKey]);
    card.securityCode = nilIfNSNull(dictionary[kSecurityCodeKey]);
    card.number       = nilIfNSNull(dictionary[kNumberKey]);
    
    return card;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if ([self.number length])
        dictionary[kNumberKey]    = self.number;
    if ([self.month intValue])
        dictionary[kExpMonthKey]  = self.month;
    if ([self.year intValue])
        dictionary[kExpYearKey]   = self.year;
    if ([self.securityCode length])
        dictionary[kCVCKey]       = self.securityCode;
    if ([self.trackData length])
        dictionary[kTrackDataKey] = self.trackData;
    if ([self.scheme length])
        dictionary[kSchemeKey]    = self.scheme;

    return dictionary;
}

@end
