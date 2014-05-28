#import "TXHSupplier.h"
#import "TXHDefines.h"

#import "TXHProduct.h"
#import "TXHContact.h"

// StaticStrings for keys
static NSString * const kTokenKey        = @"token";
static NSString * const kAccessTokenKey  = @"access_token";
static NSString * const kRefreshTokenKey = @"refresh_token";
static NSString * const kCountryKey      = @"country";
static NSString * const kCurrencyKey     = @"currency";
static NSString * const kTimeZoneKey     = @"time_zone";
static NSString * const kProductsKey     = @"products";
static NSString * const kContactKey      = @"contact";


@interface TXHSupplier ()

// Private interface goes here.

@end


@implementation TXHSupplier

#pragma mark - Set up and tear down

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc {

    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHSupplier *supplier = [[self class] insertInManagedObjectContext:moc];

    // These values are all required, so they should be provided by the API
    supplier.accessToken  = nilIfNSNull(dictionary[kTokenKey][kAccessTokenKey]);
    supplier.refreshToken = nilIfNSNull(dictionary[kTokenKey][kRefreshTokenKey]);
    supplier.country      = nilIfNSNull(dictionary[kCountryKey]);
    supplier.currency     = nilIfNSNull(dictionary[kCurrencyKey]);
    supplier.timeZoneName = nilIfNSNull(dictionary[kTimeZoneKey]);

    NSArray *products = dictionary[kProductsKey];
    for (NSDictionary *productDictionary in products) {
        TXHProduct *product = [TXHProduct createWithDictionary:productDictionary inManagedObjectContext:moc];
        product.supplier = supplier;
    }
    
    NSDictionary *contact = dictionary[kContactKey];
    supplier.contact = [TXHContact createWithDictionary:contact inManagedObjectContext:moc];

    return supplier;
}

@end
