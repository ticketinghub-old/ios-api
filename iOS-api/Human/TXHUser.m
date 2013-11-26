#import "TXHUser.h"
#import "NSDictionary+JCSKeyMapping.h"


@interface TXHUser ()

// Private interface goes here.

@end


@implementation TXHUser

+ (instancetype)createIfNeededWithDictionary:(NSDictionary *)dictionary inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(dictionary, @"cannot pass a nil for the dictionary paramater");
    // mogenerated code asserts the managed object context

    if (![dictionary count]) {
        return nil;
    }
    
    TXHUser *user = [[self class] userWithEmail:dictionary[@"email"] inManagedObjectContext:moc];
    if (!user) {
        user = [[self class] insertInManagedObjectContext:moc];
    }

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

+ (instancetype)userWithEmail:(NSString *)email inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[[self class] entityName]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", TXHUserAttributes.email, email];
    [request setPredicate:predicate];

    NSError *error;
    NSArray *users = [moc executeFetchRequest:request error:&error];
    if (!users) {
        NSLog(@"Unable to fetch users because: %@", error);
        return nil;
    }

    if (![users count] || [users count] > 1) {
        NSLog(@"None or too many users");
        return nil;
    }

    return [users firstObject];
}

@end
