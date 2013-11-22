#import "_TXHProduct.h"

@interface TXHProduct : _TXHProduct {}

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
