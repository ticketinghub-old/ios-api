#import "_TXHSupplier.h"

@interface TXHSupplier : _TXHSupplier {}

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
