#import "TXHGateway.h"
#import "TXHDefines.h"

static NSString * const kGatewayIDKey     = @"id";
static NSString * const kPublishableIDKey = @"publishable_key";
static NSString * const kSharedSecretKey  = @"shared_secret";
static NSString * const kTypeKey          = @"type";
static NSString * const kInputTypesKey    = @"input_types";


static NSString * const kInputTypesSeparator = @"|";

@interface TXHGateway ()

@end


@implementation TXHGateway

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;
    
    TXHGateway *gateway = [TXHGateway insertInManagedObjectContext:moc];
    
    gateway.gatewayId      = nilIfNSNull(dictionary[kGatewayIDKey]);
    gateway.publishableKey = nilIfNSNull(dictionary[kPublishableIDKey]);
    gateway.type           = nilIfNSNull(dictionary[kTypeKey]);
    gateway.sharedSecret   = nilIfNSNull(dictionary[kSharedSecretKey]);
    gateway.inputTypes     = nilIfNSNull(dictionary[kInputTypesKey]);
    
    return gateway;
}

- (void)setInputTypes:(NSArray *)inputTypes
{
    self.inputTypesString = [inputTypes componentsJoinedByString:kInputTypesSeparator];
}


- (NSArray *)inputTypes
{
    return [self.inputTypesString componentsSeparatedByString:kInputTypesSeparator];
}


@end
