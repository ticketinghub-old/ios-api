#import "_TXHPayment.h"

@interface TXHPayment : _TXHPayment {}

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

- (NSDictionary *)dictionaryRepresentation;

@end
