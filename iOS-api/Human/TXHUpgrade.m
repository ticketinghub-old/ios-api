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
        upgrade = [TXHUpgrade createWithDictionary:dict inManagedObjectContext:moc];;
    } else {
        [upgrade updateWithDictionary:dict];
    }

    return upgrade;
}

+ (instancetype)upgradeWithID:(NSString *)upgradeID inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(upgradeID, @"upgradeID cannot be nil");
    NSAssert(moc, @"moc parameter cannot be nil");

    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
       formattedPredicate = [NSPredicate predicateWithFormat:@"upgradeId == $UPGRADE_ID"];
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

+ (instancetype)createWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSAssert(dict, @"dict parameter cannot be nil");
    NSAssert(moc, @"moc parameter cannot be nil");

    if (![dict count]) {
        return nil;
    }

    TXHUpgrade *upgrade = [TXHUpgrade insertInManagedObjectContext:moc];
    [upgrade updateWithDictionary:dict];

    return upgrade;
}

- (void)updateWithDictionary:(NSDictionary *)dict {
    NSAssert(dict, @"dict parameter cannot be nil");

    self.bit = dict[@"bit"];
    self.upgradeDescription = dict[@"description"];
    self.upgradeId = dict[@"id"];
    self.name = dict[@"name"];
    self.price = dict[@"price"];

}

@end
