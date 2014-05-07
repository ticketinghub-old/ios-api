#import "TXHGateway.h"
#import "TXHDefines.h"

static NSString * const kGatewayIDKey     = @"id";
static NSString * const kPublishableIDKey = @"publishable_key";
static NSString * const kSharedSecretKey  = @"shared_secret";
static NSString * const kTypeKey          = @"type";

@interface TXHGateway ()


@end


@implementation TXHGateway

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHGateway *gateway = [TXHGateway insertInManagedObjectContext:moc];
    
    gateway.gatewayId      = nilIfNSNull(dictionary[kGatewayIDKey]);
    gateway.type           = nilIfNSNull(dictionary[kPublishableIDKey]);
    gateway.publishableKey = nilIfNSNull(dictionary[kTypeKey]);
    gateway.sharedSecret   = nilIfNSNull(dictionary[kSharedSecretKey]);

    return gateway;
}


@end
