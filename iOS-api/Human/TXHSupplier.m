#import "TXHSupplier.h"

// StaticStrings for keys
static NSString * const kTokenKey = @"token";
static NSString * const kAccessTokenKey = @"access_token";
static NSString * const kRefreshTokenKey = @"refresh_token";
static NSString * const kCountryKey = @"country";
static NSString * const kCurrencyKey = @"currency";
static NSString * const kTimeZoneKey = @"time_zone";


@interface TXHSupplier ()

// Private interface goes here.

@end


@implementation TXHSupplier

#pragma mark - Set up and tear down

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc {
    TXHSupplier *supplier = [[self class] insertInManagedObjectContext:moc];

    // These values are all required, so they should be provided by the API
    supplier.accessToken = dictionary[kTokenKey][kAccessTokenKey];
    supplier.refreshToken = dictionary[kTokenKey][kRefreshTokenKey];
    supplier.country = dictionary[kCountryKey];
    supplier.currency = dictionary[kCurrencyKey];
    supplier.timeZoneName = dictionary[kTimeZoneKey];

    return supplier;
}

@end
