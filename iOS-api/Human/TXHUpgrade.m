#import "TXHUpgrade.h"
#import "TXHDefines.h"


@interface TXHUpgrade ()

// Private interface goes here.

@end


@implementation TXHUpgrade

#pragma mark - Public

+ (instancetype)updateWithDictionaryCreateIfNeeded:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(moc);

    if (![dict isKindOfClass:[NSDictionary class]] || ![dict count])
        return nil; // Nothing to do here
 
    NSString *internalID = [self generateInternalIdFromDictionary:dict];
    
    TXHUpgrade *upgrade = [self upgradeWithInternalID:internalID inManagedObjectContext:moc];

    if (!upgrade) {
        upgrade = [TXHUpgrade createWithDictionary:dict inManagedObjectContext:moc];;
    } else {
        [upgrade updateWithDictionary:dict];
    }

    return upgrade;
}

+ (instancetype)upgradeWithID:(NSString *)upgradeID inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(upgradeID);
    NSParameterAssert(moc);

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

+ (instancetype)upgradeWithInternalID:(NSString *)internalUpgradeID inManagedObjectContext:(NSManagedObjectContext *)moc
{
    NSParameterAssert(internalUpgradeID);
    NSParameterAssert(moc);
    
    static NSPredicate *formattedPredicate = nil;
    if (!formattedPredicate) {
        formattedPredicate = [NSPredicate predicateWithFormat:@"internalUpgradeId == $INTERNAL_UPGRADE_ID"];
    }
    
    NSDictionary *variables = @{@"INTERNAL_UPGRADE_ID": internalUpgradeID};
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:[formattedPredicate predicateWithSubstitutionVariables:variables]];
    
    NSArray *upgrades = [moc executeFetchRequest:request error:NULL];
    
    if (!upgrades) {
        return nil;
    }
    
    return [upgrades firstObject];
}

+ (instancetype)createWithDictionary:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)moc {
    NSParameterAssert(moc);

    if (![dict count]) {
        return nil;
    }

    TXHUpgrade *upgrade = [TXHUpgrade insertInManagedObjectContext:moc];
    NSString *internalID = [self generateInternalIdFromDictionary:dict];

    upgrade.internalUpgradeId = internalID;
    [upgrade updateWithDictionary:dict];

    return upgrade;
}

- (void)updateWithDictionary:(NSDictionary *)dict {

    self.bit                = dict[@"bit"];
    self.upgradeDescription = dict[@"description"];
    self.upgradeId          = dict[@"id"];
    self.name               = dict[@"name"];
    self.price              = dict[@"price"];
}

+ (NSString *)generateInternalIdFromDictionary:(NSDictionary *)dict
{
    NSString *upgradeId = dict[@"id"];
    NSNumber *price = dict[@"price"];
    
    return [NSString stringWithFormat:@"%@%@",upgradeId,price];
}


@end
