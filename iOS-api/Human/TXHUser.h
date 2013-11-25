#import "_TXHUser.h"

@interface TXHUser : _TXHUser {}

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));
@end
