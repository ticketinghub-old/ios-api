#import "_TXHUpgrade.h"

@interface TXHUpgrade : _TXHUpgrade {}

+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
