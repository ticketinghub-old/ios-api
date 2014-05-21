#import "_TXHContact.h"

@interface TXHContact : _TXHContact {}

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
