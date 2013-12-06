#import "TXHUpgrade.h"


@interface TXHUpgrade ()

// Private interface goes here.

@end


@implementation TXHUpgrade

#pragma mark - Public

+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(dict, @"The dict parameter cannot be nil");
    NSAssert(moc, @"the moc parameter cannot be nil");

    if (![dict count]) {
        return nil; // Nothing to do here
    }

    TXHUpgrade *upgrade = [self upgradeWithID:dict[@"id"] inManagedObjectContext:moc];

    if (!upgrade) {
        upgrade = [TXHUpgrade insertInManagedObjectContext:moc];
    }

    upgrade.bit = dict[@"bit"];
    upgrade.upgradeDescription = dict[@"description"];
    upgrade.upgradeId = dict[@"id"];
    upgrade.name = dict[@"name"];
    upgrade.price = dict[@"price"];

    return upgrade;
}

+ (instancetype)upgradeWithID:(NSString *)upgradeID inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(upgradeID, @"upgradeID cannot be nil");
    NSAssert(moc, @"moc parameter cannot be nil");

    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
       formattedPredicate = [NSPredicate predicateWithFormat:@"upgradeID == $UPGRADE_ID"];
    }

    NSDictionary *variables = @{@"UPGRADE_ID": upgradeID};

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:[formattedPredicate predicateWithSubstitutionVariables:variables]];

    NSArray *upgrades = [moc executeFetchRequest:request error:NULL];

    if (!upgrades) {
        return nil;
    }

    return [upgrades firstObject];

}

@end
