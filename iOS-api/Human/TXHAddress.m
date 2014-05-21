#import "TXHAddress.h"
#import "TXHDefines.h"

static NSString * const kBuildingKey   = @"building";
static NSString * const kCityKey       = @"city";
static NSString * const kCountryKey    = @"country";
static NSString * const kFormattedKey  = @"formatted";
static NSString * const kPostalCodeKey = @"postal_code";
static NSString * const kRegionKey     = @"region";
static NSString * const kStreetKey     = @"street";



@interface TXHAddress ()

@end


@implementation TXHAddress

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHAddress *address = [TXHAddress insertInManagedObjectContext:moc];

    address.building    = nilIfNSNull(dictionary[kBuildingKey]);
    address.city        = nilIfNSNull(dictionary[kCityKey]);
    address.country     = nilIfNSNull(dictionary[kCountryKey]);
    address.formatted   = nilIfNSNull(dictionary[kFormattedKey]);
    address.postal_code = nilIfNSNull(dictionary[kPostalCodeKey]);
    address.region      = nilIfNSNull(dictionary[kRegionKey]);
    address.street      = nilIfNSNull(dictionary[kStreetKey]);
    
    return address;
}

@end
