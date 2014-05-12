#import "_TXHGateway.h"

@interface TXHGateway : _TXHGateway {}

@property (nonatomic, copy) NSArray *inputTypes;

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc;

@end
