#import "TXHProduct.h"

#import "NSDateFormatter+TicketingHubFormat.h"

static NSString * const kIdKey                    = @"id";
static NSString * const kNameKey                  = @"name";
static NSString * const kAvailabilitiesUpdatedKey = @"availabilities_updated";

@interface TXHProduct ()

// Private interface goes here.

@end


@implementation TXHProduct

#pragma mark - Set up and tear down

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc {
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![dictionary count])
        return nil;

    TXHProduct *product = [TXHProduct insertInManagedObjectContext:moc];

    // These are required properties, so we can expect them from the API
    product.productId             = nilIfNSNull(dictionary[kIdKey]);
    product.name                  = nilIfNSNull(dictionary[kNameKey]);
    product.availabilitiesUpdated = [NSDateFormatter txh_dateFromString:nilIfNSNull(dictionary[kAvailabilitiesUpdatedKey])];
    return product;
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    // This should be set for large availability updates
    self.availabilitiesUpdated = nil;
}

@end
