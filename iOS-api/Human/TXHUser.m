#import "TXHUser.h"
#import "NSDictionary+JCSKeyMapping.h"


@interface TXHUser ()

// Private interface goes here.

@end


@implementation TXHUser

+ (instancetype)createWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(dictionary, @"cannot pass a nil for the dictionary paramater");
    // mogenerated code asserts the managed object context

    if (![dictionary count]) {
        return nil;
    }
    TXHUser *user = [[self class] insertInManagedObjectContext:moc];
    NSDictionary *userDictionary = [dictionary jcsRemapKeysWithMapping:[[self class] mappingDictionary] removingNullValues:YES];

    [user setValuesForKeysWithDictionary:userDictionary];

    return user;
}

#pragma mark - Private methods

+ (NSDictionary *)mappingDictionary {
    static NSDictionary *dict = nil;

    if (!dict) {
        dict = @{@"first_name": @"firstName",
                 @"last_name": @"lastName",
                 @"id": @"userId"};
    }

    return dict;
}

@end
