#import "_TXHGateway.h"

@interface TXHGateway : _TXHGateway {}

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
