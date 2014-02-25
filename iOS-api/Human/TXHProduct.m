#import "TXHProduct.h"

static NSString * const kIdKey = @"id";
static NSString * const kNameKey = @"name";

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
    product.productId = dictionary[kIdKey];
    product.name = dictionary[kNameKey];

    return product;
}

- (void)awakeFromInsert {
    [super awakeFromInsert];
    // This should be set for large availability updates
    self.availabilitiesUpdated = nil;
}

@end
