#import "_TXHCard.h"

@interface TXHCard : _TXHCard {}

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
