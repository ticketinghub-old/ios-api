#import "_TXHUser.h"

@interface TXHUser : _TXHUser {}

@property (copy, readonly, nonatomic) NSString *fullName;

+ (instancetype)createIfNeededWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));

- (id)updateWithDictionary:(NSDictionary *)dictionary;
@end
