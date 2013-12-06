#import "TXHTier.h"

#import "TXHUpgrade.h"


@interface TXHTier ()

// Private interface goes here.

@end


@implementation TXHTier

#pragma mark - Public

+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(dict, @"The dict parameter cannot be nil");
    NSAssert(moc, @"The moc parameter cannot be nil");

    if (![dict count]) {
        return nil;
    }

    TXHTier *tier = [self tierWithID:dict[@"id"] inManagedObjectContext:moc];

    if (!tier) {
        tier = [self createWithDictionary:dict inManagedObjectContext:moc];
    } else {
        [tier updateWithDictionary:dict];
    }


    return tier;
}

+ (instancetype)tierWithID:(NSString *)tierID inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(tierID, @"tierID cannot be nil");
    NSAssert(moc, @"moc parameter cannot be nil");

    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
        formattedPredicate = [NSPredicate predicateWithFormat:@"tierId == $TIER_ID"];
    }

    NSDictionary *variables = @{@"TIER_ID": tierID};

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:[formattedPredicate predicateWithSubstitutionVariables:variables]];

    NSArray *tiers = [moc executeFetchRequest:request error:NULL];

    if (!tiers) {
        return nil;
    }

    return [tiers firstObject];
}

- (void)updateWithDictionary:(NSDictionary *)dict {
    self.tierDescription = dict[@"description"];
    self.discount = dict[@"discount"];
    self.tierId = dict[@"id"];
    self.limit = dict[@"limit"];
    self.name = dict[@"name"];
    self.price = dict[@"price"];
    self.size = dict[@"size"];

    if (dict[@"upgrades"]) {
        // Do something here.
    }

}

+ (TXHTier *)createWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(dict, @"dict parameter cannot be nil");
    NSAssert(moc, @"moc parameter cannot be nil");

    if (![dict count]) {
        return nil;
    }

    TXHTier *tier = [TXHTier insertInManagedObjectContext:moc];
    [tier updateWithDictionary:dict];

    return tier;
}

#pragma mark - Private

// synchronize the tiers relationship with the objects from the array
- (void)updateUpgradesFromArray:(NSArray *)upgradesArray {
    if (![upgradesArray count]) {
        // Empty array so remove all upgrades
        NSSet *upgrades = self.upgrades;
        for (TXHUpgrade *upgrade in upgrades) {
            [upgrade.managedObjectContext deleteObject:upgrade];
        }

        return;
    }

    // Richard told me about the efficient update algorithm which might work. Two sorted arrays with cursors.
    // Create sets for:
    // - objects that exist in the relationship already. - update
    // - objects that are in the array and not in the relationship - create and add.
    // - the above two can be done at once.
    // - objects that are in the relationship but not in the array - delete
}

@end
